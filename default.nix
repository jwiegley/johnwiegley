{ rev    ? "70c1c856d4c96fb37b6e507db4acb125656f992d"
, sha256 ? "0w155rcknc3cfmliqjaq280d09rx4i0wshcrh9xrsiwpdn90i52d"
, pkgs   ?
  import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256; }) {
    config.allowUnfree = true;
    config.allowBroken = true;
    config.packageOverrides = pkgs: rec {
      sitebuilder = pkgs.callPackage ~/src/sitebuilder { compiler = "ghc865"; };
    };
  }

, mkDerivation ? null
}:

with pkgs;

stdenv.mkDerivation {
  name = "johnwiegley";
  src = ./.;

  buildInputs = [ yuicompressor ];

  buildPhase = ''
    ${pkgs.sitebuilder}/bin/sitebuilder rebuild
  '';

  installPhase = ''
    mkdir -p $out/share/html
    cp -pR _site $out/share/html/johnwiegley
  '';
}
