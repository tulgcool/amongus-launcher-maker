# amongus-launcher-maker

CLI tool for Linux (Mint/Ubuntu/Debian, native Steam install) that generates a
`.desktop` launcher for a **modded Among Us** copy (BepInEx mods).

Launchers start the game **through Steam itself** (AppID 945360): a small shim
in the game's Launch Options swaps the vanilla exe for your modded copy and
sets the `winhttp` override BepInEx needs. Because Steam launches the game,
the Running status, Stop button and Steam Overlay all work correctly — and
launching Among Us from Steam normally still runs vanilla, untouched.

No protontricks, no flatpak, no manual winecfg needed.

## Install

Download the `.deb` from the [latest release](../../releases/latest), then:

```bash
sudo apt install ./amongus-launcher-maker_2.0.0_all.deb
```

## One-time setup

1. **Among Us** installed through Steam (native Steam, not flatpak), run at
   least once with Proton.

2. In Steam: **Library → Among Us → Properties → Launch Options**, paste:

   ```
   /usr/lib/amongus-launcher-maker/steam-shim %command%
   ```

3. A **modded copy** of the game: duplicate your
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

## How it works

Each generated launcher writes the modded exe path to
`~/.config/amongus-launcher-maker/target` and triggers
`steam steam://rungameid/945360`. The shim (running inside Steam's launch
command thanks to `%command%`) consumes that file, substitutes the exe path,
exports `WINEDLLOVERRIDES="winhttp=n,b"` and hands control back to
Steam/Proton. If no target file is pending, the shim changes nothing —
vanilla launches stay vanilla. A per-launch debug log is kept at
`~/.config/amongus-launcher-maker/shim.log`.

## Build from source

```bash
./build-deb.sh
# -> dist/amongus-launcher-maker_2.0.0_all.deb
```
