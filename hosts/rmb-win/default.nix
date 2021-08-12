{ lib, pkgs, config, modulesPath, suites, ... }:

with lib;
let
  defaultUser = "nixos";
  syschdemd = import ./syschdemd.nix { inherit lib pkgs config defaultUser; };
in
{
  ### root password is empty by default ###
  imports = suites.wsl;

  boot.isContainer = true;

  environment.etc.hosts.enable = false;
  environment.etc."resolv.conf".enable = false;

  networking.dhcpcd.enable = false;

  users.users.root = {
    shell = "${syschdemd}/bin/syschdemd";
    # Otherwise WSL fails to login as root with "initgroups failed 5"
    extraGroups = [ "root" ];
    password = "adminmkl";
  };

  security.sudo.wheelNeedsPassword = false;

  services.vscode-server.enable = true;

  environment.variables.VSCODE_WSL_EXT_LOCATION = "/mnt/c/Users/luqma/.vscode/extensions/ms-vscode-remote.remote-wsl-0.58.2";

  # Disable systemd units that don't make sense on WSL
  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;

  systemd.services.firewall.enable = false;
  systemd.services.systemd-resolved.enable = false;
  systemd.services.systemd-udevd.enable = false;

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;


  # These are from nixos minimal profile
  environment.noXlibs = true;
  i18n.supportedLocales = [ (config.i18n.defaultLocale + "/UTF-8") ];

  # Enable documentations, since I'm not Dr. Strange
  documentation.enable = true;
  documentation.nixos.enable = true;
}
