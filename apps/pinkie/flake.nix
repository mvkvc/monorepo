{
  description = "pinkie";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs//a1291d0d020a200c7ce3c48e96090bfa4890a475";
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            gcc
            gnumake
            inotify-tools
            elixir
            nodejs-18_x
            go_1_20
            kubo
            nixpacks
            python310
            python310Packages.ansible
            terraform
          ];
          shellHook = ''
            export PINKIE_HOME=$PWD/pinkie
            export GATEWAY_HOME=$PWD/gateway
            export MIX_HOME=$PINKIE_HOME/.nix_mix
            export HEX_HOME=$PINKIE_HOME/.nix_hex
            export PATH=$MIX_HOME/bin:$PATH
            export PATH=$HEX_HOME/bin:$PATH
            export PATH=$MIX_HOME/escripts:$PATH
            export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
            export IS_NIX=true
          '';
        };
      }
    );
}
