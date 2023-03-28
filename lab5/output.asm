EXTRN OCT: NEAR
EXTRN HEX: NEAR
EXTRN TO_UNSIGNED_OCT: NEAR
EXTRN TO_SIGNED_HEX: NEAR
EXTERN SIGN:WORD
PUBLIC OUTPUT_UNSIGNED_OCT
PUBLIC OUTPUT_SIGNED_HEX


DATASEG SEGMENT PARA PUBLIC 'DATA'

    OUT_UHEX_MSG DB 'Signed hexadecimal number:  $'
    OUT_UOCT_MSG DB 'Unigned octus number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

NEWLINE_PRINT PROC NEAR

    mov ah, 02h
    mov dl, 10
    int 21h

    ret
NEWLINE_PRINT ENDP

OUTPUT_UNSIGNED_OCT  PROC NEAR

    call NEWLINE_PRINT

    mov DX, OFFSET OUT_UOCT_MSG
    mov ah, 09h
    int 21H

    call TO_UNSIGNED_OCT

    mov ah, 09h
    mov dx, OFFSET OCT
    int 21h

    call NEWLINE_PRINT

    RET
OUTPUT_UNSIGNED_OCT  ENDP


OUTPUT_SIGNED_HEX  PROC NEAR

    call NEWLINE_PRINT

    mov DX, OFFSET OUT_UHEX_MSG
    mov ah, 09h
    int 21H

    call TO_SIGNED_HEX

	mov ax,sign
	cmp al,1
	jne plus
	mov ah, 02h
	mov dl, '-'
	int 21h
	plus:

    mov ah, 09h
    mov dx, OFFSET HEX
    int 21h

    call NEWLINE_PRINT

    RET
OUTPUT_SIGNED_HEX  ENDP

CODESEG ENDS
END