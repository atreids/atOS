# FAT 12 Notes

This bootloader is written specifically to boot a FAT12 formatted 3.5" floppy diskette.

Floppy disks are commonly non-partitioned storage due to their small size (1.44MB). Therefore in the context of trying to boot an operating system from the storage the first sector of the disk (logical sector 0) will contain the reserved boot sector (also called volume boot record).

In the FAT12 filesystem you _can_ have more than 1 reserved sectors at the start of the disk. In our case we are assuming the 'basic' scenario of there being only one reserved sector at the start, and the reserved sector must therefore be the boot sector.

Our boot loader (`boot.asm`) must therefore be written into the boot sector of our FAT12 filesystem, and meet the specification of a valid boot sector (aka, include a BIOS parameter block and end in a boot signature).

Below are the basic components of our expected FAT12 filesystem:

1. The boot sector (512bytes long - 1 sector)
- - Starts at logical sector 0 (aka, at the very start of the disk)
- - We write our bootloader here. Which means our bootloader binary must also contain things to meet the spec of a valid FAT12 boot sector. Aka the BPB and boot signature at the end.
2. FAT sectors (File allocation tables) - First FAT is at sector 1, second FAT at 10 (they are 9 long)
- - Sectors which give the FAT file system its name. These contain a map of data clusters/sectors to their place within sectors on the disk. On FAT12 specifically a cluster and a sector are the same size of 512bytes.
- - Either way they can tell us useful information _about_ data clusters. Importantly each entry in the FAT corresponds to exactly one cluster on disk, and the value tells us something about the cluster.
- - - 0x00 - Unused
- - - 0xFF0-0xFF6 - Reserved cluster
- - - 0xFF7 - Bad cluster
- - - 0xFF8-0xFFF - Last cluster in a file (important this one)
- - - <any other value> - Number of the next cluster for this file that is in this cluster.
3. Root Directory (14 sectors long - Starts at sector 19)
- - Basically a table of entries where every entry points either to a file or a directory on disk.
- - Is made up of 14 sectors, each 512 bytes long, containing 16 entries each, each entry is therefore 32 bytes.
- - Can tell you important things about the files/directory. Such as creation time, access date etc. For us the important things is the first 11 bytes in each entry tell us the name (8 bytes) + extension (3 bytes) of the file. The name is padded with spaces to reach 8 bytes if it is shorter. We will also need the 26th byte of the entry that we have identified as our kernel file, as this byte contains the first logical cluster that contains our kernel. If our kernel is larger than 512 bytes, it is likely to span more than one cluster, and we must use the FAT to find our what other clusters contain our kernel, as they may not be store contiguous locations.
4. Data region (Follows root dir. Starts at logical sector 32 as root dir is 14 long)


