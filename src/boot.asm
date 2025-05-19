    BITS 16       ; BIOS real mode is always 16bits
    ORG 0x7C00        ; Bootloader will be placed by BIOS here in RAM

    jmp start

    %include "print.asm"

; ---------------------
; Main bootloader

start:
    cld
    xor ax, ax        ; Sets AX = 0
    mov ds, ax        ; Sets DS (data segment) = 0
    mov ss, ax
    mov sp, 0x7C00       ; Set stack below bootloader in memory.

    mov si, init_msg       ; Print a debug string
    call print_string

    mov ah, 0x02       ; INT 13h service, read disk sectors
    mov ch, 0       ; Track num
    mov cl, 2       ; Sector 2, sector 1 is this bootloader
    mov dh, 0       ; Head Num
    mov al, 1       ; Read 1 sector only

    mov ax, 0x1000
    mov es, ax        ; ES:BX is where the read buffer will be placed in memory
    mov bx, 0

    int 13h       ; Read disk using above params
    jc disk_error       ; Check if read error occurred

    call read_success

    jmp 0x1000        ; Pass control to kernel

; -----------------------------
; Subroutines

disk_error:
    mov si, general_disk_error_msg
    call print_string
    jmp $

about_to_read:
    mov si, about_to_read_msg
    call print_string
    ret

read_success:
    mov si, floppy_found
    call print_string
    ret

; -----------------------------
; Variables

about_to_read_msg db 'Initiating disk read', 13, 10, 0
general_disk_error_msg db 'Disk error', 13, 10,  0
floppy_found db 'Kernel loaded, transferring...', 13, 10, 0
init_msg db 'Bootloader of AtomOS version 0.1a',  13, 10, 'Created by Aaron Donaldson', 13, 10, 'Booting...', 13, 10, 0

; -----------------------------
; Buffer and signature

times 510-($-$$) db 0
dw 0xAA55       ; SIGNATURE
