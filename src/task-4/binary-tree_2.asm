extern array_idx_2      ;; int array_idx_2

section .text
    global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

; HINT: folositi variabila importata array_idx_2 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test al functiei inorder_intruders.      

inorder_intruders:
    enter 0, 0
    pusha

    ; edi = node
    mov edi, [ebp + 8]
    ; esi = parent
    mov esi, [ebp+ 12 ]
    ; ebx = array
    mov ebx, [ebp+ 16 ]

    ; daca node == NULL, atunci return
    cmp edi, 0
    je end

    ; apelam recursiv inorder_intruders pentru fiul stang
    ; eax = node->left
    mov eax, [edi + 4]
    push ebx
    push edi
    push eax
    call inorder_intruders
    add esp, 12

    ; daca parent == NULL, atunci continuam cu resucrsivitatea
    cmp esi, 0
    je continue

    ; daca nu e frunza continuam
    mov eax, [edi + 4]
    cmp eax, 0
    jne continue
    mov eax, [edi + 8]
    cmp eax, 0
    jne continue

    ; daca am ajuns aici, nodul e frunza
    ; eax = parent->left
    mov eax, [esi + 4]
    cmp eax, edi
    jne right_son

    ; daca am ajuns aici, copilul este stang, deci
    ; comparam valorea parintele cu cea a fiului
    mov eax, [esi]
    mov edx, [edi]
    cmp eax, edx
    jg continue

    ; daca am ajuns aici, avem un intruder
    mov eax, [array_idx_2]
    mov ecx, [edi]
    mov [ebx + eax * 4], ecx
    inc dword [array_idx_2]
    jmp continue

right_son:
    ; daca ajung aici, copilul este drept, deci
    ; comparam valorea parintele cu cea a fiului
    mov eax, [esi]
    mov edx, [edi]
    cmp eax, edx
    jl continue

    ; daca am ajuns aici, avem un intruder
    mov eax, [array_idx_2]
    mov ecx, [edi]
    mov [ebx + eax * 4], ecx
    inc dword [array_idx_2]

continue:
    ; copil drept
    ; eax = parent->right
    mov eax, [edi + 8]
    push ebx
    push edi
    push eax
    call inorder_intruders
    add esp, 12

end:
    popa
    leave
    ret
