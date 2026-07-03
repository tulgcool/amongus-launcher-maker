# amongus-launcher-maker

CLI tool for Linux (Mint/Ubuntu/Debian, native Steam install) that generates a
`.desktop` launcher for a **modded Among Us** copy (BepInEx mods), launched
through the Protontricks flatpak against the vanilla Among Us Proton prefix
(Steam AppID 945360).

## Install

Download the `.deb` from the [latest release](../../releases/latest), then:

```bash
sudo apt install ./amongus-launcher-maker_1.0.0_all.deb
```

## One-time setup (required before first use)

1. **Vanilla Among Us** must be installed through Steam and have been run at
   least once (so the Proton prefix for AppID 945360 exists).

2. **Protontricks flatpak** with home directory access:

   ```bash
   flatpak install flathub com.github.Matoking.protontricks
   flatpak override --user --filesystem=home com.github.Matoking.protontricks
   ```

3. **winhttp DLL override** in the Among Us Proton prefix (this is what lets
   BepInEx hook the game). Run:

   ```bash
   flatpak run --command=protontricks com.github.Matoking.protontricks 945360 winecfg
   ```

   In winecfg: **Libraries** tab → type `winhttp` → **Add** → select it →
   **Edit...** → choose **Native then Builtin** → OK. Only needed once.

4. A **modded copy** of the game: duplicate your
   `~/.steam/steam/steamapps/common/Among Us` folder and install BepInEx +
   mods into the copy (mod managers do this for you).

## Usage

```bash
amongus-launcher-maker
```

Follow the prompts: pick the modded `Among Us.exe`, choose a display name
(e.g. "Town of Us"), a `.desktop` filename, and where to save the launcher
(e.g. `~/.local/share/applications` for the app menu, or `~/Desktop`).

Run it again for each additional modded folder — every run creates its own
independent launcher. See `amongus-launcher-maker --help` for non-interactive
flags.

## Build from source

```bash
./build-deb.sh
# -> dist/amongus-launcher-maker_1.0.0_all.deb
```
