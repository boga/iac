#!/usr/bin/env bash
set -euo pipefail

# automation-pve-runner
# Forced-command SSH boundary for the automation-agent Proxmox user.
# Install on each Proxmox node as /usr/local/bin/automation-pve-runner.sh.

PATH=/usr/sbin:/usr/bin:/sbin:/bin
readonly LOG_FILE="/var/log/automation-pve-runner.log"
readonly ORIGINAL_COMMAND="${SSH_ORIGINAL_COMMAND:-}"
readonly MANAGED_POOL="automation-managed"

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

is_uint() {
  [[ "${1:-}" =~ ^[0-9]+$ ]]
}

has_arg() {
  local expected="$1"
  local arg
  for arg in "${argv[@]}"; do
    [[ "$arg" == "$expected" ]] && return 0
  done
  return 1
}

arg_value() {
  local key="$1"
  local i
  for ((i = 0; i < ${#argv[@]}; i++)); do
    if [[ "${argv[$i]}" == "$key" ]]; then
      printf '%s\n' "${argv[$((i + 1))]:-}"
      return 0
    fi
  done
  return 1
}

require_pool_option() {
  local pool
  pool="$(arg_value --pool || true)"
  [[ "$pool" == "$MANAGED_POOL" ]] || deny "mutating create/clone commands must include --pool $MANAGED_POOL"
}

vmid_in_managed_pool() {
  local vmid="$1"
  sudo -n /usr/bin/pvesh get "/pools/${MANAGED_POOL}" --output-format json 2>/dev/null \
    | grep -Eq '"vmid"[[:space:]]*:[[:space:]]*'"${vmid}"'([^0-9]|$)'
}

require_managed_vmid() {
  local vmid="$1"
  is_uint "$vmid" || deny "VMID must be numeric: ${vmid:-missing}"
  vmid_in_managed_pool "$vmid" || deny "VMID $vmid is not in pool $MANAGED_POOL"
}

validate_pvesh_path() {
  local action="$1"
  local path_arg="${2:-}"

  [[ "$path_arg" == /* ]] || deny "pvesh path must be absolute"
  [[ "$path_arg" != *..* ]] || deny "pvesh path traversal disabled"

  case "$action:$path_arg" in
    get:/nodes|get:/nodes/*/storage|get:/pools|get:/pools/$MANAGED_POOL|get:/cluster/resources)
      return 0
      ;;
    *)
      deny "pvesh path not allowlisted: $action $path_arg"
      ;;
  esac
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

read -r -a argv <<< "$ORIGINAL_COMMAND"

if [[ "${#argv[@]}" -eq 0 ]]; then
  deny "empty command"
fi

command_name="${argv[0]}"
subcommand="${argv[1]:-}"

for arg in "${argv[@]}"; do
  if [[ "$arg" == -* ]]; then
    case "$arg" in
      --agent|--bios|--boot|--bootdisk|--bridge|--cipassword|--ciuser|--cores|--description|--full|--gateway|--hotplug|--ide*|--ipconfig*|--memory|--name|--nameserver|--net*|--numa|--onboot|--ostype|--pool|--protection|--scsi*|--scsihw|--serial*|--sockets|--sshkey|--start|--storage|--tablet|--tags|--target|--vga|--virtio*|--vmgenid) ;;
      --output-format|--human-readable|--current|--pending|--verbose|--dry-run|--force|--skiplock) ;;
      --*) deny "long option not allowlisted: $arg" ;;
      -*) ;;
    esac
  fi

done

case "$command_name" in
  qm)
    case "$subcommand" in
      list)
        allow "qm list"
        exec sudo -n /usr/sbin/qm "${argv[@]:1}"
        ;;
      status|config|pending)
        is_uint "${argv[2]:-}" || deny "VMID must be numeric: ${argv[2]:-missing}"
        allow "qm $subcommand"
        exec sudo -n /usr/sbin/qm "${argv[@]:1}"
        ;;
      create|clone)
        require_pool_option
        allow "qm $subcommand in pool $MANAGED_POOL"
        exec sudo -n /usr/sbin/qm "${argv[@]:1}"
        ;;
      set|resize|start|stop|shutdown|reboot|reset|migrate|template)
        require_managed_vmid "${argv[2]:-}"
        allow "qm $subcommand in pool $MANAGED_POOL"
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
      list)
        allow "pct list"
        exec sudo -n /usr/sbin/pct "${argv[@]:1}"
        ;;
      status|config|pending)
        is_uint "${argv[2]:-}" || deny "CTID must be numeric: ${argv[2]:-missing}"
        allow "pct $subcommand"
        exec sudo -n /usr/sbin/pct "${argv[@]:1}"
        ;;
      create)
        require_pool_option
        allow "pct create in pool $MANAGED_POOL"
        exec sudo -n /usr/sbin/pct "${argv[@]:1}"
        ;;
      set|resize|start|stop|shutdown|reboot|migrate)
        require_managed_vmid "${argv[2]:-}"
        allow "pct $subcommand in pool $MANAGED_POOL"
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
      get)
        validate_pvesh_path "$subcommand" "${argv[2]:-}"
        allow "pvesh $subcommand ${argv[2]}"
        exec sudo -n /usr/bin/pvesh "${argv[@]:1}"
        ;;
      create|set|delete)
        deny "pvesh $subcommand disabled; use qm/pct allowlisted commands"
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
