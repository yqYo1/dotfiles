{
  description = "Home Manager configuration of yayoi";

  nixConfig = {
    extra-substituters = [
      "https://catppuccin.cachix.org"
      "https://cache.numtide.com"
      # dsh-nix publishes the dsh build here; only the root flake's
      # nixConfig is applied, so the cache dsh-nix declares does not reach
      # consumers unless it is listed here.
      "https://yqyo1.cachix.org"
    ];
    extra-trusted-public-keys = [
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "yqyo1.cachix.org-1:8v2GAv9lm0AURGOHo92N4+lgAhVE0+v8ou3DFT7hDEg="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    aicommit2.url = "github:tak-bro/aicommit2";
    catppuccin.url = "github:catppuccin/nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    # No `nixpkgs.follows`: dsh-nix publishes its own build of dsh to
    # yqyo1.cachix.org, and rebuilding it against this flake's nixpkgs yields a
    # different derivation that no cache serves. home.nix uses the package from
    # dsh-nix so the cached build is reused.
    dsh-nix = {
      url = "github:yqYo1/dsh-nix";
    };
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Skill catalog sources (Agent Skills format). Non-flake inputs: consumed as
    # plain source trees by agent-skills-nix.
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    intel-skills = {
      url = "github:intel/skills";
      flake = false;
    };
    intel-gpu-ai-skills = {
      url = "github:intel/gpu-ai-skills";
      flake = false;
    };
    uxl-skills = {
      url = "github:uxlfoundation/skills";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      aicommit2,
      catppuccin,
      dsh-nix,
      flake-parts,
      llm-agents,
      systems,
      ...
    }:
    let
      lib = nixpkgs.lib;
      username = "yayoi";
      homeDirectory = "/home/${username}";
      dotfiles = self.outPath;
      linuxSystems = import systems;

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            # Use llm-agents' own package set. The shared-nixpkgs overlay
            # rebuilds its packages against this flake's nixpkgs, which makes
            # compiled packages (omp) a different derivation from the build
            # llm-agents publishes, so no binary cache can serve them.
            (final: prev: { llm-agents = llm-agents.packages.${system}; })
            (final: prev: {
              # codex sandbox
              # llm-agents = prev.llm-agents // {
              #   codex = prev.llm-agents.codex.overrideAttrs (old: {
              #     postFixup = builtins.replaceStrings [ "--prefix PATH :" ] [ "--suffix PATH :" ] old.postFixup;
              #   });
              # };
              aicommit2 = aicommit2.packages.${system}.default;
              llm-agents = prev.llm-agents // {
                dsh = prev.llm-agents.dsh.overrideAttrs (old: {
                  postInstall = (old.postInstall or "") + ''
                              addon="$out/lib/node_modules/@deepseek-ai/dsh/node_modules/node-addon-require-builtin/lib/index.js"

                              if [ ! -f "$addon" ]; then
                                echo "error: node-addon-require-builtin not found: $addon" >&2
                                exit 1
                              fi

                              cat > "$addon" <<'EOF'
                    'use strict';

                    function isAllowedInternalId(_id) {
                      return true;
                    }

                    function requireBuiltin(id) {
                      return require(id);
                    }

                    module.exports = {
                      isAllowedInternalId,
                      requireBuiltin,
                    };
                    EOF
                  '';
                });
              };
            })
          ];
        };

      mkHomeConfiguration =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;

          modules = [
            "${dotfiles}/nix/home.nix"
            catppuccin.homeModules.catppuccin
            dsh-nix.homeManagerModules.dsh
            inputs.agent-skills.homeManagerModules.default
          ];

          extraSpecialArgs = {
            inherit username homeDirectory dotfiles;
            # nix/agent-skills.nix reads the agent-skills library and the skill
            # catalog sources (all flake inputs) from this.
            inputs = inputs;
          };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = linuxSystems;

      perSystem =
        { system, ... }:
        let
          pkgs = mkPkgs system;
          hmAttr = "${username}-${system}";

          mkHmApp =
            name: command:
            let
              app = pkgs.writeShellApplication {
                name = "hm-${name}";
                runtimeInputs = [
                  home-manager.packages.${system}.home-manager
                ];
                text = ''
                  exec home-manager ${command} "$@"
                '';
              };
            in
            {
              type = "app";
              program = "${app}/bin/hm-${name}";
            };
        in
        {
          apps = rec {
            switch = mkHmApp "switch" "switch -b backup --flake .#${hmAttr}";
            build = mkHmApp "build" "build --flake .#${hmAttr}";
            generations = mkHmApp "generations" "generations --flake .#${hmAttr}";
            default = switch;
          };
        };

      flake.homeConfigurations = lib.genAttrs (map (system: "${username}-${system}") linuxSystems) (
        name:
        let
          system = lib.removePrefix "${username}-" name;
        in
        mkHomeConfiguration system
      );
    };
}
