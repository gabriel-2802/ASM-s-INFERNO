extern array_idx_1      ;; int array_idx_1

section .text
    global inorder_parc
    extern printf

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_parc(struct node *node, int *array);
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor in vectorul array.
;    @params:
;        node  -> nodul actual din arborele de cautare;
;        array -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!
; HINT: folositi variabila importata array_idx_1 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test.

inorder_parc:
    enter 0, 0
    ; salvam registrii
    pusha

    ; edi = node
    mov edi, [ebp + 8]
    ; esi = array
    mov esi, [ebp + 12]
    cmp edi, 0
    je end

    ; visitam nodul stang
    mov eax, [edi + 4]
    push esi
    push eax
    call inorder_parc
    add esp, 8

    ; salvam valoarea nodului in vector
    mov eax, [array_idx_1]
    mov ebx, [edi]
    ; inmultim cu 4 pentru ca vectorul este de int-uri
    mov [esi + eax * 4], ebx
    inc dword [array_idx_1]

    ; vizitam nodul drept
    mov eax, [edi + 8]
    push esi
    push eax
    call inorder_parc
    add esp, 8

end:
    ; restauram registrii
    popa

    leave
    ret