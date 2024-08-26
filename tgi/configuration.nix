{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ 
      "${modulesPath}/virtualisation/amazon-image.nix" 
      ../common/configuration.nix
  ];
  networking.hostName = "tgi"; # Define your hostname.
  # No boot partition
  boot.loader.systemd-boot.enable = lib.mkForce false;
  home-manager.users.nicolas = { pkgs, ... }: {
    programs.git.signing.key = "64AF4752B2967863";
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
        bind-key -n M-e split-window -vf
        bind-key -n M-Space split-window -hf
        bind-key -n M-k select-pane -t :.+
        bind-key -n M-1 select-pane -t 1
        bind-key -n M-2 select-pane -t 2
        bind-key -n M-3 select-pane -t 3
        bind-key -n M-4 select-pane -t 4
        bind-key -n M-5 select-pane -t 5
        bind-key -n M-6 select-pane -t 6
        bind-key -n M-7 select-pane -t 7
        bind-key -n M-8 select-pane -t 8
        bind-key -n M-9 select-pane -t 9
      '';
    };
    programs.zsh = {
      oh-my-zsh.extraConfig = ''
          PROMPT="$fg[cyan]%}$USER@%{$fg[blue]%}%m ''${PROMPT}"
          ZSH_TMUX_AUTOSTART=true
          export HF_HOME=/mnt
      '';
    };
    programs.alacritty = {
      enable = true;
    };

  };
}
