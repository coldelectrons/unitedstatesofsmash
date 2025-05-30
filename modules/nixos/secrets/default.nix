{
  options,
  config,
  pkgs,
  lib,
  inputs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.secrets;

  secretsDirectory = builtins.toString inputs.nix-secrets;
  secretsFile = "${secretsDirectory}/secrets.yaml";

  userName = config.${namespace}.user.name;
  userHome = config.users.users.${userName}.home;
  hostName = config.networking.hostName;
in
{
  options.${namespace}.secrets = {
    enable = mkBoolOpt true "Whether or not to enable SOPS secrets.";
    inherit secretsFile;

  };

  config = mkIf cfg.enable {

    sops = {
      defaultSopsFile = "${secretsFile}";
      validateSopsFiles = false;

      age = {
        # automatically import host SSH keys as age keys
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };

      # secrets will be output to /run/secrets
      # e.g. /run/secrets/msmtp-password
      # secrets required for user creation are handled in respective ./users/<username>.nix files
      # because they will be output to /run/secrets-for-users and only when the user is assigned to a host.
      secrets = {
        # For home-manager a separate age key is used to decrypt secrets and must be placed onto the host. This is because
        # the user doesn't have read permission for the ssh service private key. However, we can bootstrap the age key from
        # the secrets decrypted by the host key, which allows home-manager secrets to work without manually copying over
        # the age key.
        # These age keys are are unique for the user on each host and are generated on their own (i.e. they are not derived
        # from an ssh key).
        "user-age-keys/${userName}-${hostName}" = {
          owner = config.users.users.${userName}.name;
          inherit (config.users.users.${userName}) group;
          # We need to ensure the entire directory structure is that of the user...
          path = "${userHome}/.config/sops/age/keys.txt";
        };
        # extract to default pam-u2f authfile location for passwordless sudo. see modules/common/yubikey
        "yubico/u2f_keys" = {
          owner = config.users.users.${userName}.name;
          inherit (config.users.users.${userName}) group;
          path = "${userHome}/.config/Yubico/u2f_keys";
        };

        # extract password/username to /run/secrets-for-users/ so it can be used to create the user
        "passwords/${userName}".neededForUsers = true;
        # "passwords/msmtp" = { };
        # borg password required by nix-config/modules/nixos/backup
        # "passwords/borg" = {
        #   owner = "root";
        #   group = if pkgs.stdenv.isLinux then "root" else "wheel";
        #   mode = "0600";
        #   path = "/etc/borg/passphrase";
        # };
        "wifi" = {
          owner = config.users.users.${userName}.name;
          group = config.users.users.${userName}.group;
        };
      };
    };
    # The containing folders are created as root and if this is the first ~/.config/ entry,
    # the ownership is busted and home-manager can't target because it can't write into .config...
    # FIXME:(sops) We might not need this depending on how https://github.com/Mic92/sops-nix/issues/381 is fixed
    system.activationScripts.sopsSetAgeKeyOwnership =
      let
        ageFolder = "${userHome}/.config/sops/age";
        user = config.users.users.${userName}.name;
        group = config.users.users.${userName}.group;
      in
      ''
        mkdir -p ${ageFolder} || true
        chown -R ${user}:${group} ${ageFolder}
      '';
  };

}

