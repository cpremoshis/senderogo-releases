#!/usr/bin/env bash
#
# install.sh — install the sdgo receiver from the signed SenderoGo apt
# repository (Debian/Ubuntu, amd64). Sets up the archive keyring and a
# sources.list.d entry, then installs the package; updates arrive through
# normal `apt upgrade` from then on. The package is self-contained (bundled
# LGPL FFmpeg + libsrt in /usr/lib/senderogo) — no distro media libs needed.
#
# Usage:
#   sudo ./install.sh
#   curl -fsSL https://cpremoshis.github.io/senderogo-releases/install.sh | sudo bash
#
# Building from source instead (developers): go build ./cmd/sdgo — needs Go
# plus the libsrt/FFmpeg dev headers; see the README.
set -euo pipefail

BASE="https://cpremoshis.github.io/senderogo-releases"
KEYRING=/usr/share/keyrings/senderogo-archive-keyring.gpg
LIST=/etc/apt/sources.list.d/senderogo.list

say()  { printf '\033[1m→ %s\033[0m\n' "$*"; }
die()  { printf '\033[31merror: %s\033[0m\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || die "run as root: sudo ./install.sh"
command -v curl >/dev/null || apt-get install -y curl
command -v gpg  >/dev/null || apt-get install -y gnupg

say "adding the SenderoGo archive key → $KEYRING"
curl -fsSL "$BASE/keys/senderogo-archive-keyring.asc" | gpg --dearmor --yes -o "$KEYRING"

say "adding the apt source → $LIST"
echo "deb [signed-by=$KEYRING] $BASE/apt stable main" > "$LIST"

say "installing sdgo"
apt-get update -qq
apt-get install -y sdgo

# Report from dpkg, not by executing `sdgo` — a dev copy earlier on PATH
# (e.g. /usr/local/bin) would answer instead of the package we just installed.
say "installed: sdgo $(dpkg-query -W -f '${Version}' sdgo)"
resolved=$(command -v sdgo || true)
if [ -n "$resolved" ] && [ "$resolved" != "/usr/bin/sdgo" ]; then
  printf '\033[33m! note: %s shadows the packaged /usr/bin/sdgo on this machine\033[0m\n' "$resolved" >&2
fi
echo "Run 'sdgo help' to get started, or 'sdgo setup' for first-time configuration."
