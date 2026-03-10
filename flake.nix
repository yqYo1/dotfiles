{
  description = "Home Manager configuration of yayoi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }:
    let
      system = "x86_64-linux";
      username = "yayoi";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      apps.${system}.switch = {
        type = "app";
        program = let
          switchScript = pkgs.writeShellScriptBin "switch" ''
            ${home-manager.packages.${system}.home-manager}/bin/home-manager switch --flake .#${username} "$@"
          '';
        in "${switchScript}/bin/switch";
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

      };

    };
}
