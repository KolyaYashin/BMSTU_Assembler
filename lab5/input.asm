EXTRN NEWLINE_PRINT: NEAR
EXTRN EXIT: NEAR
EXTRN CLEAR: NEAR
EXTRN SIGN: WORD

PUBLIC NUMBER
PUBLIC CHOOSE_ACTION
PUBLIC INPUT_UNSIGNED_BIN

DATASEG SEGMENT PARA PUBLIC 'DATA'
    NUMBER DW 0
    INPUT_MSG DB 'Enter unsigned binary number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

CHOOSE_ACTION PROC NEAR

	mov AX,0
	mov SIGN, AX
    MOV AH, 1
    INT 21H

    cmp al, 13
    je EXIT

    sub al, '0'
    mov cl, 2
    mul cl
    mov SI, AX
    ret

CHOOSE_ACTION ENDP


INPUT_UNSIGNED_BIN PROC NEAR

	 call CLEAR
     call NEWLINE_PRINT
     mov dx, offset INPUT_MSG
     mov ah, 09h
     int 21h

     INPUT_SYMBOL:
        mov ah, 01h               ; ввод символа
        int 21h

        cmp al, 13                ; сравнивает если ничего не ввели
        je ENDINPUT
        mov cl,al
		mov ax,2
		mul bx
		mov bx,ax
		mov ch,0
		sub cl,'0'
		add bx,cx
        JMP INPUT_SYMBOL

     ENDINPUT:
     mov NUMBER, bx

     ret
INPUT_UNSIGNED_BIN ENDP

CODESEG ENDS
END