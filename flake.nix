{
  description = "Home Manager configuration of yayoi";

  nixConfig = {
    extra-substituters = [
      "https://catppuccin.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      catppuccin,
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
          overlays = [
            llm-agents.overlays.default
          ];
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "github-copilot-cli"
            ];
        };

      mkHomeConfiguration =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;

          modules = [
            ./nix/home.nix
            catppuccin.homeModules.catppuccin
          ];

          extraSpecialArgs = {
            inherit username homeDirectory dotfiles;
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
            switch = mkHmApp "switch" "switch --flake .#${hmAttr}";
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
