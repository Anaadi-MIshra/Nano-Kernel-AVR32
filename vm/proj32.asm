; ******************************************************
; BASIC .ASM template file for AVR
; ******************************************************

.include "C:\VMLAB\include\m32def.inc"


.org 0x00
jmp main

.org 0x14
jmp  SWITCH_TASK




 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
.org 0x0100
 TASK_1_INIT:

in Yh, sph                 ; change it after including 3rd task to zh and zl      3->1    z->x
in Yl, spl

out sph, XH
out spl, XL


pop r16
out sreg, r1
pop r22
pop r21
pop r20
pop r19
pop r18
pop r17
pop r16
ret

 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
.org 0x0200

TASK_2_INIT:

in Xh, sph                 ; change it after including 3rd task to zh and zl      3->1    z->x
in Xl, spl

out sph, YH
out spl, YL


pop r16
out sreg, r1
pop r22
pop r21
pop r20
pop r19
pop r18
pop r17
pop r16
ret

 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




main:
ldi r20, high(RAMEND)
out sph, r20
ldi r20, low(RAMEND)
out spl, r20

ldi r23, 0x00     ; load with task 2 init
ldi r24, 0x00


ldi Xh, 0x08 ; stack pointer task 1 last of data memory
ldi Xl, 0x5f

ldi Yh, 0x80   ;stack pointer task 2
ldi Yl, 0x47

ldi Zh, 0x08   ;stack pointer task 3
ldi Zl, 0x2f


;delay code

ldi r20, (1<<OCIE0)
out TIMSK, r20
sei
ldi r20, 125
out OCR0, r20
ldi r20, 0x0b
out TCCR0, r20
loop: rjmp loop



SWITCH_TASK:


push r20                    ;pushing r20 to save the context
ldi r20, 125
;out TCCR0, r20             ;restoring r20
pop r20


push r16                                                ;push required registers into current stack and redirect to next task
push r17
push r18
push r19
push r20
push r21
push r22
in r16, sreg     ; sreg cant be puch directly so saving sreg value temporarily
push r16
push r23          ; load r23 and r24 in every task with next task initializer function                  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
push r24


reti


 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


TASK_1:    ; task 1 is just wasting cpu time


ldi r24, 0x02                   ; load the next task 1 initializer
ldi r23, 0x00

nop
nop
nop
nop
nop
nop
nop
nop
jmp TASK_1
 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



TASK_2:                   ;recieving from uart and storing to a sram loacation




;uart initlization
ldi r16, 0x33
out UBRRL, r16

ldi r16, (1<<RXEN)
out UCSRB, r16
ldi r16, (1<<UCSZ1) |(1<<UCSZ0) | (1<<URSEL)
out UCSRC, R16
                  ;only recieve from uart
ldi r16, 0xff
out ddrc, r16
ldi r24, 0x01                   ; load the next task 1 initializer
ldi r23, 0x00


recieving:
 sbis ucsra, rxc
 rjmp recieving
 	SBI UCSRA, RXC          ;polling rxc flag for received data
		IN R16, UDR
		RET

mov Yh, r22
mov Yl,  r21

 in r17, udr

 st -Y,r17

; mov Yh, r22
; mov Yl, r21

 rjmp recieving


 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------















 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------














 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

























 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






