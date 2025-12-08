{
  description = "Pwntester nix-darwin system flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [ 
        bzip2
	      ffmpeg
        imagemagick
        mkalias # Needed to make nix gui apps available to spotlight/raycast
        interactsh # Not available in brew
      ];


      homebrew = {
        enable = true;
        taps = [
          "FelixKratz/formulae"
        ];
        brews = [
          "awscli"
          "docker-credential-helper-ecr"
          "mas" # To search the AppStore for App Ids with `mas search <App Name>`
          "sketchybar"
          "qemu"
          "graphviz"
          "switchaudio-osx"
          "bzip2"
          "ffmpeg"
          "imagemagick"
          "sqlmap"
          "neovim"
          "tmux"
          "gum" # for sesh
          "jq"
          "yq"
          "zoxide"
          "ripgrep"
          "difftastic"
          "delta"
          "fd"
          "bat"
          "serpl"
          "fzf"
          "eza"
          "tree"
          "broot"
          "lazygit"
          "sesh"
          "wget"
          "curl"
          "git"
          "git-lfs"
          "gh"
          "stylua"
          "stow"
          "docker"
          "nuclei"
          "nmap"
          "devcontainer"
          "max-sixty/worktrunk/wt"
          "gemini-cli"
        ];
        casks = [
          "utm" # Universal Tunneling Machine (VMs)
          "blackhole-16ch"
          "virtualbox"
          "ngrok"
          "caffeine"
          "burp-suite-professional"
          "docker-desktop"
          "claude-code"
          "copilot-cli"
          "the-unarchiver"
          "google-drive"
          "google-chrome"
          "microsoft-edge"
          "zoom"
 	        "elgato-camera-hub"
          "ghostty"
          "font-source-code-pro"
          "font-hack-nerd-font"
          "synology-drive"
          "tailscale-app"
          "rectangle"
          "karabiner-elements"
          "msty"
          "granola"
          "intellij-idea"
          "mitmproxy"
          "1password"
          "discord"
          "obsidian"
          "ollama-app"
          "raycast"
          "slack"
          "visual-studio-code"
          "codeql"
          "loupedeck"
        ];
	      # masApps disabled due to mas CLI limitations on newer macOS versions
        # Install these manually from the App Store if needed
        # masApps = {
	      #   "Things3" = 904280696;
        #   "Perplexity" = 6714467650;
        # };
        # remove brew apps installed outside nix when rebuilding
        # Note: loupedeck uses manual installer and must be upgraded with: brew upgrade --cask loupedeck
        onActivation.cleanup = "zap";
        # Update and upgrade brew on rebuild
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
	
      fonts.packages = with pkgs; [
	      nerd-fonts.jetbrains-mono
	      nerd-fonts.monaspace
      ];

      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "aarch64-darwin";
      programs.zsh.enable = true;
      security.pam.services.sudo_local.touchIdAuth = true;
      nix.enable = true;

      # https://daiderd.com/nix-darwin/manual/index.html
      system = {
        stateVersion = 5;
        primaryUser = "pwntester";

        configurationRevision = self.rev or self.dirtyRev or null;

        defaults = {
          CustomUserPreferences = {
            "com.knollsoft.Rectangle" = {
              screenEdgeGapTop = 35;
              screenEdgeGapBottom = 0;
              screenEdgeGapLeft = 0;
              screenEdgeGapRight = 0;
            };
          };
          NSGlobalDomain = {
            _HIHideMenuBar = true;
            NSAutomaticWindowAnimationsEnabled = false; # Reduce motion
          };
        };
        
        # defaults = {
        #   LaunchServices = {
        #     LSQuarantine = false;
        #   };
        #
        #   NSGlobalDomain = {
        #     AppleInterfaceStyle = "Dark";
        #     AppleICUForce24HourTime = true;
        #     AppleShowAllExtensions = true;
        #     ApplePressAndHoldEnabled = false;
        #
        #     # 120, 90, 60, 30, 12, 6, 2
        #     KeyRepeat = 2;
        #
        #     # 120, 94, 68, 35, 25, 15
        #     InitialKeyRepeat = 15;
        #
        #     "com.apple.mouse.tapBehavior" = 1;
        #     "com.apple.sound.beep.volume" = 0.0;
        #     "com.apple.sound.beep.feedback" = 0;
        #   };
        #
        #   dock = {
        #     autohide = true;
        #     show-recents = false;
        #     launchanim = true;
        #     orientation = "right";
        #     tilesize = 48;
        #     mru-spaces = false;
        #   };
        #
        #   finder = {
        #     AppleShowAllExtensions = true;
        #    FXPreferredViewStyle = "clmv";
        #     _FXShowPosixPathInTitle = false;
        #   };
        #
        #   loginwindow = {
        #     GuestEnabled = false;
        #     LoginwindowText = "pwntester";
        #   };
        #
        #   screencapture = {
        #     location = "~/Pictures/screenshots";
        #   };
        #
        #   trackpad = {
        #     Clicking = true;
        #     TrackpadThreeFingerDrag = true;
        #   };
        # };

        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        };
      };

      # Create symlinks so we can launch apps from Spotlight
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = [ "/Applications" ];
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
