# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 */1 * * * mvkvc /etc/nixos/scripts/restic_backup.sh"
      "0 11 * * 1 mvkvc /etc/nixos/scripts/restic_prune.sh"
      "0 */2 * * * mvkvc /etc/nixos/nixos_backup.sh"
      #"0 */2 * * * mvkvc /etc/nixos/dev_backup.sh"
    ];
  };

  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.dnsname.enable = true;
  users.extraUsers.mvkvc.extraGroups = ["podman"];
  
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    withRuby = true;
    withPython3 = true;
    withNodeJs = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          ayu-vim
          vim-airline
          vim-airline-themes
          vim-gitgutter
          vim-fugitive
          nerdtree
          lightspeed-nvim
          vim-elixir
          vim-erlang-runtime
          vim-erlang-compiler
          vim-erlang-omnicomplete
          vim-ruby
          vim-lfe
          coc-pyright
          coc-rust-analyzer
          coc-html
          coc-css      
          coc-yaml
          coc-json
        ];
      };
      customRC = ''
      set termguicolors
      set background=dark     " for either mirage or dark version.
      let g:ayucolor="mirage" " for mirage version of theme
      colorscheme ayu
      let g:airline_theme= 'ayu_mirage'
      nnoremap <Bslash><t> :NERDTreeToggle<CR>    
      '';
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mvkvc = {
    isNormalUser = true;
    description = "Marko Vukovic";
    extraGroups = [ "networkmanager" "wheel"];
    packages = with pkgs; [
      bitwarden
      gnome.gnome-calendar
      firefox
      thunderbird
      protonmail-bridge
      signal-desktop
      ferdi
      element-desktop
      zulip
      xed-editor
      libreoffice
      logseq
      zotero
      zeal
      vscodium.fhs
      guake
      gnome.gnome-terminal
      gparted
      obs-studio
      cider
      gnome-podcasts
      # unfree
      clockify
      discord
      slack
      spotify
      zoom-us
      sublime-merge
      #vscode.fhs
      # cli
      exercism
      neofetch
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
                  "ferdi-5.8.1"
                  "electron-11.5.0"
		  "python3.10-mistune-0.8.4"
                ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    curl
    git
    thefuck
    restic
    cachix
    direnv
    nix-direnv
    rclone
    backblaze-b2
    docker-client
    arion
    poetry
    python310
    elixir
    minikube
  ];

  programs.git.config = { 
    init = { defaultBranch = "main"; } ;
  };

  environment.shellAliases = {
    nixconfig = "sudo nvim /etc/nixos/configuration.nix";
    resticbackup = "/etc/nixos/scripts/restic_backup.sh";
    devbackup = "/etc/nixos/scripts/dev_backup.sh";
    ll = "ls -l";
    la = "ls -la";
  };

  # Empty for now
  programs.bash.shellInit = ''
    '';

  environment.interactiveShellInit = ''
      eval "$(thefuck --alias)"
      eval "$(direnv hook bash)"
    '';

  environment.variables = rec {
    B2_ACCOUNT_ID = "00225b4f27c1f97000000000b";
    B2_ACCOUNT_KEY = "K002MEScy8Alh4Xm4zcXF0SbwJ97my4";
    RESTIC_REPOSITORY = "b2:mvkvc-restic";
    RESTIC_PASSWORD_FILE="/etc/nixos/secrets/restic_pwd";
  };

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  nixpkgs.overlays = [
    (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
  ];

  fonts.fonts = with pkgs; [
    fira-code
  ];  

  systemd.services.foo = {
    script = ''
      echo 0 | tee /sys/module/hid_apple/parameters/fnmode
    '';
    wantedBy = [ "multi-user.target" ];
  };



  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
