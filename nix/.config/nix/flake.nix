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
        codeql
        neovim
        tmux
        gum # for sesh
        jq
        yq
        zoxide
        ripgrep
        difftastic
        delta
        fd
        bat
        serpl
        fzf
        eza
        tree
        broot
        lazygit
        sesh
        wget
        curl
        git
        git-lfs
        gh
        gh-dash
        stylua
        stow
        discord
        docker
        obsidian
        ollama
	      raycast
        slack
        vscode
        nodejs
        nodePackages.npm
        # project discovery
        interactsh
        nuclei
        # python
        # python312
        # python312Packages.semgrep
      ];


      homebrew = {
        enable = true;
        taps = [
          "FelixKratz/formulae"
        ];
        brews = [
          "awscli"
          #"podman"
          "docker-credential-helper-ecr"
          # "docker-credential-helper"
          "mas" # To search the AppStore for App Ids with `mas search <App Name>`
          "borders" # https://github.com/FelixKratz/JankyBorders
          "scc" # for counting lines of code https://github.com/boyter/scc?tab=readme-ov-file
          "llm"
          "mitmproxy"
        ];
        casks = [
          "caffeine"
          "burp-suite-professional"
          "krisp"
          "docker"
          # "podman-desktop"
          "the-unarchiver"
          "google-drive"
          "google-chrome"
          "microsoft-edge"
          "zoom"
 	        "elgato-camera-hub"
          "ghostty"
          "font-source-code-pro"
          "synology-drive"
          "tailscale"
          "tunnelblick"
          "lookaway"
          "rectangle"
          "karabiner-elements"
          "msty"
          "granola"
          "intellij-idea"
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

      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "aarch64-darwin";
      programs.zsh.enable = true;
      security.pam.enableSudoTouchIdAuth = true;
      services.nix-daemon.enable = true;

      # https://daiderd.com/nix-darwin/manual/index.html
      system = {
        stateVersion = 5;

        configurationRevision = self.rev or self.dirtyRev or null;

        defaults = {
          LaunchServices = {
            LSQuarantine = false;
          };

          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
            AppleICUForce24HourTime = true;
            AppleShowAllExtensions = true;
            ApplePressAndHoldEnabled = false;

            # 120, 90, 60, 30, 12, 6, 2
            KeyRepeat = 2;

            # 120, 94, 68, 35, 25, 15
            InitialKeyRepeat = 15;

            "com.apple.mouse.tapBehavior" = 1;
            "com.apple.sound.beep.volume" = 0.0;
            "com.apple.sound.beep.feedback" = 0;
          };

          dock = {
            autohide = true;
            show-recents = false;
            launchanim = true;
            orientation = "right";
            tilesize = 48;
            mru-spaces = false;
          };

          finder = {
            AppleShowAllExtensions = true;
	          FXPreferredViewStyle = "clmv";
            _FXShowPosixPathInTitle = false;
          };

          loginwindow = {
            GuestEnabled = false;
            LoginwindowText = "pwntester";
          };

          screencapture = {
            location = "~/Pictures/screenshots";
          };

          trackpad = {
            Clicking = true;
            TrackpadThreeFingerDrag = true;
          };
        };

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
