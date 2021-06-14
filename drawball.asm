        section .data
    
        section .text
        global  main
        extern drawball
drawball:
;prolog
        push    rbp             ;zapamiętanie wskaźnika ramki procedury wywołującej
        mov     rbp, rsp        ;ustanowienie własnego wskaźnika ramki

;ciało procedury
        mov     rax, 0x1        ;system call for write
        mov     rdx, rdi        ;string size
        mov     rdi, 0x1        ;file descriptor (1 - std out)
        syscall

; epilog
        pop     rbp
        ret