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

- `programs.agent-skills.skills.enable` lists the skill IDs to install. The
  prefix-free IDs keep the installed layout flat (`<target>/<skill>/SKILL.md`),
  which is what agents discover.
- Targets are every Nix-managed agent: `agents` (`~/.agents/skills`, read by omp
  and orca), `claude` (`~/.claude/skills`), `opencode`
  (`~/.config/opencode/skills`), and `pi` (`~/.pi/agent/skills`).
- Hermes is not a target yet. It keeps its own skills directory until that
  directory is managed by Nix.

Each target directory is owned by agent-skills-nix and carries
`.agent-skills-managed.json`; synchronization rewrites it, so do not add
unmanaged files there. To take over an existing non-empty directory, run the
activation once with `AGENT_SKILLS_FORCE=1`.

### Add a skill

1. Local skill: create `nix/skills/<name>/SKILL.md` and add `"<name>"` to
   `skills.enable`.
2. Third-party skill: add the repository as a `flake = false` input, declare a
   source such as `sources.<name> = { input = "<input>"; subdir = "skills"; };`,
   then add the discovered skill IDs to `skills.enable`.
3. Apply with `nix run .#switch`.
