{
  description = "A very basic bitch.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-apple-silicon = {
      url = "github:quinneden/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    lix-module,
    nixos-apple-silicon,
    ...
  } @ inputs: let
    system = "aarch64-linux";
    pkgs = import nixpkgs {
      config.allowUnfree = true;
      overlays = [nixos-apple-silicon.overlays.default];
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {inherit self inputs;};
        modules = [
          nixos-apple-silicon.nixosModules.default
          lix-module.nixosModules.default
          ./configuration.nix
        ];
      };
    };
  };
}
