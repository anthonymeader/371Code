;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
main:
;---------
;Demo 1 Immediate 16 Bit Initilize
;---------

			mov		#4444h, R4
			mov		#5555h, R5
			mov		#6666h, R6
;------------
;Immediate Clear 16 Bit
;------------
			mov		#0h, R4
			mov		#0h, R5
			mov		#0h, R6
;------------
;Immediate 8 Bit Intilize
;------------
			mov.b	#77h, R7
			mov.b	#88h, R8
			mov.b	#99h, R9
;---------------
;Demo2 Register Copy 8 Bit
;---------------
			mov.b	R7, R10
			mov.b	R8,	R11
			mov.b	R9, R12
;---------------
;Register Copy 16 Bit
;---------------
			mov		PC, R13
			mov		SP, R14


;-----------------
;Demo3 Absoule Mode Addressing to Copy Info
;-----------------
			mov		&2000h, &2020h
			mov		&2002h, &2022h
			mov		&2004h, &2024h
			mov		&2006h, &2026h
			mov		&2008h,	&2028h
			mov		&200ah, &202ah
			mov		&200ch, &202ch
			mov		&200eh, &202eh
			mov		&2010h, &2030h
			mov		&2012h,	&2032h
			mov		&2014h, &2034h
			mov		&2016h, &2036h
			mov		&2018h, &2038h
			mov		&201ah,	&203ah
			mov		&201ch, &203ch
			mov		&201eh, &203eh

			mov.b	&2040h, &204bh
			mov.b 	&2043h,	&204ah
			mov.b	&2042h, &204dh
			mov.b	&2044h,	&204ch
			mov.b	&2046h, &204fh


			jmp		main

;--------------
;Reserve Locations in Data Memory
;--------------
			.data
			.retain

Const1:		.short	0000h, 1111h, 2222h, 3333h, 4444h, 5555h, 6666h, 7777h, 8888h, 9999h, 0AAAAh, 0BBBBh, 0CCCCh, 0DDDDh, 0EEEEh, 0FFFFh
Var1:		.space	32
Const2:		.byte	23h, 01h, 67h, 45h, 0ABh, 89h, 0EFh, 0CDh
Var3:       .space	8



                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
