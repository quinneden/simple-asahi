{
  description = "A very basic bitch.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
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
        modules = [
          ./configuration.nix
        ];
        specialArgs = {
          inherit self inputs;
        };
      };
    };
  };
}
