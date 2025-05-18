  BITS 16
  ORG 8000h

jmp start

msg db 'Welcome to AtomOS!', 0

start:
  mov si, msg
  mov ah, 0Eh

.repeat:
  lodsb
  cmp al, 0
    je .done
  int 10h
  jmp .repeat
.done:
  mov ah, 00h
  int 16h
  jmp $

