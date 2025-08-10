
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
L__leer_teclado69:
	BTFSC      STATUS+0, 2
	GOTO       L__leer_teclado70
	LSLF       R0, 1
	ADDLW      255
	GOTO       L__leer_teclado69
L__leer_teclado70:
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
L__leer_teclado71:
	BTFSC      STATUS+0, 2
	GOTO       L__leer_teclado72
	LSLF       R0, 1
	RLF        R1, 1
	ADDLW      255
	GOTO       L__leer_teclado71
L__leer_teclado72:
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
L__leer_teclado73:
	BTFSC      STATUS+0, 2
	GOTO       L__leer_teclado74
	LSLF       R0, 1
	RLF        R1, 1
	ADDLW      255
	GOTO       L__leer_teclado73
L__leer_teclado74:
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
L__Pulsador_Modo_Presionado64:
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
L__Pulsador_Start_Presionado65:
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

_Cronometro_Init:

;cronometro.h,10 :: 		void Cronometro_Init() {
;cronometro.h,11 :: 		minutos = 0;
	CLRF       main_minutos+0
;cronometro.h,12 :: 		segundos = 0;
	CLRF       main_segundos+0
;cronometro.h,13 :: 		decimas = 0;
	CLRF       main_decimas+0
;cronometro.h,14 :: 		}
L_end_Cronometro_Init:
	RETURN
; end of _Cronometro_Init

_Cronometro_Reset:

;cronometro.h,17 :: 		void Cronometro_Reset() {
;cronometro.h,18 :: 		minutos = 0;
	CLRF       main_minutos+0
;cronometro.h,19 :: 		segundos = 0;
	CLRF       main_segundos+0
;cronometro.h,20 :: 		decimas = 0;
	CLRF       main_decimas+0
;cronometro.h,21 :: 		}
L_end_Cronometro_Reset:
	RETURN
; end of _Cronometro_Reset

_Cronometro_Tick:

;cronometro.h,25 :: 		void Cronometro_Tick() {
;cronometro.h,27 :: 		ms10_count++;
	INCF       Cronometro_Tick_ms10_count_L0+0, 1
;cronometro.h,28 :: 		if(ms10_count >= 10) { // 10*10ms = 100ms = 0.1s (décima)
	MOVLW      10
	SUBWF      Cronometro_Tick_ms10_count_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Cronometro_Tick20
;cronometro.h,29 :: 		ms10_count = 0;
	CLRF       Cronometro_Tick_ms10_count_L0+0
;cronometro.h,30 :: 		decimas++;
	INCF       main_decimas+0, 1
;cronometro.h,31 :: 		if(decimas >= 10) {
	MOVLW      10
	SUBWF      main_decimas+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Cronometro_Tick21
;cronometro.h,32 :: 		decimas = 0;
	CLRF       main_decimas+0
;cronometro.h,33 :: 		segundos++;
	INCF       main_segundos+0, 1
;cronometro.h,34 :: 		if(segundos >= 60) {
	MOVLW      60
	SUBWF      main_segundos+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Cronometro_Tick22
;cronometro.h,35 :: 		segundos = 0;
	CLRF       main_segundos+0
;cronometro.h,36 :: 		minutos++;
	INCF       main_minutos+0, 1
;cronometro.h,37 :: 		if(minutos >= 100) { // Tope 99:59.9
	MOVLW      100
	SUBWF      main_minutos+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Cronometro_Tick23
;cronometro.h,38 :: 		minutos = 0;
	CLRF       main_minutos+0
;cronometro.h,39 :: 		}
L_Cronometro_Tick23:
;cronometro.h,40 :: 		}
L_Cronometro_Tick22:
;cronometro.h,41 :: 		}
L_Cronometro_Tick21:
;cronometro.h,42 :: 		}
L_Cronometro_Tick20:
;cronometro.h,43 :: 		}
L_end_Cronometro_Tick:
	RETURN
; end of _Cronometro_Tick

_Cronometro_Mostrar:

