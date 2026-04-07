{
  config,
  lib,
  pkgs,
  username,
  homeDirectory,
  dotfiles,
  ...
}:

let
  localZshEnv = "${config.home.homeDirectory}/.zshenv.local";
  localZshRc = "${config.home.homeDirectory}/.zshrc.local";

  catppuccinZshFsh = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "zsh-fsh";
    rev = "a9bdf479f8982c4b83b5c5005c8231c6b3352e2a";
    hash = "sha256-WeqvsKXTO3Iham+2dI1QsNZWA8Yv9BHn1BgdlvR8zaw=";
  };

  mkXdgConfigDirs =
    base: names:
    lib.genAttrs names (name: {
      source = "${base}/${name}";
      recursive = true;
    });
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    actionlint
    arduino-language-server
    aicommit2
    basedpyright
    bat
    bottom
    bun
    chezmoi
    comma
    deno
    direnv
    efm-langserver
    emacs
    eza
    fd
    fzf
    gh
    ghq
    git
    git-wt
    jq
    lua-language-server
    neovim
    nil
    nix-search-cli
    nixd
    nixfmt
    nodejs-slim
    osc
    powershell
    powershell-editor-services
    ripgrep
    ruff
    sheldon
    starship
    stylua
    tree-sitter
    ty
    uv
    vim
    zoxide
    zsh

    llm-agents.copilot-cli
    llm-agents.jules
    llm-agents.kilocode-cli
    llm-agents.opencode
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;

  programs.bat.enable = true;
  programs.bottom.enable = true;
  programs.eza.enable = true;
  programs.lazygit = {
    enable = true;
    settings = { };
    package = pkgs.writeShellScriptBin "lazygit" ''
      export LG_CONFIG_FILE="${config.xdg.configHome}/lazygit/config.yml''${LG_CONFIG_FILE:+,$LG_CONFIG_FILE}"
      exec ${lib.getExe pkgs.lazygit} "$@"
    '';
  };

  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode;
    settings = {
      permission = {
        edit = "allow";
        bash = {
          "*" = "ask";
        };
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    autocd = false;
    enableCompletion = false;
    dotDir = "${config.xdg.configHome}/zsh";

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
        src = lib.cleanSource "${dotfiles}/zsh";
        file = "p10k.zsh";
      }
      {
        name = "zsh-autocomplete";
        # src = "${pkgs.zsh-autocomplete}/share/zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "bbba73ebdc7c01323e09d4d518e51e2d6847ccc2";
          sha256 = "sha256-998rYEyYD67XleSDbqvnQptRrGuG2N2AgFvTpFWvoV8=";
        };
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
      zmodload -i zsh/complist

      zstyle ':autocomplete::compinit' arguments -C

      zstyle ':autocomplete:*' widget-style list-choices
      zstyle ':autocomplete:*' min-input 1
      zstyle ':autocomplete:*' delay 0.0
      zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 4 )) )'

      bindkey '^I' menu-select
      [[ -n "''${terminfo[kcbt]-}" ]] && bindkey "''${terminfo[kcbt]}" reverse-menu-complete
      bindkey -M menuselect '^I' menu-complete
      [[ -n "''${terminfo[kcbt]-}" ]] && bindkey -M menuselect "''${terminfo[kcbt]}" reverse-menu-complete

      bindkey '^N' menu-select
      bindkey '^P' reverse-menu-complete

      bindkey -M menuselect '^N' menu-complete
      bindkey -M menuselect '^P' reverse-menu-complete

      fast-theme -q XDG:catppuccin-${config.catppuccin.flavor}

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
      ZENO_HOME = "${config.home.homeDirectory}/.config/zeno";
      ZENO_ENABLE_SOCK = 1;
      ZENO_DISABLE_EXECUTE_CACHE_COMMAND = 1;
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
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

  home.activation.ensureLocalZshFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.home.homeDirectory}"

    if [ ! -e "${localZshEnv}" ]; then
      run install -m 600 /dev/null "${localZshEnv}"
    fi

    if [ ! -e "${localZshRc}" ]; then
      run install -m 600 /dev/null "${localZshRc}"
    fi

    if ! grep -q "export LITELLM_API_KEY" "${localZshEnv}"; then
      echo "export LITELLM_API_KEY=\"input_LITELLM_API_KEY_here\"" >> "${localZshEnv}"
    fi
    if ! grep -q "export HF_TOKEN" "${localZshEnv}"; then
      echo "export HF_TOKEN=\"input_HF_TOKEN_here\"" >> "${localZshEnv}"
    fi
  '';

  catppuccin = {
    flavor = "mocha";
    accent = "mauve";

    bat.enable = true;
    bottom.enable = true;
    eza.enable = true;
    lazygit.enable = true;
    opencode.enable = true;
  };

  xdg = {
    enable = true;

    configFile = {
      "zeno/config.yml".text = ''
        snippets:
          - name: git status
            keyword: gs
            snippet: git status --short --branch
      '';

      "fsh/catppuccin-${config.catppuccin.flavor}.ini".source =
        "${catppuccinZshFsh}/themes/catppuccin-${config.catppuccin.flavor}.ini";

    }
    // mkXdgConfigDirs dotfiles [
      "lazygit"
      "aicommit2"
      "git"
      "nvim"
      "wezterm"
    ];
  };
}
