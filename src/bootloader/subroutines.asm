
; Print
print_string:
    mov ah, 0Eh       ; BIOS.Teletype

.print_char:
    lodsb
    cmp al, 0
      je .done
    int 10h
    jmp .print_char

.done:
    ret
; End print

disk_error:
    mov si, general_disk_error_msg
    call print_string
    jmp $

read_success:
    mov si, floppy_found
    call print_string
    ret

init_message:
    mov si, init_msg
    call print_string
    ret


calcRegsFromLogical: ;Given a logical sector is in AX, set correct registers for INT13h
    push bx
    push ax

    ; Figures out what sector we need
    mov bx, ax
    mov dx, 0
    div word [SectorsPerTrack]
    add dl, 01h
    mov cl, dl
    mov ax, bx

    ; Figure out what head
    mov dx, 0
    div word [SectorsPerTrack]
    mov dx, 0
    div word [Sides]
    mov dh, dl
    mov ch, al

    pop ax
    pop bx

    mov dl, byte [bootdevice]
    ret

; -----------------------------
; Variables

bootdevice      db 0
cluster         dw 0 ; On floppy clusters and sectors are the same 512bytes stretch
pointer         dw 0 ; Pointer into to where kernel will exist in buffer

kernel_name db "KERNEL  BIN"
about_to_read_msg db "Initiating disk read", 13, 10, 0
general_disk_error_msg db "Disk error", 13, 10,  0
floppy_found db "Kernel loaded, transferring...", 13, 10, 0
init_msg db "Bootloader of AtomOS version 0.1a",  13, 10, "Created by Aaron Donaldson", 13, 10, "Booting...", 13, 10, 0


