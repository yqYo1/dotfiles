# nix

Home Manager configuration for this profile.

## Layout

- `home.nix` — entry point: packages, programs, shell, editor, services.
- `agent-skills.nix` — declarative Agent Skills, imported by `home.nix`.
- `../skills/` — skills authored in this repository, at the repository root
  rather than under `nix/` so the source tree reads as skills first. The path is
  not one of the directories agents scan for project skills (`.claude/skills`,
  `.agents/skills`, ...), so having it in the repository does not advertise these
  skills to agents working on this repository.

`nix run .#switch` from the repository root applies the configuration.

## Agent skills

Agent Skills (`SKILL.md` directories) are managed with
[agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) through
`programs.agent-skills` in `agent-skills.nix`.

### Sources

- `local` — `skills/`, skills authored in this repository. The path is
  intentionally not an agent-discovered location (`.claude/skills`,
  `.agents/skills`, ...): these are not skills of the dotfiles repository itself.
- `mattpocock` — `github:mattpocock/skills`. The repository nests skills as
  `skills/<group>/<skill>/SKILL.md`, so every selected skill is renamed to its
  basename and installed flat.
- `intel` — `github:intel/skills`.
- `intel-gpu` — `github:intel/gpu-ai-skills`. It repeats the `intel` catalog, so
  the source is filtered to the skills `intel` does not provide.
- `uxl` — `github:uxlfoundation/skills`.

All non-local sources are `flake = false` inputs pinned in `flake.lock`.

### Selection

Selection is source-driven, not name-driven, so a flake input update never needs
a hand-edited allowlist.

- `skills.enableAll` covers `local`, `intel`, `intel-gpu` and `uxl`. A skill that
  appears upstream is installed on the next activation.
- `mattpocock` is selected through `skills.explicit`, generated from the
  discovered catalog, because its two-level layout has to be flattened to
  `<target>/<skill>/SKILL.md`. New upstream skills are flattened the same way.
- The `intel-gpu` filter is the complement of the `intel` catalog, computed at
  evaluation time. A gpu-only skill is picked up automatically and a skill that
  `intel` later absorbs stops being a duplicate instead of breaking evaluation.
- Structural drift fails the build instead of silently installing less: a source
  that yields no skills, a duplicate skill ID across sources, and duplicate
  flattened basenames all raise an evaluation error.

### Where agents look

Verified against each product's documentation or source. None of them scans a
plain `skills/` directory at the repository root: every path is a product-specific
directory, or the cross-agent `.agents/skills`.

| Harness | Project paths (repo) | User paths |
| --- | --- | --- |
| Claude Code | `.claude/skills` in the cwd and every parent up to the repo root, nested `<subdir>/.claude/skills`, `--add-dir <dir>/.claude/skills`; a plugin package uses `<plugin>/skills/` | `~/.claude/skills` (`CLAUDE_CONFIG_DIR`) |
| Codex CLI | `.agents/skills` in the cwd, parent directories and the repo root | `~/.agents/skills`; admin `/etc/codex/skills` |
| GitHub Copilot CLI | `.github/skills`, `.claude/skills`, `.agents/skills` | `~/.copilot/skills`, `~/.agents/skills` |
| opencode | `.opencode/skills`, `.claude/skills`, `.agents/skills` (walk up to the git worktree) | `~/.config/opencode/skills`, `~/.claude/skills`, `~/.agents/skills` |
| pi | `.pi/skills`, `.agents/skills` (ancestors) | `~/.pi/agent/skills` |
| omp | `.omp/skills` (ancestors) plus the `.claude`, `.codex`, `.config/opencode`, `.github` and `.agents` roots it reads as providers | `~/.omp/agent/skills` plus the same provider roots |
| orca | `.agents/skills`, plus provider roots such as `.claude/skills` and `.opencode/skills` | `~/.agents/skills` |
| Cursor | `.agents/skills`, `.cursor/skills`, including nested ones anywhere in the repo | `~/.agents/skills`, `~/.cursor/skills` |
| Windsurf / Devin Desktop | `.devin/skills` (legacy `.windsurf/skills`), `.agents/skills`, `.claude/skills` when Claude config reading is on | `~/.codeium/windsurf/skills`, `~/.config/devin/skills`, `~/.agents/skills` |
| Antigravity | `.agents/skills` (App, CLI and IDE) | App/IDE `~/.gemini/config/skills`; CLI `~/.gemini/antigravity-cli/skills`; legacy `~/.gemini/antigravity/skills` |
| Gemini CLI | `.gemini/skills`, `.agents/skills` | `~/.gemini/skills` |

Two agent-skills-nix defaults differ from the current product paths and only
matter if that agent is installed:

- `codex` writes `~/.codex/skills`, while the current Codex documentation lists
  `~/.agents/skills` (the `agents` target) for user scope.
- `antigravity` writes `~/.gemini/antigravity/skills`, the legacy IDE path. The
  App and IDE now read `~/.gemini/config/skills`, and the CLI reads
  `~/.gemini/antigravity-cli/skills`.

### Targets

Every target agent-skills-nix ships is declared, whether or not it is installed
today. A target is enabled while its agent's package is in
`config.home.packages` and disabled when the package is removed. Detection never
reads `programs.*.enable`.

A package matches when `lib.getName` (pname, else name) equals one of the
target's names. Every name below was checked against the pinned nixpkgs and
llm-agents.

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

A self-packaged agent whose name does not match is registered by derivation:

```nix
pi = {
  names = [ "pi" "pi-coding-agent" ];
  packages = [ pkgs.my-own-pi ];
};
```

Name matching is what makes this cheap, and it has two known failure modes: a
different package that happens to share a name turns a target on, and a package
that gets renamed upstream turns a target off until the name list is updated.

Each target directory is owned by agent-skills-nix and carries
`.agent-skills-managed.json`; synchronization rewrites it, so do not add
unmanaged files there. To take over an existing non-empty directory, run the
activation once with `AGENT_SKILLS_FORCE=1`.

### Add a skill

1. Local skill: create `skills/<name>/SKILL.md`. It is installed on the next
   `nix run .#switch` without any list edit.
2. Third-party catalog: add the repository as a `flake = false` input and declare
   a source such as `{ path = inputs."<input>"; subdir = "skills"; }` in
   `agent-skills.nix`, then add its name to `skills.enableAll`.
3. Apply with `nix run .#switch`.

### Verify

- Bundle contents:
  `nix build --no-link --print-out-paths '.#homeConfigurations."yayoi-x86_64-linux".config.programs.agent-skills.bundlePath' | xargs ls`
- Installed skills: `ls ~/.agents/skills | wc -l`
- Agent-side view: `omp skill list --json | jq '.skills | length'`
- Apply: `nix run`
