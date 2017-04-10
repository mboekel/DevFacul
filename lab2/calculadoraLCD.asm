
_interrupt:

;calculadoraLCD.c,33 :: 		void interrupt(void){
;calculadoraLCD.c,34 :: 		if(INTCON.RBIF)
	BTFSS       INTCON+0, 0 
	GOTO        L_interrupt0
;calculadoraLCD.c,40 :: 		for(i = 0, xx = 0x0f; (i < 4) && (xx==0x0f); i++)
	CLRF        interrupt_i_L1+0 
	MOVLW       15
	MOVWF       _xx+0 
L_interrupt1:
	MOVLW       4
	SUBWF       interrupt_i_L1+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt2
	MOVF        _xx+0, 0 
	XORLW       15
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt2
L__interrupt48:
;calculadoraLCD.c,42 :: 		PORTB.RB0 = 1; // digital output
	BSF         PORTB+0, 0 
;calculadoraLCD.c,43 :: 		PORTB.RB1 = 1;
	BSF         PORTB+0, 1 
;calculadoraLCD.c,44 :: 		PORTB.RB2 = 1;
	BSF         PORTB+0, 2 
;calculadoraLCD.c,45 :: 		PORTB.RB3 = 1;
	BSF         PORTB+0, 3 
;calculadoraLCD.c,46 :: 		if(i==0)PORTB.RB0 = 0; // digital output
	MOVF        interrupt_i_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt6
	BCF         PORTB+0, 0 
L_interrupt6:
;calculadoraLCD.c,47 :: 		if(i==1)PORTB.RB1 = 0;
	MOVF        interrupt_i_L1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt7
	BCF         PORTB+0, 1 
L_interrupt7:
;calculadoraLCD.c,48 :: 		if(i==2)PORTB.RB2 = 0;
	MOVF        interrupt_i_L1+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt8
	BCF         PORTB+0, 2 
L_interrupt8:
;calculadoraLCD.c,49 :: 		if(i==3)PORTB.RB3 = 0;
	MOVF        interrupt_i_L1+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt9
	BCF         PORTB+0, 3 
L_interrupt9:
;calculadoraLCD.c,50 :: 		xx = PORTB >> 4;
	MOVF        PORTB+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        R0, 0 
	MOVWF       _xx+0 
;calculadoraLCD.c,40 :: 		for(i = 0, xx = 0x0f; (i < 4) && (xx==0x0f); i++)
	INCF        interrupt_i_L1+0, 1 
;calculadoraLCD.c,51 :: 		}
	GOTO        L_interrupt1
L_interrupt2:
;calculadoraLCD.c,52 :: 		result = convertTecla(PORTB, &type);
	MOVF        PORTB+0, 0 
	MOVWF       FARG_convertTecla_tecla+0 
	MOVLW       0
	MOVWF       FARG_convertTecla_tecla+1 
	MOVLW       interrupt_type_L1+0
	MOVWF       FARG_convertTecla_type+0 
	MOVLW       hi_addr(interrupt_type_L1+0)
	MOVWF       FARG_convertTecla_type+1 
	CALL        _convertTecla+0, 0
	MOVF        R0, 0 
	MOVWF       interrupt_result_L1+0 
	MOVF        R1, 0 
	MOVWF       interrupt_result_L1+1 
;calculadoraLCD.c,53 :: 		PORTB.RB0 = 0; // digital output
	BCF         PORTB+0, 0 
;calculadoraLCD.c,54 :: 		PORTB.RB1 = 0;
	BCF         PORTB+0, 1 
;calculadoraLCD.c,55 :: 		PORTB.RB2 = 0;
	BCF         PORTB+0, 2 
;calculadoraLCD.c,56 :: 		PORTB.RB3 = 0;
	BCF         PORTB+0, 3 
;calculadoraLCD.c,58 :: 		if(edge == 1)
	MOVF        _edge+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt10
;calculadoraLCD.c,60 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;calculadoraLCD.c,62 :: 		if(type == NUM && operation == EMPTY)
	MOVF        interrupt_type_L1+0, 0 
	XORLW       6
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt13
	MOVF        _operation+0, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt13
L__interrupt47:
;calculadoraLCD.c,64 :: 		operando1 *= 10;
	MOVF        _operando1+0, 0 
	MOVWF       R0 
	MOVF        _operando1+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _operando1+0 
	MOVF        R1, 0 
	MOVWF       _operando1+1 
