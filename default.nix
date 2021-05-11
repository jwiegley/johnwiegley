{ pkgs ? (import <darwin> {}).pkgs

# , rev    ? "28c2c0156da98dbe553490f904da92ed436df134"
# , sha256 ? "04f3qqjs5kd5pjmqxrngjrr72lly5azcr7njx71nv1942yq1vy2f"
# , pkgs   ? import (builtins.fetchTarball {
#     url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
#     inherit sha256; }) {
#     config.allowUnfree = true;
#   }

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
    DESTDIR=$out/share/html/johnwiegley
    cp -pR _site $DESTDIR

    mkdir -p $out/bin
    cat <<EOF > $out/bin/publish-johnwiegley
#!${pkgs.bash}/bin/bash
${pkgs.lftp}/bin/lftp \
  -u johnw@newartisans.com,\$(${pkgs.pass}/bin/pass show ftp.fastmail.com | ${pkgs.coreutils}/bin/head -1) \
  ftp://johnw@newartisans.com@ftp.fastmail.com \
  -e "set ftp:ssl-allow no; mirror --no-perms --no-symlinks --no-umask --overwrite --reverse $DESTDIR /johnw.newartisans.com/files/johnwiegley ; quit"
EOF
    chmod +x $out/bin/publish-johnwiegley
  '';
}
