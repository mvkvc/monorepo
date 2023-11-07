{
  description = "bountisol";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs//bf744fe90419885eefced41b3e5ae442d732712d";
      flake-utils.url = "github:numtide/flake-utils";
      rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          (import rust-overlay)
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
        {
        devShell = pkgs.mkShell {
          buildInputs = [
            erlangR26
            pkgs.beam.packages.erlangR26.elixir
            nodejs-18_x
            yarn
            direnv
            # rust-bin.beta.latest.default
          ];
          shellHook = ''
            eval "$(direnv hook bash)"
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
