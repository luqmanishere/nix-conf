{ config, lib, pkgs, ... }:

with lib;
let cfg = config.shells.zsh;
in
{
  options = {
    shells.zsh = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable configuration for ZSH
        '';
      };
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      home.sessionVariables = {
        NIX_BUILD_SHELL = "zsh";
      };
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
            l = "ls -1";
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
          {
            name = "zsh-cargo-completion";
            src = fetchFromGitHub {
              repo = "zsh-cargo-completion";
              owner = "MenkeTechnologies";
              rev = "35a9ca5ff58d228b4a332eb70a31172fc4716b61";
              sha256 = "1wvpp9s2fxhq04fxpjwkixxwppvj38lfpll4ciasb8lrgg0vl01q";
            };
          }
          {
            name = "nix-zsh-completions";
            src = fetchFromGitHub {
              repo = "nix-zsh-completions";
              owner = "spwhitt";
              rev = "468d8cf752a62b877eba1a196fbbebb4ce4ebb6f";
              sha256 = "16r0l7c1jp492977p8k6fcw2jgp6r43r85p6n3n1a53ym7kjhs2d";
            };
            file = "nix-zsh-completions.plugin.zsh";
          }
          {
            name = "zsh-auto-notify";
            src = fetchFromGitHub {
              owner = "MichaelAquilina";
              repo = "zsh-auto-notify";
              rev = "fb38802d331408e2ebc8e6745fb8e50356344aa4";
              sha256 = "02x7q0ncbj1bn031ha7k3n2q2vrbv1wbvpx9w2qxv9jagqnjm3bd";
            };
            file = "auto-notify.plugin.zsh";
          }
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.4.0";
              sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
            };
          }
        ];

        prezto = {
          enable = true;
          pmodules = [
            #"utility"
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
    })
  ];

}
