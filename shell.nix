let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { overlays = [ ] ; config = {}; };

  zig_version = "0.10.0";
  zig_overlay = builtins.fetchTarball sources.zig-overlay.url;
  zig_0_10_0 = (import zig_overlay { pkgs = pkgs; }).${zig_version};

  zig_master = (import zig_overlay { pkgs = pkgs; }).master;


  zls_overlay = pkgs.fetchgit { 
    url = "https://github.com/zigtools/zls";
    sha256 = "sha256-/sgm7zcOB7BwxwM7y7GI0be2q0aufK+T0kO0HnSEQf4=";   
    fetchSubmodules = true; 
    deepClone = true;
  };
  zls = (import zls_overlay { pkgs = pkgs; }).overrideAttrs(attrs: prevAttrs: {
    version = "${zig_version}.dev";
    nativeBuildInputs = [zig_master];
    buildPhase = ''
      mkdir -p $out
      zig build install -Dcpu=baseline -Drelease-safe=true -Ddata_version=${zig_version} --prefix $out
    '';
  });
in pkgs.mkShell {
  buildInputs = [
    zig_0_10_0
    zls
  ];
}
