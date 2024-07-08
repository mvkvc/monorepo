{
  description = "octo_firmware";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs//bf744fe90419885eefced41b3e5ae442d732712d";
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            autoconf
            automake
            curl
            erlangR26
            fwup
            git
            pkgs.beam.packages.erlangR26.elixir
            rebar3
            squashfsTools
            x11_ssh_askpass
            pkg-config
          ];
          shellHook = ''
            export MIX_HOME=$PWD/.nix_mix
            export HEX_HOME=$PWD/.nix_hex
            export PATH=$MIX_HOME/bin:$PATH
            export PATH=$HEX_HOME/bin:$PATH
            export PATH=$MIX_HOME/escripts:$PATH
            export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
            export SUDO_ASKPASS=${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass
            export IS_NIX=true
          '';
        };
      }
    );
}
