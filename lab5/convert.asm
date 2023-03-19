EXTRN NUMBER : WORD

PUBLIC SHEX
PUBLIC UOCT


PUBLIC TO_SIGNED_HEX
PUBLIC TO_UNSIGNED_OCT

DATASEG SEGMENT PARA PUBLIC 'DATA'
    MASK16 DW 15
    MASK8 DW 7
    SHEX DB 5 DUP(0), '$'
    UOCT DB 6 DUP(0), '$'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG


TO_SIGNED_HEX PROC NEAR   ; переводим в безнаковое 16 сс

    mov ax, NUMBER
    mov si, 3               
    convert_hex:
        mov dx, ax
        and dx, MASK16
        cmp dl, 10          ; доходим до 10, то число у нас F 
        jb ISDIGIT
        add dl, 7           ; прибавляем к числу 7
        
        ISDIGIT:
        add dl, '0'         ; переводим число в символ
        mov UHEX[SI], dl    ; записываем в буфер
        mov cl, 4
        sar ax, cl          ; сдвигаемся на 4, т.к одно 16-е число предст. 4-мя 2-ми
        dec si
        cmp si, -1
        jne convert_hex
        
    ret
TO_SIGNED_HEX ENDP

TO_UNSIGNED_OCT PROC NEAR   ; перевод в знаковую 2 сс

    mov dh, SIGN
    mov ax, NUMBER
    cmp dh, "-"          ; смотрим на clзнак
    jne BIN_POS
    neg ax
    mov SBIN[0], "-"
    BIN_POS:
    mov si, 16
    CONVERT_BIN:
        mov dx, ax
        and dx, MASK21
        add dl, '0'
        mov SBIN[si], dl
        mov cl, 1
        sar ax, cl
        dec si
        cmp si, 0
        jne CONVERT_BIN
                    
    ret
TO_UNSIGNED_OCT ENDP
    
CODESEG ENDS
END    
