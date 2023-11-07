{
  description = "akashi";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs//bf744fe90419885eefced41b3e5ae442d732712d";
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            erlangR26
            pkgs.beam.packages.erlangR26.elixir
            nodejs-18_x
            python310
            python310Packages.pipx
            earthly
            direnv
          ];
          shellHook = ''
            eval "$(direnv hook bash)"
            export POETRY_VIRTUALENVS_IN_PROJECT=true
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
