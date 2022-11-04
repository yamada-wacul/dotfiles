# dotfiles

## installation

1. setup git & zsh
2. register SSH key to GitHub
3. call below

```sh
curl -H "Cache-Control: no-cache" "https://raw.githubusercontent.com/yamada-wacul/dotfiles/main/setup" | zsh
```

4. register GPG key
5. create a `${DOTFILES}/git/config_host` like below.

```
[user]
	signingkey = <gpg key id>
[include]
	path = config_Linux
```

## setup git

- Import GPG key to gpg-agent and trust it.
- Export SSH key to ssh-agent (`~/.ssh/...`).
- Include SSH config: `Include ~/.config/ssh/*.conf`


## my Ergodox layout

https://configure.ergodox-ez.com/ergodox-ez/layouts/MZajL/latest/0

:memo: if you want to change layout, login and edit it.
