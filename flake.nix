{
  description = "A configured version of Starship";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs_unstable,
    flake-utils
  }: flake-utils.lib.eachDefaultSystem (system:
    let
      starship_overlay = import ./starship nixpkgs.lib;

      pkgsForSystem = system: import nixpkgs {
        overlays = [ starship_overlay ];
        inherit system;
      };

      pkgs = pkgsForSystem system;
    in {
      packages = pkgs.starship;
      devShell = pkgs.mkShell {
        packages = [pkgs.zsh];
        inputsFrom = [pkgs.starship];
        shellHook = "zsh;exit";
      };
    }
  );
}
