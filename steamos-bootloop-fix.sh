#!/usr/bin/env bash
set -euo pipefail

# Steam Deck / SteamOS user-level fix:
# Make steamos-manager not hard-fail if gamescope-environment isn't present yet.
# Optional: disable plasma-remotecontrollers timeouts.
#
# Usage:
#   ./steamos-bootloop-fix.sh            # apply fix
#   ./steamos-bootloop-fix.sh --revert   # undo fix
#   ./steamos-bootloop-fix.sh --status   # show relevant status

OVERRIDE_DIR="${HOME}/.config/systemd/user/steamos-manager.service.d"
OVERRIDE_FILE="${OVERRIDE_DIR}/override.conf"

print_status() {
  echo "== steamos-manager.service (user) =="
  systemctl --user status steamos-manager.service --no-pager || true
  echo
  echo "== Override file =="
  if [[ -f "${OVERRIDE_FILE}" ]]; then
    echo "Found: ${OVERRIDE_FILE}"
    echo "-----"
    cat "${OVERRIDE_FILE}"
    echo "-----"
  else
    echo "No override file present."
  fi
  echo
  echo "== plasma-remotecontrollers.service (user) =="
  systemctl --user status plasma-remotecontrollers.service --no-pager || true
}

apply_fix() {
  echo "Applying SteamOS boot stability fix (user-level override)..."

  mkdir -p "${OVERRIDE_DIR}"

  # Write override:
  # - Clear existing EnvironmentFile lines from the base unit
  # - Re-add as OPTIONAL using the '-' prefix
  cat > "${OVERRIDE_FILE}" <<'EOF'
[Service]
EnvironmentFile=
EnvironmentFile=-%t/gamescope-environment
EOF

  systemctl --user daemon-reload

  # Restart service to pick up override (won't break Gaming Mode; it's user service)
  systemctl --user restart steamos-manager.service || true

  # Optional cleanup: plasma remote controllers tends to hang/time out on some setups.
  # This is safe for most users; it mainly affects KDE/Plasma desktop integration.
  if systemctl --user list-unit-files | grep -q '^plasma-remotecontrollers\.service'; then
    systemctl --user disable --now plasma-remotecontrollers.service >/dev/null 2>&1 || true
    systemctl --user mask plasma-remotecontrollers.service >/dev/null 2>&1 || true
  fi

  echo "Done."
  echo
  print_status
  echo
  echo "Next step: reboot and see if the repeated Steam-logo reboots stop/improve."
}

revert_fix() {
  echo "Reverting SteamOS boot stability fix..."

  # Remove override
  if [[ -f "${OVERRIDE_FILE}" ]]; then
    rm -f "${OVERRIDE_FILE}"
  fi

  # Remove directory if empty
  if [[ -d "${OVERRIDE_DIR}" ]]; then
    rmdir "${OVERRIDE_DIR}" 2>/dev/null || true
  fi

  systemctl --user daemon-reload

  # Unmask / re-enable plasma service (only if it exists)
  if systemctl --user list-unit-files | grep -q '^plasma-remotecontrollers\.service'; then
    systemctl --user unmask plasma-remotecontrollers.service >/dev/null 2>&1 || true
    systemctl --user enable --now plasma-remotecontrollers.service >/dev/null 2>&1 || true
  fi

  # Restart steamos-manager to load stock unit config
  systemctl --user restart steamos-manager.service || true

  echo "Revert complete."
  echo
  print_status
}

case "${1:-}" in
  --revert)
    revert_fix
    ;;
  --status)
    print_status
    ;;
  "" )
    apply_fix
    ;;
  *)
    echo "Unknown option: ${1}"
    echo "Usage: $0 [--revert|--status]"
    exit 2
    ;;
esac
