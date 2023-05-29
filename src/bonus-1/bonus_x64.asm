section .text
	global intertwine
	alternate dd 0
;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	push	rbp
	mov 	rbp, rsp

	; rdi = v1
	; rsi = n1
	; rdx = v2
	; rcx = n2
	; r8 = v

	imul rsi, rsi, 4
	imul rcx, rcx, 4

	;r8 va fi contorul v1, v2
	;r9 va fi contorul v
	xor rax, rax
	xor r9, r9
while:
	cmp rax, rsi
	je end_while
	cmp rax, rcx
	je end_while

	; mutam el i din v1 in v
	xor rbx, rbx
	mov ebx, [rdi + rax]
	mov [r8 + r9], ebx
	; incrementam indecele lui v
	add r9, 4

	; mutam el i din v2 in v
	xor rbx, rbx
	mov ebx, [rdx + rax]
	mov [r8 + r9], ebx
	add rax, 4
	add r9, 4
	jmp while

end_while:

	;verificam daca au ramas elemente in v1
finish_first_array:
	cmp rax, rsi
	jge finish_second_array
	
	xor rbx, rbx
	mov ebx, [rdi + rax]
	mov [r8 + r9], ebx
	add r9, 4
	add rax, 4
	jmp finish_first_array

	;verificam daca au ramas elemente in v2
finish_second_array:
	cmp rax, rcx
	jge end

	xor rbx, rbx
	mov ebx, [rdx + rax]
	mov [r8 + r9], ebx
	add r9, 4
	add rax, 4
	jmp finish_second_array
end:

	leave
	ret
