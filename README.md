# esy-fhs

Esy and Nix are [not compatible](https://github.com/esy/esy/issues/972).

However, it is possible to use Nix to construct the kind of environment Esy
expects, and then use Esy to build your project. This repository provides a Nix
flake for doing just that - it builds an FHS-compatible chroot environment with
Esy and its dependencies installed, from which you can use `esy` commands as
normal.

## Usage

(Be sure
[Nix flake support is enabled](https://nixos.wiki/wiki/Flakes#Installing_flakes))

The main function exposed is `lib.makeFHSApp` - this lets you create an "app"
can run use with `nix run`.

Example:

```nix
# flake.nix
{
  inputs.esy-fhs.url = "github:d4hines/esy-fhs";
  outputs = { self, esy-fhs }: {
      defaultApp = lib.makeFHSApp { };
  };
}
```

To use `esy`, run `nix run`. When successful, nothing should change, except you
should notice `esy` is now on your path.

( To speed up build time, I recommend you use https://app.cachix.org/cache/anmonteiro)

There additional options you can pass to `lib.makeFHSApp`:

- `extraPackages` - additional nix packages to install in an FHS-compatible way.
- `extraBuildCommands` - additional commands to run to set up the environment.
- `runScript` - the command to run on entering the environment. Defaults to your
  current shell.
