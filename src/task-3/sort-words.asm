global get_words
global compare_func
global sort
global compare

section .data
    del dd " .," , 0
    null dd 0
    word_count dd 0
    compared dd 0


section .text
    extern qsort
    extern strtok
    extern printf
    extern strlen
    extern strcmp

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    ; salvam registrii pe stiva
    pusha

    ; edi = s
    mov edi, [ebp + 8]
    ; esi = words
    mov esi, [ebp + 12]
    ; eax = number_of_words
    mov eax, [ebp + 16]

    ; contorul pentru cuvinte
    mov dword [word_count], 0

    ; vom folosi strtok pentru a separa cuvintele
    push dword del
    push edi
    call strtok
    add esp, 8

    cmp eax, 0
    je end

add_word:
    ;adaugam cuvantul in words
    mov dword ecx, [word_count]
    mov dword[esi + ecx], eax

    ; incrementam contorul pentru cuvinte
    add dword [word_count], 4

loop:
    ; apelam strtok(NULL, del)
    push dword del
    push 0
    call strtok
    add esp, 8
    
    ; comparam rez strokt cu NULL
    cmp eax, 0
    jnz add_word
end:

    popa
    leave
    ret

; compare(const void *a, const void *b)
compare:
    enter 0, 0
    pusha

    ; esi = a
    mov esi, dword [ebp + 8]
    mov esi, dword [esi]
    
    ; edi = b
    mov edi, dword [ebp + 12]
    mov edi, dword [edi]
    
    ; ebx = strlen(a)
    push esi
    call strlen
    add esp, 4
    mov ebx, eax

    ; eax = strlen(b)
    push edi
    call strlen
    add esp, 4

    ; comparam lungimile
    sub ebx, eax
    mov dword [compared], ebx
    ; daca sunt egale, comparam lexicografic
    jnz compare_end

    ; comparam lexicografic
    push edi
    push esi
    call strcmp
    add esp, 8
    mov dword [compared], eax

compare_end:
    popa
    mov eax, dword [compared]

    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:

    enter 0, 0
    pusha

    ; edi = words
    mov edi, [ebp + 8]
    ; eax = number_of_words
    mov eax, [ebp + 12]
    ; ebx = size
    mov ebx, [ebp + 16]
    
    ; sortam folosind qsort si functia compare
    push compare
    push ebx
    push eax
    push edi
    call qsort
    add esp, 16

    popa
    leave
    ret
