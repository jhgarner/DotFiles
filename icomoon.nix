{ config, lib, pkgs, ... }:

with lib;

let icomoon = pkgs.fetchFromGitHub {
  owner = "adi1090x";
  repo = "polybar-themes";
  rev = "46154c5283861a6f0a440363d82c4febead3c818";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/truetype
    cp fonts/*.ttf -d $out/share/fonts/truetype/
  '';

  sha256 = "0ga1wz15fw8sh7xsq3zz7dmczgfxw18yi1isw0k7q6095qcp4m5v";
};
  linotte = pkgs.fetchzip {
    url = "https://dafonttop.com/zipdown/16174137131617413713/8897/linotte-bold.zip";
    sha256 = "00k9wdrlqzicm6b6s1xr0l1rb3w2kkssrhi3xxkn9g7xw8l26am4";
    stripRoot = false;
  };
  linotte-font = pkgs.runCommandLocal "Linotte-fonts" {} ''
    mkdir -p $out/share/fonts/opentype/
    cp ${linotte}/*.otf -d $out/share/fonts/opentype/
    '';
in {
  config.fonts.fonts = [ icomoon linotte-font ];
}
