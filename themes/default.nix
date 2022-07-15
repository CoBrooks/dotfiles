{ pkgs }: 
with builtins; {
  getTheme = { name ? "gruvbox-material-dark-medium" }:
  let
    inherit pkgs;

    fromYaml = yaml: fromJSON(
      readFile(
        pkgs.runCommand "from-yaml" {
          inherit yaml;
          allowSubstitutes = false;
          preferLocalBuild = true;
        }
        ''
          ${pkgs.remarshal}/bin/remarshal \
          -if yaml \
          -i <(echo "$yaml") \
          -of json \
          -o $out
        ''
      )
    );

    readYaml = path: fromYaml (readFile path);

    b = readYaml (builtins.path {
      path = (builtins.fetchGit {
        url = "https://github.com/base16-project/base16-schemes.git";
        ref = "master";
        rev = "99529527e7cb3d777fb6e041c2aabbe6cdec4c4c";
      }).outPath + "/${name}.yaml";
    });
  in {
    name = "${name}";

    background = "#${b.base00}";
    foreground = "#${b.base06}";

    primary.background = "#${b.base00}";
    primary.foreground = "#${b.base06}";

    normal = {
      black   = "#${b.base01}";
      red     = "#${b.base08}";
      yellow  = "#${b.base0A}";
      green   = "#${b.base0B}";
      cyan    = "#${b.base0C}";
      blue    = "#${b.base0D}";
      magenta = "#${b.base0E}";
      white   = "#${b.base05}";
    };

    bright = {
      black   = "#${b.base03}";
      red     = "#${b.base08}";
      yellow  = "#${b.base0A}";
      green   = "#${b.base0B}";
      cyan    = "#${b.base0C}";
      blue    = "#${b.base0D}";
      magenta = "#${b.base0E}";
      white   = "#${b.base07}";
    };
  };
}
