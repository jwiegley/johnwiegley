{ mkDerivation, base, bytestring, containers, ghc-prim, lens
, stdenv, text, xml-conduit, xml-lens, zippers
}:
mkDerivation {
  pname = "convert";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring containers ghc-prim lens text xml-conduit xml-lens
    zippers
  ];
  description = "WordPress to Hakyll converter";
  license = stdenv.lib.licenses.mit;
}
