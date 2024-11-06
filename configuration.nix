{ pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nixpkgs.config.allowUnfree = true;
  
      environment.systemPackages =
        [ 
          pkgs.neovim
          pkgs.onefetch
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
          pkgs.yarn
          pkgs.mkalias
          pkgs.google-chrome
          pkgs.pass
          pkgs.yazi
          pkgs.yabai
          pkgs.bat
          pkgs.luajit
          pkgs.pngpaste
          pkgs.fd
          pkgs.ripgrep
          pkgs.lazygit
          pkgs.go
          pkgs.nodejs
          pkgs.ruby
          pkgs.luajit
          pkgs.luajitPackages.magick
          pkgs.stow
          pkgs.postgresql_16_jit
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
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"

        ];
        casks = [
          "hammerspoon"
          "iina"
          ];
        masApps = {
          # "Yoink" = 457622435; 
        };
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;

        onActivation.cleanup = "zap";
      };

      services.nix-daemon.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;

      system.stateVersion = 5;

      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users."GabrielAraujo" = {
        name = "GabrielAraujo";
        home = "/Users/GabrielAraujo/";
      };
    }

