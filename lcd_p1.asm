
_main:

;lcd_p1.c,3 :: 		void main() {
;lcd_p1.c,4 :: 		LCD_P1_Init();
	CALL       _LCD_P1_Init+0
;lcd_p1.c,5 :: 		Lcd_Out(1, 1, "PRUEBA LCD");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_lcd_p1+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr1_lcd_p1+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;lcd_p1.c,6 :: 		while(1);
L_main0:
	GOTO       L_main0
;lcd_p1.c,7 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
