SSEG SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
SSEG ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	mesM db 'Input m: $'
	mesN db 'Input n: $'
	mesOutputBefore db 10
					db 'Matrix before: $'
	mesOutputAfter db 10
					db 'Matrix after: $'
DSEG ENDS

DSEGMATRIX SEGMENT PARA PUBLIC 'DATA'
	m db 9 ; количество строк по умолчанию
	n db 9 ; количество столбцов по умолчанию
	m_new db 0 ; фактическое количество строк
	n_new db 0 ; фактическое количество столбцов
	memcx db 0 ; переменная, запоминающая cl для внешнего loop
	membx db 0
	symb db '?' ; переменная для ввыода элемета матрицы
	matrix db 9*9 dup ('0')
DSEGMATRIX ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, ES:DSEGMATRIX, SS:SSEG
	
	
output:
	mov AH,9
	int 21h

	xor cx,cx
	mov memcx,0
	mov cl,m_new
	sub cl, 30h
	mov bx,0
	mov ah, 2
	mov dl, 10
	int 21h

output_row:
	mov memcx, cl
	xor cx,cx
	mov cl,n_new
	sub cl,30h
	mov si,0

	output_column:
		mov ah,2
		mov dl,matrix[bx][si]
		int 21h
		mov ah,2
		mov dl,' '
		int 21h
		inc si
	loop output_column

	mov dl,10 ; перевод каретки на новую строку для красивого вывода
	mov ah,2h
	int 21h

	xor cx,cx
	mov cl, memcx
	add bl,n
loop output_row
ret	



input:
	mov ah,9 ; вывод сообщения на экран
	mov dx,offset mesM
	int 21h

	mov ah,1 ; считывание символа с экрана - количество строк
	int 21h
	mov m_new,al

	mov dl,10 ; перевод каретки на новую строку
	mov ah,2h
	int 21h

	mov ah,9 ; вывод сообщения на экран
	mov dx,offset mesN
	int 21h

	mov ah,1 ; считывание символа с экрана - количество столбцов
	int 21h
	mov n_new,al
	
	mov dl,10 ; перевод каретки на новую строку
	mov ah,2h
	int 21h

	xor cx,cx ; зануление регистра cx
	mov cl, m_new ; т.к в регистр передаем переменную, то используем только часть регистра (1 байт)
	sub cl,30h ; переход по ASCII
	mov bx,0 ; индекс для обращения к строке

 input_row:
	mov memcx, cl ; запоминаем счетчик внешнего цикла
	xor cx,cx
	mov cl, n_new
	sub cl,30h ; переход по ASCII
	mov si,0 ; индекс для обращения к столбцу

	input_column:
		mov ah,1 ; считывание символа с экрана 
		int 21h
		mov symb,al

		mov dl,' ' ; перевод каретки на новую строку
		mov ah,2h
		int 21h

		mov dh,symb ; записываем введенный символ в матрицу через dh
		mov matrix[bx][si],dh
		inc si
	loop input_column


	mov dl,10 ; перевод каретки на новую строку для красивого вывода
	mov ah,2h
	int 21h
	
	xor cx,cx
	mov cl, memcx ; возвращаемся к внешнему циклу
	add bl,n
 loop input_row
ret


task:
	xor cx, cx
	mov memcx, 0
	mov cl, m_new
	sub cl, 30h
	sar cl, 1
	mov bx, 0
HALF_ROWS:
	MOV MEMCX, CL
	XOR CX,CX
	MOV CL,N_NEW
	SUB CL,30H
	MOV SI,0
	
	CHANGE:  ;SWAP MATRIX[BX][SI] AND MATRIX[M_NEW - BX][SI]
		MOV DH, MATRIX[BX][SI]     
		
		mov membx, BL      
		xor BX,BX          
		mov BL, m_new     
		dec BL
		sub BL, 30h    
		;BX*N
		mov AL, N
		mul BL
		mov BL, AL
		
		sub BL, membx           
		
		
		MOV DL,MATRIX[BX][SI]
		xor BX,BX
		mov BL, membx
		mov MATRIX[BX][SI], DL
		
		mov membx, BL      
		xor BX,BX          
		mov BL, m_new     
		dec BL
		sub BL, 30h    
		;BX*N
		mov AL, N
		mul BL
		mov BL, AL
		
		sub BL, membx      
		
		
		MOV MATRIX[BX][SI], DH
		xor BX,BX
		mov BL, membx
		
		
		INC SI
	LOOP CHANGE


	XOR CX,CX
	MOV CL, MEMCX
	ADD BL,N
 DEC CX
 jne HALF_ROWS
ret

main:        
    mov ax, DSEG
    mov ds, ax 
    
    mov ax, DSEGMATRIX
    mov es, ax 
	
	call input 

	mov dx, OFFSET mesOutputBefore
	call output
	
	call task

	mov dx, OFFSET mesOutputAfter
	call output
	
    mov ax, 4c00h
    int 21h
	
CSEG ENDS
END main