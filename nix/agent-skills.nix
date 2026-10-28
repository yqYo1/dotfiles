{
  config,
  lib,
  inputs,
  ...
}:

let
  # Agent skill targets and how each one is detected in home.packages.
  #
  # `names` matches lib.getName (pname, else name) against the packages
  # installed in home.packages, so the same tool is found regardless of where
  # it is packaged (nixpkgs, llm-agents, vendor). `packages` matches exact
  # derivations for self-packaged builds whose name does not match.
  #
  # One entry per target that agent-skills-nix ships. The key must be the
  # target name; `dest` overrides the module's default destination for that
  # name.
  agentTargets = {
    agents = {
      names = [
        "omp"
        "orca"
      ];
    };
    codex = {
      names = [ "codex" ];
      # Codex reads ~/.agents/skills as its current user scope;
      # $CODEX_HOME/skills (~/.codex/skills) is deprecated in its source. Write
      # only to the modern location so a skill is never listed twice.
      dest = "$HOME/.agents/skills";
    };
    opencode = {
      names = [
        "opencode"
        "opencode2"
      ];
    };
    claude = {
      names = [ "claude-code" ];
    };
    copilot = {
      names = [
        "github-copilot-cli"
        "copilot-cli"
      ];
    };
    cursor = {
      names = [ "cursor-agent" ];
    };
    windsurf = {
      names = [ "devin-desktop" ];
    };
    antigravity = {
      names = [
        "antigravity-ide"
        "antigravity-cli"
      ];
    };
    gemini = {
      names = [ "gemini-cli" ];
    };
    pi = {
      names = [
        "pi"
        "pi-coding-agent"
      ];
      # packages = [ pkgs.my-own-pi ];
    };
    # A self-packaged agent: list its derivation here so the name does not
    # matter, for example
    #   my-agent = { names = [ ]; packages = [ pkgs.my-agent ]; };
  };

  agentPackageMatches =
    target: package:
    builtins.elem (lib.getName package) target.names
    || builtins.any (extra: extra.outPath == package.outPath) (target.packages or [ ]);

  agentTargetEnabled = target: builtins.any (agentPackageMatches target) config.home.packages;

