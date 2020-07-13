{
  config,
  pkgs,
  lib,
  ...
}:

with pkgs;

{
  # nixpkgs.config  = (import ./config.nix);

  programs.home-manager.enable = true;
  gtk.theme.name = "Dracula";

  programs.bash = {
    enable = true;
    initExtra = ''
      ${neofetch}/bin/neofetch | ${lolcat}/bin/lolcat
      ${fortune}/bin/fortune \
        | ${cowsay}/bin/cowsay \
        | ${lolcat}/bin/lolcat
      # sudo kubectl cluster-info | ${lolcat}/bin/lolcat
      git -C "$HOME" status --porcelain | ${lolcat}/bin/lolcat
    '';
  };

  programs.git = {
    enable = true;
    userName = "David Rojas Camaggi";
    userEmail = "drojascamaggi@gmail.com";
    extraConfig = {
      url = {
        "git@github.com:drojas/" = {
          insteadOf = "drojas:";
        };
        "git@github.com:" = {
          insteadOf = "gh:";
        };
      };
    };
  };

  home = {
    #sessionVariables = {
    #  VISUAL = "emacsclient";
    #  EDITOR = "emacsclient";
    #  LANG = "en_US.UTF-8";
    #};

    activation = {
      spacemacs = config.lib.dag.entryAfter [ "installPackages" ] ''
        $DRY_RUN_CMD git clone -b develop gh:syl20bnr/spacemacs ~/.config/emacs 2>/dev/null || true
        $DRY_RUN_CMD rm -fr ~/.emacs.d.old || true
        $DRY_RUN_CMD mv ~/.emacs.d ~/.emacs.d.old || true
        $DRY_RUN_CMD git -C ~/.config/emacs pull
      '';

      remote = config.lib.dag.entryAfter [ "installPackages" ] ''
        $DRY_RUN_CMD git -C "$HOME" init
        echo "local initialized"

        $DRY_RUN_CMD git -C "$HOME" remote add origin drojas:home || true
        echo "remote origin set"

        $DRY_RUN_CMD git -C "$HOME" config status.showUntrackedFiles no
        echo "config set"

        $DRY_RUN_CMD git -C "$HOME" fetch origin master || true
        echo "tree ready"

        $DRY_RUN_CMD git -C "$HOME" checkout master || true
        echo "tree synced"

        $DRY_RUN_CMD git -C "$HOME" branch --set-upstream-to=origin/master || true
        echo "branch tracking set"
      '';
    };
  };

  xresources = {
    extraConfig = builtins.readFile(
      pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "xresources";
        rev = "ca0d05cf2b7e5c37104c6ad1a3f5378b72c705db";
        sha256 = "0ywkf2bzxkr45a0nmrmb2j3pp7igx6qvq6ar0kk7d5wigmkr9m5n";
      } + "/Xresources"
    );
  };
}
