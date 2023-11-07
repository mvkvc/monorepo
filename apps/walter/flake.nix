{
  description = "walter";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs//3c15feef7770eb5500a4b8792623e2d6f598c9c1";
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
          ];
          shellHook = ''
            export MIX_HOME=$PWD/.nix_mix
            export HEX_HOME=$PWD/.nix_hex
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
