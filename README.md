# Bonewalk

Color Computer 3 maze runner — **320×192, 16-color** graphics. MAME `coco3` target.

You are a stick figure loose inside machine memory. Clear **5 procedurally generated circuits**. Reach the exit glyph to advance.

## Mode note

Tandy numbering:

| `HSCREEN` | Resolution | Colors |
|-----------|------------|--------|
| **2** | 320×192 | **16** (this game) |
| 3 | 640×192 | 2 |
| 4 | 640×192 | 4 |

## Controls

| Key | Action |
|-----|--------|
| W / ↑ | Up |
| S / ↓ | Down |
| A / ← | Left |
| D / → | Right |
| Q | Quit |
| R | Play again (win screen) |

## Run (MAME coco3)

1. Start MAME with the `coco3` driver and a disk controller.
2. Mount **`disks/BONEWALK.DSK`** in drive 0.
3. At `OK`:

```basic
RUN"BONEWALK"
```

First launch builds `HBUFF` tiles (several seconds), then shows the title screen.

### coco3 MCP

```text
coco_start
coco_mount_flop  path=<project>/disks/BONEWALK.DSK
RUN"BONEWALK"
```

## Disk contents

Dedicated image: **`disks/BONEWALK.DSK`**

| File | Role |
|------|------|
| `BONEWALK.BAS` | Game |
| `FASTPUT.BIN` | ML stub at `$7F00` (`USR0` hook; tile blit uses ROM `HGET`/`HPUT`) |

`FASTPUT.BIN` must be Disk BASIC **type 2** (machine language). Rebuild with `tools/build_disk.ps1` so the type flag is correct (`decb copy -2 -b`).

## Rebuild

```powershell
python tools/mk_fastput_bin.py
powershell -File tools/build_disk.ps1
```

Requires [ToolShed](https://github.com/nitros9project/toolshed) `decb`. On Windows, run `decb` from a directory so the `.dsk` path has **no drive-letter colon** (or use the script above).

## Source layout

| Path | Description |
|------|-------------|
| `src/BONEWALK.BAS` | Graphics game (`HSCREEN 2`) |
| `src/BONEWALK-TEXT.BAS` | Original WIDTH 40 text version |
| `src/asm/FASTPUT.ASM` | ML hook source |
| `bin/FASTPUT.BIN` | DECB `LOADM` binary |
| `disks/BONEWALK.DSK` | Playable disk |
| `tools/mk_fastput_bin.py` | Writes `FASTPUT.BIN` |
| `tools/build_disk.ps1` | Formats disk + copies BAS/BIN |

## Tech

- Tile erase/redraw via **`HBUFF` / `HGET` / `HPUT`** (ROM ML)
- 8×8 path / wall / player / exit tiles
- Binary-tree maze; levels 19×9 → 35×17
- No enemies, scrolling, or SFX in v1
- **MAME-only** (512K coco3 recommended)
