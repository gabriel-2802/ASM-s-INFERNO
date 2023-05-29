section .text
	global do_math
	two dd 2.0
	four dd 4

;; float do_math(float x, float y, float z)
;  returns x * sqrt(2) + y * sin(z * PI * 1/e)
do_math:
	push	ebp
	mov 	ebp, esp

	fld dword [ebp + 8]	; x
	fld dword [two]		; 2
	fsqrt
	fmul
	; ST(0) contine acum x * sqrt(2)


	; incepem sa prelucram termenul sin(z * PI * 1/e)
	fld dword [ebp +  16]	; z
	fldpi
	fmul
	; ST(0) contine acum z * PI

	; pt a obtine 1/e, folosim prop a^log_a(b) = b
	fldl2e
	fchs
	; pt a obtine 1 / e, inmultim log_2(e) cu -1
	fild word [four]
	; f2xm1 functioneaza daca | ST(0) |  < 0.5
	; deci impartim log_2(e) cu 4
	fdivp
	f2xm1	
	fld1
	faddp
	; adunam 1 pentru ca f2xm1 calculeaza 2^x - 1
	; trebuie sa ridicam rez la a 4-a
	; ST(0) = 1 pe radical de ordin 4 din e
	fld st0
	fmul 
	fld st0
	fmul

	; ST(0) contine acum sin(z * PI * 1/e)
	fmul
	; aplicam sinus
	fsin
	fld dword [ebp + 12]	; y
	fmulp

	faddp
	; ST(0) contine acum x * sqrt(2) + y * sin(z * PI * 1/e)
 

	leave
	ret
