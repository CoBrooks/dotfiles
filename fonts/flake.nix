{
  description = "Iosevka Custom";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    let
      allSystems = flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            plainPackage = pkgs.iosevka.override {
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
            nerdFontPackage = let outDir = "$out/share/fonts/truetype/"; in
              pkgs.stdenv.mkDerivation {
                pname = "iosevka-custom-nerd-font";
                version = plainPackage.version;
                src = builtins.path { path = ./.; name = "iosevka-custom"; };
                buildInputs = [ pkgs.nerd-font-patcher ];
                configurePhase = "mkdir -p ${outDir}";
                buildPhase = ''
                  for fontfile in ${plainPackage}/share/fonts/truetype/*
                  do
                  nerd-font-patcher $fontfile --complete --careful --outputdir ${outDir}
                  done
                '';
                dontInstall = true;
              };
            packages = {
              normal = plainPackage;
              nerd-font = nerdFontPackage;
            };
          in
          {
            inherit packages;
            defaultPackage = plainPackage;
          }
        );
    in
    {
      packages = allSystems.packages;
      defaultPackage = allSystems.defaultPackage;
      overlay = final: prev: {
        iosevka-custom = allSystems.packages.${final.system}; # either `normal` or `nerd-font`
      };
    };
}
