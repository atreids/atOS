BOOTLOADER_SRC := ./src/bootloader/boot.asm
KERNEL_SRC := ./src/kernel.asm
FLOPPY_DISK := ./dist/atOS.flp
FLOPPY_DISK_SIZE := 1440
LOCAL_USER := aaron


default: build-asm build-floppy
build-asm:
	rm -rf ./dist
	mkdir ./dist
	nasm $(BOOTLOADER_SRC) -i src/bootloader -f bin -o ./dist/boot.bin 
	nasm $(KERNEL_SRC) -f bin -o ./dist/kernel.bin

build-floppy:
	mkfs.vfat -C $(FLOPPY_DISK) $(FLOPPY_DISK_SIZE)
	dd status=noxfer conv=notrunc if=./dist/boot.bin of=$(FLOPPY_DISK)
	rm -rf tmp-loop
	mkdir tmp-loop
	mount -o loop -t vfat $(FLOPPY_DISK) tmp-loop
	cp ./dist/kernel.bin tmp-loop/
	umount tmp-loop
	rm -rf tmp-loop
	mkisofs -quiet -V 'ATOS' -input-charset iso8859-1 -o dist/atOS.iso -b atOS.flp dist/
	chmod -R 777 ./dist

start:
	qemu-system-i386 -drive format=raw,file=dist/atOS.flp,index=0,if=floppy
