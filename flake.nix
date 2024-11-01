{
  description = "Plus Ultra";

  inputs = {
    # NixPkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # NixPkgs Unstable
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

<<<<<<< HEAD
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
||||||| parent of d20e02c (chore: update inputs)
=======
    # Lix
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
>>>>>>> d20e02c (chore: update inputs)
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # improved Wine variants
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Generate System Images
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib?ref=v3.0.3";
    # snowfall-lib.url = "path:/home/short/work/@snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Avalanche
    avalanche.url = "github:snowfallorg/avalanche";
    # avalanche.url = "path:/home/short/work/@snowfallorg/avalanche";
    avalanche.inputs.nixpkgs.follows = "unstable";

    # Snowfall Flake
    flake.url = "github:snowfallorg/flake?ref=v1.4.1";
    flake.inputs.nixpkgs.follows = "unstable";

    # Snowfall Thaw
    thaw.url = "github:snowfallorg/thaw?ref=v1.0.7";

    # Snowfall Drift
    drift.url = "github:snowfallorg/drift";
    drift.inputs.nixpkgs.follows = "nixpkgs";

    # Comma
    comma.url = "github:nix-community/comma";
    comma.inputs.nixpkgs.follows = "unstable";

    # System Deployment
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    # Run unpatched dynamically compiled binaries
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "unstable";

    # Neovim
    neovim.url = "github:coldelectrons/neovim";
    neovim.inputs.nixpkgs.follows = "unstable";

    # Tmux
    tmux.url = "github:coldelectrons/tmux";
    tmux.inputs = {
      nixpkgs.follows = "nixpkgs";
      unstable.follows = "unstable";
    };

    # Binary Cache
    attic = {
      url = "github:zhaofengli/attic";

      # FIXME: A specific version of Rust is needed right now or
      # the build fails. Re-enable this after some time has passed.
      inputs.nixpkgs.follows = "unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    # Vault Integration
    vault-service = {
      url = "github:DeterminateSystems/nixos-vault-service";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Hygiene
    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Backup management
    icehouse = {
      url = "github:snowfallorg/icehouse?ref=v1.1.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Yubikey Guide
    yubikey-guide = {
      url = "github:drduh/YubiKey-Guide";
      flake = false;
    };

    # GPG default configuration
    gpg-base-conf = {
      url = "github:drduh/config";
      flake = false;
    };

    bibata-cursors = {
      url = "github:suchipi/Bibata_Cursor";
      flake = false;
    };

  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        # snowfallorg.user.name = "coldelectrons";
        snowfall = {
          meta = {
            name = "plusultra";
            title = "Plus Ultra";
          };

          namespace = "plusultra";
        };
      };
    in
    lib.mkFlake
      {
        channels-config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "electron-25.9.0"
            "electron-27.3.11"
          ];
        };

        overlays = with inputs; [
          avalanche.overlays.default
          aux-website.overlays.default
          neovim.overlays.default
          tmux.overlay
          flake.overlays.default
          thaw.overlays.default
          drift.overlays.default
          cowsay.overlays.default
          icehouse.overlays.default
          rf.overlays.default
          attic.overlays.default
          snowfall-docs.overlays.default
          nixpkgs-news.overlays.default
          lix.overlays.default
        ];

<<<<<<< HEAD
      overlays = with inputs; [
        avalanche.overlays.default
        neovim.overlays.default
        tmux.overlay
        flake.overlays.default
        thaw.overlays.default
        drift.overlays.default
        icehouse.overlays.default
        attic.overlays.default
      ];
||||||| parent of d20e02c (chore: update inputs)
      overlays = with inputs; [
        avalanche.overlays.default
        aux-website.overlays.default
        neovim.overlays.default
        tmux.overlay
        flake.overlays.default
        thaw.overlays.default
        drift.overlays.default
        cowsay.overlays.default
        icehouse.overlays.default
        rf.overlays.default
        attic.overlays.default
        snowfall-docs.overlays.default
        nixpkgs-news.overlays.default
      ];
=======
        systems.modules.nixos = with inputs; [
          avalanche.nixosModules."avalanche/desktop"
          home-manager.nixosModules.home-manager
          nix-ld.nixosModules.nix-ld
          vault-service.nixosModules.nixos-vault-service
          # lix.nixosModules.default
          # TODO: Replace plusultra.services.attic now that vault-agent
          # exists and can force override environment files.
          # attic.nixosModules.atticd
        ];
>>>>>>> d20e02c (chore: update inputs)

<<<<<<< HEAD
      systems.modules.nixos = with inputs; [
        avalanche.nixosModules."avalanche/desktop"
        home-manager.nixosModules.home-manager
        nix-ld.nixosModules.nix-ld
        lix-module.nixosModules.default
        vault-service.nixosModules.nixos-vault-service
        # TODO: Replace plusultra.services.attic now that vault-agent
        # exists and can force override environment files.
        # attic.nixosModules.atticd
      ];
||||||| parent of d20e02c (chore: update inputs)
      systems.modules.nixos = with inputs; [
        avalanche.nixosModules."avalanche/desktop"
        home-manager.nixosModules.home-manager
        nix-ld.nixosModules.nix-ld
        vault-service.nixosModules.nixos-vault-service
        # TODO: Replace plusultra.services.attic now that vault-agent
        # exists and can force override environment files.
        # attic.nixosModules.atticd
      ];
=======
        systems.hosts.jasper.modules = with inputs; [
          nixos-hardware.nixosModules.framework-11th-gen-intel
        ];
>>>>>>> d20e02c (chore: update inputs)

<<<<<<< HEAD
      deploy = lib.mkDeploy { inherit (inputs) self; };
||||||| parent of d20e02c (chore: update inputs)
      systems.hosts.jasper.modules = with inputs; [
        nixos-hardware.nixosModules.framework-11th-gen-intel
      ];

      deploy = lib.mkDeploy { inherit (inputs) self; };
=======
        deploy = lib.mkDeploy { inherit (inputs) self; };

        checks = builtins.mapAttrs
          (
            system: deploy-lib: deploy-lib.deployChecks inputs.self.deploy
          )
          inputs.deploy-rs.lib;
>>>>>>> d20e02c (chore: update inputs)

        outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
      }
    // {
      self = inputs.self;
    };
}