;calculadoraLCD.c,65 :: 		operando1 += result;
	MOVF        interrupt_result_L1+0, 0 
	ADDWF       R0, 1 
	MOVF        interrupt_result_L1+1, 0 
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       _operando1+0 
	MOVF        R1, 0 
	MOVWF       _operando1+1 
;calculadoraLCD.c,66 :: 		IntToStr(operando1, text);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;calculadoraLCD.c,67 :: 		}
L_interrupt13:
;calculadoraLCD.c,68 :: 		if(type != NUM && type != ON_CLEAR && type != IGUAL)
	MOVF        interrupt_type_L1+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt16
	MOVF        interrupt_type_L1+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt16
	MOVF        interrupt_type_L1+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt16
L__interrupt46:
;calculadoraLCD.c,70 :: 		operation = type;
	MOVF        interrupt_type_L1+0, 0 
	MOVWF       _operation+0 
;calculadoraLCD.c,71 :: 		}
L_interrupt16:
;calculadoraLCD.c,72 :: 		if(type == NUM && operation != EMPTY)
	MOVF        interrupt_type_L1+0, 0 
	XORLW       6
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt19
	MOVF        _operation+0, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt19
L__interrupt45:
;calculadoraLCD.c,74 :: 		operando2 *= 10;
	MOVF        _operando2+0, 0 
	MOVWF       R0 
	MOVF        _operando2+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _operando2+0 
	MOVF        R1, 0 
	MOVWF       _operando2+1 
;calculadoraLCD.c,75 :: 		operando2 += result;
	MOVF        interrupt_result_L1+0, 0 
	ADDWF       R0, 1 
	MOVF        interrupt_result_L1+1, 0 
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       _operando2+0 
	MOVF        R1, 0 
	MOVWF       _operando2+1 
;calculadoraLCD.c,76 :: 		IntToStr(operando2, text);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;calculadoraLCD.c,77 :: 		}
L_interrupt19:
;calculadoraLCD.c,78 :: 		if(type == IGUAL)
	MOVF        interrupt_type_L1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt20
;calculadoraLCD.c,80 :: 		if(operation == SOMA)
	MOVF        _operation+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt21
;calculadoraLCD.c,81 :: 		IntToStr(operando1 + operando2, text);
	MOVF        _operando2+0, 0 
	ADDWF       _operando1+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _operando2+1, 0 
	ADDWFC      _operando1+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
L_interrupt21:
;calculadoraLCD.c,83 :: 		if(operation == SUB)
	MOVF        _operation+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt22
;calculadoraLCD.c,84 :: 		IntToStr(operando1 - operando2, text);
	MOVF        _operando2+0, 0 
	SUBWF       _operando1+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _operando2+1, 0 
	SUBWFB      _operando1+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
L_interrupt22:
;calculadoraLCD.c,86 :: 		if(operation == MULT)
	MOVF        _operation+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt23
;calculadoraLCD.c,87 :: 		IntToStr(operando1 * operando2, text);
	MOVF        _operando1+0, 0 
	MOVWF       R0 
	MOVF        _operando1+1, 0 
	MOVWF       R1 
	MOVF        _operando2+0, 0 
	MOVWF       R4 
	MOVF        _operando2+1, 0 
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
L_interrupt23:
;calculadoraLCD.c,89 :: 		if(operation == DIVI)
	MOVF        _operation+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt24
;calculadoraLCD.c,90 :: 		IntToStr(operando1 / operando2, text);
	MOVF        _operando2+0, 0 
	MOVWF       R4 
	MOVF        _operando2+1, 0 
	MOVWF       R5 
	MOVF        _operando1+0, 0 
	MOVWF       R0 
	MOVF        _operando1+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
L_interrupt24:
;calculadoraLCD.c,91 :: 		}
L_interrupt20:
;calculadoraLCD.c,92 :: 		if(type == ON_CLEAR)
	MOVF        interrupt_type_L1+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt25
;calculadoraLCD.c,94 :: 		operando1 = 0;
	CLRF        _operando1+0 
	CLRF        _operando1+1 
;calculadoraLCD.c,95 :: 		operando2 = 0;
	CLRF        _operando2+0 
	CLRF        _operando2+1 
;calculadoraLCD.c,96 :: 		operation = EMPTY;
	MOVLW       7
	MOVWF       _operation+0 
