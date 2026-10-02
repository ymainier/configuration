# configuration

My dotfiles: git, zsh, tmux, vim, and a setup script to install them on a new Mac.

Files here are **symlinked** into `$HOME`, so editing `~/.gitconfig` edits this repo.
Commit the change like any other.

## New machine

1. Install [brew](https://brew.sh/)
2. `git clone git@github.com:ymainier/configuration.git ~/src/configuration && ~/src/configuration/setup.sh`
3. **Set this machine's git identity** — see below. Until you do, git refuses to commit.
4. `open 'Github Dark.terminal'` to import the terminal.app profile, then set it as the
   default in Terminal › Settings › Profiles.

`setup.sh` is idempotent: it skips anything already linked or installed, so it is safe
to re-run after pulling.

## Git identity, per machine

`~/.gitconfig` deliberately has **no `user.email`**, and sets `user.useConfigOnly = true`.
Git will not guess an address from the hostname — it errors out instead:

```
Author identity unknown
```

That is intentional. An email committed to this repo would follow it onto every machine,
and the wrong one silently attributed to work commits is far worse than a failed commit.

Fill in `~/.gitconfig.local`, which `setup.sh` scaffolds and which is never tracked:

```ini
[user]
	email = you@example.com
	# Only if this machine's signing key is not ~/.ssh/id_rsa.pub:
	signingKey = ~/.ssh/id_ed25519.pub
```

### What goes in which file

`~/.gitconfig` ends with `[include] path = ~/.gitconfig.local`, so anything the local
file sets wins. The test for where a setting belongs:

> Does the **value** differ between machines, or only the thing it points at?

Only the first belongs in `~/.gitconfig.local`. `gpg.ssh.allowedSignersFile` is the same
path everywhere even though its contents differ per machine, so it lives in the shared
file. `user.signingKey` is a genuinely different key, so it does not. Same for
`credential.helper`: `gh auth setup-git` writes an absolute `gh` path
(`/opt/homebrew/...` vs `/usr/local/...`), so that block belongs in the local file.
Because `~/.gitconfig` is a symlink into this repo, running that command would commit
the path from whichever machine you ran it on.

Keep `[include]` last. It used to sit mid-file, which silently made every setting after it
impossible to override.

### Commit signing

Signing is on for every repo (`commit.gpgsign`), using SSH rather than GPG. Two things are
per-machine and not tracked here:

- `~/.ssh/allowed_signers` — public keys you trust, one `email ssh-rsa AAAA…` line each.
  Without it, `git log` prints `allowedSignersFile needs to be configured` on every commit.
- The signing key itself must be registered on GitHub **as a signing key**, which is a
  separate entry from the authentication key: `gh ssh-key add ~/.ssh/id_rsa.pub --type signing`

A missing key path fails loudly — the commit is refused and nothing is written. A *different*
key at the expected path does not: it signs, and the commits show Unverified on GitHub.

## What's in here

| File | Notes |
|---|---|
| `.gitconfig` | Aliases, diff/grep tuning, `pull.rebase = merges`, signing. Machine-agnostic only. |
| `.gitignore_global` | `core.excludesFile`. macOS, editor and tooling noise. |
| `.zshrc` | Zim bootstrap, aliases, history, `fnm`, `fzf`, PATH. |
| `.zimrc` | [Zim](https://zimfw.sh/) module list. Prompt is starship. |
| `starship.toml` | Linked to `~/.config/starship.toml`. |
| `.tmux.conf`, `.vimrc` | |
| `Github Dark.terminal` | terminal.app profile: colours, font, cursor. Imported, not symlinked. |
| `setup.sh` | Symlinks the above, installs brew packages and casks. |

## Not tracked, per machine

| File | Purpose |
|---|---|
| `~/.gitconfig.local` | Git identity and signing key. Required. Also `gh` credential helper. |
| `~/.zshrc.local` | Shell extras. Sourced by `.zshrc` if present. |
| `~/.ssh/allowed_signers` | Public keys trusted for signature verification. |
