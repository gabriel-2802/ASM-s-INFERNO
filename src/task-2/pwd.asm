section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here

	nr_dirs dd 0
	n dd 0
	max dd 255

section .bss
	output resb 256

section .text
	global pwd
	extern printf
	extern strcmp
	extern strcat
	extern strrchr
	extern strcpy
	extern strlen

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
	enter 0, 0

	; salvam toti registrii
	pusha

	; directoare
	mov edi, [ebp + 8]
	; n
	mov ebx, [ebp + 12]

	; pentru a parcuge vectorul de directoare, vom inumlti n
	; cu sizeof(char *) si folosim o var globala pentru a salva
	; registrii
	imul ebx, ebx, 4
	mov [n], ebx

	; nr_dir va contoriza cate directoare avem 
	mov dword [nr_dirs], 0

	; initalizam cu NULL output
	xor ecx, ecx

looping:
	cmp dword ecx, [max]
	je endlooping
	mov byte [output + ecx], 0
	inc ecx
	jmp looping

endlooping:
	

	xor ecx, ecx
for:
	cmp ecx, dword [n]
	je endfor

	; salvam ecx in stiva
	push ecx

	;directorul curent
	mov ebx, dword[edi + ecx] 

	; verificam daca comanda este .
	push ebx
	push curr
	call strcmp
	add esp, 8
	cmp eax, 0
	; daca comanda este ., continuam cu urmatorul director
	je continue

	; verificam daca comanda este ..
	push ebx
	push back
	call strcmp
	add esp, 8
	cmp eax, 0
	; daca comanda nu este .., concateman directorul la output
	jne concatenate


	; daca nu exista directoare, continuam cu urm comanda
	cmp dword [nr_dirs], 0
	je continue

	; daca este primul director, il stergem
	cmp dword [nr_dirs], 1
	je remove_first

	; daca nu este primul director, folosim strrchr pentru a gasi
	; ultimul / din output
	; 47 == '/' in ASCII
	xor edx, edx
	mov edx, 47
	push edx
	push output
	call strrchr
	add esp, 8

	; setam null unde am gasit ultimul /
	mov byte [eax], 0
	
	; decrementam nr_dirs
	sub dword [nr_dirs], 1
	jmp continue

remove_first:
	; setam fiecare bit cu NULL
	xor ecx, ecx

null_first:
	cmp dword ecx, [max]
	je end_null_first

	mov byte [output + ecx], 0
	inc ecx
	jmp null_first

end_null_first:

	jmp continue

concatenate:
	; concatenam / la final de output
	push slash
	push dword output
	call strcat
	add esp, 8
	mov [output], eax

	; concatenam directorul la final de output
	push ebx
	push dword output
	call strcat
	add esp, 8
	mov [output], eax

	; incrementam nr_dirs
	inc dword [nr_dirs]

continue:
	pop ecx
	add ecx, 4
	jmp for

endfor:

	; concatenam / la final de output
	push slash
	push dword output
	call strcat
	add esp, 8
	mov [output], eax

	; setam inainte de output /
	mov [output + 3], byte 47
	; codul de mai sus creeaza 3 caractere neprintabile
	; la inceput de output
	lea ebx, [output + 3]

	; copiem output in parametrul output
	mov eax, [ebp + 16]
	push ebx
	push dword [ebp + 16]
	call strcpy
	add esp, 8
	
	popa
	
	leave
	ret