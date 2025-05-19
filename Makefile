default: build-asm build-floppy
build-asm:
	rm -rf ./dist
	mkdir ./dist
	nasm src/boot.asm -i src -f bin -o dist/boot.bin 
	nasm -f bin -o ./dist/kernel.bin ./src/kernel.asm

build-floppy:
	mkdosfs -C ./dist/atOS.flp 1440
	dd status=noxfer conv=notrunc if=./dist/boot.bin of=./dist/atOS.flp
	dd skip=1 status=noxfer conv=notrunc if=dist/kernel.bin of=dist/atOS.flp

start:
	qemu-system-i386 -drive format=raw,file=dist/atOS.flp,index=0,if=floppy
