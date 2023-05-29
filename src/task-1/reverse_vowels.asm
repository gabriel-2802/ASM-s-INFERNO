section .data
	; declare global vars here

section .text
	global reverse_vowels
	extern printf
	extern strchr

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	enter 0,0
	pusha

	; edi = string
	push dword [ebp + 8]
	pop edi

	; salvam strlen(string) in esi
	xor esi, esi
my_strlen:
	cmp byte [edi], 0
	je end_my_strlen
	inc esi
	inc edi
	jmp my_strlen
end_my_strlen:

	; readucem in edi string ul
	push dword [ebp + 8]
	pop edi
	
	xor ebx, ebx
push_vowels:
	cmp ebx, esi
	je end_push_vowels

	; verificam daca litera e vocala
	cmp byte [edi + ebx], 97
	je is_vowel
	cmp byte [edi + ebx], 101
	je is_vowel
	cmp byte [edi + ebx], 105
	je is_vowel
	cmp byte [edi + ebx], 111
	je is_vowel
	cmp byte [edi + ebx], 117
	je is_vowel

	jmp continue


is_vowel:
	; daca e vocala, o punem in stiva impreuna cu urm litera
	push word [edi + ebx]

continue:
	inc ebx
	jmp push_vowels

end_push_vowels:

	; readucem in edi string ul
	push dword [ebp + 8]
	pop edi

	; initalizam contorul cu 0
	xor ebx, ebx
pop_vowels:
	cmp ebx, esi
	je end_pop_vowels

	; verificam daca litera e vocala
	cmp byte [edi + ebx], 97
	je is_vowel2
	cmp byte [edi + ebx], 101
	je is_vowel2
	cmp byte [edi + ebx], 105
	je is_vowel2
	cmp byte [edi + ebx], 111
	je is_vowel2
	cmp byte [edi + ebx], 117
	je is_vowel2

	jmp continue2

is_vowel2:
	; daca e vocala, trebuie inlocuita cu ultima vocala din stiva
	; deci scoatem din singura vocala + urm lit
	pop word ax
	; punem in stiva cuvantul de dupa vocala
	push dword [edi + ebx + 1]
	push word ax
	; punem in pozitia vocalei orginale, vocala din stiva
	pop word [edi + ebx]
	; la final punem dupa vocala, restul cuvantului salvat in stiva
	pop dword [edi + ebx + 1]


continue2:
	inc ebx
	jmp pop_vowels

end_pop_vowels:

	popa
	leave
	ret