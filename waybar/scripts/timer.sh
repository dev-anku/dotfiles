
#!/usr/bin/env bash
set -Eeuo pipefail

umask 077

readonly STEP_MS=60000
readonly CLICK_DELAY=0.2

readonly STATE_ROOT="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
readonly STATE_DIR="${STATE_ROOT}/waybar-timer-${UID}"
readonly STATE_FILE="${STATE_DIR}/state"
readonly LOCK_FILE="${STATE_DIR}/lock"

mkdir -p -- "$STATE_DIR"
chmod 700 -- "$STATE_DIR"

# Serialize all state access.
exec 9>"$LOCK_FILE"
flock -x 9

# Read monotonic system uptime in milliseconds.
now_ms() {
  awk '{ printf "%.0f\n", $1 * 1000 }' /proc/uptime
}

load_state() {
  remaining_ms=0
  deadline_ms=0
  running=0
  click_seq=0
  finished=0

  if [[ -r "$STATE_FILE" ]]; then
    read -r remaining_ms deadline_ms running click_seq finished \
      < "$STATE_FILE" || true
  fi

  [[ "$remaining_ms" =~ ^[0-9]+$ ]] || remaining_ms=0
  [[ "$deadline_ms" =~ ^[0-9]+$ ]] || deadline_ms=0
  [[ "$running" == 1 ]] || running=0
  [[ "$click_seq" =~ ^[0-9]+$ ]] || click_seq=0
  [[ "$finished" == 1 ]] || finished=0

  if (( running == 0 )); then
    deadline_ms=0
  fi
}

save_state() {
  printf '%s %s %s %s %s\n' \
    "$remaining_ms" "$deadline_ms" "$running" \
    "$click_seq" "$finished" > "$STATE_FILE"
}

# Calculate remaining time and stop if it has expired.
refresh_state() {
  if (( running == 1 )); then
    local current_ms
    current_ms=$(now_ms)

    remaining_ms=$((deadline_ms - current_ms))

    if (( remaining_ms <= 0 )); then
      remaining_ms=0
      deadline_ms=0
      running=0
      finished=1

      if command -v notify-send >/dev/null 2>&1; then
        notify-send \
          --app-name="Waybar Timer" \
          --urgency=normal \
          --icon="$HOME/pictures/wallpapers/anime-girl-using-laptop.jpg" \
          "Timer finished!" \
          >/dev/null 2>&1 || true
      fi
    fi
  fi
}

toggle_timer() {
  local current_ms
  current_ms=$(now_ms)

  refresh_state

  if (( running == 1 )); then
    # Pause.
    running=0
    deadline_ms=0

  elif (( remaining_ms > 0 )); then
    # Start or resume.
    deadline_ms=$((current_ms + remaining_ms))
    running=1
    finished=0
  fi
}

load_state

case "${1:-display}" in

  display)
    refresh_state
    save_state

    total_seconds=$(((remaining_ms + 999) / 1000))
    minutes=$((total_seconds / 60))
    seconds=$((total_seconds % 60))

    printf -v display_text '%02d:%02d' "$minutes" "$seconds"

    if (( running == 1 )); then
      state_class="running"
    elif (( finished == 1 )); then
      state_class="finished"
    elif (( remaining_ms > 0 )); then
      state_class="paused"
    else
      state_class="idle"
    fi

    printf '{"text":"%s","class":"%s","tooltip":"Left click: start/pause\\nDouble-click: reset\\nScroll: +/- 1 minute (paused only)"}\n' \
      "$display_text" "$state_class"
    ;;

  click)
    # Defer the single-click action to detect double-clicks.
    click_seq=$((click_seq + 1))
    click_token=$click_seq

    save_state

    (
      # Do not keep the parent's lock open.
      exec 9>&-

      sleep "$CLICK_DELAY"

      "$0" delayed-toggle "$click_token"
      ) </dev/null >/dev/null 2>&1 &

      ;;

    delayed-toggle)
      expected_seq="${2:-}"

        # Only execute if no double-click or newer click cancelled it.
        if [[ "$expected_seq" == "$click_seq" ]]; then
          toggle_timer
          save_state
        fi
        ;;

      toggle)
        # Immediate toggle, useful for manual testing.
        click_seq=$((click_seq + 1))
        toggle_timer
        save_state
        ;;

      reset)
        # Cancel any pending single-click operation.
        click_seq=$((click_seq + 1))

        remaining_ms=0
        deadline_ms=0
        running=0
        finished=0

        save_state
        ;;

      increase)
        refresh_state

        if (( running == 0 )); then
          remaining_ms=$((remaining_ms + STEP_MS))
          finished=0
        fi

        save_state
        ;;

      decrease)
        refresh_state

        if (( running == 0 )); then
          remaining_ms=$((remaining_ms - STEP_MS))

          if (( remaining_ms < 0 )); then
            remaining_ms=0
          fi
        fi

        save_state
        ;;

      *)
        echo "Usage: $0 {display|click|toggle|reset|increase|decrease}" >&2
        exit 2
        ;;

      esac

