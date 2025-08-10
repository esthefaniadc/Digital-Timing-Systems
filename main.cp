#line 1 "C:/Esthefanía MG/Documentos/UNIVERSITY FOLDERS/NOW/OneDrive - uc.edu.ve/NOW/DISEÑO DIGITAL/Prácticas/P1/Versión1/MikroC For PIC/main.c"
#line 1 "c:/esthefanía mg/documentos/university folders/now/onedrive - uc.edu.ve/now/diseÑo digital/prácticas/p1/versión1/mikroc for pic/lcd_p1.h"




sbit LCD_RS at RD0_bit;
sbit LCD_EN at RD1_bit;
sbit LCD_D4 at RD2_bit;
sbit LCD_D5 at RD3_bit;
sbit LCD_D6 at RD4_bit;
sbit LCD_D7 at RD5_bit;

sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D4_Direction at TRISD2_bit;
sbit LCD_D5_Direction at TRISD3_bit;
sbit LCD_D6_Direction at TRISD4_bit;
sbit LCD_D7_Direction at TRISD5_bit;


void LCD_P1_Init() {
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
}
#line 1 "c:/esthefanía mg/documentos/university folders/now/onedrive - uc.edu.ve/now/diseÑo digital/prácticas/p1/versión1/mikroc for pic/keypad_p1.h"




const char tecla_map[4][4] = {
 {'7','8','9','A'},
 {'4','5','6','B'},
 {'1','2','3','C'},
 {'O','0','E','D'}
};






char leer_teclado() {
 char fila, col;

  TRISB  = 0b11110000;
  LATB  = 0x0F;

 for (fila = 0; fila < 4; fila++) {
  LATB  = 0x0F;
  LATB  &= ~(1 << fila);
 Delay_us(20);

 for (col = 0; col < 4; col++) {
 if (!( PORTB  & (1 << (col + 4)))) {
 while (!( PORTB  & (1 << (col + 4))));
 return tecla_map[fila][col];
 }
 }
 }
 return 0;
}
#line 1 "c:/esthefanía mg/documentos/university folders/now/onedrive - uc.edu.ve/now/diseÑo digital/prácticas/p1/versión1/mikroc for pic/pulsador_p1.h"






static char prev_modo;
static char prev_start;

void Pulsadores_P1_Init() {
 TRISC.F1 = 1;
 TRISC.F2 = 1;

 WPUC.F1 = 1;
 WPUC.F2 = 1;

 Delay_ms(10);


 prev_modo =  PORTC.F1 ;
 prev_start =  PORTC.F2 ;
}

char Pulsador_Modo_Presionado() {
 char pressed = 0;
 if ((prev_modo == 1) && ( PORTC.F1  == 0)) {
 Delay_ms(20);
 if ( PORTC.F1  == 0) pressed = 1;
 }
 prev_modo =  PORTC.F1 ;
 return pressed;
}

char Pulsador_Start_Presionado() {
 char pressed = 0;
 if ((prev_start == 1) && ( PORTC.F2  == 0)) {
 Delay_ms(20);
 if ( PORTC.F2  == 0) pressed = 1;
 }
 prev_start =  PORTC.F2 ;
 return pressed;
}
#line 9 "C:/Esthefanía MG/Documentos/UNIVERSITY FOLDERS/NOW/OneDrive - uc.edu.ve/NOW/DISEÑO DIGITAL/Prácticas/P1/Versión1/MikroC For PIC/main.c"
unsigned char modo_actual;
bit sistema_on;
bit conteo_activo;

void mostrar_modo(unsigned char modo) {
 Lcd_Cmd(_LCD_CLEAR);
 switch(modo) {
 case  0 :
 Lcd_Out(1,1,"Modo: Cronometro");
 break;
 case  1 :
 Lcd_Out(1,1,"Modo: Temporizador");
 break;
 case  2 :
 Lcd_Out(1,1,"Modo: Frec.Metro");
 break;
 }
 if(conteo_activo)
 Lcd_Out(2,1,"En ejecucion...");
 else
 Lcd_Out(2,1,"RC2:Start/Stop");
}

void main() {
 char tecla;


 ANSELB = 0x00;
 ANSELD = 0x00;
 ANSELC = 0x00;


 LCD_P1_Init();
 Pulsadores_P1_Init();


 sistema_on = 0;
 conteo_activo = 0;
 modo_actual =  0 ;


 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Presione O (ON)");
 Lcd_Out(2,1,"para iniciar");


 while(!sistema_on) {
 tecla = leer_teclado();
 if (tecla == 'O') {
 Delay_ms(20);
 while (leer_teclado() == 'O');
 sistema_on = 1;
 mostrar_modo(modo_actual);
 Delay_ms(300);
 }
 }


 while(1) {

 if (Pulsador_Modo_Presionado()) {
 modo_actual++;
 if (modo_actual >  2 )
 modo_actual =  0 ;
 mostrar_modo(modo_actual);
 Delay_ms(120);
 }


 if (Pulsador_Start_Presionado()) {
 conteo_activo = !conteo_activo;
 mostrar_modo(modo_actual);
 Delay_ms(120);
 }


 if (conteo_activo) {
 switch (modo_actual) {
 case  0 :

 break;
 case  1 :

 break;
 case  2 :

 break;
 }
 }

 Delay_ms(10);
 }
}
