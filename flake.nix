{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations.nix-charlie = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.apple-t2
      ];
    };
  };
}
