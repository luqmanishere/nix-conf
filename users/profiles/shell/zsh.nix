{ config, lib, pkgs, ... }:

with lib;
{
  options = {
    shells.zsh = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = '''';
      };
    };
  };
  config = mkIf config.shells.zsh.enable {
    home.packages = [
      pkgs.aria2
    ];

    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      shellAliases =
        {
          ls = "${pkgs.exa}/bin/exa --git --group-directories-first --time-style=long-iso";
          sl = "ls";
          ll = "ls -al";
          llm = "ll --sort=modified";
          la = "ls -lbhHigUmuSa";
          tree = "${pkgs.exa}/bin/exa --tree";
          ip = "ip --color=auto";
          # Search docs using manix
          mn = ''
            manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
          '';
          nrb = "sudo nixos-rebuild";
          ns = "nix search --no-update-lock-file nixos";
        };

      # Added into zshrc
      initExtra = ''
        autopair-init
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      '';

      plugins = with pkgs; [
        {
          name = "zsh-you-should-use";
          src = fetchFromGitHub {
            owner = "MichaelAquilina";
            repo = "zsh-you-should-use";
            rev = "ccc7e7f75bd7169758a1c931ea574b96b71aa9a0";
            sha256 = "12kwwk4gqg00n4xinf8iw30gfjwshjj1vhvmykjk3czxjiw66cl5";
          };
        }
        {
          name = "enhancd";
          src = fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "aec0e0c1c0b1376e87da74b8940fda5657269948";
            sha256 = "13n2c2kj25g8aqvlkb5j4vzcz5a4a22yc8v6ary651lpqgckx7cg";
          };
          file = "init.sh";
        }
        {
          name = "zsh-autopair";
          src = fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "9d003fc02dbaa6db06e6b12e8c271398478e0b5d";
            sha256 = "0s4xj7yv75lpbcwl4s8rgsaa72b41vy6nhhc5ndl7lirb9nl61l7";
          };
        }
      ];

      prezto = {
        enable = true;
        pmodules = [
          "utility"
          #"syntax-highlighting"
          #"autosuggestions"
          "history"
          "completion"
        ];

        extraConfig = ''
          zstyle -s ':prezto:module:utility:download' helper 'aria2c'
        '';
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
