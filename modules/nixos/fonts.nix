{ pkgs, config, ... }: 
let 
  iosevka-aile = pkgs.iosevka-bin.override {
    variant = "aile";
  };
  
  iosevka-custom = pkgs.iosevka.override {
    set = "custom";
    privateBuildPlan = {
      family = "Iosevka Custom";
      spacing = "term";
      serifs = "sans";
      no-cv-ss = true;
      variants.design = {
        asterisk = "penta-low";
        percent = "rings-continuous-slash";
      };
      widths.normal = {
        shape = 600;
        menu = 5;
        css = "normal";
      };
    };
  };

  iosevka-nerd-font = let outDir = "$out/share/fonts/truetype/"; in
    pkgs.stdenv.mkDerivation {
      pname = "iosevka-custom-nerd-font";
      version = plainPackage.version;

      src = builtins.path { path =./.; name = "iosevka-custom"; };

      buildInputs = [ pkgs.nerd-font-patcher ];

      configure = "mkdir -p ${outDir}";
      buildPhase = ''
         for fontfile in ${plainPackage}/share/fonts/truetype/*
         do
            nerd-font-patcher $fontfile --complete --careful --outputdir ${outDir}
         done
      '';
      dontInstall = true;
    }
in {
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    iosevka-aile
    iosevka-custom
    font-awesome
  ];
}
