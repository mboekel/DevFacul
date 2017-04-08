
_main:

;Lab1.c,1 :: 		void main()
;Lab1.c,3 :: 		TRISB.RB0 = 1;
	BSF         TRISB+0, 0 
;Lab1.c,4 :: 		TRISD.RD0 = 0;
	BCF         TRISD+0, 0 
;Lab1.c,6 :: 		while(1)
L_main0:
;Lab1.c,8 :: 		if (PORTB.RB0==0)
	BTFSC       PORTB+0, 0 
	GOTO        L_main2
;Lab1.c,10 :: 		PORTD.RD0 = 1;
	BSF         PORTD+0, 0 
;Lab1.c,11 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
;Lab1.c,12 :: 		PORTD.RD0 = 0;
	BCF         PORTD+0, 0 
;Lab1.c,14 :: 		}
L_main2:
;Lab1.c,15 :: 		}
	GOTO        L_main0
;Lab1.c,16 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
