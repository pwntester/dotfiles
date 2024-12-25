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
      environment.systemPackages = with pkgs; [ 
        mkalias # Needed to make nix gui apps available to spotlight/raycast
        neovim
        tmux

        #burpsuite
        discord
        docker
        obsidian
        ollama
	raycast
        slack
        synology-drive-client
        tailscale
        vscode
        wezterm
        #zoom
      ];

      homebrew = {
        enable = true;
        brews = [
          # To search the AppStore for App Ids with `mas search <App Name>`
          "mas"
        ];
        casks = [
          burp-suite-professional
          krisp
          the-unarchiver
          google-drive
          google-chrome
          zoom
          rectangle
        ];
	masApps = {
	  "Things3" = 904280696;
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

      nixpkgs.config.allowUnfree = true;
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 5;
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;

      # Create symlinks so we can launch apps from Spotlight
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
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
	finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled = false;
        loginwindow.LoginwindowText = "pwntester";
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        screencapture.location = "~/Pictures/screenshots";
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
