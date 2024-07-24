{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ 
      "${modulesPath}/virtualisation/amazon-image.nix" 
      ../common/configuration.nix
  ];
  networking.hostName = "tgi"; # Define your hostname.
  # No boot partition
  boot.loader.systemd-boot.enable = lib.mkForce false;
  home-manager.users.nicolas = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      plugins = with pkgs; [
        tmuxPlugins.catppuccin
        tmuxPlugins.vim-tmux-navigator
      ];
      extraConfig = ''
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on
      '';
    };
    programs.zsh = {
      oh-my-zsh.extraConfig = ''
          PROMPT="$fg[cyan]%}$USER@%{$fg[blue]%}%m ''${PROMPT}"
          ZSH_TMUX_AUTOSTART=true
          export HF_HOME=/mnt
          export PYENV_ROOT="$HOME/.pyenv"
          [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
          eval "$(pyenv init -)"
      '';
    };
    programs.alacritty = {
      enable = true;
      settings = {
        keyboard.bindings = [
          {
            chars = "\\u0002%";
            key = "D";
            mods = "Command";
          }
        ];
      };
    };

  };
}
