{
  description = "treefi";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs//e1fa12d4f6c6fe19ccb59cac54b5b3f25e160870";
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            erlangR26
            pkgs.beam.packages.erlangR26.elixir
            nodejs_20
            corepack_20
            python310
            python310Packages.pipx
            direnv
          ];
          shellHook = ''
            eval "$(direnv hook bash)"
            export MIX_HOME=$PWD/.nix_mix
            export HEX_HOME=$PWD/.nix_hex
            export PATH=$MIX_HOME/bin:$PATH
            export PATH=$HEX_HOME/bin:$PATH
            export PATH=$MIX_HOME/escripts:$PATH
            export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
            export POETRY_VIRTUALENVS_IN_PROJECT=true
            export IS_NIX=true
          '';
        };
      }
    );
}
