{ config, lib, pkgs, ... }:
{
    home.packages = with pkgs; [ 
      alacritty
      rustup
      ripgrep
      gcc
      libiconv
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
      killall
      tmux
      cachix
    ];

    nix = {
      package = lib.mkDefault pkgs.nix;
      settings = {
	    substituters = [ "https://cache.nixos.org" "https://tgi.cachix.org" ];
        trusted-public-keys = ["tgi.cachix.org-1:exYnmXQw8K8BEazwDyG/vhQp56mp6DLFXuOO1EpwIWI="];
	    experimental-features = [ "nix-command" "flakes" ];
      };
    };
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        export PYENV_ROOT="$HOME/.pyenv"
        [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
        export GPG_TTY=$(tty)
      '';
      shellAliases = {
        s = "cd ..";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "sudo" "fzf" "tmux" ];
      };
    };
    programs.alacritty = {
      enable = true;
      settings = {
        font.size = 18;
        keyboard.bindings = [
          {
            chars = "\\u0002%";
            key = "Space";
            mods = "Command";
          }
          {
            chars = "\\u0002%";
            key = "Space";
            mods = "Super";
          }
          {
            chars = "\\u0002o";
            key = "K";
            mods = "Command|Shift";
          }
          {
            chars = "\\u0002o";
            key = "K";
            mods = "Super|Shift";
          }
        ];
      };
    };
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "tgi" = {
          host = "tgi";
          hostname = "10.90.0.154";
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
              lspconfig.pyright.setup {
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

      '';

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
      ignores = [ "*.sw[a-z]" ".envrc" "default.nix" ".direnv" ".venv"];
      lfs.enable = true;
      signing =  {
        signByDefault = true;
      };
      extraConfig = {
        push = { autoSetupRemote = true; };
        init = { defaultBranch = "main"; };
      };
    };
  programs.home-manager.enable = true;
}
