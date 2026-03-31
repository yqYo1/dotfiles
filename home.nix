{ config, lib, pkgs, username, homeDirectory, ... }:

let
  localZshEnv = "${config.home.homeDirectory}/.zshenv.local";
  localZshRc = "${config.home.homeDirectory}/.zshrc.local";


in
{
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    actionlint
    basedpyright
    bat
    bun
    chezmoi
    comma
    deno
    efm-langserver
    emacs
    eza
    fd
    fzf
    gh
    ghq
    git
    git-wt
    github-copilot-cli
    jq
    lazygit
    lua-language-server
    neovim
    nodejs-slim
    nix-search-cli
    osc
    powershell
    powershell-editor-services
    ripgrep
    ruff
    sheldon
    starship
    tree-sitter
    uv
    vim
    zoxide
    zsh
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;

    autocd = false;

    enableCompletion = false;

    plugins = [
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
      }
      # {
      #   name = "zeno";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "yuki-yano";
      #     repo = "zeno.zsh";
      #     rev = "d57a389";
      #     hash = "sha256-1vqSLW78/jSEWJB0Ui7Mm4frRpnS8qrfEtnnyd+eX2o=";
      #   };
      #   file = "zeno.zsh";
      # }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./zsh;
          file = "p10k.zsh";
      }
      {
        name = "zsh-autocomplete";
        src = "${pkgs.zsh-autocomplete}/share/zsh-autocomplete";
        file = "zsh-autocomplete.plugin.zsh";
      }
    ];

    history = {
      append = true;
      saveNoDups = true;
      save = 1000000;
    };

    setOptions = [
      "no_auto_pushd"
      "no_beep"
      "hist_reduce_blanks"
      "hist_ignore_all_dups"
      "hist_ignore_space"
      "hist_verify"
      "share_history"
    ];

    envExtra = ''
      skip_global_compinit=1
      [[ -r "${localZshEnv}" ]] && source "${localZshEnv}"
    '';

    initContent = ''
      zstyle ':autocomplete::compinit' arguments -C

      if [[ -n $ZENO_LOADED ]]; then
        bindkey '^x^i' zeno-completion
        bindkey '^r'   zeno-history-selection
      fi

      zshaddhistory() {
        [[ "$?" == 0 ]]
      }

      [[ -r "${localZshRc}" ]] && source "${localZshRc}"
    '';

    sessionVariables = {
      ZENO_HOME="${config.home.homeDirectory}/.config/zeno";
      ZENO_ENABLE_SOCK=1;
      ZENO_DISABLE_EXECUTE_CACHE_COMMAND=1;
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true;
    };

    shellAliases = {
      ".." = "cd ../";
      "..." = "cd ../../";
      cat = "bat --paging=never --style=grid";
      clip = "osc copy";
      cls = "clear";
      d = "cd $(ghq list --full-path --exact yqYo1/dotfiles)";
      em = "emacs -nw";
      gp = "git pull";
      lg = "lazygit";
      ll = "eza -alhF --git --git-repos";
      ls = "eza -F";
      lt = "eza -T";
      vi = "nvim";
    };

    siteFunctions = {
      frepo = ''
        local repo_dir=$(ghq list --full-path | fzf --preview "bat --color=always --style=header,grid --line-range :80 {}/README.*")
        if [ -n "$repo_dir" ]; then
          cd -- $repo_dir
        fi
      '';
    };
  };

  xdg.configFile."zeno/config.yml".text = ''
    snippets:
      - name: git status
        keyword: gs
        snippet: git status --short --branch
  '';

  home.activation.ensureLocalZshFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "${config.home.homeDirectory}"

      if [ ! -e "${localZshEnv}" ]; then
        run install -m 600 /dev/null "${localZshEnv}"
      fi

      if [ ! -e "${localZshRc}" ]; then
        run install -m 600 /dev/null "${localZshRc}"
      fi

      if ! grep -q "export LITELLM_API_KEY" "${localZshEnv}"; then
        echo "export LITELLM_API_KEY=\"LITELLM_API_KEY\"" >> "${localZshEnv}"
      fi
  '';

}
