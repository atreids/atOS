# AtomOS

Tiny (bootloader sized) program built for fun.

## Commands

- `make build` Compile assembly file into binary + write to virtual floppy disk.
- `make floppy` Write binary into virtual floppy disk image to boot from.
- `make start` Start a virtual computer with floppy disk attached using Qemu.

## Steps

1. Make tiny bootloader.
2. Make tiny kernel.
3. Use bootloader to load tiny kernel from another part of the disk.
4. Hand control to kernel.
5. Flesh out kernel:
- - Print to screen
- - Keyboard input
- - Maybe some bare bones applications.

