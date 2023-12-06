{
    description = "A simple client for Kafka written in Zig";

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      zig = {
        url = "github:mitchellh/zig-overlay";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      flake-utils = {
        url = "github:numtide/flake-utils";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      zls = {
        url = "github:zigtools/zls";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    outputs = { self, nixpkgs, zig, flake-utils, zls }:
    let
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      outputs = flake-utils.lib.eachSystem systems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.pkg-config
            zig.packages.${system}.master
            zls.packages.${system}.zls
          ] ;
          shellHook = pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
            export CPATH=$(xcrun --sdk macosx --show-sdk-path)/usr/include
          '';
        };
      });
    in outputs // {};

    nixConfig = {};
}
