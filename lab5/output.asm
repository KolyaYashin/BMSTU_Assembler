EXTRN TO_UNSIGNED_OCT: NEAR
EXTRN TO_SIGNED_HEX : NEAR

EXTRN SHEX: BYTE
EXTRN UOCT: BYTE
EXTRN SDEC: BYTE
EXTRN SIGN: BYTE

PUBLIC OUT_UNSIGNED_OCT
PUBLIC OUT_SIGNED_HEX
PUBLIC NEWLINE_PRINT

DATASEG SEGMENT PARA PUBLIC 'DATA'
    OUT_SHEX_MSG DB 'Signed hexadecimal number:  $'
    OUT_UOCT_MSG DB 'Unsigned octal number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

NEWLINE_PRINT PROC NEAR                   
    
    mov ah, 02h
    mov dl, 10
    int 21h
   
    ret  
NEWLINE_PRINT ENDP 
    
OUT_UNSIGNED_OCT PROC NEAR
    
    call NEWLINE_PRINT

    mov DX, OFFSET OUT_SBIN_MSG
    mov ah, 09h
    int 21H
    
    
    
    call TO_SIGNED_BIN

    mov ah, 09h
    mov dx, OFFSET SBIN
    int 21h
    
    call NEWLINE_PRINT
    call NEWLINE_PRINT
    
    RET
OUT_UNSIGNED_OCT ENDP



OUT_SIGNED_HEX PROC NEAR

    call NEWLINE_PRINT
    
    mov DX, OFFSET OUT_UHEX_MSG
    mov ah, 09h
    int 21H

    call TO_UNSIGNED_HEX

    mov ah, 09h
    mov dx, OFFSET UHEX
    int 21h
    
    call NEWLINE_PRINT
    call NEWLINE_PRINT
    
    ret
OUT_SIGNED_HEX ENDP

CODESEG ENDS
END  
