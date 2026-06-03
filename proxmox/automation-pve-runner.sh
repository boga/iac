#!/usr/bin/env bash
set -euo pipefail

# automation-pve-runner
# Forced-command SSH boundary for the automation-agent Proxmox user.
# Install on each Proxmox node as /usr/local/bin/automation-pve-runner.sh.

PATH=/usr/sbin:/usr/bin:/sbin:/bin
readonly LOG_FILE="/var/log/automation-pve-runner.log"
readonly ORIGINAL_COMMAND="${SSH_ORIGINAL_COMMAND:-}"

log() {
  local decision="$1"
  local reason="$2"
  local remote="${SSH_CONNECTION:-unknown}"
  local line
  line=$(printf '%s decision=%q reason=%q remote=%q command=%q' \
    "$(date --iso-8601=seconds)" \
    "$decision" \
    "$reason" \
    "$remote" \
    "$ORIGINAL_COMMAND")

  if ! { printf '%s\n' "$line" >> "$LOG_FILE"; } 2>/dev/null; then
    logger -t automation-pve-runner -- "$line" || true
  fi
}

deny() {
  local reason="$1"
  log "deny" "$reason"
  printf 'automation-pve-runner: denied: %s\n' "$reason" >&2
  exit 126
}

allow() {
  local reason="$1"
  log "allow" "$reason"
}

if [[ -z "$ORIGINAL_COMMAND" ]]; then
  deny "interactive shell disabled"
fi

# Keep the boundary intentionally narrow. This wrapper accepts only simple
# whitespace-delimited commands. Quote-dependent arguments are rejected so the
# script never needs eval or shell re-parsing.
if [[ "$ORIGINAL_COMMAND" =~ [\;\&\|\<\>\`\$\(\)\{\}\[\]\\\"\'] ]]; then
  deny "shell metacharacters disabled"
fi

if [[ "$ORIGINAL_COMMAND" =~ (^|[[:space:]])\.\.($|/|[[:space:]]) ]]; then
  deny "path traversal disabled"
fi

if [[ "$ORIGINAL_COMMAND" =~ (^|[[:space:]])/ ]]; then
  deny "absolute paths disabled"
fi

read -r -a argv <<< "$ORIGINAL_COMMAND"

if [[ "${#argv[@]}" -eq 0 ]]; then
  deny "empty command"
fi

command_name="${argv[0]}"
subcommand="${argv[1]:-}"

for arg in "${argv[@]}"; do
  if [[ "$arg" == -* ]]; then
    case "$arg" in
      --output-format|--human-readable|--full|--current|--pending|--verbose|--dry-run|--force|--skiplock) ;;
      --*) deny "long option not allowlisted: $arg" ;;
      -*) ;;
    esac
  fi

done

case "$command_name" in
  qm)
    case "$subcommand" in
      list|status|config|pending|create|clone|set|resize|start|stop|shutdown|reboot|reset|migrate|template)
        allow "qm $subcommand"
        exec sudo -n /usr/sbin/qm "${argv[@]:1}"
        ;;
      destroy|unlink|disk|importdisk|importovf|restore)
        deny "destructive or broad qm subcommand requires manual root session: $subcommand"
        ;;
      *)
        deny "qm subcommand not allowlisted: ${subcommand:-missing}"
        ;;
    esac
    ;;

  pct)
    case "$subcommand" in
      list|status|config|pending|create|set|resize|start|stop|shutdown|reboot|migrate)
        allow "pct $subcommand"
        exec sudo -n /usr/sbin/pct "${argv[@]:1}"
        ;;
      destroy|restore|mount|unmount|enter|exec|pull|push)
        deny "destructive or shell-capable pct subcommand disabled: $subcommand"
        ;;
      *)
        deny "pct subcommand not allowlisted: ${subcommand:-missing}"
        ;;
    esac
    ;;

  pvesh)
    case "$subcommand" in
      get|create|set)
        allow "pvesh $subcommand"
        exec sudo -n /usr/bin/pvesh "${argv[@]:1}"
        ;;
      delete)
        deny "pvesh delete disabled"
        ;;
      *)
        deny "pvesh subcommand not allowlisted: ${subcommand:-missing}"
        ;;
    esac
    ;;

  pvecm)
    if [[ "$subcommand" == "status" && "${#argv[@]}" -eq 2 ]]; then
      allow "pvecm status"
      exec sudo -n /usr/bin/pvecm status
    fi
    deny "only pvecm status is allowed"
    ;;

  ha-manager)
    case "$subcommand" in
      status|config)
        allow "ha-manager $subcommand"
        exec sudo -n /usr/sbin/ha-manager "${argv[@]:1}"
        ;;
      *)
        deny "ha-manager subcommand not allowlisted: ${subcommand:-missing}"
        ;;
    esac
    ;;

  vzdump)
    deny "vzdump disabled until backup policy is documented"
    ;;

  bash|sh|zsh|dash|sudo|su|doas|scp|sftp|rsync|cat|vi|vim|nano|rm|mv|cp|dd|nc|socat|python|perl|ruby|node)
    deny "non-PVE command disabled: $command_name"
    ;;

  *)
    deny "command not allowlisted: $command_name"
    ;;
esac
