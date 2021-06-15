; ----------------------------------------------------
;
; arguments passed
; ----------------
; rdi   -   bitmap pointer (top left pixel)
; rsi   -   width including pixel size (32 bit)
; rdx   -   height
; rcx   -   x click position
; r8    -   y click position
; xmm0  -   initial velocity (float)
;
;
; local values
; ------------
; r10d  -   drawing line color
; r11   -   cur_x counter
; r12   -   calculated y coordinate
; xmm?  -   described next to use case (often temporary)
;
; ---------------------------------------------------

section .text
global  drawball

drawball:

; ------
; prolog
; ------
        push    rbp
        mov     rbp, rsp

        push    rbx                
	push    r12
	push    r13
	push    r14
	push    r15


        ; initialise values
        ; ----------------
        mov     r11, 0                  ;r11  - cur_x counter
        mov     r10d, 0x0000ffff        ;r10d - drawing line color in format RRGGBBAA


        ; revert y coordinate
        ; -------------------
        mov     r9, rdx
        sub     r9, r8
        mov     r8, r9


        ; move bitmap beginning to bottom-left pixel
        ; ------------------------------------------
        mov     rax, rdx
        mul     rsi                     ;rax = rsi * rdx (pitch * height)
        mov     r15, rdi                ;save original rdi
        sub     rdi, rax
        

 draw:  ; draw shot line on passed bitmap
        ; -------------------------------
        

        ; count y(cur_x) = tanß*cur_x - (cur_x^2*g)/(2*v_0^2*cos^2ß)
        ; ---------------------------------------------------------
        ; r11 - current x index
        ; rsi - width
        ; rcx - x click position
        ; r8  - y click position
        
        ; count tanß*cur_x
        cvtsi2ss        xmm1, r11               ;xmm1 - current x value
        cvtsi2ss        xmm3, rcx               ;xmm3 - mouse x
        cvtsi2ss        xmm4, r8                ;xmm4 - mouse y
        divss           xmm4, xmm3              ;xmm4 - y/x = tanß
        mulss           xmm4, xmm1              ; -> xmm4 - tanß*cur_x

        ;count cos^2ß
        cvtsi2ss        xmm2, rcx               ;xmm2 - mouse x
        cvtsi2ss        xmm3, r8                ;xmm2 - mouse y
        mulss           xmm2, xmm2              ;xmm2 - x^2
        mulss           xmm3, xmm3              ;xmm3 - y^2
        addss           xmm3, xmm2              ;xmm3 - x^2 + y^2
        sqrtss          xmm3, xmm3              ;xmm3 - distance between x and y (c)
        cvtsi2ss        xmm2, rcx               ;xmm2 - mouse x
        divss           xmm2, xmm3              ;xmm2 - cosß
        mulss           xmm2, xmm2              ; -> xmm2 - cos^2ß

        ;count 2*v_0^2
        movss           xmm5, xmm0              ;copy of xmm0
        mulss           xmm5, xmm5              ;xmm5 - v_0^2
        addss           xmm5, xmm5              ;-> xmm5 - 2*v_0^2

        ;count cur_x^2*g, g=8
        mov             r12, 0x1000
        cvtsi2ss        xmm3, r12               ;xmm3 - g
        cvtsi2ss        xmm1, r11               ;xmm1 - cur_x
        mulss           xmm1, xmm1              ;xmm1 - cur_x^2
        mulss           xmm1, xmm3              ; -> xmm1 - cur_x^2 * g --?

        ;count all (final)
        mulss           xmm5, xmm2              ;xmm5 - (2*v_o^2*cos^2ß)
        divss           xmm1, xmm5              ;xmm1 - (cur_x^2*g)/(2*v_o^2*cos^2ß)
        subss           xmm4, xmm1              ; -> xmm4 - y(cur_x)

        ;convert fp value to integer
        cvttss2si       r12, xmm4               ; -> r12  - y coordinate corresponding to cur_x


        ; prevent painting behind the bottom edge
        ; ---------------------------------------
        cmp             r12, 0
        jle             skip_painting


        ; find draw index based on y calculated
        ; -------------------------------------
        ; r12 - current y index
        ; r11 - current x index
        ; rdi - current x pointer
        ; rsi - width

        mov     r13, rdi        ;r13 - copy of rdi
        mov     rax, rsi        ;rax - width
        mul     r12             ;rax - padding of size of width*y
        add     r13, rax        ; -> r13 - place to paint pixel


        ; prevent painting behind the upper edge
        ;---------------------------------------
        cmp     r13, r15
        jge     skip_painting


        ; paint pixel found
        ; -----------------
        mov     [r13], r10d     ;color


skip_painting: 

        ; increment cur_x
        ; ---------------
        add     rdi, 4
        inc     r11

        ; prevent painting behind the right edge
        ; --------------------------------------
        mov     r14, rsi
        shr     r14, 2          ;divide by 4
        sub     r14, r11
        cmp     r14, 0
        jge     draw


        ; procedure end
        ; -------------


; epilog
; ------
        pop r15
	pop r14
	pop r13
	pop r12
	pop rbx

        pop     rbp
        ret