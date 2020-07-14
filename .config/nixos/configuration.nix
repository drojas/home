# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./all-packages.nix
      ./all-users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [
    "ext4"
    "ntfs"
  ];
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.plymouth = {
    enable = true;
    # theme = "fade-in";
    logo = ./saturn_small.png;
    extraConfig = ''
      DeviceScale=2
    '';
  };

  systemd.user.services.my-gnome-bg = {
    wantedBy = [ "graphical-session.target" ];
    # wantedBy = [ "graphical-session.target" ];
    # after = [ "graphical-session-pre.target" ];
    # partOf = [ "graphical-session.target" ];
    description = "Set random desktop background using FractalArt and gsettings";

    serviceConfig = with pkgs; {
      Type = "oneshot";
      ExecStart = [
        "${coreutils}/bin/mkdir -p %h/.backgrounds"
        "${haskellPackages.FractalArt}/bin/FractalArt --no-bg -f %h/.backgrounds/bg-img && ${glib.bin}/bin/gsettings set org.gnome.desktop.background picture-uri '%h/.backgrounds/bg-img'"
        "${haskellPackages.FractalArt}/bin/FractalArt --no-bg -f %h/.backgrounds/sc-img && ${glib.bin}/bin/gsettings set org.gnome.desktop.screensaver picture-uri '%h/.backgrounds/sc-img'"
      ];
      IOSchedulingClass = "idle";
    };
  };

  systemd.user.timers.my-gnome-bg = {
    description = "Set random desktop background using FractalArt and gsettings";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnStartupSec = "1";
      OnUnitActiveSec = "5m";
    };
  };

  networking.hostName = "matebook"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp60s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles"; 

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    tapping = true;
  };

  services.xserver.desktopManager.gnome3 = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.desktop.wm.preferences]
      theme="Dracula"
    '';
  };
  services.xserver.displayManager.gdm = {
    enable = true;
    # autoSuspend = false;
    autoLogin = {
      enable = true;
      user = "david";
    };
  };
  services.xserver.videoDrivers = [ "intel" ];

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
