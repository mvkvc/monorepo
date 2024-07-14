defmodule CritiqueWeb.Router do
  use CritiqueWeb, :router

  use Kaffy.Routes,
    scope: "/admin",
    pipe_through: [:require_admin_user]

  import CritiqueWeb.UserAuth
  alias CritiqueWeb.Plugs.RequireAdminUser

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {CritiqueWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :require_admin_user do
    plug(RequireAdminUser)
  end

  scope "/", CritiqueWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
    # get("/uploads", RedirectController, :uploads)
    # get("/jobs", RedirectController, :jobs)
  end

  # Other scopes may use custom stacks.
  # scope "/api", CritiqueWeb do
  #   pipe_through :api
  # end

  scope "/webhook", CritiqueWeb do
    pipe_through :api

    post("/:job_id", WebhookController, :hook)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:critique, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: CritiqueWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", CritiqueWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{CritiqueWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", CritiqueWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{CritiqueWeb.UserAuth, :ensure_authenticated}] do
      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
      live("/upload", UploadLive)
      live "/jobs", JobLive.Index, :index
      # live "/job/new", JobLive.Index, :new
      # live "/job/:id/edit", JobLive.Index, :edit
      live "/jobs/:id", JobLive.Show, :show
      # live "/job/:id/show/edit", JobLive.Show, :edit
    end
  end

  scope "/", CritiqueWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{CritiqueWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end
end
