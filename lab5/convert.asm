EXTRN NUMBER: WORD
PUBLIC CLEAR
PUBLIC TO_UNSIGNED_OCT
PUBLIC TO_SIGNED_HEX
PUBLIC OCT
PUBLIC HEX
PUBLIC SIGN


DATASEG SEGMENT PARA PUBLIC 'DATA'
    OCT DB 6 DUP(0), '$'
	HEX DB 4 DUP (0), '$'
	MEM_BX DW 0
	mem_Cl DW 0
	SIGN DW 0
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

CLEAR PROC NEAR
  mov cx, 6
  mov si, 0
  clear_oct:
    mov OCT[si], '$'
	inc si
  loop clear_oct

  mov cx, 5
  mov si, 0
  clear_hex:
    mov HEX[si], '$'
	inc si
  loop clear_hex
  mov number,0
  ret
CLEAR ENDP

TO_UNSIGNED_OCT PROC NEAR

    mov bx, NUMBER
    mov cx, 6
    CONVERT_BIN:
	mov MEM_BX,bx
	and bx,7
	add bx,'0'
	mov si,cx
	dec si
	mov OCT[si],bl
	mov bx,MEM_BX
	mov mem_Cl,cx
	mov cl,3
	shr bx,cl
	mov cx, mem_Cl
	loop CONVERT_BIN
    ret
TO_UNSIGNED_OCT ENDP

TEST_POSITIVE PROC NEAR
mov MEM_BX,bx
mov cx,1
mov dx,0
mov ax,bx
mov bx,32768
div bx
mov bx,ax
cmp bx,1
jne pos
mov sign,1
mov bx,MEM_BX
neg bx
jmp return
pos:
mov bx,MEM_BX

return:
ret
TEST_POSITIVE ENDP


TO_SIGNED_HEX PROC NEAR
    mov bx, NUMBER
    call TEST_POSITIVE
    mov cx, 4
    CONVERT_BIN:
	mov MEM_BX,bx
	and bx,15
	cmp bx,9
	jg to_ascii
	add bx,'0'
	jmp next
	to_ascii:
	sub bx,10
	add bx,'A'
	next:
	mov si,cx
	dec si
	mov HEX[si],bl
	mov bx,MEM_BX
	mov mem_Cl,cx
	mov cl,4
	shr bx,cl
	mov cx,mem_Cl
	loop CONVERT_BIN
    ret
TO_SIGNED_HEX ENDP

CODESEG ENDS
END
