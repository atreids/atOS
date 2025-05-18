  BITS 16 ; BIOS 'real mode' is 16 bit
  ORG 0x7C00 ; ORG sets 'start' memory location for all following moves

jmp start

msg db 'Bootloader of AtomOS version 0.1a',  13, 10, 'Created by Aaron Donaldson', 13, 10, 'Booting...', 0

start:
  xor ax, ax ; Sets AX = 0
  mov ds, ax ; Sets DS (data segment) = 0
  cld;
  add ax, 288
  mov sp, 4096

  mov si, msg
  call print_string

  xor ax, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov si, 8000h ;Kernel location
  mov ah, 02h ; INT 13h service, read sectors
  mov ch, 0
  mov cl, 2 ;Sector 2, sector 1 is this bootloader
  mov dh, 0
  mov al, 1 ;Read 1 sector only
  int 13h ;Read kernel from above params into RAM

  jmp 8000h ;Pass control to kernel


print_string:
  mov ah, 0Eh ;BIOS.Teletype
.repeat:
  lodsb
  cmp al, 0
    je .done
  int 10h
  jmp .repeat
.done
  ret


;Pad file with 0s to 510 bytes, and then add bootloader signature of AA55 in last 2 bytes.
;BIOS will not recongise this sector as the boot sector unless exactly 512 bytes ending in AA55
times 510-($-$$) db 0
dw 0xAA55
