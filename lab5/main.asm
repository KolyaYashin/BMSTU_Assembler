EXTRN CHOOSE_ACTION: NEAR
EXTRN INPUT_UNSIGNED_BIN: NEAR
EXTRN OUTPUT_UNSIGNED_OCT: NEAR
EXTRN OUTPUT_SIGNED_HEX: NEAR
EXTRN NEWLINE_PRINT: NEAR

PUBLIC EXIT

STACKSEG SEGMENT PARA STACK 'STACK'
    DB 200H DUP(0)
STACKSEG ENDS

DATASEG SEGMENT PARA PUBLIC 'DATA'
    MENU DB 'Available actions:', 13, 10, 10
        DB '1. Input unsigned binary number: ', 13, 10
        DB '2. Convert to unsigned octal: ', 13, 10
        DB '3. Convert to signed hex: ', 13, 10, 10, 10
        DB '0. Exit program.', 13, 10, 10
        DB 'Choose action: $'

    ACTIONS DW EXIT, INPUT_UNSIGNED_BIN, OUTPUT_UNSIGNED_OCT, OUTPUT_SIGNED_HEX
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG

MAIN:
    mov ax, DATASEG
    mov ds, ax

    START:
    mov dx, offset MENU
    mov ah, 09h
    int 21h

    call CHOOSE_ACTION
    call ACTIONS[si]
    jmp START

EXIT PROC NEAR
    mov ax, 4c00h
    int 21h
EXIT ENDP

CODESEG ENDS
END MAIN