;calculadoraLCD.c,97 :: 		IntToStr(0, text);
	CLRF        FARG_IntToStr_input+0 
	CLRF        FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;calculadoraLCD.c,98 :: 		}
L_interrupt25:
;calculadoraLCD.c,101 :: 		Lcd_Out(1,1,text);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _text+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;calculadoraLCD.c,102 :: 		}
	GOTO        L_interrupt26
L_interrupt10:
;calculadoraLCD.c,106 :: 		}
L_interrupt26:
;calculadoraLCD.c,108 :: 		edge = !edge;
	MOVF        _edge+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       _edge+0 
;calculadoraLCD.c,109 :: 		INTCON.RBIF = 0;
	BCF         INTCON+0, 0 
;calculadoraLCD.c,110 :: 		}
L_interrupt0:
;calculadoraLCD.c,111 :: 		}
L_end_interrupt:
L__interrupt50:
	RETFIE      1
; end of _interrupt

_main:

;calculadoraLCD.c,113 :: 		void main()
;calculadoraLCD.c,116 :: 		ADCON1 = 0x6;
	MOVLW       6
	MOVWF       ADCON1+0 
;calculadoraLCD.c,119 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;calculadoraLCD.c,122 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;calculadoraLCD.c,125 :: 		TRISB.RB4 = 1; // digital input
	BSF         TRISB+0, 4 
;calculadoraLCD.c,126 :: 		TRISB.RB5 = 1; // digital input
	BSF         TRISB+0, 5 
;calculadoraLCD.c,127 :: 		TRISB.RB6 = 1; // digital input
	BSF         TRISB+0, 6 
;calculadoraLCD.c,128 :: 		TRISB.RB7 = 1; // digital input
	BSF         TRISB+0, 7 
;calculadoraLCD.c,130 :: 		TRISB.RB0 = 0; // digital output
	BCF         TRISB+0, 0 
;calculadoraLCD.c,131 :: 		TRISB.RB1 = 0;
	BCF         TRISB+0, 1 
;calculadoraLCD.c,132 :: 		TRISB.RB2 = 0;
	BCF         TRISB+0, 2 
;calculadoraLCD.c,133 :: 		TRISB.RB3 = 0;
	BCF         TRISB+0, 3 
;calculadoraLCD.c,135 :: 		PORTB.RB0 = 0; // digital output
	BCF         PORTB+0, 0 
;calculadoraLCD.c,136 :: 		PORTB.RB1 = 0;
	BCF         PORTB+0, 1 
;calculadoraLCD.c,137 :: 		PORTB.RB2 = 0;
	BCF         PORTB+0, 2 
;calculadoraLCD.c,138 :: 		PORTB.RB3 = 0;
	BCF         PORTB+0, 3 
;calculadoraLCD.c,140 :: 		INTCON.RBIE = 1;
	BSF         INTCON+0, 3 
;calculadoraLCD.c,141 :: 		INTCON.RBIF = 0;
	BCF         INTCON+0, 0 
;calculadoraLCD.c,142 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_convertTecla:

;calculadoraLCD.c,144 :: 		int convertTecla (int tecla, KeyType* type)
;calculadoraLCD.c,146 :: 		int result = -1;
	MOVLW       255
	MOVWF       convertTecla_result_L0+0 
	MOVLW       255
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,147 :: 		switch(tecla)
	GOTO        L_convertTecla27
;calculadoraLCD.c,149 :: 		case 231:
L_convertTecla29:
;calculadoraLCD.c,150 :: 		*type = ON_CLEAR;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       5
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,151 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,153 :: 		case 215:
L_convertTecla30:
;calculadoraLCD.c,154 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,155 :: 		result = 0;
	CLRF        convertTecla_result_L0+0 
	CLRF        convertTecla_result_L0+1 
