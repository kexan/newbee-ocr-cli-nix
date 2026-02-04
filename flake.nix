{
  description = "newbee-ocr-cli flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.callPackage ./default.nix { };
          newbee-ocr-cli = pkgs.callPackage ./default.nix { };
        }
      );

      overlays.default = final: prev: {
        newbee-ocr-cli = final.callPackage ./default.nix { };
      };
    };
}
