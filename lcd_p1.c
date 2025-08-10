#include "lcd_p1.h"

void main() {
    LCD_P1_Init();
    Lcd_Out(1, 1, "PRUEBA LCD");
    while(1);
}