{
  description = "SilkOS Flake";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }@inputs: {
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    	system = "x86_64-linux";
	modules = [
	   ./configuration.nix
	];
    };
    
  };

}
