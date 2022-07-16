{ pkgs, config, ... }: 
let 
  iosevka-aile = pkgs.iosevka-bin.override {
    variant = "aile";
  };
  
  # iosevka-custom = pkgs.iosevka.override {
  #   set = "custom";
  #   privateBuildPlan = {
  #     family = "Iosevka Custom";
  #     spacing = "term";
  #     serifs = "sans";
  #     no-cv-ss = true;
  #     variants.design = {
  #       asterisk = "penta-low";
  #       percent = "rings-continuous-slash";
  #     };
  #     widths.normal = {
  #       shape = 600;
  #       menu = 5;
  #       css = "normal";
  #     };
  #   };
  # };
in {
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    iosevka-aile
    iosevka-custom.nerd-font
    font-awesome
  ];
}
