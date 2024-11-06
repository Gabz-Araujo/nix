{ pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nixpkgs.config.allowUnfree = true;
  
      environment.systemPackages =
        [ 
          pkgs.neovim
          pkgs.tmux
          pkgs.git
          pkgs.gh
          pkgs.kitty
          pkgs.obsidian
          pkgs.eza
          pkgs.starship
          pkgs.moreutils
          pkgs.gum
          pkgs.glow
          pkgs.fzf
          pkgs.zoxide
          pkgs.zsh-syntax-highlighting
          pkgs.zsh-autosuggestions
          pkgs.yarn
          pkgs.mkalias
        ];

      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];

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
          while read src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

      homebrew = {
        enable = true;
        brews = [
          "mas"
        ];
        casks = [
          "hammerspoon"
          "iina"
        ];
        masApps = {
          # "Yoink" = 457622435; 
        };

        onActivation.cleanup = "zap";
      };

      
      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # services.karabiner-elements.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;
      # programs.fish.enable = true;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users."GabrielAraujo" = {
        name = "GabrielAraujo";
        home = "/Users/GabrielAraujo";
      };
    }
