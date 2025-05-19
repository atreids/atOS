
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
