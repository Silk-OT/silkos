{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  # TODO Check if Needed
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};
  
  programs.zsh.enable = true;

  programs.zsh.ohMyZsh = {
     enable = true;
     #plugins = [ "..." ];
  }; 

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.silk = {
    #shell = pkgs.zsh;
    isNormalUser = true;
    description = "silk";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
       librewolf
       #vesktop	
       #vimPlugins.nvchad
       vscodium
    ];
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     wget
     kitty
     pavucontrol # PulseAudio Vol. Control
     pamixer # CLI PulseAudio Mixer
     bluez # BT - Support
     bluez-tools # BT - Tools
     xdg-desktop-portal-hyprland # Backend for Hyprland   
     dconf
     xwayland
  ];
  
  hardware = {
     bluetooth = {
        enable = true;
        powerOnBoot = true;
     };

     graphics = {
        enable = true;
        enable32Bit = true;
     };

     #amdgpu.amdvlk = { # Alt. Drivers for AMD GPU (Official Drivers by AMD)
     #   enable = true;
     #   support32Bit.enable = true;    
     #};
  };
 
  fonts.packages = with pkgs; [
     nerd-fonts.ubuntu
  ];
  
  security.rtkit.enable = true; # Enables RealtimeKit for audio
  security.polkit.enable = true; # Enables Polkit for Hyprland
  
  services.pulseaudio.enable = false; # Switches to Pipewire
  services.displayManager.ly.enable = true;
  services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
     #jack.enable = true; # Optional: Enables JACK applications
  };
 
  programs.hyprland = {
     enable = true;
     xwayland.enable = true;
  }; 
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Tells Electron apps to use Wayland  
  
  programs.steam = {
     enable = false;
     remotePlay.openFirewall = true;
     dedicatedServer.openFirewall = true;
     localNetworkGameTransfers.openFirewall = true;
     gamescopeSession.enable = true;
     extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
     enable = true;
     settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
	AllowUsers = [ "silk" ];
     };
     ports = [ 22 ];
  };

  services.printing.enable = true;
  # Open ports in the firewall.
  # Note: Added Ports for Minecraft
  networking.firewall.allowedTCPPorts = [ 25565 ]; 
  networking.firewall.allowedUDPPorts = [ 25565 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