;cronometro.h,46 :: 		void Cronometro_Mostrar() {
;cronometro.h,50 :: 		ByteToStrWithZeros(minutos, minStr);   // " 00"
	MOVF       main_minutos+0, 0
	MOVWF      FARG_ByteToStrWithZeros_input+0
	MOVLW      Cronometro_Mostrar_minStr_L0+0
	MOVWF      FARG_ByteToStrWithZeros_output+0
	MOVLW      hi_addr(Cronometro_Mostrar_minStr_L0+0)
	MOVWF      FARG_ByteToStrWithZeros_output+1
	CALL       _ByteToStrWithZeros+0
;cronometro.h,51 :: 		ByteToStrWithZeros(segundos, segStr);  // " 00"
	MOVF       main_segundos+0, 0
	MOVWF      FARG_ByteToStrWithZeros_input+0
	MOVLW      Cronometro_Mostrar_segStr_L0+0
	MOVWF      FARG_ByteToStrWithZeros_output+0
	MOVLW      hi_addr(Cronometro_Mostrar_segStr_L0+0)
	MOVWF      FARG_ByteToStrWithZeros_output+1
	CALL       _ByteToStrWithZeros+0
;cronometro.h,53 :: 		buffer[0] = minStr[1];
	MOVF       Cronometro_Mostrar_minStr_L0+1, 0
	MOVWF      Cronometro_Mostrar_buffer_L0+0
;cronometro.h,54 :: 		buffer[1] = minStr[2];
	MOVF       Cronometro_Mostrar_minStr_L0+2, 0
	MOVWF      Cronometro_Mostrar_buffer_L0+1
;cronometro.h,55 :: 		buffer[2] = ':';
	MOVLW      58
	MOVWF      Cronometro_Mostrar_buffer_L0+2
;cronometro.h,56 :: 		buffer[3] = segStr[1];
	MOVF       Cronometro_Mostrar_segStr_L0+1, 0
	MOVWF      Cronometro_Mostrar_buffer_L0+3
;cronometro.h,57 :: 		buffer[4] = segStr[2];
	MOVF       Cronometro_Mostrar_segStr_L0+2, 0
	MOVWF      Cronometro_Mostrar_buffer_L0+4
;cronometro.h,58 :: 		buffer[5] = '.';
	MOVLW      46
	MOVWF      Cronometro_Mostrar_buffer_L0+5
;cronometro.h,59 :: 		buffer[6] = decimas + '0';
	MOVLW      48
	ADDWF      main_decimas+0, 0
	MOVWF      Cronometro_Mostrar_buffer_L0+6
;cronometro.h,60 :: 		buffer[7] = 0;
	CLRF       Cronometro_Mostrar_buffer_L0+7
;cronometro.h,62 :: 		Lcd_Out(2,1,buffer);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      Cronometro_Mostrar_buffer_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(Cronometro_Mostrar_buffer_L0+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;cronometro.h,63 :: 		}
L_end_Cronometro_Mostrar:
	RETURN
; end of _Cronometro_Mostrar

_mostrar_modo:

;main.c,14 :: 		void mostrar_modo(unsigned char modo) {
;main.c,15 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;main.c,16 :: 		switch(modo) {
	GOTO       L_mostrar_modo24
;main.c,17 :: 		case MODO_CRONOMETRO:
L_mostrar_modo26:
;main.c,18 :: 		Lcd_Out(1,1," Cronometro");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr1_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,19 :: 		break;
	GOTO       L_mostrar_modo25
;main.c,20 :: 		case MODO_TEMPORIZADOR:
L_mostrar_modo27:
;main.c,21 :: 		Lcd_Out(1,1," Temporizador");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr2_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,22 :: 		break;
	GOTO       L_mostrar_modo25
;main.c,23 :: 		case MODO_FRECUENCIMETRO:
L_mostrar_modo28:
;main.c,24 :: 		Lcd_Out(1,1," Frecuencimetro");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr3_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,25 :: 		break;
	GOTO       L_mostrar_modo25
;main.c,26 :: 		}
L_mostrar_modo24:
	MOVF       FARG_mostrar_modo_modo+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_mostrar_modo26
	MOVF       FARG_mostrar_modo_modo+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_mostrar_modo27
	MOVF       FARG_mostrar_modo_modo+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_mostrar_modo28
L_mostrar_modo25:
;main.c,27 :: 		Lcd_Out(2,1," "); // Limpia segunda línea
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr4_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,28 :: 		}
L_end_mostrar_modo:
	RETURN
; end of _mostrar_modo

_main:

;main.c,30 :: 		void main() {
;main.c,34 :: 		ANSELB = 0x00; // Keypad digital
	CLRF       ANSELB+0
;main.c,35 :: 		ANSELD = 0x00; // LCD digital
	CLRF       ANSELD+0
;main.c,36 :: 		ANSELC = 0x00; // Pulsadores digitales
	CLRF       ANSELC+0
;main.c,39 :: 		TRISC.F0 = 0; // RC0 salida
	BCF        TRISC+0, 0
;main.c,40 :: 		LATC.F0 = 0;  // Activo bajo: en pantalla de selección
	BCF        LATC+0, 0
;main.c,43 :: 		LCD_P1_Init();
	CALL       _LCD_P1_Init+0
;main.c,44 :: 		Pulsadores_P1_Init();
	CALL       _Pulsadores_P1_Init+0
;main.c,47 :: 		sistema_on = 0;
	BCF        _sistema_on+0, BitPos(_sistema_on+0)
;main.c,48 :: 		conteo_activo = 0;
	BCF        _conteo_activo+0, BitPos(_conteo_activo+0)
;main.c,49 :: 		modo_actual = MODO_CRONOMETRO;
	CLRF       _modo_actual+0
;main.c,52 :: 		Cronometro_Init();
	CALL       _Cronometro_Init+0
;main.c,55 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;main.c,56 :: 		Lcd_Out(1,1," Presione O (ON)");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr5_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,57 :: 		Lcd_Out(2,1,"para iniciar");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr6_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,60 :: 		while(!sistema_on) {
L_main29:
	BTFSC      _sistema_on+0, BitPos(_sistema_on+0)
	GOTO       L_main30
;main.c,61 :: 		tecla = leer_teclado();
	CALL       _leer_teclado+0
	MOVF       R0, 0
	MOVWF      main_tecla_L0+0
;main.c,62 :: 		if (tecla == 'O') {
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main31
;main.c,63 :: 		Delay_ms(20);
	MOVLW      7
	MOVWF      R12
	MOVLW      125
	MOVWF      R13
L_main32:
	DECFSZ     R13, 1
	GOTO       L_main32
	DECFSZ     R12, 1
	GOTO       L_main32
;main.c,64 :: 		while (leer_teclado() == 'O');
L_main33:
	CALL       _leer_teclado+0
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main34
	GOTO       L_main33
L_main34:
;main.c,65 :: 		sistema_on = 1;
	BSF        _sistema_on+0, BitPos(_sistema_on+0)
;main.c,66 :: 		LATC.F0 = 1; // Activo alto: ya seleccionó una opción
	BSF        LATC+0, 0
;main.c,67 :: 		mostrar_modo(modo_actual);
	MOVF       _modo_actual+0, 0
	MOVWF      FARG_mostrar_modo_modo+0
	CALL       _mostrar_modo+0
;main.c,68 :: 		Delay_ms(300);
	MOVLW      98
	MOVWF      R12
	MOVLW      101
	MOVWF      R13
L_main35:
	DECFSZ     R13, 1
	GOTO       L_main35
	DECFSZ     R12, 1
	GOTO       L_main35
	NOP
	NOP
;main.c,69 :: 		}
L_main31:
;main.c,70 :: 		}
	GOTO       L_main29
L_main30:
;main.c,73 :: 		while(1) {
L_main36:
;main.c,75 :: 		if (Pulsador_Modo_Presionado()) {
	CALL       _Pulsador_Modo_Presionado+0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main38
;main.c,76 :: 		modo_actual++;
	INCF       _modo_actual+0, 1
;main.c,77 :: 		if (modo_actual > MODO_FRECUENCIMETRO)
	MOVF       _modo_actual+0, 0
	SUBLW      2
	BTFSC      STATUS+0, 0
	GOTO       L_main39
;main.c,78 :: 		modo_actual = MODO_CRONOMETRO;
	CLRF       _modo_actual+0
L_main39:
;main.c,79 :: 		conteo_activo = 0;
	BCF        _conteo_activo+0, BitPos(_conteo_activo+0)
;main.c,80 :: 		mostrar_modo(modo_actual);
	MOVF       _modo_actual+0, 0
	MOVWF      FARG_mostrar_modo_modo+0
	CALL       _mostrar_modo+0
;main.c,83 :: 		if(modo_actual == MODO_CRONOMETRO) {
	MOVF       _modo_actual+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main40
;main.c,84 :: 		Cronometro_Reset();
	CALL       _Cronometro_Reset+0
;main.c,85 :: 		}
L_main40:
;main.c,86 :: 		Delay_ms(120);
	MOVLW      39
	MOVWF      R12
	MOVLW      245
	MOVWF      R13
L_main41:
	DECFSZ     R13, 1
	GOTO       L_main41
	DECFSZ     R12, 1
	GOTO       L_main41
;main.c,87 :: 		}
L_main38:
;main.c,90 :: 		if (Pulsador_Start_Presionado()) {
	CALL       _Pulsador_Start_Presionado+0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main42
;main.c,91 :: 		conteo_activo = !conteo_activo;
	MOVLW
	XORWF      _conteo_activo+0, 1
;main.c,92 :: 		mostrar_modo(modo_actual);
	MOVF       _modo_actual+0, 0
	MOVWF      FARG_mostrar_modo_modo+0
	CALL       _mostrar_modo+0
;main.c,93 :: 		Delay_ms(120);
	MOVLW      39
	MOVWF      R12
	MOVLW      245
	MOVWF      R13
L_main43:
	DECFSZ     R13, 1
	GOTO       L_main43
	DECFSZ     R12, 1
	GOTO       L_main43
;main.c,94 :: 		}
L_main42:
;main.c,97 :: 		tecla = leer_teclado();
	CALL       _leer_teclado+0
	MOVF       R0, 0
	MOVWF      main_tecla_L0+0
;main.c,98 :: 		if (modo_actual == MODO_CRONOMETRO && tecla == '0') {
	MOVF       _modo_actual+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main46
	MOVF       main_tecla_L0+0, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main46
L__main66:
;main.c,99 :: 		conteo_activo = !conteo_activo;
	MOVLW
	XORWF      _conteo_activo+0, 1
;main.c,100 :: 		mostrar_modo(modo_actual);
	MOVF       _modo_actual+0, 0
	MOVWF      FARG_mostrar_modo_modo+0
	CALL       _mostrar_modo+0
;main.c,101 :: 		Delay_ms(200);
	MOVLW      65
	MOVWF      R12
	MOVLW      238
	MOVWF      R13
L_main47:
	DECFSZ     R13, 1
	GOTO       L_main47
	DECFSZ     R12, 1
	GOTO       L_main47
	NOP
;main.c,102 :: 		while(leer_teclado() == '0');
L_main48:
	CALL       _leer_teclado+0
	MOVF       R0, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main49
	GOTO       L_main48
L_main49:
;main.c,103 :: 		}
L_main46:
;main.c,106 :: 		if(modo_actual == MODO_CRONOMETRO) {
	MOVF       _modo_actual+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main50
;main.c,107 :: 		if(conteo_activo) {
	BTFSS      _conteo_activo+0, BitPos(_conteo_activo+0)
	GOTO       L_main51
;main.c,108 :: 		Cronometro_Tick();
	CALL       _Cronometro_Tick+0
;main.c,109 :: 		}
L_main51:
;main.c,110 :: 		Cronometro_Mostrar();
	CALL       _Cronometro_Mostrar+0
;main.c,111 :: 		}
L_main50:
;main.c,115 :: 		tecla = leer_teclado();
	CALL       _leer_teclado+0
	MOVF       R0, 0
	MOVWF      main_tecla_L0+0
;main.c,116 :: 		if (tecla == 'O') {
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main52
;main.c,117 :: 		Delay_ms(20);
	MOVLW      7
	MOVWF      R12
	MOVLW      125
	MOVWF      R13
L_main53:
	DECFSZ     R13, 1
	GOTO       L_main53
	DECFSZ     R12, 1
	GOTO       L_main53
;main.c,118 :: 		while (leer_teclado() == 'O');
L_main54:
	CALL       _leer_teclado+0
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main55
	GOTO       L_main54
L_main55:
;main.c,119 :: 		sistema_on = 0;
	BCF        _sistema_on+0, BitPos(_sistema_on+0)
;main.c,120 :: 		conteo_activo = 0;
	BCF        _conteo_activo+0, BitPos(_conteo_activo+0)
;main.c,121 :: 		LATC.F0 = 0; // Activo bajo: vuelve a modo selección
	BCF        LATC+0, 0
;main.c,122 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;main.c,123 :: 		Lcd_Out(1,1," Presione O (ON)");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr7_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,124 :: 		Lcd_Out(2,1,"para iniciar");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_main+0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      hi_addr(?lstr8_main+0)
	MOVWF      FARG_Lcd_Out_text+1
	CALL       _Lcd_Out+0
;main.c,125 :: 		while(!sistema_on) {
L_main56:
	BTFSC      _sistema_on+0, BitPos(_sistema_on+0)
	GOTO       L_main57
;main.c,126 :: 		tecla = leer_teclado();
	CALL       _leer_teclado+0
	MOVF       R0, 0
	MOVWF      main_tecla_L0+0
;main.c,127 :: 		if (tecla == 'O') {
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main58
;main.c,128 :: 		Delay_ms(20);
	MOVLW      7
	MOVWF      R12
	MOVLW      125
	MOVWF      R13
L_main59:
	DECFSZ     R13, 1
	GOTO       L_main59
	DECFSZ     R12, 1
	GOTO       L_main59
;main.c,129 :: 		while (leer_teclado() == 'O');
L_main60:
	CALL       _leer_teclado+0
	MOVF       R0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L_main61
	GOTO       L_main60
L_main61:
;main.c,130 :: 		sistema_on = 1;
	BSF        _sistema_on+0, BitPos(_sistema_on+0)
;main.c,131 :: 		LATC.F0 = 1; // Activo alto
	BSF        LATC+0, 0
;main.c,132 :: 		mostrar_modo(modo_actual);
	MOVF       _modo_actual+0, 0
	MOVWF      FARG_mostrar_modo_modo+0
	CALL       _mostrar_modo+0
;main.c,133 :: 		Delay_ms(300);
	MOVLW      98
	MOVWF      R12
	MOVLW      101
	MOVWF      R13
L_main62:
	DECFSZ     R13, 1
	GOTO       L_main62
	DECFSZ     R12, 1
	GOTO       L_main62
	NOP
	NOP
;main.c,134 :: 		}
L_main58:
;main.c,135 :: 		}
	GOTO       L_main56
L_main57:
;main.c,136 :: 		}
L_main52:
;main.c,138 :: 		Delay_ms(10); // periodo base del sistema (~10ms)
	MOVLW      4
	MOVWF      R12
	MOVLW      61
	MOVWF      R13
L_main63:
	DECFSZ     R13, 1
	GOTO       L_main63
	DECFSZ     R12, 1
	GOTO       L_main63
	NOP
	NOP
;main.c,139 :: 		}
	GOTO       L_main36
;main.c,140 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
