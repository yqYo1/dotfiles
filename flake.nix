{
  description = "Home Manager configuration of yayoi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      home-manager,
      systems,
      ...
    }:
    let
      lib = nixpkgs.lib;
      username = "yayoi";
      homeDirectory = "/home/${username}";
      linuxSystems = import systems;

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
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

          modules = [ ./home.nix ];

          extraSpecialArgs = {
            inherit username homeDirectory;
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
