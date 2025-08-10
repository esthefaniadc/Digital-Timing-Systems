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
#line 1 "c:/esthefanía mg/documentos/university folders/now/onedrive - uc.edu.ve/now/diseÑo digital/prácticas/p1/versión1/mikroc for pic/cronometro.h"




static unsigned char minutos = 0;
static unsigned char segundos = 0;
static unsigned char decimas = 0;


void Cronometro_Init() {
 minutos = 0;
 segundos = 0;
 decimas = 0;
}


void Cronometro_Reset() {
 minutos = 0;
 segundos = 0;
 decimas = 0;
}



void Cronometro_Tick() {
 static unsigned char ms10_count = 0;
 ms10_count++;
 if(ms10_count >= 10) {
 ms10_count = 0;
 decimas++;
 if(decimas >= 10) {
 decimas = 0;
 segundos++;
 if(segundos >= 60) {
 segundos = 0;
 minutos++;
 if(minutos >= 100) {
 minutos = 0;
 }
 }
 }
 }
}


void Cronometro_Mostrar() {
 char buffer[9];
 char minStr[4], segStr[4];

 ByteToStrWithZeros(minutos, minStr);
 ByteToStrWithZeros(segundos, segStr);

 buffer[0] = minStr[1];
 buffer[1] = minStr[2];
 buffer[2] = ':';
 buffer[3] = segStr[1];
 buffer[4] = segStr[2];
 buffer[5] = '.';
 buffer[6] = decimas + '0';
 buffer[7] = 0;

 Lcd_Out(2,1,buffer);
}
#line 10 "C:/Esthefanía MG/Documentos/UNIVERSITY FOLDERS/NOW/OneDrive - uc.edu.ve/NOW/DISEÑO DIGITAL/Prácticas/P1/Versión1/MikroC For PIC/main.c"
unsigned char modo_actual;
bit sistema_on;
bit conteo_activo;

void mostrar_modo(unsigned char modo) {
 Lcd_Cmd(_LCD_CLEAR);
 switch(modo) {
 case  0 :
 Lcd_Out(1,1," Cronometro");
 break;
 case  1 :
 Lcd_Out(1,1," Temporizador");
 break;
 case  2 :
 Lcd_Out(1,1," Frecuencimetro");
 break;
 }
 Lcd_Out(2,1," ");
}

void main() {
 char tecla;


 ANSELB = 0x00;
 ANSELD = 0x00;
 ANSELC = 0x00;


 TRISC.F0 = 0;
 LATC.F0 = 0;


 LCD_P1_Init();
 Pulsadores_P1_Init();


 sistema_on = 0;
 conteo_activo = 0;
 modo_actual =  0 ;


 Cronometro_Init();


 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1," Presione O (ON)");
 Lcd_Out(2,1,"para iniciar");


 while(!sistema_on) {
 tecla = leer_teclado();
 if (tecla == 'O') {
 Delay_ms(20);
 while (leer_teclado() == 'O');
 sistema_on = 1;
 LATC.F0 = 1;
 mostrar_modo(modo_actual);
 Delay_ms(300);
 }
 }


 while(1) {

 if (Pulsador_Modo_Presionado()) {
 modo_actual++;
 if (modo_actual >  2 )
 modo_actual =  0 ;
 conteo_activo = 0;
 mostrar_modo(modo_actual);


 if(modo_actual ==  0 ) {
 Cronometro_Reset();
 }
 Delay_ms(120);
 }


 if (Pulsador_Start_Presionado()) {
 conteo_activo = !conteo_activo;
 mostrar_modo(modo_actual);
 Delay_ms(120);
 }


 tecla = leer_teclado();
 if (modo_actual ==  0  && tecla == '0') {
 conteo_activo = !conteo_activo;
 mostrar_modo(modo_actual);
 Delay_ms(200);
 while(leer_teclado() == '0');
 }


 if(modo_actual ==  0 ) {
 if(conteo_activo) {
 Cronometro_Tick();
 }
 Cronometro_Mostrar();
 }



 tecla = leer_teclado();
 if (tecla == 'O') {
 Delay_ms(20);
 while (leer_teclado() == 'O');
 sistema_on = 0;
 conteo_activo = 0;
 LATC.F0 = 0;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1," Presione O (ON)");
 Lcd_Out(2,1,"para iniciar");
 while(!sistema_on) {
 tecla = leer_teclado();
 if (tecla == 'O') {
 Delay_ms(20);
 while (leer_teclado() == 'O');
 sistema_on = 1;
 LATC.F0 = 1;
 mostrar_modo(modo_actual);
 Delay_ms(300);
 }
 }
 }

 Delay_ms(10);
 }
}
