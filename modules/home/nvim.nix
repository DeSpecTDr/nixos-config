# nvim config from MatthiasBenaets
# todo: https://github.com/figsoda/dotfiles/blob/main/lib/nvim/default.nix

{ pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        rust-tools-nvim
        crates-nvim
        direnv-vim
        vimtex

        # Syntax
        vim-nix
        vim-markdown

        # Quality of life
        vim-lastplace # Opens document where you left it
        auto-pairs # Print double quotes/brackets/etc.
        vim-gitgutter # See uncommitted changes of file :GitGutterEnable

        # File Tree
        nerdtree # File Manager - set in extraConfig to F6

        # Customization 
        wombat256-vim # Color scheme for lightline
        srcery-vim # Color scheme for text

        lightline-vim # Info bar at bottom
        indent-blankline-nvim # Indentation lines
      ];

      extraConfig = ''
        set clipboard+=unnamedplus                " Set global clipboard
        syntax enable                             " Syntax highlighting
        colorscheme srcery                        " Color scheme text
        let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ }                                     " Color scheme lightline
        highlight Comment cterm=italic gui=italic " Comments become italic
        hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal them
        set number                                " Set numbers
        nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree
      '';
    };
  };
}
