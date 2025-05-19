    BITS 16       ; BIOS real mode is always 16bits

    jmp short start
    nop

; ---------------------
; This BIOS Parameter Block (BPB) (and jmp short <blah> nop above) is required to make the output a valid FAT12 floppy disk
; See https://wiki.osdev.org/FAT#BPB_(BIOS_Parameter_Block)
; Values match IBM 3.5" floppy.
;
; Define series of bytes at start of file to make valid BPB
; We may redefine some of these variables later by reading the actual floppy inserted

OEMLabel          db "ATOSBOOT" ; OEM Identifier (must be 8 bytes aka 8 chars)
BytesPerSector    dw 512        ; Bytes per sector
SectorsPerCluster db 1          ; Sectors per cluster
ReservedForBoot   dw 1          ; Reserved sectors for boot record
NumberOfFats      db 2          ; Number of copies of the FAT
RootDirEntries    dw 224        ; Number of entries in root dir
                                  ; (224 * 32 = 7168 = 14 sectors to read)
LogicalSectors    dw 2880       ; Number of logical sectors
MediaByte         db 0x0F0       ; Media descriptor
SectorsPerFat     dw 9          ; Sectors per FAT
SectorsPerTrack   dw 18         ; Sectors per track (36/cylinder)
Sides             dw 2          ; Number of sides/heads
HiddenSectors     dd 0          ; Number of hidden sectors
LargeSectors      dd 0          ; Number of LBA sectors
DriveNo           dw 0          ; Drive No: 0
Signature         db 0x29       ; Drive signature: 29h for floppy
VolumeID          dd 0x0000     ; Volume ID: any number
VolumeLabel       db "ATOS"     ; Volume Label
FileSystem        db "FAT12"    ; File system type

; ---------------------
; Main bootloader
start:
    cld
    mov ax, 0x7C00
    mov ds, ax        ; Set data segment to where we are in memory: 7C00
    mov ss, ax        ; Set stack segment to same place
    mov sp, 0x7C00      ; Set stack pointer below bootloader in memory. Generally safe place.
                        ; as stacks expand down in x86
    call init_message

    cmp dl, 0
      jne disk_error ; DL should contain drive number 0. If it doesn't lets just error
                     ; See http://wiki.osdev.org/System_Initialization_(x86)#BIOS_initialization

    ; Now we need to load the root directory
    mov ax, 19 ; in FAT12 root dir will start at logical sector 19
    call calcRegsFromLogical

    mov si, buffer
    mov bx, ds    ; DS at this point is 7C00 aka our offset
    mov es, bx
    mov bx, si    ; Int13h + 02h will write to ES:BX aka segment:offset.
                  ; Result is buffer:7C00
    mov ah, 02h   ; Read
    mov al, 14    ; Read 14 sectors (floppy)

    pusha
    int 13h
      jnc disk_error ; Oops our read failed. On a real system this sort of setup would not be acceptable. We would need to retry.
                     ; As real floppy disks commonly would fail to read the first few times as the disks warmed up.
    popa

    ; Root dir is now in buffer
    ; We must search for our kernel file :)
    mov ax, ds
    mov es, ax
    mov di, buffer

    mov cx, word [RootDirEntries] ; Move the contents of RootDirEntries (as 2bytes) into cx
    mov ax, 0

    xchg cx, dx ; swap cx and dx
    mov si, kernel_name ;Input string is our file name
    mov cx, 11 ; counter
    rep cmpsb ; repeat cmpsb 11 times, comparing DI (our buffer) with SI (our kernel name) byte by byte. 11 times cuz that is the length of our kernel filename string


; -----------------------------
; Buffer and signature

%include "subroutines.asm"

times 510-($-$$) db 0
dw 0xAA55       ; SIGNATURE

buffer: ; This label allows us to make sure we don't overwrite our own code in memory
        ; by placing things after this (stack is under this code at 7C00)
        ; this buffer must start then at 7C00 + 512B
