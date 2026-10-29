# nixvm

`nixvm` is a Nix-backed Java, Ruby, and Python version manager for macOS. It installs supported Nixpkgs versions and records a selected version for each runtime.

## Requirements

- macOS on Apple Silicon (`aarch64`).
- Nix with `nix-command` and `flakes` enabled.
- Zsh to use the provided command completion.
- `jq` when running `bin/nixvm` directly; the Nix package supplies it automatically.

## Install

From a checkout of this repository, install the flake package into your Nix profile:

```bash
nix profile install .
```

Or run it directly without installing:

```bash
nix run . -- --help
```

Add the installed completion directory to `~/.zshrc` before calling `compinit` (adjust the profile path if you use a non-default Nix profile):

```zsh
fpath=("$HOME/.nix-profile/share/zsh/site-functions" $fpath)
autoload -Uz compinit
compinit
```

`nixvm use` records the selected version but does not modify the current shell's `PATH` or `JAVA_HOME`. Add the selected runtime's installed `bin` directory to `PATH` manually when you want to use it.

## Usage

```bash
nixvm install java 21
nixvm install ruby 3.3
nixvm install python 3.12
nixvm list [runtime] [--available|--installed]
nixvm use <runtime> <version>
nixvm remove <runtime> <version>
```

Java versions use an integer major version; Ruby and Python versions use `major.minor`. Use `nixvm list --available` to see versions supported by the locked Nixpkgs revision. Run `nixvm --help` for command details.

## Project Structure

```text
├── .github/workflows/  # CI and release workflows
├── bin/nixvm           # CLI executable
├── completion/_nixvm   # Zsh command completion
├── flake.nix           # Darwin Nix package and app
├── flake.lock          # Locked Nixpkgs input
├── LICENSE
└── README.md
```

## Releases

Push a version tag such as `v1.0.0` to create a GitHub release. The release workflow publishes a source archive, its Nix SRI hash, and a manifest for the `sstix-tools` registry.
