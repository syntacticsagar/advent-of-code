let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { overlays = [ ] ; config = {}; };

  zig_version = "0.10.0";
  zig_overlay = builtins.fetchTarball sources.zig-overlay.url;
  zig_0_10_0 = (import zig_overlay { pkgs = pkgs; }).${zig_version};
in pkgs.mkShell {
  buildInputs = [
    zig_0_10_0
  ];
}
