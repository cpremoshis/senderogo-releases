# SenderoGo — Releases

Downloadable builds of the SenderoGo receivers (source is developed privately;
this repository holds only release artifacts and update feeds).

## macOS — SenderoGo Receiver

Download the latest `SenderoGo-Receiver-<version>.dmg` from
[Releases](../../releases), open it, and drag **SenderoGo Receiver** to
Applications. Builds are Developer ID-signed and notarized by Apple.

## Linux — sdgo

Download the latest `sdgo_<version>_<arch>.deb` from [Releases](../../releases)
and install with `sudo dpkg -i`. A signed apt repository (automatic updates via
`apt upgrade`) is coming next.

Every build bundles its own LGPL FFmpeg and MPL libsrt — license texts ship
inside the artifacts. Update checks (when enabled) contact github.com only.

## Linux — apt repository (automatic updates)

```sh
curl -fsSL https://cpremoshis.github.io/senderogo-releases/keys/senderogo-archive-keyring.asc \
  | sudo gpg --dearmor -o /usr/share/keyrings/senderogo-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/senderogo-archive-keyring.gpg] https://cpremoshis.github.io/senderogo-releases/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/senderogo.list
sudo apt update && sudo apt install sdgo
```

Updates then arrive through normal `apt upgrade`.
