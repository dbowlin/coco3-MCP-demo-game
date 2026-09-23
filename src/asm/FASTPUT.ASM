***********************************************************************
* FASTPUT.ASM - Bonewalk ML hook (CoCo 3)
* Assembles to a LOADM-able stub at $7F00.
* v1: RTS placeholder; BASIC uses ROM HGET/HPUT for tile blit.
* Extend here later for custom GIME tile copy if needed.
***********************************************************************

        ORG     $7F00

* USR entry: X may hold argument; we ignore and return
FASTPUT
        RTS

        END
