{ config, lib, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nicolas";
  home.homeDirectory = "/Users/nicolas";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into youwith pkgs; r
  # environment.
  home.packages = with pkgs; [
      alacritty
      rustup
      ripgrep
      gcc
      htop
      nodePackages_latest.pyright
      git
      k9s
      gnupg
      tailscale
      unzip
      gh
      hub
      pre-commit
      ruff
  ];
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "tgi" = {
          host = "tgi";
          hostname = "ec2-44-200-204-84.compute-1.amazonaws.com";
        };
        "m3" = {
          host = "m3";
          hostname = "m3.home";
        };
        "home" = {
          host = "home";
          hostname = "192.168.1.227";
        };
        "m1dc2" = {
          host = "home";
          hostname = "10.254.0.11";
        };
      };
    };
    # programs.zsh.enable = true;
    imports = [ ./neovim.nix ];
    programs.direnv.enable = true;
    programs.k9s.enable = true;
    programs.gpg.enable = true;
    programs.git = {
      enable = true;
      userEmail = "patry.nicolas@protonmail.com";
      userName = "Nicolas Patry";
      ignores = [ "*.sw[a-z]" ".envrc" "default.nix" ];
      signing =  {
        signByDefault = true;
      };
      lfs.enable = true;
      extraConfig = {
        push = { autoSetupRemote = true; };
        init = { defaultBranch = "main"; };
      };
    };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nicolas/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"
    '';
    shellAliases = {
      s = "cd ..";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "fzf" ];
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 18;
      keyboard.bindings = [
        {
          chars = "\\u0002%";
          key = "D";
          mods = "Command";
        }
        {
          chars = "\\u0002o";
          key = "K";
          mods = "Command|Shift";
        }
      ];
    };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
