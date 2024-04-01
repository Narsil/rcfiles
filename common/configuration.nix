# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16"laptop
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  console = {
    useXkbConfig = true; # use xkbOptions in tty.
  };
  services.xserver = {
    enable = false;
    layout = "us";
    xkbVariant = "intl";
  };


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # wireplumber.configPackages = [
    #   (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
    #     bluez_monitor.properties = {
    #     	["bluez5.enable-sbc-xq"] = true,
    #     	["bluez5.enable-msbc"] = true,
    #     	["bluez5.enable-hw-volume"] = true,
    #     	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
    #     }
    #   '')
    # ];
  };
  
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "cudatoolkit"
      "cuda_cudart"
  ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    prime = {
      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:1:0";
      nvidiaBusId = "PCI:101:0:0";
    };
    modesetting.enable = true;
    nvidiaPersistenced = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = { General = { Experimental = true; }; } ;
    disabledPlugins = ["sap"]; 
    package = pkgs.bluez;
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.nicolas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
  };
  virtualisation.docker.enable = true;
  home-manager.users.nicolas = { pkgs, ... }: {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        # Add additional package names here
        "infra"
        "steam"
        "steam-original"
    ];
    home.packages = with pkgs; [ 
      alacritty
      rustup
      ripgrep
      gcc
      libiconv
      mlocate
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      mako # notification system developed by swaywm maintainer
      firefox
      pyenv
      # Everything for building python
      gnumake 
      zlib
      zlib-ng
      xz
      readline
      tk
      libxcrypt
      libffi
      bzip2
      # End Python deps
      htop
      nodePackages_latest.pyright
      git
      k9s
      tailscale
      infra
      unzip
      gh
      hub
      pre-commit
      ruff
      nvidia-docker
      pavucontrol
      lutris
      nix-index
    ];
    programs.gpg.enable = true;
    programs.home-manager.enable = true;
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "tgi" = {
	  user = "ubuntu";
	  host = "tgi";
	  hostname = "ec2-54-162-192-146.compute-1.amazonaws.com";
	  identityFile = "~/etc/nicolas_tgi_sandbox2.pem";
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
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        { 
	  plugin = nvim-cmp;
	  type = "lua";
	  config = ''
              -- Set up nvim-cmp.
              local cmp = require'cmp'
            
              cmp.setup({
                snippet = {
                  -- REQUIRED - you must specify a snippet engine
                  expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                  end,
                },
                window = {
                  -- completion = cmp.config.window.bordered(),
                  -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'vsnip' }, -- For vsnip users.
                  -- { name = 'luasnip' }, -- For luasnip users.
                  -- { name = 'ultisnips' }, -- For ultisnips users.
                  -- { name = 'snippy' }, -- For snippy users.
                }, {
                  { name = 'buffer' },
                })
              })
            
              -- Set configuration for specific filetype.
              cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                  { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
                }, {
                  { name = 'buffer' },
                })
              })
            
              -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
              cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                  { name = 'buffer' }
                }
              })
            
              -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
              cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                  { name = 'path' }
                }, {
                  { name = 'cmdline' }
                })
              })
            
              -- Set up lspconfig.
              local capabilities = require('cmp_nvim_lsp').default_capabilities()
              -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
              require('lspconfig')['rust_analyzer'].setup {
                capabilities = capabilities
              }
              require('lspconfig')['pyright'].setup {
                capabilities = capabilities
              }
	  '';
	}
        { 
	  plugin = nvim-lspconfig;
	  config = ''
            lua require'lspconfig'.rust_analyzer.setup {}
            lua require'lspconfig'.pyright.setup {}
	  '';
	}
	{ 
	  plugin = fzf-vim;
	  config = "noremap <silent> <c-k> :FZF<cr>";
	}
	{ 
	  plugin = catppuccin-nvim;
	  config = "colorscheme catppuccin"; #catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
	}
      ];
      extraConfig = ''
        "syntax on
        set backspace=2				  " For macOS apparently we need to set that.
        set number                    " Display line numbers
        set numberwidth=1             " using only 1 column (and 1 space) while possible
        set background=dark           " We are using dark background in vim
        colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
        "set title                     " show title in console title bar
        "set wildmenu                  " Menu completion in command mode on <Tab>
        "set wildmode=full             " <Tab> cycles between all matching choices.
        " Ignore these files when completing
        set wildignore+=*.o,*.obj,.git,*.pyc
        " show existing tab with 4 spaces width
        set tabstop=4
        " when indenting with '>', use 4 spaces width
        set shiftwidth=4
        " On pressing tab, insert 4 spaces
        set expandtab

        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
        autocmd BufWritePre * lua vim.lsp.buf.format()
      '';

    };
    programs.zsh.enable = true;
    programs.direnv.enable = true;
    programs.k9s.enable = true;

    programs.git = {
      enable = true;
      userEmail = "patry.nicolas@protonmail.com";
      userName = "Nicolas Patry";
      ignores = [ "*.sw[a-z]" ".envrc" "default.nix" ];
    };

    programs.firefox = {
        enable = true;
        profiles = {
          work = {
            id = 0;
            name = "work";
            isDefault = true;
          };
          home = {
            id = 1;
            name = "home";
          };
        };
    };
    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        modifier = "Mod4";
        terminal = "alacritty"; 
        window.titlebar = false;
        input = {
          "input:keyboard" = {
            xkb_layout = "us";
            xkb_variant = "intl";
          };
        };
	    keybindings = lib.mkOptionDefault {
          "${modifier}+q" = "kill";
          "${modifier}+k" = "focus next";
	    };
        startup = [
          # Launch Firefox on start
          {command = "firefox -P work";}
          {command = "firefox -P home";}
        ];
      };
    };

  
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };

  nix.settings.trusted-users = [ "root" "nicolas" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    fzf
    cudaPackages_12_2.cudatoolkit
    cudaPackages_12_2.cuda_cudart
    clamav
    openssl
    pkg-config
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  security.polkit.enable = true;
  programs.sway = {
    enable = true;
    # config = rec {
    #   terminal = "alacritty";
    # };
  };
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    loginShellInit = ''
      if [[ -z $DISPLAY && $TTY = /dev/tty1 ]]; then
        export MOZ_ENABLE_WAYLAND=1
        export WLR_NO_HARDWARE_CURSORS=1
	    export XKB_DEFAULT_LAYOUT=us
        export XKB_DEFAULT_VARIANT=intl
        exec sway --unsupported-gpu
      fi
    '';
    shellInit = ''
      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"
      export CUDA_PATH=${pkgs.cudaPackages_12_2.cudatoolkit}
      export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib
      # export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
      export EXTRA_CCFLAGS="-I/usr/include"
    '';
    shellAliases = {
      s = "cd ..";
    };
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "fzf" ];
    };
  };



  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.locate.enable = true;
  services.tailscale.enable = true;
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
  };
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
