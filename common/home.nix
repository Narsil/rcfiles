{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs = {
    config = {
      allowUnfreePredicate = (
        pkg:
        builtins.elem (lib.getName pkg) [
          "cursor"
        ]
      );
    };
  };
  home.packages = with pkgs; [
    alacritty
    ripgrep
    gcc
    libiconv
    htop
    git
    k9s
    gnupg
    tailscale
    unzip
    gh
    hub
    pre-commit
    ruff
    pyright
    killall
    zellij
    cachix
    nixd
    nixfmt-rfc-style
    uv
    code-cursor
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://huggingface.cachix.org"
        "https://text-generation-inference.cachix.org"
        "https://narsil.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "huggingface.cachix.org-1:ynTPbLS0W8ofXd9fDjk1KvoFky9K2jhxe6r4nXAkc/o="
        "text-generation-inference.cachix.org-1:xdQ8eIf9LuIwS0n0/5ZmOHLaCXC6yy7MgzQNK/y+R1c="
        "narsil.cachix.org-1:eTLhYqg5uVi7Pv3x6L/Ov8NdESEpGeViXiwGKLYpo90="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # initExtra = ''
    #   export PYENV_ROOT="$HOME/.pyenv"
    #   [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    #   eval "$(pyenv init -)"
    #   export GPG_TTY=$(tty)
    # '';
    shellAliases = {
      s = "cd ..";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "fzf"
      ];
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 18;
    };
  };
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "tgi" = {
        host = "tgi";
        hostname = "10.90.4.185";
      };
      "tgi-intel" = {
        host = "tgi-intel";
        hostname = "10.90.10.38";
      };
      "tgi-intel-metal" = {
        host = "tgi-intel-metal";
        hostname = "10.90.3.139";
      };
      "tgi-intel-pvc" = {
        host = "tgi-intel-pvc";
        user = "sdp";
        hostname = "100.80.137.45";
        identityFile = "~/.ssh/intel_pvc";
        proxyJump = "jumphost";
      };
      "tgi-intel-hpu" = {
        host = "tgi-intel-hpu";
        user = "sdp";
        hostname = "100.83.80.81";
        identityFile = "~/.ssh/intel_pvc";
        proxyJump = "jumphost2";
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
      "jumphost2" = {
        user = "guest";
        hostname = "146.152.224.71";
        identityFile = "~/.ssh/intel_pvc";
      };
      "jumphost" = {
        user = "guest";
        hostname = "146.152.232.8";
        identityFile = "~/.ssh/intel_pvc";
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
      cmp-vsnip
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-lspconfig
      vim-vsnip
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
                        local lspconfig = require('lspconfig')
                        -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
                        lspconfig.rust_analyzer.setup {
                          capabilities = capabilities
                        }
                        lspconfig.ruff.setup {
                          capabilities = capabilities
                        }
                        lspconfig.pyright.setup {
                          capabilities = capabilities
                        }
                        lspconfig.nixd.setup {
                          capabilities = capabilities
                        }
                        lspconfig.zls.setup {
                          capabilities = capabilities
                        }
                        vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
                        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
                        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
                        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
                        vim.keymap.set("n", "<space>f", vim.lsp.buf.format, { desc = "Format code" })
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
          	  '';
      }

      {
        plugin = fzf-vim;
        config = "noremap <silent> <c-k> :FZF<cr>";
      }
      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin"; # catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
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

      set mouse=v

    '';

  };
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "make"
    ];

    ## everything inside of these brackets are Zed options.
    userSettings = {
      agent = {
        always_allow_tool_actions = true;
        version = "2";
      };

      vim_mode = true;
      ## tell zed to use direnv and direnv can use a flake.nix enviroment.
      load_direnv = "shell_hook";
      theme = {
        mode = "dark";
        light = "One Light";
        dark = "One Dark";
      };
    };

  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.k9s.enable = true;
  programs.gpg.enable = true;
  programs.git = {
    enable = true;
    userEmail = "patry.nicolas@protonmail.com";
    userName = "Nicolas Patry";
    ignores = [
      "*.sw[a-z]"
      ".envrc"
      ".direnv"
      ".venv"
      # "flake.nix"
      # "flake.lock"
    ];
    lfs.enable = true;
    signing.key = lib.mkDefault null;
    signing.signByDefault = (config.programs.git.signing.key != null);
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
  xdg = {
    portal = {
      enable = true;

      config = {
        sway = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.OpenURI" = [ "firefox" ];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  programs.home-manager.enable = true;
}
