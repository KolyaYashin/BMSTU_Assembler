StkSeg SEGMENT PARA STACK 'STACK'
 DB 200h DUP (?)
StkSeg ENDS
;
DataS SEGMENT WORD 'DATA'
HelloMessage DB 13 ;курсор поместить в нач. строки
 DB 10 ;перевести курсор на нов. строку
 DB 'Hello, world !' ;текст сообщения
 DB '$' ;ограничитель для функции DOS
DataS ENDS
;
Code SEGMENT WORD 'CODE'
 ASSUME CS:Code, DS:DataS
DispMsg:
 mov AX,DataS ;загрузка в AX адреса сегмента данных
 mov DS,AX ;установка DS
 mov DX,OFFSET HelloMessage ;DS:DX - адрес строки
 mov CX, 3
 mov AH, 9 ;
 lp:
	int 21h ;
	loop lp
 mov AH,7 ;
 int 21h ;
 mov AH, 4Ch;
 int 21h ;
Code ENDS
 END DispMsg