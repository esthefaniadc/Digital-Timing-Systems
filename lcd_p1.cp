#line 1 "C:/Esthefanía MG/Documentos/UNIVERSITY FOLDERS/NOW/OneDrive - uc.edu.ve/NOW/DISEÑO DIGITAL/Prácticas/P1/Versión1/MikroC For PIC/lcd_p1.c"
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


void LCD_P1_Init();
#line 3 "C:/Esthefanía MG/Documentos/UNIVERSITY FOLDERS/NOW/OneDrive - uc.edu.ve/NOW/DISEÑO DIGITAL/Prácticas/P1/Versión1/MikroC For PIC/lcd_p1.c"
void main() {
 LCD_P1_Init();
 Lcd_Out(1, 1, "PRUEBA LCD");
 while(1);
}
