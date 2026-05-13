export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.bun/bin"
eval "$(zoxide init bash)"

detach() {
  if [ "$#" -eq 0 ]; then
    echo "usage: detach <command> [args...]" >&2
    return 2
  fi

  nohup setsid "$@" >/dev/null 2>&1 < /dev/null &
  printf '[detach] started PID %s: %s\n' "$!" "$1"
}

rd() {
  detach "$@"
}

rds() {
  local unit="rds-$(date +%s%N)"
  systemd-run --user --quiet --collect --unit="$unit" "$@"
  printf '[rds] started unit %s: %s\n' "$unit" "$1"
}

# NixOS
alias nrs='sudo nixos-rebuild switch --flake /home/john/repos/config#$(hostname)'
alias nrb='nixos-rebuild build --flake /home/john/repos/config#$(hostname)'
alias nfu='nix flake update --flake /home/john/repos/config'
alias ngc='sudo nix-collect-garbage -d'
alias ndo='sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old'

# eza -> ls
alias ls='eza'
alias ll='eza -la --group-directories-first'
alias lt='eza --tree --level=2'
alias la='eza -a'

# tools
alias n='nnn -de'
alias zj='zellij'
alias zja='zellij attach'
alias vpn='sudo wgnord connect'
alias vpnd='sudo wgnord disconnect'

# dev launchers
alias clr='cd ~/repos && claude'
alias cdr='cd ~/repos && codex'
alias nixconf='cd /home/john/repos/config && fresh .'
