defmodule OctoWeb.Router do
  use OctoWeb, :router

  def default_assigns(conn, _opts) do
    conn
    |> assign(:meta_attrs, [])
    |> assign(:manifest, nil)
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {OctoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :default_assigns
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OctoWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/chat", ChatLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", OctoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:octo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: OctoWeb.Telemetry
    end
  end
end
