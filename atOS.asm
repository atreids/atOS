    BITS 16 ; BIOS 'real mode' is 16 bit
    ORG 0x7C00 ; ORG sets 'start' memory location for all following moves
    ;BIOS loads the code in this file into RAM at 0x7C00 and begins execution there (aka jmps there).

jmp start ; Not strictly necessary

start:
    xor ax, ax ; Sets AX = 0
    mov ds, ax ; Sets DS (data segment) = 0
    cld ; clear line direction flag
    ;mov ax, 0x0012 ; Videomode
    int 10h ; BIOS screen output

    mov si, text_string ; Move first char byte of our string into SI register
    ;mov bl, 4 ; BL register contains color for our text, red.

    call print_string

    jmp $

    text_string db 'AtomOS version 0.1a', 13, 10, 'Created by Aaron Donaldson', 0

print_string:
    ;mov bh, 0
    mov ah, 0Eh ; BIOS.Teletype

.repeat:
    lodsb
    cmp al, 0 ; Check if end of string
      je .done
    int 10h
    jmp .repeat

.done:
    ret

times 510-($-$$) db 0
dw 0xAA55
