
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


; This code comes from MikeOS. See LICENCE
; Given a logical sector is in AX, set correct registers for INT13h
calcRegsFromLogical:
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

progress_msg db "Step reached...", 13, 10, 0
kernel_name db "KERNEL  BIN"
general_disk_error_msg db "ERROR: INT13h error", 13, 10, 0
floppy_found db "Kernel loaded, transferring...", 13, 10, 0
init_msg db "Bootloader of AtomOS version 0.1a",  13, 10, "Created by Aaron Donaldson", 13, 10, "Initiating bootloader...", 13, 10, 0


