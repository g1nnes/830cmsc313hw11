section .data
    inputBuf db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
    inputLen equ $ - inputBuf

    hexChars db "0123456789ABCDEF"

section .bss
    outputBuf resb 80

section .text
    global _start

; Subroutine: byte_translate
; Converts AL to two ASCII hex characters.
; Writes to [EDI], advances EDI by 2.
; Pops eax

byte_translate:
    push eax
    mov ah, al

    ; Grab and translate first 4 bytes
    shr al, 4
    and al, 0x0F
    movzx ebx, al
    mov al, [hexChars + ebx]		; Reference database to translate
    stosb

    ; Grab and translate last 4 bytes
    pop eax
    and al, 0x0F
    movzx ebx, al
    mov al, [hexChars + ebx]
    stosb

    ret

_start:
    mov esi, inputBuf        ; source buffer pointer
    mov edi, outputBuf       ; output buffer pointer
    mov ecx, inputLen        ; number of bytes
    mov ebx, 0             ; index

convert_loop:
    lodsb                    ; load AL into ESI
    call byte_translate      ; translate and store at [EDI]
	
	; If at end of translation, cap off with newline and display
	; Else append space and continue
    inc ebx
    cmp ebx, inputLen
    je finish
    mov al, ' '
    stosb

finish:
    loop convert_loop

    ; append newline
    mov al, 0x0A
    stosb

    ; print outputBuf to screen
    mov edx, edi             ; current end of buffer
    sub edx, outputBuf       ; shrink from pointer to actual needed size
    mov ecx, outputBuf       ; ecx = pointer to buffer
    mov ebx, 1               ; write to stdout
    mov eax, 4               ; invoke sys_write
    int 0x80

    ; exit
	mov ebx, 0
    mov eax, 1
    int 0x80