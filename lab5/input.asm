EXTRN NEWLINE_PRINT: NEAR
EXTRN EXIT: NEAR

PUBLIC SIGN
PUBLIC NUMBER
PUBLIC INPUT_SIGNED_DEC
PUBLIC INPUT_ACTION

DATASEG SEGMENT PARA PUBLIC 'DATA'
    NUMBER DW 0
    SIGN DB ' '
    INPUT_MSG DB 'Enter signed decimal number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

INPUT_ACTION PROC NEAR
    MOV AH, 1
    INT 21H
    
    cmp al, 13
    je EXIT
    
    sub al, '0'
    mov cl, 2
    mul cl
    mov SI, AX
    ret            
    
INPUT_ACTION ENDP

ADD_SYMBOL PROC NEAR    ;добавление к числу (bx) нового символа
    mov cl, al
    mov ax, 10
    mul bx
    mov bx, ax
    mov ch, 0
    sub cl, '0'
    add bx, cx
    ret
ADD_SYMBOL ENDP

INPUT_UNSIGNED_BIN PROC NEAR
     mov SIGN, '+'
     call NEWLINE_PRINT   
     mov dx, offset INPUT_MSG
     mov ah, 09h
     int 21h
     
     mov bx, 0                 ; инцилизация используемых РОР
     mov dx, 0
     
     mov ah, 01h               ; ввод символа
     int 21h
     
     cmp al, 13                ; сравнивает если ничего не ввели
     je ENDINPUT
     
     
     mov dh, al
     jmp INPUT_FIGURE
     
     call ADD_SYMBOL
     
     INPUT_FIGURE:
        mov ah, 01h               ; ввод символа
        int 21h
        
        cmp al, 13                ; сравнивает если ничего не ввели
        je ENDINPUT
        
        call ADD_SYMBOL
        JMP INPUT_FIGURE
     
     ENDINPUT:
     mov SIGN, 

     mov NUMBER, bx
     
     ret   
INPUT_UNSIGNED_BIN ENDP
    
CODESEG ENDS
END    
Footer
