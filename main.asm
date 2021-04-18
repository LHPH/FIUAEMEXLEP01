TITLE Ejercicio 8				(main.asm)

; Description: programa que suma,resta y multiplica matrices de 2x2
; 
; Revision date:

INCLUDE Irvine32.inc
.data
  Arreglo1 REAL4 ?,?,?,?
  Arreglo2 REAL4 ?,?,?,?
  ArregloR REAL4 ?,?,?,?
  aux REAL4 ?
  opc DWORD ?
  ind DWORD 0

  msg1 BYTE "Menu de Opciones",0dh,0ah
       BYTE "1-Sumar ",0dh,0ah
	   BYTE "2-Restar ",0dh,0ah
	   BYTE "3-Multiplicar ",0dh,0ah
	   BYTE "Opcion: ",0

  msg12 BYTE "Primera Matriz ",0dh,0ah,0
  msg13 BYTE "Segunda Matriz ",0dh,0ah,0

  msg2 BYTE "Dame Numero ",0dh,0ah,0
  msgres BYTE "Resultado de la operacion ",0dh,0ah,0
  borde BYTE "|",0
  coma BYTE ",",0
  suma BYTE " +  ",0
  resta BYTE " -  ",0
  multi BYTE " X  ",0
  igual BYTE " =  ",0
  espacio BYTE "    ",0

.code
main PROC
    call Clrscr
	finit
	call Menu
	call Clrscr
	call ObtenerNumeros2x2
	.IF(opc==1)
	   call SumarMatrices
	.ELSEIF(opc==2)
	   call RestarMatrices
	.ELSEIF(opc==3)
	   call MultiMatrices2x2
	.ENDIF
	call Clrscr
	call MostrarMatrices
	exit
main ENDP

 ;-----------------------------------------------------------------
 ;Procedimiento ObtenerNumeros el cual le pide el usuario los numeros reales
 ; que se van almacenando en la pila de registros y una vez hecho esto
 ;son asignados a la matriz correspondiente
 ;-----------------------------------------------------------------
 ObtenerNumeros2x2 PROC

   mov edx,OFFSET msg12
   call WriteString
   ;Obtener los numeros de la primera matriz
   mov esi,0
   mov ecx,4
   ;ciclo de los primeros cuatro numeros de la matriz uno
   L1:
   mov edx,OFFSET msg2
   call WriteString
   call ReadFloat

   fstp Arreglo1[esi] ;Asignar al arreglo 1 los valores reales que estan en la pila en la posicion st(0)
   add esi,TYPE REAL4
   loop L1

   call Clrscr
   mov edx,OFFSET msg13
   call WriteString
   ;Obtener los numeros de la segunda matriz
   mov esi,0
   mov ecx,4
   L2:
   mov edx,OFFSET msg2
   call WriteString
   call ReadFloat

   fstp Arreglo2[esi] ;Asignar al arreglo los valores reales que estan en la pila
   add esi,TYPE REAL4
   loop L2

   ret
 ObtenerNumeros2x2 ENDp
 ;---------------------------------------------------------

 ;--------
 ;Procedimiento Sumar Matrices que hace la suma de matrices
 ;
 SumarMatrices PROC
     mov ecx,4
	 mov esi,0
  CICLO:
    fld Arreglo1[esi]
	fld Arreglo2[esi]
	fadd st(0),st(1)
	fstp ArregloR[esi]
	add esi,TYPE REAL4
   loop CICLO

	 ret
SumarMatrices ENDP
;-------------------------------------

;-----------------------------------
;Procedimiento RestarMatrices que hace la resta de las matrices
;
RestarMatrices PROC
	  mov ecx,4
	  mov esi,0
  CICLO2:
    fld Arreglo1[esi]
	fld Arreglo2[esi]
	fsub st(1),st(0)
	fstp ArregloR[esi]
	add esi,TYPE REAL4
   loop CICLO2
	 ret
RestarMatrices ENDP
;-------------------------------------------------

;------------------------------------------------------------------
;Procedimiento MostrarMatrices que muestra las tres matrices
;las dos que metio el usuario y la tercera que muestra la matriz resultante
;de las operaciones que eligio el usuario

MostrarMatrices PROC
   mov edx,OFFSET msgres
   call WriteString
   call Crlf

   mov eax,0 ;contador

   mov esi,0
   mov ebx,0
   mov ecx,0 ;indices de las matrices