in
{
  options.programs.agent-skills.enableWithoutPackage = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      Target names to enable even when the agent's package is not in
      `home.packages`. Use this for an agent installed outside Home Manager, for
      example a vendor installer or another distribution's package manager.
      Names must be one of the targets this module declares.
    '';
    example = [
      "claude"
      "opencode"
    ];
  };

  config = {
    # Declarative Agent Skills: one shared skill set delivered to the agents
    # declared below. Hermes Agent is not packaged by this flake and keeps its
    # own ~/.hermes/skills, so it is not a target.
    programs.agent-skills =
      let
        agentLib = inputs."agent-skills".lib.agent-skills;

        # Source definitions are used both by the module and by the catalog
        # queries below, so selection can never drift from what is discovered.
        srcLocal = {
          path = ../skills;
        };
        srcMatt = {
          path = inputs."mattpocock-skills";
          subdir = "skills";
          filter.maxDepth = 2;
        };
        srcIntel = {
          path = inputs."intel-skills";
          subdir = "skills";
        };
        srcGpu = {
          path = inputs."intel-gpu-ai-skills";
          subdir = "plugins/intel-gpu-ai-skills/skills";
        };
        srcUxl = {
          path = inputs."uxl-skills";
          subdir = "skills";
        };

        idsOf = name: source: builtins.attrNames (agentLib.discoverCatalog { ${name} = source; });

        localIds = idsOf "local" srcLocal;
        mattIds = idsOf "mattpocock" srcMatt;
        intelIds = idsOf "intel" srcIntel;
        gpuIds = idsOf "intel-gpu" srcGpu;
        uxlIds = idsOf "uxl" srcUxl;

        # intel/gpu-ai-skills repeats the intel/skills catalog. Drop every name
        # intel already provides and keep the remainder, so a new gpu-only skill
        # is picked up automatically and a skill that intel later absorbs stops
        # being duplicated instead of breaking evaluation.
        gpuUnique = builtins.filter (id: !(builtins.elem id intelIds)) gpuIds;
        # "a^" can never match, so an empty complement installs nothing rather
        # than falling back to every skill in the source.
        gpuRegex =
          if gpuUnique == [ ] then
            "a^"
          else
            "^(${lib.concatMapStringsSep "|" lib.escapeRegex gpuUnique})$";

        # mattpocock/skills nests skills as skills/<group>/<skill>/SKILL.md while
        # agents discover only <target>/<skill>/SKILL.md, so every discovered
        # skill is renamed to its basename and installed flat.
        mattNames = map builtins.baseNameOf mattIds;
        mattDuplicateNames = lib.filter (
          name: builtins.length (builtins.filter (other: other == name) mattNames) > 1
        ) (lib.unique mattNames);
        explicitMatt =
          if mattDuplicateNames == [ ] then
            builtins.listToAttrs (
              map
                (id: {
                  name = builtins.baseNameOf id;
                  value = {
                    from = "mattpocock";
                    path = id;
                    rename = builtins.baseNameOf id;
                  };
                })
                mattIds
            )
          else
            throw "agent-skills: duplicate mattpocock skill basenames: ${lib.concatStringsSep ", " mattDuplicateNames}";

        # A source that stops yielding skills means its layout moved upstream.
        # Fail instead of silently installing nothing.
        emptySources = map (entry: entry.name) (
          builtins.filter (entry: entry.ids == [ ]) [
            {
              name = "local";
              ids = localIds;
            }
            {
              name = "mattpocock";
              ids = mattIds;
            }
            {
              name = "intel";
              ids = intelIds;
            }
            {
              name = "intel-gpu";
              ids = gpuIds;
            }
            {
              name = "uxl";
              ids = uxlIds;
            }
          ]
        );
      in
      assert builtins.length emptySources == 0
      || throw "agent-skills: source(s) ${lib.concatStringsSep ", " emptySources} now yield no skills; check their layout upstream";
      {
        enable = true;

        sources = {
          local = srcLocal;
          mattpocock = srcMatt;
          intel = srcIntel;
          intel-gpu = srcGpu // {
            filter.nameRegex = gpuRegex;
          };
          uxl = srcUxl;
        };

        skills = {
          # Everything discovered is installed. A new upstream skill is picked up
          # without editing this file; mattpocock is selected through `explicit`
          # because its skills need flattening. intel-gpu is only selected while
          # it still has skills intel does not provide.
          enableAll =
            [
              "local"
              "intel"
              "uxl"
            ]
            ++ lib.optional (gpuUnique != [ ]) "intel-gpu";
          explicit = explicitMatt;
        };

        # A target is on while its agent's package is in `config.home.packages`,
        # or when it is named in `enableWithoutPackage`. Detection reads
        # `home.packages` and nothing else: no `programs.*.enable` lookups, so
        # centralising package declarations later (and stopping program modules
        # from injecting their own package into home.packages) needs no change
        # here.
        targets = builtins.mapAttrs (
          name: target:
          {
            # mkDefault so a profile can override the computed value for a
            # single target without a conflicting definition.
            enable = lib.mkDefault (
              agentTargetEnabled target
              || builtins.elem name config.programs.agent-skills.enableWithoutPackage
            );
          }
          // lib.optionalAttrs (target ? dest) { dest = lib.mkDefault target.dest; }
        ) agentTargets;
      };

    assertions = [
      {
        assertion = builtins.all (name: agentTargets ? ${name}) config.programs.agent-skills.enableWithoutPackage;
        message =
          "programs.agent-skills.enableWithoutPackage: unknown target(s) "
          + lib.concatStringsSep ", " (
            builtins.filter (name: !(agentTargets ? ${name})) config.programs.agent-skills.enableWithoutPackage
          );
      }
    ];
  };
}