;calculadoraLCD.c,156 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,158 :: 		case 183:
L_convertTecla31:
;calculadoraLCD.c,159 :: 		*type = IGUAL;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	CLRF        POSTINC1+0 
;calculadoraLCD.c,160 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,162 :: 		case 119:
L_convertTecla32:
;calculadoraLCD.c,163 :: 		*type = SOMA;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       1
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,164 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,166 :: 		case 235:
L_convertTecla33:
;calculadoraLCD.c,167 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,168 :: 		result = 1;
	MOVLW       1
	MOVWF       convertTecla_result_L0+0 
	MOVLW       0
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,169 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,171 :: 		case 219:
L_convertTecla34:
;calculadoraLCD.c,172 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,173 :: 		result = 2;
	MOVLW       2
	MOVWF       convertTecla_result_L0+0 
	MOVLW       0
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,174 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,176 :: 		case 187:
L_convertTecla35:
;calculadoraLCD.c,177 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,178 :: 		result = 3;
	MOVLW       3
	MOVWF       convertTecla_result_L0+0 
	MOVLW       0
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,179 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,181 :: 		case 123:
L_convertTecla36:
;calculadoraLCD.c,182 :: 		*type = SUB;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       2
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,183 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,185 :: 		case 237:
L_convertTecla37:
;calculadoraLCD.c,186 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,187 :: 		result = 4;
	MOVLW       4
	MOVWF       convertTecla_result_L0+0 
	MOVLW       0
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,188 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,190 :: 		case 221:
L_convertTecla38:
;calculadoraLCD.c,191 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,192 :: 		result = 5;
	MOVLW       5
	MOVWF       convertTecla_result_L0+0 
	MOVLW       0
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,193 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,195 :: 		case 189:
L_convertTecla39:
;calculadoraLCD.c,196 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,197 :: 		result = 6;
	MOVLW       6
	MOVWF       convertTecla_result_L0+0 
	MOVLW       0
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,198 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,200 :: 		case 125:
L_convertTecla40:
;calculadoraLCD.c,201 :: 		*type = MULT;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       3
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,202 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,204 :: 		case 238:
L_convertTecla41:
;calculadoraLCD.c,205 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,206 :: 		result = 7;
	MOVLW       7
	MOVWF       convertTecla_result_L0+0 
	MOVLW       0
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,207 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,209 :: 		case 222:
L_convertTecla42:
;calculadoraLCD.c,210 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,211 :: 		result = 8;
	MOVLW       8
	MOVWF       convertTecla_result_L0+0 
	MOVLW       0
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,212 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,214 :: 		case 190:
L_convertTecla43:
;calculadoraLCD.c,215 :: 		*type = NUM;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       6
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,216 :: 		result = 9;
	MOVLW       9
	MOVWF       convertTecla_result_L0+0 
	MOVLW       0
	MOVWF       convertTecla_result_L0+1 
;calculadoraLCD.c,217 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,219 :: 		case 126:
L_convertTecla44:
;calculadoraLCD.c,220 :: 		*type = DIVI;
	MOVFF       FARG_convertTecla_type+0, FSR1
	MOVFF       FARG_convertTecla_type+1, FSR1H
	MOVLW       4
	MOVWF       POSTINC1+0 
;calculadoraLCD.c,221 :: 		break;
	GOTO        L_convertTecla28
;calculadoraLCD.c,222 :: 		}
L_convertTecla27:
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla53
	MOVLW       231
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla53:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla29
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla54
	MOVLW       215
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla54:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla30
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla55
	MOVLW       183
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla55:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla31
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla56
	MOVLW       119
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla56:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla32
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla57
	MOVLW       235
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla57:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla33
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla58
	MOVLW       219
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla58:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla34
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla59
	MOVLW       187
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla59:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla35
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla60
	MOVLW       123
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla60:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla36
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla61
	MOVLW       237
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla61:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla37
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla62
	MOVLW       221
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla62:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla38
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla63
	MOVLW       189
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla63:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla39
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla64
	MOVLW       125
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla64:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla40
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla65
	MOVLW       238
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla65:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla41
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla66
	MOVLW       222
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla66:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla42
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla67
	MOVLW       190
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla67:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla43
	MOVLW       0
	XORWF       FARG_convertTecla_tecla+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__convertTecla68
	MOVLW       126
	XORWF       FARG_convertTecla_tecla+0, 0 
L__convertTecla68:
	BTFSC       STATUS+0, 2 
	GOTO        L_convertTecla44
L_convertTecla28:
;calculadoraLCD.c,224 :: 		return result;
	MOVF        convertTecla_result_L0+0, 0 
	MOVWF       R0 
	MOVF        convertTecla_result_L0+1, 0 
	MOVWF       R1 
;calculadoraLCD.c,225 :: 		}
L_end_convertTecla:
	RETURN      0
; end of _convertTecla
