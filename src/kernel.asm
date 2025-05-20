  BITS 16

jmp start

msg db 'Welcome to AtomOS!', 0

start:
  cli
  xor ax, ax
  mov ss, ax
  mov sp, 0x0FFFF
  sti
  cld

  mov ax, 0x2000
  mov ds, ax
  mov es, ax,

  mov si, msg
  mov ah, 0x0E

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

