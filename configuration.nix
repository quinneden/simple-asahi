{
  config,
  pkgs,
  inputs,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };

  hardware.asahi = {
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    withRust = true;
  };

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://quinneden.cachix.org"];
    trusted-substituters = config.nix.settings.substituters;
    trusted-public-keys = ["quinneden.cachix.org-1:1iSAVU2R8SYzxTv3Qq8j6ssSPf0Hz+26gfgXkvlcbuA="];
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "clean";
      plugins = ["zsh-navigation-tools" "eza"];
      extraConfig = ''
        zstyle ':omz:update' mode auto
        zstyle ':omz:update' frequency 13
      '';
    };
    shellAliases = {
      fuck = "sudo rm -rf";
      gst = "git status";
      gsur = "git submodule update --init --recursive";
      push = "git push";
      tree = "eza -aT -I '.git*'";
    };
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    gh
    git
    eza
    fzf
    micro
    ripgrep
  ];

  system.stateVersion = "24.11";
}
