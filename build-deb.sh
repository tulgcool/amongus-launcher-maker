#!/usr/bin/env bash
# Builds amongus-launcher-maker_<version>_all.deb into dist/.
set -euo pipefail

VERSION="1.0.0"
PKG="amongus-launcher-maker"
ROOT="$(cd "$(dirname "$0")" && pwd)"
STAGE="$ROOT/dist/${PKG}_${VERSION}_all"

rm -rf "$ROOT/dist"
mkdir -p "$STAGE/DEBIAN" "$STAGE/usr/bin" "$STAGE/usr/share/doc/$PKG"

# The tool itself, on $PATH via /usr/bin — no postinst needed.
install -m 755 "$ROOT/src/$PKG" "$STAGE/usr/bin/$PKG"

cat > "$STAGE/DEBIAN/control" <<EOF
Package: $PKG
Version: $VERSION
Section: games
Priority: optional
Architecture: all
Depends: bash, flatpak, coreutils
Recommends: zenity
Maintainer: tulgcool <ido.gilary@gmail.com>
Description: Generate .desktop launchers for modded Among Us installs
 Interactive CLI that creates a wrapper script and .desktop launcher for a
 modded Among Us copy (BepInEx etc.), launched through the Protontricks
 flatpak against the vanilla Among Us Proton prefix (Steam AppID 945360).
 .
 Runtime requirement (not a deb dependency, since it is a flatpak):
 com.github.Matoking.protontricks installed via flatpak, with home
 filesystem access granted:
   flatpak override --user --filesystem=home com.github.Matoking.protontricks
EOF

cat > "$STAGE/usr/share/doc/$PKG/README" <<EOF
amongus-launcher-maker
======================
Run "amongus-launcher-maker" and follow the prompts to create a desktop
launcher for a modded Among Us folder. See "amongus-launcher-maker --help"
for non-interactive usage. Requires the Protontricks flatpak:
  flatpak install flathub com.github.Matoking.protontricks
  flatpak override --user --filesystem=home com.github.Matoking.protontricks
EOF

dpkg-deb --build --root-owner-group "$STAGE" "$ROOT/dist/${PKG}_${VERSION}_all.deb"
echo "Built: $ROOT/dist/${PKG}_${VERSION}_all.deb"
