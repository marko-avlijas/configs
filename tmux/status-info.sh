#!/bin/sh
# Text for the tmux status bar. Prints nothing when there is nothing to show.
#   status-info.sh battery   ->  "♥ AC 87%" (on power) / "♥ 54%"; nothing without a battery
#   status-info.sh network   ->  Wi-Fi name, "Ethernet" or "Offline"
# Linux and macOS. Reads local state only (/sys, routing table, pmset):
# no ping, no network traffic.

battery() {
  if [ "$(uname -s)" = Darwin ]; then battery_mac; return 0; fi
  percent="" ac=""
  for dev in "${POWER_SUPPLY_DIR:-/sys/class/power_supply}"/*; do
    [ -r "$dev/type" ] || continue
    case "$(cat "$dev/type")" in
      Battery) [ -z "$percent" ] && percent="$(cat "$dev/capacity" 2>/dev/null)" ;;
      Mains)   [ "$(cat "$dev/online" 2>/dev/null)" = 1 ] && ac="AC " ;;
    esac
  done
  if [ -n "$percent" ]; then printf '♥ %s%s%%\n' "$ac" "$percent"; fi
}

# pmset -g batt:  Now drawing from 'AC Power'
#                  -InternalBattery-0 (id=...)	87%; charging; 2:10 remaining
battery_mac() {
  out="$(pmset -g batt 2>/dev/null)" || return 0
  percent="$(printf '%s\n' "$out" | grep -Eo '[0-9]+%' | head -n 1)"
  [ -n "$percent" ] || return 0
  ac=""
  case "$out" in *"'AC Power'"*) ac="AC " ;; esac
  printf '♥ %s%s\n' "$ac" "$percent"
}

network() {
  if [ "$(uname -s)" = Darwin ]; then network_mac; return 0; fi
  ssid=""
  command -v iw >/dev/null 2>&1 &&
    ssid="$(iw dev 2>/dev/null | sed -n 's/^[[:space:]]*ssid //p' | head -n 1)"
  if [ -n "$ssid" ]; then
    printf '%s\n' "$ssid"
  elif ip route show default 2>/dev/null | grep -q .; then
    echo Ethernet
  else
    echo Offline
  fi
}

# Recent macOS hides the Wi-Fi name from command line tools (<redacted>),
# so this often only knows "Wi-Fi".
network_mac() {
  route -n get default >/dev/null 2>&1 || { echo Offline; return 0; }
  ssid="$(ipconfig getsummary en0 2>/dev/null | sed -n 's/^ *SSID : //p' | head -n 1)"
  case "$ssid" in
    ""|"<redacted>") if ipconfig getsummary en0 2>/dev/null | grep -q 'SSID'; then echo Wi-Fi; else echo Online; fi ;;
    *) printf '%s\n' "$ssid" ;;
  esac
}

case "${1:-}" in
  battery) battery ;;
  network) network ;;
  *) echo "usage: $0 battery|network" >&2; exit 2 ;;
esac
