{
  config,
  pkgs,
  inputs,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-apple-silicon.nixosModules.default
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = lib.mkForce false;
    };
    kernelParams = lib.mkForce ["console=tty0"];
  };

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  security = {
    sudo.wheelNeedsPassword = false;
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.root.password = "nixos";

  environment.systemPackages = with pkgs; [
    gh
    git
    micro
    ripgrep
  ];

  system.stateVersion = "24.11";
}
