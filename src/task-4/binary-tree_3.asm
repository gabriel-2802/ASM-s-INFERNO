section .text
    global inorder_fixing

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

; ATENTIE: DOAR in frunze pot aparea valori gresite! 
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!



    ; vom folosi baza functiei get_intruders
inorder_fixing:
    enter 0, 0
    pusha
    ; edi = node
    mov edi, [ebp + 8]
    ; esi = parent
    mov esi, [ebp+ 12 ]

    ; daca node == NULL, atunci return
    cmp edi, 0
    je end

    ; apelam recursiv inorder_fixing pentru nodul din stanga
    ; eax = node->left
    mov eax, [edi + 4]
    push edi
    push eax
    call inorder_fixing
    add esp, 8

    ; daca parent == NULL, atunci continuam cu node->right
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

    ; daca ajung aici, fiul este stang
    mov eax, [esi]
    mov edx, [edi]
    cmp eax, edx
    jg continue

    ; daca ajung aici, fiul este stang si nodul nu
    ; respecta structura BST
    mov eax, [esi]
    dec eax
    mov dword [edi], eax
    jmp continue

right_son:
    ; daca ajung aici, copilul este drept
    mov eax, [esi]
    mov edx, [edi]
    cmp eax, edx
    jl continue

    ; daca ajung aici, fiul este drept si nodul nu
    ; respecta structura BST
    mov eax, [esi]
    inc eax
    mov dword [edi], eax

continue:
    ; apealm recsuriv functia pentru fiu; drept
    mov eax, [edi + 8]
    push edi
    push eax
    call inorder_fixing
    add esp, 8

end:
    popa
    leave
    ret