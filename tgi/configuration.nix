{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ../common/configuration.nix
  ];
  networking.hostName = "tgi"; # Define your hostname.
  # No boot partition
  boot.loader.systemd-boot.enable = lib.mkForce false;
  fileSystems."/mnt" = {
    device = "/dev/nvme1n1";
    fsType = "ext4";
    options = [
      # If you don't have this options attribute, it'll default to "defaults"
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount

    ];
  };
  home-manager.users.nicolas =
    { pkgs, ... }:
    {
      programs.git.signing.key = "87B37D879D09DEB4";
      programs.zellij = {
        enable = true;
        enableZshIntegration = true;
        attachExistingSession = true;
        exitShellOnExit = true;
        settings = {
          theme = "catppuccin-frappe";
          simplified_ui = true;
          pane_frames = false;
          show_startup_tips = false;
          keybinds = {
            normal = {
              unbind = "Ctrl t"; # used in neovim
            };
            unbind = "Ctrl o"; # used in neovim
          };

        };
      };
      programs.zsh = {
        oh-my-zsh.extraConfig = ''
          PROMPT="$fg[cyan]%}$USER@%{$fg[blue]%}%m ''${PROMPT}"
          export HF_HOME=/mnt
        '';
      };
      programs.alacritty = {
        enable = true;
      };

    };
}
