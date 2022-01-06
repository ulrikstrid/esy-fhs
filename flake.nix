{
  description = "Esy package manager packaged for Nix";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.anmonteiro.url = "github:anmonteiro/nix-overlays";
  outputs = { self, nixpkgs, flake-utils, anmonteiro }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ anmonteiro.overlay ];
      };
      defaultExtraPackages = [ ];
      defaultExtraBuildCommands = "";
      defaultRunScript = "bash -c $SHELL";
    in
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        packages =
          {
            esy = pkgs.esy;
          };
        lib = {
          makeFHS =
            { extraPackages ? defaultExtraPackages
            , extraBuildCommands ? defaultExtraBuildCommands
            , runScript ? defaultRunScript
            }: pkgs.buildFHSUserEnv
              {
                inherit runScript;
                name = "esy-fhs";
                targetPkgs = pkgs: with pkgs; extraPackages ++ [
                  binutils
                  curl
                  esy
                  gcc
                  git
                  glib.dev
                  gmp
                  gnupatch
                  gnumake
                  gnum4
                  linuxHeaders
                  nodejs
                  nodePackages.npm
                  patch
                  perl
                  pkgconfig
                  unzip
                  which
                ];
                extraBuildCommands = ''
                  cp ${pkgs.esy}/lib/ocaml/4.12.0/site-lib/esy/esyBuildPackageCommand $out/usr/lib/esy
                  cp ${pkgs.esy}/lib/ocaml/4.12.0/site-lib/esy/esyRewritePrefixCommand $out/usr/lib/esy
                  ${extraBuildCommands}
                '';
              };
          makeFHSApp =
            { extraPackages ? defaultExtraPackages
            , extraBuildCommands ? defaultExtraBuildCommands
            , runScript ? defaultRunScript
            }:
            let drv =
              lib.makeFHS { inherit extraPackages extraBuildCommands runScript; };
            in
            flake-utils.lib.mkApp { inherit drv; };
        };
        defaultApp = lib.makeFHSApp { };
      }
    );
}
