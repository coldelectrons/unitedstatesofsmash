{
  description = "United States of Smash";

  inputs = {
    # NixPkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # NixPkgs Unstable
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Lix
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Generate System Images
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib?ref=v3.0.3";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

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
    # 20250119 currently fails to build due to rustc 1.83??
    # nix-ld.url = "github:nix-community/nix-ld";
    # nix-ld.inputs.nixpkgs.follows = "unstable";

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixpkgs-xr.inputs.nixpkgs.follows = "nixpkgs";

    sd-webui.url = "github:Aerobreaker/stable-diffusion-webui-nix";
    sd-webui.inputs.nixpkgs.follows = "unstable";
    
    #
    # ========= Personal Repositories =========
    #
    # Private secrets repo.  See https://unmovedcentre.com/posts/secrets-management
    # Authenticate via ssh and use shallow clone
    nix-secrets = {
      url = "git+ssh://git@gitlab.com/superfrigidneutrinos/futile_efforts.git?ref=main&shallow=1";
      inputs = { };
    };

    # TODO LATER
    # Neovim
    # neovim.url = "github:coldelectrons/neovim";
    # neovim.inputs.nixpkgs.follows = "unstable";

    # Tmux
    # tmux.url = "github:coldelectrons/tmux";
    # tmux.inputs = {
    #   nixpkgs.follows = "nixpkgs";
    #   unstable.follows = "unstable";
    # };

    # Binary Cache
    attic = {
      url = "github:zhaofengli/attic";
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

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-snapd = {
      url = "github:nix-community/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-comfyui.url = "github:dyscorv/nix-comfyui";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "plusultra";
            title = "Plus Ultra";
          };

          namespace = "plusultra";
        };
        
        snowfallorg.user = {
          enable = true;
          name = "coldelectrons";
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
            "freeimage"
          ];
        };

        overlays = with inputs; [
          # neovim.overlays.default
          # tmux.overlay
          flake.overlays.default
          thaw.overlays.default
          drift.overlays.default
          icehouse.overlays.default
          attic.overlays.default
          # snowfall-docs.overlays.default
          # nixpkgs-news.overlays.default
          # lix-module.overlays.default
          # nix-comfyui.overlays.default
        ];

        systems.modules.nixos = with inputs; [
          home-manager.nixosModules.home-manager
          {
            # home-manager.useGlobalPkgs = true;
            # home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup"; # Set backup file extension
          }
          # nix-ld.nixosModules.nix-ld
          lix-module.nixosModules.default
          nixpkgs-xr.nixosModules.nixpkgs-xr
          vault-service.nixosModules.nixos-vault-service
          # TODO: Replace plusultra.services.attic now that vault-agent
          # exists and can force override environment files.
          # attic.nixosModules.atticd
          nix-snapd.nixosModules.default
          sops-nix.nixosModules.sops
          nur.modules.nixos.default
        ];
        # systems.hosts.hades.modules = with inputs; [
          # nixos-hardware.nixosModules.framework-11th-gen-intel
        # ];

        deploy = lib.mkDeploy { inherit (inputs) self; };

        checks = builtins.mapAttrs
          (
            system: deploy-lib: deploy-lib.deployChecks inputs.self.deploy
          )
          inputs.deploy-rs.lib;

        outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
      }
    // {
      self = inputs.self;
    };
}
