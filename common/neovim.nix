
{ config, lib, pkgs, ... }:
{
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
}
