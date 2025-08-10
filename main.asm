
_LCD_P1_Init:

;lcd_p1.h,20 :: 		void LCD_P1_Init() {
;lcd_p1.h,21 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;lcd_p1.h,22 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd_p1.h,23 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd_p1.h,24 :: 		}
L_end_LCD_P1_Init:
	RETURN
; end of _LCD_P1_Init

_leer_teclado:

;keypad_p1.h,17 :: 		char leer_teclado() {
;keypad_p1.h,20 :: 		FILAS_TRIS = 0b11110000; // RB0-RB3 salidas (filas), RB4-RB7 entradas (columnas)
	MOVLW      240
	MOVWF      TRISB+0
;keypad_p1.h,21 :: 		FILAS_LAT = 0x0F;        // Filas en alto (RB0-RB3), columnas sin modificar
	MOVLW      15
	MOVWF      LATB+0
;keypad_p1.h,23 :: 		for (fila = 0; fila < 4; fila++) {
	CLRF       R3+0
L_leer_teclado0:
	MOVLW      4
	SUBWF      R3+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_leer_teclado1
;keypad_p1.h,24 :: 		FILAS_LAT = 0x0F;            // Todas filas en alto
	MOVLW      15
	MOVWF      LATB+0
;keypad_p1.h,25 :: 		FILAS_LAT &= ~(1 << fila);   // Activa fila (baja)
	MOVF       R3+0, 0
	MOVWF      R1
	MOVLW      1
	MOVWF      R0
	MOVF       R1, 0
L__leer_teclado63:
	BTFSC      STATUS+0, 2
	GOTO       L__leer_teclado64
	LSLF       R0, 1
	ADDLW      255
	GOTO       L__leer_teclado63
L__leer_teclado64:
	COMF       R0, 1
	MOVF       R0, 0
	ANDWF      LATB+0, 1
;keypad_p1.h,26 :: 		Delay_us(20);
	NOP
	NOP
	NOP
	NOP
	NOP
;keypad_p1.h,28 :: 		for (col = 0; col < 4; col++) {
	CLRF       R4+0
L_leer_teclado3:
	MOVLW      4
	SUBWF      R4+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_leer_teclado4
;keypad_p1.h,29 :: 		if (!(FILAS_PORT & (1 << (col + 4)))) { // Si columna baja (tecla presionada)
	MOVLW      4
	ADDWF      R4+0, 0
	MOVWF      R0
	CLRF       R1
	MOVLW      0
	ADDWFC     R1, 1
	MOVF       R0, 0
	MOVWF      R2
	MOVLW      1
	MOVWF      R0
	MOVLW      0
	MOVWF      R1
	MOVF       R2, 0
L__leer_teclado65:
	BTFSC      STATUS+0, 2
	GOTO       L__leer_teclado66
	LSLF       R0, 1
	RLF        R1, 1
	ADDLW      255
	GOTO       L__leer_teclado65
L__leer_teclado66:
	MOVF       PORTB+0, 0
	ANDWF      R0, 1
	MOVLW      0
	ANDWF      R1, 1
	MOVF       R0, 0
	IORWF       R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_leer_teclado6
;keypad_p1.h,30 :: 		while (!(FILAS_PORT & (1 << (col + 4)))); // Espera que se suelte (antirrebote)
L_leer_teclado7:
	MOVLW      4
	ADDWF      R4+0, 0
	MOVWF      R0
	CLRF       R1
	MOVLW      0
	ADDWFC     R1, 1
	MOVF       R0, 0
	MOVWF      R2
	MOVLW      1
	MOVWF      R0
	MOVLW      0
	MOVWF      R1
	MOVF       R2, 0
L__leer_teclado67:
	BTFSC      STATUS+0, 2
	GOTO       L__leer_teclado68
	LSLF       R0, 1
	RLF        R1, 1
	ADDLW      255
	GOTO       L__leer_teclado67
L__leer_teclado68:
	MOVF       PORTB+0, 0
	ANDWF      R0, 1
	MOVLW      0
	ANDWF      R1, 1
	MOVF       R0, 0
	IORWF       R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_leer_teclado8
	GOTO       L_leer_teclado7
L_leer_teclado8:
;keypad_p1.h,31 :: 		return tecla_map[fila][col];
	MOVF       R3+0, 0
	MOVWF      R0
	CLRF       R1
	LSLF       R0, 1
	RLF        R1, 1
	LSLF       R0, 1
	RLF        R1, 1
	MOVLW      _tecla_map+0
	ADDWF      R0, 1
	MOVLW      hi_addr(_tecla_map+0)
	ADDWFC     R1, 1
	MOVF       R4+0, 0
	ADDWF      R0, 0
	MOVWF      FSR0L
	MOVLW      0
	ADDWFC     R1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      R0
	GOTO       L_end_leer_teclado
;keypad_p1.h,32 :: 		}
L_leer_teclado6:
;keypad_p1.h,28 :: 		for (col = 0; col < 4; col++) {
	INCF       R4+0, 1
;keypad_p1.h,33 :: 		}
	GOTO       L_leer_teclado3
L_leer_teclado4:
;keypad_p1.h,23 :: 		for (fila = 0; fila < 4; fila++) {
	INCF       R3+0, 1
;keypad_p1.h,34 :: 		}
	GOTO       L_leer_teclado0
L_leer_teclado1:
;keypad_p1.h,35 :: 		return 0; // Ninguna tecla presionada
	CLRF       R0
;keypad_p1.h,36 :: 		}
L_end_leer_teclado:
	RETURN
; end of _leer_teclado

_Pulsadores_P1_Init:

;pulsador_p1.h,10 :: 		void Pulsadores_P1_Init() {
;pulsador_p1.h,11 :: 		TRISC.F1 = 1; // RC1 como entrada
	BSF        TRISC+0, 1
;pulsador_p1.h,12 :: 		TRISC.F2 = 1; // RC2 como entrada
	BSF        TRISC+0, 2
;pulsador_p1.h,14 :: 		WPUC.F1 = 1;
	BSF        WPUC+0, 1
;pulsador_p1.h,15 :: 		WPUC.F2 = 1;
	BSF        WPUC+0, 2
;pulsador_p1.h,17 :: 		Delay_ms(10); // Estabilizar lectura inicial
	MOVLW      4
	MOVWF      R12
	MOVLW      61
	MOVWF      R13
L_Pulsadores_P1_Init9:
	DECFSZ     R13, 1
	GOTO       L_Pulsadores_P1_Init9
	DECFSZ     R12, 1
	GOTO       L_Pulsadores_P1_Init9
	NOP
	NOP
;pulsador_p1.h,20 :: 		prev_modo  = PULSADOR_MODO;
	MOVLW      0
	BTFSC      PORTC+0, 1
	MOVLW      1
	MOVWF      main_prev_modo+0
;pulsador_p1.h,21 :: 		prev_start = PULSADOR_START;
	MOVLW      0
	BTFSC      PORTC+0, 2
	MOVLW      1
	MOVWF      main_prev_start+0
;pulsador_p1.h,22 :: 		}
L_end_Pulsadores_P1_Init:
	RETURN
; end of _Pulsadores_P1_Init

_Pulsador_Modo_Presionado:

;pulsador_p1.h,24 :: 		char Pulsador_Modo_Presionado() {
;pulsador_p1.h,25 :: 		char pressed = 0;
	CLRF       Pulsador_Modo_Presionado_pressed_L0+0
;pulsador_p1.h,26 :: 		if ((prev_modo == 1) && (PULSADOR_MODO == 0)) {
	MOVF       main_prev_modo+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Pulsador_Modo_Presionado12
	BTFSC      PORTC+0, 1
	GOTO       L_Pulsador_Modo_Presionado12
L__Pulsador_Modo_Presionado59:
;pulsador_p1.h,27 :: 		Delay_ms(20); // debounce
	MOVLW      7
	MOVWF      R12
	MOVLW      125
	MOVWF      R13
L_Pulsador_Modo_Presionado13:
	DECFSZ     R13, 1
	GOTO       L_Pulsador_Modo_Presionado13
	DECFSZ     R12, 1
	GOTO       L_Pulsador_Modo_Presionado13
;pulsador_p1.h,28 :: 		if (PULSADOR_MODO == 0) pressed = 1;
	BTFSC      PORTC+0, 1
	GOTO       L_Pulsador_Modo_Presionado14
	MOVLW      1
	MOVWF      Pulsador_Modo_Presionado_pressed_L0+0
L_Pulsador_Modo_Presionado14:
;pulsador_p1.h,29 :: 		}
L_Pulsador_Modo_Presionado12:
;pulsador_p1.h,30 :: 		prev_modo = PULSADOR_MODO;
	MOVLW      0
	BTFSC      PORTC+0, 1
	MOVLW      1
	MOVWF      main_prev_modo+0
;pulsador_p1.h,31 :: 		return pressed;
	MOVF       Pulsador_Modo_Presionado_pressed_L0+0, 0
	MOVWF      R0
;pulsador_p1.h,32 :: 		}
L_end_Pulsador_Modo_Presionado:
	RETURN
; end of _Pulsador_Modo_Presionado

_Pulsador_Start_Presionado:

;pulsador_p1.h,34 :: 		char Pulsador_Start_Presionado() {
;pulsador_p1.h,35 :: 		char pressed = 0;
	CLRF       Pulsador_Start_Presionado_pressed_L0+0
;pulsador_p1.h,36 :: 		if ((prev_start == 1) && (PULSADOR_START == 0)) {
	MOVF       main_prev_start+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Pulsador_Start_Presionado17
	BTFSC      PORTC+0, 2
	GOTO       L_Pulsador_Start_Presionado17
L__Pulsador_Start_Presionado60:
;pulsador_p1.h,37 :: 		Delay_ms(20); // debounce
	MOVLW      7
	MOVWF      R12
	MOVLW      125
	MOVWF      R13
L_Pulsador_Start_Presionado18:
	DECFSZ     R13, 1
	GOTO       L_Pulsador_Start_Presionado18
	DECFSZ     R12, 1
	GOTO       L_Pulsador_Start_Presionado18
;pulsador_p1.h,38 :: 		if (PULSADOR_START == 0) pressed = 1;
	BTFSC      PORTC+0, 2
	GOTO       L_Pulsador_Start_Presionado19
	MOVLW      1
	MOVWF      Pulsador_Start_Presionado_pressed_L0+0
L_Pulsador_Start_Presionado19:
;pulsador_p1.h,39 :: 		}
L_Pulsador_Start_Presionado17:
;pulsador_p1.h,40 :: 		prev_start = PULSADOR_START;
	MOVLW      0
	BTFSC      PORTC+0, 2
	MOVLW      1
	MOVWF      main_prev_start+0
;pulsador_p1.h,41 :: 		return pressed;
	MOVF       Pulsador_Start_Presionado_pressed_L0+0, 0
	MOVWF      R0
;pulsador_p1.h,42 :: 		}
L_end_Pulsador_Start_Presionado:
	RETURN
; end of _Pulsador_Start_Presionado

_mostrar_modo:

;main.c,13 :: 		void mostrar_modo(unsigned char modo) {
;main.c,14 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;main.c,15 :: 		switch(modo) {
	GOTO       L_mostrar_modo20
;main.c,16 :: 		case MODO_CRONOMETRO:
L_mostrar_modo22:
;main.c,17 :: 		Lcd_Out(1,1,"Modo: Cronometro");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr1_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,18 :: 		break;
	GOTO       L_mostrar_modo21
;main.c,19 :: 		case MODO_TEMPORIZADOR:
L_mostrar_modo23:
;main.c,20 :: 		Lcd_Out(1,1,"Modo: Temporizador");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr2_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,21 :: 		break;
	GOTO       L_mostrar_modo21
;main.c,22 :: 		case MODO_FRECUENCIMETRO:
L_mostrar_modo24:
;main.c,23 :: 		Lcd_Out(1,1,"Modo: Frec.Metro");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr3_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,24 :: 		break;
	GOTO       L_mostrar_modo21
;main.c,25 :: 		}
L_mostrar_modo20:
	MOVF       FARG_mostrar_modo_modo+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_mostrar_modo22
	MOVF       FARG_mostrar_modo_modo+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_mostrar_modo23
	MOVF       FARG_mostrar_modo_modo+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_mostrar_modo24
L_mostrar_modo21:
;main.c,26 :: 		if(conteo_activo)
	BTFSS      _conteo_activo+0, BitPos(_conteo_activo+0)
	GOTO       L_mostrar_modo25
;main.c,27 :: 		Lcd_Out(2,1,"En ejecucion...");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr4_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
	GOTO       L_mostrar_modo26
L_mostrar_modo25:
;main.c,29 :: 		Lcd_Out(2,1,"RC2:Start/Stop");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr5_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
L_mostrar_modo26:
;main.c,30 :: 		}
L_end_mostrar_modo:
	RETURN
; end of _mostrar_modo

_main:

;main.c,32 :: 		void main() {
;main.c,36 :: 		ANSELB = 0x00; // Keypad digital
	CLRF       ANSELB+0
;main.c,37 :: 		ANSELD = 0x00; // LCD digital
	CLRF       ANSELD+0
;main.c,38 :: 		ANSELC = 0x00; // Pulsadores digitales
	CLRF       ANSELC+0
;main.c,41 :: 		TRISC.F0 = 0; // RC0 salida
	BCF        TRISC+0, 0
;main.c,42 :: 		LATC.F0 = 0;  // Activo bajo: en pantalla de selección
	BCF        LATC+0, 0
;main.c,45 :: 		LCD_P1_Init();
	CALL       _LCD_P1_Init+0
;main.c,46 :: 		Pulsadores_P1_Init();
	CALL       _Pulsadores_P1_Init+0
;main.c,49 :: 		sistema_on = 0;
	BCF        _sistema_on+0, BitPos(_sistema_on+0)
;main.c,50 :: 		conteo_activo = 0;
	BCF        _conteo_activo+0, BitPos(_conteo_activo+0)
;main.c,51 :: 		modo_actual = MODO_CRONOMETRO;
	CLRF       _modo_actual+0
;main.c,54 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;main.c,55 :: 		Lcd_Out(1,1,"Presione O (ON)");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr6_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,56 :: 		Lcd_Out(2,1,"para iniciar");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr7_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,59 :: 		while(!sistema_on) {
L_main27:
	BTFSC      _sistema_on+0, BitPos(_sistema_on+0)
	GOTO       L_main28
;main.c,60 :: 		tecla = leer_teclado();
	CALL       _leer_teclado+0
;main.c,61 :: 		if (tecla == 'O') {
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main29
;main.c,62 :: 		Delay_ms(20);                 // debounce
	MOVLW      7
	MOVWF      R12
	MOVLW      125
	MOVWF      R13
L_main30:
	DECFSZ     R13, 1
	GOTO       L_main30
	DECFSZ     R12, 1
	GOTO       L_main30
;main.c,63 :: 		while (leer_teclado() == 'O'); // esperar liberación
L_main31:
	CALL       _leer_teclado+0
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main32
	GOTO       L_main31
L_main32:
;main.c,64 :: 		sistema_on = 1;
	BSF        _sistema_on+0, BitPos(_sistema_on+0)
;main.c,65 :: 		LATC.F0 = 1; // Activo alto: ya seleccionó una opción
	BSF        LATC+0, 0
;main.c,66 :: 		mostrar_modo(modo_actual);
	MOVF       _modo_actual+0, 0
	MOVWF      FARG_mostrar_modo_modo+0
	CALL       _mostrar_modo+0
;main.c,67 :: 		Delay_ms(300);
	MOVLW      98
	MOVWF      R12
	MOVLW      101
	MOVWF      R13
L_main33:
	DECFSZ     R13, 1
	GOTO       L_main33
	DECFSZ     R12, 1
	GOTO       L_main33
	NOP
	NOP
;main.c,68 :: 		}
L_main29:
;main.c,69 :: 		}
	GOTO       L_main27
L_main28:
;main.c,72 :: 		while(1) {
L_main34:
;main.c,74 :: 		if (Pulsador_Modo_Presionado()) {
	CALL       _Pulsador_Modo_Presionado+0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main36
;main.c,75 :: 		modo_actual++;
	INCF       _modo_actual+0, 1
;main.c,76 :: 		if (modo_actual > MODO_FRECUENCIMETRO)
	MOVF       _modo_actual+0, 0
	SUBLW      2
	BTFSC      STATUS+0, 0
	GOTO       L_main37
;main.c,77 :: 		modo_actual = MODO_CRONOMETRO;
	CLRF       _modo_actual+0
L_main37:
;main.c,78 :: 		mostrar_modo(modo_actual);
	MOVF       _modo_actual+0, 0
	MOVWF      FARG_mostrar_modo_modo+0
	CALL       _mostrar_modo+0
;main.c,79 :: 		Delay_ms(120);
	MOVLW      39
	MOVWF      R12
	MOVLW      245
	MOVWF      R13
L_main38:
	DECFSZ     R13, 1
	GOTO       L_main38
	DECFSZ     R12, 1
	GOTO       L_main38
;main.c,80 :: 		}
L_main36:
;main.c,83 :: 		if (Pulsador_Start_Presionado()) {
	CALL       _Pulsador_Start_Presionado+0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main39
;main.c,84 :: 		conteo_activo = !conteo_activo;
	MOVLW
	XORWF      _conteo_activo+0, 1
;main.c,85 :: 		mostrar_modo(modo_actual);
	MOVF       _modo_actual+0, 0
	MOVWF      FARG_mostrar_modo_modo+0
	CALL       _mostrar_modo+0
;main.c,86 :: 		Delay_ms(120);
	MOVLW      39
	MOVWF      R12
	MOVLW      245
	MOVWF      R13
L_main40:
	DECFSZ     R13, 1
	GOTO       L_main40
	DECFSZ     R12, 1
	GOTO       L_main40
;main.c,87 :: 		}
L_main39:
;main.c,90 :: 		if (conteo_activo) {
	BTFSS      _conteo_activo+0, BitPos(_conteo_activo+0)
	GOTO       L_main41
;main.c,91 :: 		switch (modo_actual) {
	GOTO       L_main42
;main.c,92 :: 		case MODO_CRONOMETRO:
L_main44:
;main.c,94 :: 		break;
	GOTO       L_main43
;main.c,95 :: 		case MODO_TEMPORIZADOR:
L_main45:
;main.c,97 :: 		break;
	GOTO       L_main43
;main.c,98 :: 		case MODO_FRECUENCIMETRO:
L_main46:
;main.c,100 :: 		break;
	GOTO       L_main43
;main.c,101 :: 		}
L_main42:
	MOVF       _modo_actual+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main44
	MOVF       _modo_actual+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main45
	MOVF       _modo_actual+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main46
L_main43:
;main.c,102 :: 		}
L_main41:
;main.c,105 :: 		tecla = leer_teclado();
	CALL       _leer_teclado+0
;main.c,106 :: 		if (tecla == 'O') {
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main47
;main.c,107 :: 		Delay_ms(20);
	MOVLW      7
	MOVWF      R12
	MOVLW      125
	MOVWF      R13
L_main48:
	DECFSZ     R13, 1
	GOTO       L_main48
	DECFSZ     R12, 1
	GOTO       L_main48
;main.c,108 :: 		while (leer_teclado() == 'O');
L_main49:
	CALL       _leer_teclado+0
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main50
	GOTO       L_main49
L_main50:
;main.c,109 :: 		sistema_on = 0;
	BCF        _sistema_on+0, BitPos(_sistema_on+0)
;main.c,110 :: 		conteo_activo = 0;
	BCF        _conteo_activo+0, BitPos(_conteo_activo+0)
;main.c,111 :: 		LATC.F0 = 0; // Activo bajo: vuelve a modo selección
	BCF        LATC+0, 0
;main.c,112 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;main.c,113 :: 		Lcd_Out(1,1,"Presione O (ON)");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr8_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,114 :: 		Lcd_Out(2,1,"para iniciar");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr9_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,116 :: 		while(!sistema_on) {
L_main51:
	BTFSC      _sistema_on+0, BitPos(_sistema_on+0)
	GOTO       L_main52
;main.c,117 :: 		tecla = leer_teclado();
	CALL       _leer_teclado+0
;main.c,118 :: 		if (tecla == 'O') {
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main53
;main.c,119 :: 		Delay_ms(20);
	MOVLW      7
	MOVWF      R12
	MOVLW      125
	MOVWF      R13
L_main54:
	DECFSZ     R13, 1
	GOTO       L_main54
	DECFSZ     R12, 1
	GOTO       L_main54
;main.c,120 :: 		while (leer_teclado() == 'O');
L_main55:
	CALL       _leer_teclado+0
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main56
	GOTO       L_main55
L_main56:
;main.c,121 :: 		sistema_on = 1;
	BSF        _sistema_on+0, BitPos(_sistema_on+0)
;main.c,122 :: 		LATC.F0 = 1; // Activo alto: ya seleccionó una opción
	BSF        LATC+0, 0
;main.c,123 :: 		mostrar_modo(modo_actual);
	MOVF       _modo_actual+0, 0
	MOVWF      FARG_mostrar_modo_modo+0
	CALL       _mostrar_modo+0
;main.c,124 :: 		Delay_ms(300);
	MOVLW      98
	MOVWF      R12
	MOVLW      101
	MOVWF      R13
L_main57:
	DECFSZ     R13, 1
	GOTO       L_main57
	DECFSZ     R12, 1
	GOTO       L_main57
	NOP
	NOP
;main.c,125 :: 		}
L_main53:
;main.c,126 :: 		}
	GOTO       L_main51
L_main52:
;main.c,127 :: 		}
L_main47:
;main.c,129 :: 		Delay_ms(10); // evitar uso excesivo de CPU
	MOVLW      4
	MOVWF      R12
	MOVLW      61
	MOVWF      R13
L_main58:
	DECFSZ     R13, 1
	GOTO       L_main58
	DECFSZ     R12, 1
	GOTO       L_main58
	NOP
	NOP
;main.c,130 :: 		}
	GOTO       L_main34
;main.c,131 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
