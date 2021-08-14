{ config, pkgs, lib, ... }:

{

  home.packages = [
    pkgs.tmux
    pkgs.exa
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
        ls = "exa";
        sl = "exa";
        la = "exa -al";
        ll = "exa -l";
        ip = "ip --color=auto";
        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';
        nrb = "sudo nixos-rebuild";
      };

    # Added into zshrc
    initExtra = ''
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

      extraConfig = "zstyle -s ':prezto:module:utility:download' helper 'aria2c'";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
