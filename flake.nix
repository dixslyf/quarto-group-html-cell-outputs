{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:Numtide/flake-utils";
  };
  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        quarto = pkgs.quartoMinimal.override {
          inherit (pkgs) python3;
        };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = [
              quarto
            ];
          };
        };

        # Re-export Quarto for use in CI.
        packages = {
          inherit quarto;
        };
      }
    );
}
