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
  zshCompletionDir = "${config.xdg.dataHome}/zsh/site-functions";

  generatedZshCompletions = [
    "podman completion zsh"
    "tailscale completion zsh"
  ];

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
  home.stateVersion = "26.11";
  news.display = "silent";

  home.packages = with pkgs; [
    actionlint
    aicommit2
    arduino-language-server
    astro-language-server
    basedpyright
    bash
    bash-language-server
    bat
    bottom
    bun
    chezmoi
    clang
    clang-tools
    comma
    deno
    direnv
    dockerfile-language-server
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
    nh
    nil
    nix-search-cli
    nixd
    nixfmt
    nodejs-slim
    osc
    powershell
    powershell-editor-services
    pyright
    ripgrep
    ruff
    rust-analyzer
    sheldon
    starship
    stylua
    tree-sitter
    ty
    typescript-language-server
    uv
    vim
    vscode-langservers-extracted
    vue-language-server
    yaml-language-server
    zoxide
    zsh

    llm-agents.ccusage
    llm-agents.claude-code
    # llm-agents.codex
    # llm-agents.dsh
    llm-agents.omp
    llm-agents.opencode
    llm-agents.pi
    llm-agents.orca

  ];

  home.file = {
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases = {
    ".." = "cd ../";
    "..." = "cd ../../";
    cat = "bat --paging=never --style=grid";
    clip = "osc copy";
    cls = "clear";
    d = ''cd "$(ghq list --full-path --exact yqYo1/dotfiles)"'';
    em = "emacs -nw";
    gp = "git pull";
    lg = "lazygit";
    ll = "eza -alhF --git --git-repos";
    ls = "eza -F";
    lt = "eza -T";
    vi = "nvim";
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

  # Declarative Agent Skills: one shared skill set delivered to every
  # Nix-managed agent. Hermes keeps its own skills directory for now, so it is
  # intentionally not a target here.
  programs.agent-skills =
    let
      # mattpocock/skills nests its skills as skills/<group>/<skill>/SKILL.md.
      # Agents discover only <target>/<skill>/SKILL.md, so every selected skill
      # is renamed to its basename and installed flat.
      mattSkills = [
          "engineering/ask-matt"
          "engineering/code-review"
          "engineering/codebase-design"
          "engineering/diagnosing-bugs"
          "engineering/domain-modeling"
          "engineering/grill-with-docs"
          "engineering/implement"
          "engineering/implement-spec"
          "engineering/improve-codebase-architecture"
          "engineering/pr"
          "engineering/prototype"
          "engineering/research"
          "engineering/retro"
          "engineering/setup-matt-pocock-skills"
          "engineering/tdd"
          "engineering/to-spec"
          "engineering/to-tickets"
          "engineering/triage"
          "engineering/wayfinder"
          "engineering/wizard"
          "in-progress/chief-of-staff"
          "in-progress/claude-handoff"
          "in-progress/loop-me"
          "in-progress/setup-ts-deep-modules"
          "in-progress/writing-beats"
          "in-progress/writing-fragments"
          "in-progress/writing-shape"
          "misc/git-guardrails-claude-code"
          "misc/migrate-to-shoehorn"
          "misc/scaffold-exercises"
          "misc/setup-pre-commit"
          "productivity/grill-me"
          "productivity/grilling"
          "productivity/handoff"
          "productivity/teach"
          "productivity/to-questionnaire"
          "productivity/wait-what"
          "productivity/writing-for-agents"
      ];
      flatFrom =
        source: ids:
        builtins.listToAttrs (
          map (id: {
            name = builtins.baseNameOf id;
            value = {
              from = source;
              path = id;
              rename = builtins.baseNameOf id;
            };
          }) ids
        );
      # builtins.listToAttrs keeps the first duplicate key and silently drops
      # the rest, so a basename collision added upstream would lose a skill
      # without an error. Fail loudly instead.
      mattNames = map builtins.baseNameOf mattSkills;
      mattDuplicateNames = lib.filter (
        name: builtins.length (builtins.filter (other: other == name) mattNames) > 1
      ) (lib.unique mattNames);
      explicitMatt =
        if mattDuplicateNames == [ ] then
          flatFrom "mattpocock" mattSkills
        else
          throw "agent-skills: duplicate mattpocock skill basenames: ${lib.concatStringsSep ", " mattDuplicateNames}";
    in
    {
      enable = true;

      sources = {
        # Skills authored in this repository. `nix/skills` is deliberately not
        # an agent-discoverable path (`.claude/skills`, `.agents/skills`, ...):
        # these are not project skills of the dotfiles repository itself.
        local = {
          path = ./skills;
        };

        # Third-party catalogs, all pinned by flake.lock.
        mattpocock = {
          input = "mattpocock-skills";
          subdir = "skills";
          filter.maxDepth = 2;
        };
        intel = {
          input = "intel-skills";
          subdir = "skills";
        };
        # intel/gpu-ai-skills ships the same skills as intel/skills; only its
        # unique skill is selected so the catalog has no duplicate IDs.
        intel-gpu = {
          input = "intel-gpu-ai-skills";
          subdir = "plugins/intel-gpu-ai-skills/skills";
          filter.nameRegex = "^enable-xpu-monitoring$";
        };
        uxl = {
          input = "uxl-skills";
          subdir = "skills";
        };
      };

      skills = {
        enable = [
          "git-workflow"
          "enable-xpu-monitoring"
          # intel/skills
          "cuda-to-xpu-migration"
          "dpnp-interop"
          "dpnp-io"
          "dpnp-linalg-fft"
          "dpnp-memory"
          "dpnp-migration"
          "dpnp-quickstart"
          "dpnp-random"
          "dpnp-troubleshooting"
          "linux-perf"
          "llamacpp-xpu-run"
          "mkl-extension-advisor"
          "model-can-it-fit"
          "model-config-recommend"
          "onetbb-quickstart"
          "performance-patterns"
          "phoronix-test-suite"
          "sglang-xpu-bench"
          "sglang-xpu-run"
          "torch-xpu-bench"
          "torch-xpu-profile"
          "torch-xpu-run"
          "vllm-xpu-bench"
          "vllm-xpu-profile"
          "vllm-xpu-run"
          "xpu-container-run"
          "xpu-deploy-plan"
          "xpu-discover"
          "xpu-model-type-detect"
          "xpu-port"
          "xpu-profile-unitrace"
          "xpu-runtime-preflight"
          "xpu-system-setup"
          # uxlfoundation/skills
          "uxl-oneccl"
          "uxl-onedal"
          "uxl-onednn"
          "uxl-onedpl"
          "uxl-onemath"
          "uxl-onetbb"
          "uxl-performance-validation"
          "uxl-sycl-build-debug"
        ];
        explicit = explicitMatt;
      };

      targets = {
        agents.enable = true; # omp / orca (shared Agent Skills home)
        claude.enable = true; # Claude Code
        opencode.enable = true; # opencode
        pi.enable = true; # pi
      };
    };

  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode;
    settings = {
      provider.litellm = {
        npm = "@ai-sdk/openai-compatible";
        name = "LiteLLM";
        options = {
          baseURL = "https://litellm.yqyoi.dev/v1";
          apiKey = "{env:LITELLM_API_KEY}";
        };
        models = {
          "deepseek-v4-flash" = {
            name = "DeepSeek V4 Flash";
          };
          "deepseek-v4-pro" = {
            name = "DeepSeek V4 Pro";
          };
          "glm-5.1" = {
            name = "GLM 5.1";
          };
          "glm-5.2" = {
            name = "GLM 5.2";
          };
          "qwen3.6-plus" = {
            name = "Qwen 3.6 Plus";
          };
          "qwen3.7-plus" = {
            name = "Qwen 3.7 Plus";
          };
          "qwen3.7-max" = {
            name = "Qwen 3.7 Max";
          };
          "kimi-k2.6" = {
            name = "Kimi K2.6";
          };
          "kimi-k2.7-code" = {
            name = "Kimi K2.7 Code";
          };
          "mimo-v2.5-pro" = {
            name = "MiMo-V2.5-Pro";
          };
          "mimo-v2.5" = {
            name = "MiMo-V2.5";
          };

        };
      };
      provider.opencode = {
        models = {
          "glm-5.3-flash-free" = {
            limit = {
              context = 1000000;
              output = 32000;
            };
            options.reasoningEffort = "max";
          };
          "deepseek-v4.1-flash-free" = {
            limit = {
              context = 1000000;
              output = 32000;
            };
            options.reasoningEffort = "max";
          };
        };
      };
      small_model = "opencode/glm-5.3-flash-free";
      model = "opencode/deepseek-v4.1-flash-free";
      default_agent = "build";
      autoupdate = false;
      permission = {
        edit = "allow";
        bash = {
          "*" = "ask";
          "pwd" = "allow";
          "ls" = "allow";
          "ls *" = "allow";
          "git status" = "allow";
          "git status *" = "allow";
          "git diff" = "allow";
          "git diff *" = "allow";
          "git push *" = "ask";
        };
      };
    };
  };

  # programs.dsh = {
  #   enable = true;
  #   # package = pkgs.llm-agents.dsh;
  #
  #   profiles.web = {
  #     plugins = [
  #       "@deepseek-ai/dsh-base"
  #       "@deepseek-ai/dsh-web-app"
  #
  #       # ChatGPT subscription / Codex
  #       # "dsh-codex@0.3.2"
  #     ];
  #
  #     # userPatches = [
  #     #   {
  #     #     id = "llm-openai-codex";
  #     #     config = {
  #     #       searchMode = "live";
  #     #
  #     #       # OpenAI/Codex native compaction
  #     #       useNativeCompaction = true;
  #     #     };
  #     #   }
  #     # ];
  #     #
  #     # specsHash = "sha256-INvE43uf7q58QjE11LlK0oPqTCjgXfIMm8DExVGX5mQ=";
  #   };
  # };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 30d --keep-one --optimise";
    };
  };

  # `nh` shells out to `nix`, but systemd user services run with the user
  # manager's environment, which has no Nix on PATH: the weekly cleanup fails
  # instantly. Give the generated unit an explicit PATH.
  systemd.user.services.nh-clean.Service.Environment = [
    "PATH=${pkgs.nix}/bin:/usr/bin:/bin"
  ];

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
      "hist_find_no_dups"
      "hist_ignore_all_dups"
      "hist_ignore_space"
      "hist_reduce_blanks"
      "hist_verify"
      "no_auto_pushd"
      "no_beep"
      "share_history"
    ];

    envExtra = ''
      skip_global_compinit=1
      gh_token_temp="$(env -u GH_TOKEN -u GITHUB_TOKEN gh auth token 2>/dev/null || true)"
      if [ -n "$gh_token_temp" ]; then
        export GH_TOKEN="$gh_token_temp"
        export GITHUB_TOKEN="$gh_token_temp"
      fi
      unset gh_token_temp
      [[ -r "${localZshEnv}" ]] && source "${localZshEnv}"
    '';

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        typeset -U fpath
        fpath=(
          "${zshCompletionDir}"
          "${config.home.profileDirectory}/share/zsh/site-functions"
          "${config.home.profileDirectory}/share/zsh/$ZSH_VERSION/functions"
          "${config.home.profileDirectory}/share/zsh/vendor-completions"
          /usr/local/share/zsh/site-functions
          /usr/local/share/zsh/vendor-completions
          /usr/share/zsh/site-functions
          /usr/share/zsh/vendor-completions
          /usr/share/zsh/vendor-functions
          $fpath
        )
      '')
      (lib.mkOrder 1000 ''
        zmodload -i zsh/complist

        # zstyle ':autocomplete::compinit' arguments -C
        zstyle ':autocomplete::compinit' arguments -i

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
      '')
    ];

    sessionVariables = {
      ZENO_HOME = "${config.home.homeDirectory}/.config/zeno";
      ZENO_ENABLE_SOCK = 1;
      ZENO_DISABLE_EXECUTE_CACHE_COMMAND = 1;
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
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
    enable = true;
    autoEnable = false;

    flavor = "mocha";
    accent = "mauve";

    bat.enable = true;
    bottom.enable = true;
    eza.enable = true;
    lazygit.enable = true;
    opencode.enable = true;
  };

  # service
  # systemd.user.services.codex-remote-control = {
  #   Unit = {
  #     Description = "OpenAI Codex Remote Control";
  #   };
  #
  #   Service = {
  #     Type = "simple";
  #     ExecStart = "${lib.getExe pkgs.llm-agents.codex} remote-control";
  #
  #     Restart = "always";
  #     RestartSec = 5;
  #
  #     # Codex 0.156.1+ の foreground remote-control で、
  #     # socket directory の permission check に引っ掛かる問題への対策。
  #     UMask = "0077";
  #
  #     Environment = [
  #       "PATH=${config.home.homeDirectory}/.local/bin:${config.home.profileDirectory}/bin:/usr/local/bin:/usr/bin:/bin"
  #     ];
  #   };
  #
  #   Install = {
  #     WantedBy = [ "default.target" ];
  #   };
  # };

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
      "aicommit2"
      "claude"
      "git"
      "lazygit"
      "nvim"
      "wezterm"
    ];
  };

  home.activation.generateExternalZshCompletions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      normalizeZshCompletionEntry =
        entry: if builtins.isString entry then { generate = entry; } else entry;

      inferCmdFromGenerate =
        entry:
        let
          normalized = normalizeZshCompletionEntry entry;
        in
        if normalized ? cmd then
          normalized.cmd
        else
          let
            parts = lib.filter (part: part != "") (lib.splitString " " normalized.generate);
          in
          if parts == [ ] then
            throw "generatedZshCompletions entry must have non-empty generate command"
          else
            lib.head parts;

      inferCompletionFile =
        entry:
        let
          normalized = normalizeZshCompletionEntry entry;
          cmd = inferCmdFromGenerate normalized;
        in
        normalized.file or "_${cmd}";

      generators = lib.concatMapStringsSep "\n" (
        rawEntry:
        let
          entry = normalizeZshCompletionEntry rawEntry;
          cmd = inferCmdFromGenerate entry;
          completionFile = inferCompletionFile entry;
          outputPath = "${zshCompletionDir}/${completionFile}";
          shellCommand = "${entry.generate} > ${lib.escapeShellArg outputPath}";
        in
        ''
          if command -v ${lib.escapeShellArg cmd} >/dev/null 2>&1; then
            if ! sh -c ${lib.escapeShellArg shellCommand}; then
              echo "warning: failed to generate zsh completion for ${cmd}" >&2
              rm -f ${lib.escapeShellArg outputPath}
            fi
          fi
        ''
      ) generatedZshCompletions;
    in
    ''
      PATH="${config.home.path}/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
      export PATH

      run mkdir -p ${lib.escapeShellArg zshCompletionDir}
      ${generators}
    ''
  );
}