.REPEAT
   ;mostrar primeros dos valores o dos ultimos segun el valor de eax de la primera matriz
	mov edx,OFFSET borde
	call WriteString
	fld Arreglo1[esi]
	call WriteFloat

	mov edx,OFFSET coma
	call WriteString
	fstp aux
	add esi,TYPE REAL4

	fld Arreglo1[esi]
	call WriteFloat
	mov edx,OFFSET borde
	call WriteString
	add esi,TYPE REAL4

	; dependiendo del valor de eax y de opc se mostrara el signo +,-,X o un espacio
	.IF eax==0 && opc==1
	   mov edx,OFFSET suma
	   call WriteString
	.ELSEIF (eax==0 && opc==2)
	   mov edx,OFFSET resta
	   call WriteString  
	.ELSEIF (eax==0 && opc==3)
	   mov edx,OFFSET multi
	   call WriteString
	.ELSEIF
	   mov edx,OFFSET espacio
	   call WriteString
	.ENDIF

	;mostrar los primeros dos valores  o dos ultimos de la segunda matriz
	mov edx,OFFSET borde
	call WriteString
	fld Arreglo2[ebx]
	call WriteFloat

	mov edx,OFFSET coma  ;escribir una coma
	call WriteString
	fstp Arreglo2[ebx]
	add ebx,TYPE REAL4

	fld Arreglo2[ebx]
	call WriteFloat
	mov edx,OFFSET borde  ; escribir un borde
	call WriteString

	add ebx,TYPE REAL4
	.IF eax==0
	   mov edx,OFFSET igual
	   call WriteString
	.ELSEIF
	    mov edx,OFFSET espacio
		call WriteString
	.ENDIF
	fstp aux

	;mostrar los dos primeros o dos ultimos valores de la matriz resultante segun el valor de eax
	mov edx,OFFSET borde
	call WriteString
	fld ArregloR[ecx]
	call WriteFloat

	mov edx,OFFSET coma
	call WriteString
	;fstp ArregloR[ecx]
	fstp aux
	add ecx,TYPE REAL4

	fld ArregloR[ecx]
	call WriteFloat
	mov edx,OFFSET borde
	call WriteString

	add ecx,TYPE REAL4
	inc eax
	call Crlf
   .UNTIL eax==2

     ret
MostrarMatrices ENDP
;---------------------------------------------------

;--------------------------------------------------------
;MultiMatrices2x2 procedimiento que multiplica dos matrices de 2x2
;

 MultiMatrices2x2 PROC
	 ;Inicializando contadores
	 mov esi,0
	 mov eax,0
	 mov ebx,0
	 mov ecx,0
	 ;Cargar renglon y columna en la pila y hacer las operaciones indicadas
	 .REPEAT
	 fld Arreglo1[esi]
	 fld Arreglo2[eax]
	 add esi,TYPE REAL4
	 add eax,TYPE REAL4
	 add eax,TYPE REAL4

	 fmul ST(0),ST(1)

	 fld Arreglo1[esi]
	 fld Arreglo2[eax]

	 fmul ST(1),ST(0)
	 fstp aux
	 fadd ST(0),ST(1)

	 fstp ArregloR[ebx] ; se agrega la suma de la multiplicacion de renglon por columna en la posicion indicada de la matriz
	 add ebx,TYPE REAL4

	 fstp aux
	 fstp aux

	 sub esi,TYPE REAL4
	 sub eax,TYPE REAL4
	 fld Arreglo1[esi]
	 fld Arreglo2[eax]
	 add esi,TYPE REAL4
	 add eax,TYPE REAL4
	 add eax,TYPE REAL4

	 fmul ST(0),ST(1)

	 fld Arreglo1[esi]
	 fld Arreglo2[eax]
     

	 fmul ST(1),ST(0)
	 fstp aux
	 fadd ST(0),ST(1)

	 fstp ArregloR[ebx] ;se agrega el segundo valor al primer o segundo renglon segun el valor de ebx
	 add ebx,TYPE REAL4
	 add esi,TYPE REAL4
	 mov eax,0
	 inc ecx
	 .UNTIL ecx==2
	 ret
 MultiMatrices2x2 ENDP

 Menu PROC
   mov edx,OFFSET msg1
   call WriteString
   call ReadDec
   mov opc,eax
    ret
 Menu ENDP



END main