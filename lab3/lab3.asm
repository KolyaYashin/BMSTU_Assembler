DATA SEGMENT WORD 'DATA'

enterMessage db 13
			 db 10
			 db 'Enter your string:  '
			 db 10
			 db '$'
replyUser db 10
			db '5th symbol of your string is - $'

string db 100, 100 dup ('$')

DATA ENDS

STK SEGMENT PARA STACK 'STACK' 
db 256 dup(?)
STK ENDS

CODE SEGMENT WORD 'CODE'
ASSUME CS:CODE, DS:DATA, SS:STK

DispMsg:
mov AX, DATA
mov DS, AX


mov AH, 09
mov DX, OFFSET enterMessage
int 21h

mov DX, OFFSET string
mov AH, 0Ah
int 21h


mov AH, 09
mov DX, OFFSET replyUser
int 21h


mov AH, 02
mov DL, string+6
int 21h

mov AH, 4Ch
int 21h


code ends
end DispMsg