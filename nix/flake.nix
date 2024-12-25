{
  description = "Pwntester nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [ 
        mkalias # Needed to make nix gui apps available to spotlight/raycast
        neovim
        tmux
        obsidian
	raycast
        wezterm
      ];

      homebrew = {
        enable = true;
        brews = [
          # To search the AppStore for App Ids with `mas search <App Name>`
          "mas"
        ];
        casks = [
          "the-unarchiver"
        ];
	masApps = {
	  # "Things3" = 1111111;
        };
        # remove brew apps installed outside nix when rebuilding
        onActivation.cleanup = "zap";
        # Update and upgrade brew on rebuild
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
	
      fonts.packages = with pkgs; [
	  nerd-fonts.jetbrains-mono
	  nerd-fonts.monaspace
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';

      system.defaults = {
        dock.autohide = true;
	finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
      };

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#xbow
    darwinConfigurations."xbow" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # Apple Silicon Only
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "pwntester";
          };
        }
      ];
    };

    # darwinPackages = self.darwinConfigurations."xbow".pkgs;
  };
}
