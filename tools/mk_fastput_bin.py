#!/usr/bin/env python3
"""Build a DECB LOADM .BIN with a single RTS at $7F00 (Bonewalk ML hook)."""
from pathlib import Path

OUT = Path(__file__).resolve().parents[1] / "bin" / "FASTPUT.BIN"
LOAD = 0x7F00
CODE = bytes([0x39])  # RTS


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    # DECB binary block: 00 len_hi len_lo load_hi load_lo data... FF 00 00 exec_hi exec_lo
    length = len(CODE)
    block = bytes([0x00, (length >> 8) & 0xFF, length & 0xFF, (LOAD >> 8) & 0xFF, LOAD & 0xFF]) + CODE
    postamble = bytes([0xFF, 0x00, 0x00, (LOAD >> 8) & 0xFF, LOAD & 0xFF])
    OUT.write_bytes(block + postamble)
    print(f"Wrote {OUT} ({OUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
