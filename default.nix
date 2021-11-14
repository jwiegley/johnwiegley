{ pkgs ? (import <darwin> {}).pkgs
, mkDerivation ? null
, yuicompressor  ? pkgs.yuicompressor
, sitebuilder ? pkgs.callPackage ~/src/sitebuilder { inherit pkgs yuicompressor; }
}:

with pkgs; stdenv.mkDerivation {
  name = "johnwiegley";
  src = ./.;
  buildInputs = [ yuicompressor sitebuilder ];
  buildPhase = "sitebuilder rebuild";
  installPhase = ''
    mkdir -p $out/share/html
    cp -pR _site $out/share/html/johnwiegley
  '';
}
