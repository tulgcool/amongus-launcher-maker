#!/usr/bin/env bash
# Builds amongus-launcher-maker_<version>_all.deb into dist/.
set -euo pipefail

VERSION="2.0.0"
PKG="amongus-launcher-maker"
ROOT="$(cd "$(dirname "$0")" && pwd)"
STAGE="$ROOT/dist/${PKG}_${VERSION}_all"

rm -rf "$ROOT/dist"
mkdir -p "$STAGE/DEBIAN" "$STAGE/usr/bin" "$STAGE/usr/lib/$PKG" \
         "$STAGE/usr/share/doc/$PKG"

# The generator on $PATH, and the launch-options shim at its fixed path.
install -m 755 "$ROOT/src/$PKG" "$STAGE/usr/bin/$PKG"
install -m 755 "$ROOT/src/steam-shim" "$STAGE/usr/lib/$PKG/steam-shim"

cat > "$STAGE/DEBIAN/control" <<EOF
Package: $PKG
Version: $VERSION
Section: games
Priority: optional
Architecture: all
Depends: bash, coreutils
Recommends: zenity
Maintainer: tulgcool <ido.gilary@gmail.com>
Description: Generate .desktop launchers for modded Among Us installs
 Interactive CLI that creates a wrapper script and .desktop launcher for a
 modded Among Us copy (BepInEx etc.). The game is launched through Steam
 itself (AppID 945360) with a %command% shim swapping in the modded exe,
 so Steam's Running status, Stop button and overlay work correctly.
 .
 Runtime requirement (not a deb dependency): a native (non-flatpak) Steam
 install with Among Us. One-time setup per machine: set Among Us's Steam
 Launch Options to:
   /usr/lib/amongus-launcher-maker/steam-shim %command%
EOF

cat > "$STAGE/usr/share/doc/$PKG/README" <<EOF
amongus-launcher-maker
======================
Run "amongus-launcher-maker" and follow the prompts to create a desktop
launcher for a modded Among Us folder. See "amongus-launcher-maker --help"
for non-interactive usage.

One-time setup: in Steam -> Among Us -> Properties -> Launch Options, set:
  /usr/lib/amongus-launcher-maker/steam-shim %command%
Launching from Steam normally still runs vanilla Among Us.
EOF

dpkg-deb --build --root-owner-group "$STAGE" "$ROOT/dist/${PKG}_${VERSION}_all.deb"
echo "Built: $ROOT/dist/${PKG}_${VERSION}_all.deb"
