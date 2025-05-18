default: build
build:
	rm -rf ./dist
	mkdir ./dist
	nasm -f bin -o ./dist/boot.bin ./src/boot.asm
	dd status=noxfer conv=notrunc if=./dist/boot.bin of=./dist/atOS.flp

start:
	qemu-system-i386 -fda ./dist/atOS.flp
