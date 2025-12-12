{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Custom uv package until 0.9.3 lands in nixpkgs
in
{
  home.packages =
    with pkgs;
    [
      alacritty
      ripgrep
      gcc
      libiconv
      htop
      git
      jujutsu
      k9s
      gnupg
      unzip
      gh
      hub
      pre-commit
      fzf
      ruff
      pyright
      killall
      zellij
      cachix
      nixd
      nixfmt-rfc-style
      claude-code
      fg-virgil
      mosh
      ffmpeg
      uv
      barrier
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ mactop ];

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
      font.size = 12;
    };
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = true;
      };
      "genesis" = {
        hostname = "166.19.34.51";
        host = "genesis";
        identityFile = "~/.ssh/genesis_key";
      };
      "h100-206-*" = {
        hostname = "%h";
        forwardAgent = true;
        addKeysToAgent = "yes";
        # strictHostKeyChecking = false;
        identityFile = "~/.ssh/genesis_key";
        proxyJump = "genesis";
      };
      "tgi" = {
        host = "tgi";
        hostname = "10.90.2.214";
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
      "laptop" = {
        host = "laptop";
        hostname = "192.168.1.136";
        setEnv = {
          TERM = "xterm-256color";
        };
      };
      "m4" = {
        host = "m4";
        hostname = "192.168.1.131";
        setEnv = {
          TERM = "xterm-256color";
        };
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
      nvim-lspconfig
      cmp-nvim-lsp
      cmp-vsnip
      cmp-buffer
      cmp-path
      cmp-cmdline
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
                      
                        -- Set up LSP with nvim-lspconfig
                        local lspconfig = require('lspconfig')
                        local capabilities = require('cmp_nvim_lsp').default_capabilities()

                        -- Setup LSP servers
                        lspconfig.rust_analyzer.setup {
                          capabilities = capabilities
                        }

                        -- Setup pyright for Python (everything except formatting)
                        lspconfig.pyright.setup {
                          capabilities = capabilities,
                          settings = {
                            python = {
                              analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "workspace",
                                useLibraryCodeForTypes = true
                              }
                            }
                          }
                        }

                        -- Setup ruff for Python formatting and import organization
                        lspconfig.ruff.setup {
                          capabilities = capabilities,
                          init_options = {
                            settings = {
                              -- Ruff will handle formatting and import sorting
                              organizeImports = true,
                              fixAll = false,  -- We only want formatting, not auto-fixing
                            }
                          },
                          -- Only attach ruff for formatting-related capabilities
                          on_attach = function(client, bufnr)
                            -- Disable hover in favor of Pyright
                            client.server_capabilities.hoverProvider = false
                          end,
                        }

                        lspconfig.nixd.setup {
                          capabilities = capabilities
                        }

                        lspconfig.zls.setup {
                          capabilities = capabilities
                        }

                        -- LSP keybindings setup
                        vim.api.nvim_create_autocmd('LspAttach', {
                          callback = function(args)
                            local opts = { buffer = args.buf, noremap = true, silent = true }

                            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                            vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, opts)
                            vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, opts)
                            vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, opts)
                            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                            vim.keymap.set("n", "<space>f", function()
                              vim.lsp.buf.format()
                            end, opts)
                          end,
                        })

                        -- Set up autoformat on save using LSP
                        vim.api.nvim_create_autocmd("BufWritePre", {
                          pattern = "*",
                          callback = function()
                            -- Use LSP formatting for all files
                            vim.lsp.buf.format()
                          end,
                        })
          	  '';
      }

      {
        plugin = fzf-vim;
        config = ''
          noremap <silent> <c-k> :FZF<cr>
          " Removed <c-m> mapping - conflicts with Enter key in quickfix
          noremap <silent> <c-l> :Rg<cr>
        '';
      }
      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin"; # catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
      }
    ];
    extraLuaConfig = ''
      -- Basic vim settings
      vim.opt.backspace = '2'        -- For macOS apparently we need to set that
      vim.opt.number = true          -- Display line numbers
      vim.opt.numberwidth = 1        -- using only 1 column (and 1 space) while possible
      vim.opt.background = 'dark'    -- We are using dark background in vim

      -- Set colorscheme
      vim.cmd('colorscheme catppuccin')


      -- Ignore these files when completing
      vim.opt.wildignore:append({"*.o", "*.obj", ".git", "*.pyc"})

      -- Tab settings
      vim.opt.tabstop = 4       -- show existing tab with 4 spaces width
      vim.opt.shiftwidth = 4    -- when indenting with '>', use 4 spaces width
      vim.opt.expandtab = true  -- On pressing tab, insert 4 spaces

      vim.opt.mouse = 'v'

      -- Nuro language syntax highlighting
      local function setup_nuro_syntax()
        print("DEBUG: setup_nuro_syntax called!")
        -- Enable syntax highlighting
        vim.cmd("syntax on")
        -- Clear any existing syntax for this buffer
        vim.cmd("syntax clear")
        
        -- Keywords
        vim.cmd([[syntax keyword nuroKeyword fn pub let const return struct if else while for]])
        vim.cmd([[syntax keyword nuroKeyword reduce write io stdout file]])

        -- Types
        vim.cmd([[syntax keyword nuroType void i8 i16 i32 i64 u8 u16 u32 u64 f32 f64 bool]])

        -- Constants
        vim.cmd([[syntax keyword nuroConstant true false]])

        -- Operators
        vim.cmd([[syntax match nuroOperator "\v\+|\-|\*|\/|\%|\=|\!\=|\<|\>|\<\=|\>\=|\&\&|\|\||\!"]])

        -- Numbers
        vim.cmd([[syntax match nuroNumber "\v<\d+[iu](8|16|32|64)>"]])
        vim.cmd([[syntax match nuroNumber "\v<\d+(\.\d+)?f(32|64)>"]])
        vim.cmd([[syntax match nuroNumber "\v<\d+>"]])
        vim.cmd([[syntax match nuroNumber "\v<0x[0-9a-fA-F]+>"]])

        -- Strings
        vim.cmd('syntax region nuroString start="\\"" end="\\"" contains=nuroEscape')
        vim.cmd([[syntax match nuroEscape "\\[nrt\\']" contained]])

        -- Comments
        vim.cmd('syntax match nuroComment "//.*$"')
        vim.cmd('syntax region nuroComment start="/\\*" end="\\*/"')

        -- Tensor types and indexing
        vim.cmd('syntax match nuroTensorType "\\v\\[[^\\]]*\\][a-zA-Z0-9_]+"')
        vim.cmd('syntax match nuroTensorIndex "\\v[a-zA-Z_][a-zA-Z0-9_]*\\[[ijk, ]*\\]"')

        -- Function definitions
        vim.cmd('syntax match nuroFunction "\\v<fn\\s+[a-zA-Z_][a-zA-Z0-9_]*"')

        -- Identifiers
        vim.cmd('syntax match nuroIdentifier "\\v<[a-zA-Z_][a-zA-Z0-9_]*>"')

        -- Delimiters
        vim.cmd('syntax match nuroDelimiter "\\v[\\(\\)\\[\\]\\{\\},;:]"')

        -- Special constructs
        vim.cmd('syntax keyword nuroSpecial reduce')
        vim.cmd('syntax match nuroSpecial "\\v<io\\.(stdout|file)"')

        -- Highlighting groups
        vim.cmd([[highlight default link nuroKeyword Keyword]])
        vim.cmd([[highlight default link nuroType Type]])
        vim.cmd([[highlight default link nuroConstant Constant]])
        vim.cmd([[highlight default link nuroOperator Operator]])
        vim.cmd([[highlight default link nuroNumber Number]])
        vim.cmd([[highlight default link nuroString String]])
        vim.cmd([[highlight default link nuroEscape SpecialChar]])
        vim.cmd([[highlight default link nuroComment Comment]])
        vim.cmd([[highlight default link nuroTensorType Type]])
        vim.cmd([[highlight default link nuroTensorIndex Identifier]])
        vim.cmd([[highlight default link nuroFunction Function]])
        vim.cmd([[highlight default link nuroIdentifier Identifier]])
        vim.cmd([[highlight default link nuroDelimiter Delimiter]])
        vim.cmd([[highlight default link nuroSpecial Special]])

        vim.b.current_syntax = "nuro"
      end

      -- Create autocommands for Nuro language
      local nuro_group = vim.api.nvim_create_augroup("NuroLanguage", { clear = true })

      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        group = nuro_group,
        pattern = "*.nu",
        callback = function()
          vim.bo.filetype = "nuro"
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = nuro_group,
        pattern = "nuro",
        callback = setup_nuro_syntax,
      })
    '';

  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
    nix-direnv.enable = true;
  };
  programs.k9s.enable = true;
  programs.gpg.enable = true;
  programs.git = {
    enable = true;
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
    settings = {
      user = {
        email = "patry.nicolas@protonmail.com";
        name = "Nicolas Patry";
      };
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
