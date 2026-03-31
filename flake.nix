{
  description = "Home Manager configuration of yayoi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@ {
    self,
    nixpkgs,
    flake-parts,
    home-manager,
    ...
  }:
    let
      system = "x86_64-linux";
      username = "yayoi";
      homeDirectory = "/home/${username}";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfreePackages = [
            "github-copilot-cli"
          ];
        };
      };

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
        in {
            type = "app";
            program = "${app}/bin/hm-${name}";
        };
    in {
      apps.${system} = rec {
          switch = mkHmApp "switch" "switch --flake .#${username}";

          build = mkHmApp "build" "build --flake .#${username}";

          generations = mkHmApp "generations" "generations --flake .#${username}";

          default = switch;
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

        extraSpecialArgs = {
          inherit username homeDirectory;
          };
      };
    };
}
