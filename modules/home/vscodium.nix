{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      ms-toolsai.jupyter
      ms-python.python

      matklad.rust-analyzer
      vadimcn.vscode-lldb
      serayuzgur.crates
      tamasfe.even-better-toml

      jnoortheen.nix-ide
      # TODO: add mkhl.direnv

      james-yu.latex-workshop
      usernamehw.errorlens
      asvetliakov.vscode-neovim
    ];
    # userSettings = {
    #   "nix.enableLanguageServer" = true;
    #   "editor.formatOnSave" = true;
    #   "files.autoSave" = "afterDelay";
    #   "vscode-neovim.neovimExecutablePaths.linux" = "nvim";
    #   "editor.acceptSuggestionOnEnter" = "off";
    # };
    # keybindings = [
    #   {
    #     key = "ctrl+shift+c";
    #     command = "editor.action.clipboardCopyAction";
    #   }
    # ];
  };
}
