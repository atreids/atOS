# FAT12 Bootloader

A tiny FAT12 filesystem bootloader made for fun.

Note: this likely wouldn't work on a real floppy diskette as they are know to sometimes fail to read and this bootloader does not account for that.

## Dependencies

- NASM - To compile assembly into machine code.
- Qemu - If you want to run on emulated hardware. Alternatively, if you have a real floppy, you could write the bootloader and kernel to it and boot on real hardware! :D

## Commands

- `make/make build` Compile assembly files into binary + write to virtual floppy disk.
- `make start` Start a virtual computer with floppy disk attached using Qemu.

## Functionality

Currently capabilities:

- A bootloader which can find the kernel (or well, a file named `kernel.bin`) within the primary data region of the FAT12 filesystem and then load it into memory and transfer control to it.
- A tiny kernel file which just prints a welcome message when control is transferred.


