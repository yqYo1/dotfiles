# dotfiles

## init
WIP
### linux
1. install nix
```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --extra-conf "extra-trusted-users = $(id -un)"
```

2. run cmd on repo root
```bash
nix run .#switch
```

## agent skills

Agent Skills (`SKILL.md` directories) are managed declaratively with
[agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) through
`programs.agent-skills` in `nix/home.nix`.

### Sources

- `local` — `nix/skills/`, skills authored in this repository. The path is
  intentionally not an agent-discovered location (`.claude/skills`,
  `.agents/skills`, ...): these are not skills of the dotfiles repository itself.
- `mattpocock` — `github:mattpocock/skills`. The repository nests skills as
  `skills/<group>/<skill>/SKILL.md`, so every selected skill is renamed to its
  basename and installed flat.
- `intel` — `github:intel/skills`.
- `intel-gpu` — `github:intel/gpu-ai-skills`. It repeats the `intel` catalog, so
  the source is filtered to its unique skill (`enable-xpu-monitoring`) and the
  rest comes from `intel`.
- `uxl` — `github:uxlfoundation/skills`.

All non-local sources are `flake = false` inputs pinned in `flake.lock`.

### Selection and targets

Selection is source-driven, not name-driven: every skill the catalogs contain is
installed, so a flake input update never needs a hand-edited allowlist.

- `skills.enableAll` covers `local`, `intel`, `intel-gpu` and `uxl`. A skill that
  appears upstream is installed on the next activation.
- `mattpocock` is selected through `skills.explicit`, generated from the
  discovered catalog, because its two-level layout has to be flattened to
  `<target>/<skill>/SKILL.md`. New upstream skills are flattened the same way.
- `intel-gpu` is filtered to the skills `intel` does not provide. The filter is
  computed from both catalogs at evaluation time, so a gpu-only skill is picked
  up automatically and a skill that `intel` later absorbs stops being a
  duplicate instead of breaking evaluation.
- Structural drift fails the build instead of silently installing less: a source
  that yields no skills, a duplicate skill ID across sources, and duplicate
  flattened basenames all raise an evaluation error.

Targets follow `config.home.packages`: a target is enabled while the agent's
package is present there and disabled when it is removed. Detection never reads
`programs.*.enable`. Note that a Home Manager program module can itself add its
package to `home.packages` (for example `programs.opencode` does); such a package
counts, because `home.packages` is the single source of truth.

Every target agent-skills-nix ships is declared, whether or not it is installed
today. A package matches when `lib.getName` (pname, else name) equals one of the
listed names, so the same tool is found from nixpkgs, llm-agents, or a vendor
package.

| Target | Matched package names | Packaged as |
| --- | --- | --- |
| `agents` | `omp`, `orca` | nixpkgs and llm-agents |
| `claude` | `claude-code` | nixpkgs and llm-agents |
| `codex` | `codex` | nixpkgs and llm-agents |
| `copilot` | `github-copilot-cli`, `copilot-cli` | nixpkgs / llm-agents |
| `cursor` | `cursor-agent` | llm-agents |
| `gemini` | `gemini-cli` | nixpkgs and llm-agents |
| `opencode` | `opencode`, `opencode2` | nixpkgs / llm-agents |
| `pi` | `pi`, `pi-coding-agent` | llm-agents / nixpkgs |
| `windsurf` | `devin-desktop` | nixpkgs (`windsurf` is an alias attribute) |
| `antigravity` | `antigravity-ide`, `antigravity-cli` | nixpkgs / llm-agents |

A self-packaged agent whose name does not match can be registered by derivation:

```nix
pi = {
  names = [ "pi" "pi-coding-agent" ];
  packages = [ pkgs.my-own-pi ];
};
```

Name matching is what makes this cheap, and it has two known failure modes: a
different package that happens to share a name turns a target on, and a package
that gets renamed upstream turns a target off until the name list is updated.

Hermes is not a target yet. It keeps its own skills directory until that
directory is managed by Nix.

Each target directory is owned by agent-skills-nix and carries
`.agent-skills-managed.json`; synchronization rewrites it, so do not add
unmanaged files there. To take over an existing non-empty directory, run the
activation once with `AGENT_SKILLS_FORCE=1`.

### Add a skill

1. Local skill: create `nix/skills/<name>/SKILL.md`. It is installed on the next
   `nix run .#switch` without any list edit.
2. Third-party catalog: add the repository as a `flake = false` input and declare
   a source such as `sources.<name> = { path = inputs."<input>"; subdir = "skills"; };`,
   then add `<name>` to `skills.enableAll`. Its skills are installed as they are
   discovered.
3. Apply with `nix run .#switch`.
