# modafinil

[![CI](https://github.com/NishantJoshi00/modafinil/actions/workflows/ci.yml/badge.svg)](https://github.com/NishantJoshi00/modafinil/actions/workflows/ci.yml)

Keep a Mac fully awake — display on, even with the lid closed — until a command
finishes or you stop it. Then put your normal sleep settings back.

## Why

`caffeinate` blocks idle system and display sleep, but not lid-close sleep.
Lid-close sleep is controlled by the persistent `pmset disablesleep` setting.
modafinil flips that setting on while it runs and restores it on exit.

Because the setting is persistent, a crash could leave your Mac stuck awake. To
prevent that, modafinil installs a one-time boot job that resets the setting on
your next startup. It refuses to touch power settings until that safety net is
in place.

## How it compares

Homebrew already has GUI menubar apps for this — KeepingYouAwake (`brew install
--cask keepingyouawake`) and Amphetamine. modafinil is the opposite: CLI-native
and scriptable (`modafinil -- make release`), it handles lid-close sleep, and it
restores your settings cleanly on exit or crash. The short version: `caffeinate`
won't keep a Mac awake with the lid closed; this does, safely.

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/NishantJoshi00/modafinil/v0.1.0/modafinil \
  -o /usr/local/bin/modafinil
chmod +x /usr/local/bin/modafinil
```

Or clone and symlink it onto your `PATH`:

```sh
git clone https://github.com/NishantJoshi00/modafinil.git
ln -s "$PWD/modafinil/modafinil" /usr/local/bin/modafinil
```

## First-time setup

```sh
modafinil --install     # one-time; asks for your password
```

This installs two root-owned files:

- `/Library/LaunchDaemons/com.nishantjoshi.modafinil-reset.plist` — resets
  `disablesleep` to 0 on each boot, then exits. It does not stay running.
- `/etc/sudoers.d/modafinil` — lets your user toggle only
  `pmset -a disablesleep 0|1` without a password. Nothing else.

```sh
modafinil --uninstall   # removes both files
```

## Usage

```sh
modafinil -- <command> [args...]   # awake until the command exits
modafinil -w <pid>                 # awake until the pid exits
modafinil -n <name>                # awake while any process matches name
modafinil                          # awake until Ctrl-C
```

Examples:

```sh
modafinil -- make release
modafinil -n ffmpeg
```

### Recovery

```sh
modafinil --off          # restore normal sleep right now
```

Also aliased as `--reset` / `--disable`. If modafinil is ever killed before it
can clean up, your next restart restores normal sleep automatically.

## Completions

```sh
eval "$(modafinil completions zsh)"
```

## Requirements

macOS. Uses `caffeinate`, `pmset`, and `launchctl`.

## License

MIT. See [LICENSE](LICENSE).
