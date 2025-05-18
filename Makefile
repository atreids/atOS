
build:
	nasm -f bin -o atOS.bin atOS.asm

floppy:
	dd status=noxfer conv=notrunc if=atOS.bin of=atOS.flp

start:
	qemu-system-i386 -fda atOS.flp
