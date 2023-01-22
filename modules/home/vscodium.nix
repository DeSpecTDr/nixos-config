{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium;
    extensions = with pkgs.unstable.vscode-extensions; [
      ms-toolsai.jupyter
      ms-python.python

      matklad.rust-analyzer
      vadimcn.vscode-lldb
      serayuzgur.crates
      tamasfe.even-better-toml

      jnoortheen.nix-ide
      mkhl.direnv

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

  xdg.configFile."VSCodium/product.json".text = ''
    {
      "extensionsGallery": {
        "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
        "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
        "itemUrl": "https://marketplace.visualstudio.com/items",
        "controlUrl": "",
        "recommendationsUrl": ""
      }
    }
  '';
}
