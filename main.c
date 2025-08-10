#include "lcd_p1.h"
#include "keypad_p1.h"
#include "pulsador_p1.h"

#define MODO_CRONOMETRO     0
#define MODO_TEMPORIZADOR   1
#define MODO_FRECUENCIMETRO 2

unsigned char modo_actual;
bit sistema_on;
bit conteo_activo;

void mostrar_modo(unsigned char modo) {
    Lcd_Cmd(_LCD_CLEAR);
    switch(modo) {
        case MODO_CRONOMETRO:
            Lcd_Out(1,1,"Modo: Cronometro");
            break;
        case MODO_TEMPORIZADOR:
            Lcd_Out(1,1,"Modo: Temporizador");
            break;
        case MODO_FRECUENCIMETRO:
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

    // Configuración de puertos digitales
    ANSELB = 0x00; // Keypad digital
    ANSELD = 0x00; // LCD digital
    ANSELC = 0x00; // Pulsadores digitales

    // Configuración de RC0 como salida para señal de estado
    TRISC.F0 = 0; // RC0 salida
    LATC.F0 = 0;  // Activo bajo: en pantalla de selección

    // Inicialización de módulos
    LCD_P1_Init();
    Pulsadores_P1_Init();

    // Inicialización de variables
    sistema_on = 0;
    conteo_activo = 0;
    modo_actual = MODO_CRONOMETRO;

    // Mensaje de bienvenida
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"Presione O (ON)");
    Lcd_Out(2,1,"para iniciar");

    // Espera hasta que se presione y suelte 'O'
    while(!sistema_on) {
        tecla = leer_teclado();
        if (tecla == 'O') {
            Delay_ms(20);                 // debounce
            while (leer_teclado() == 'O'); // esperar liberación
            sistema_on = 1;
            LATC.F0 = 1; // Activo alto: ya seleccionó una opción
            mostrar_modo(modo_actual);
            Delay_ms(300);
        }
    }

    // Bucle principal
    while(1) {
        // Cambiar modo con RC1
        if (Pulsador_Modo_Presionado()) {
            modo_actual++;
            if (modo_actual > MODO_FRECUENCIMETRO)
                modo_actual = MODO_CRONOMETRO;
            mostrar_modo(modo_actual);
            Delay_ms(120);
        }

        // Iniciar/detener con RC2
        if (Pulsador_Start_Presionado()) {
            conteo_activo = !conteo_activo;
            mostrar_modo(modo_actual);
            Delay_ms(120);
        }

        // Aquí iría la lógica de cada modo
        if (conteo_activo) {
            switch (modo_actual) {
                case MODO_CRONOMETRO:
                    // TODO: lógica cronómetro
                    break;
                case MODO_TEMPORIZADOR:
                    // TODO: lógica temporizador
                    break;
                case MODO_FRECUENCIMETRO:
                    // TODO: lógica frecuencímetro
                    break;
            }
        }

        // Si quieres permitir volver al modo selección con 'O':
        tecla = leer_teclado();
        if (tecla == 'O') {
            Delay_ms(20);
            while (leer_teclado() == 'O');
            sistema_on = 0;
            conteo_activo = 0;
            LATC.F0 = 0; // Activo bajo: vuelve a modo selección
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1,"Presione O (ON)");
            Lcd_Out(2,1,"para iniciar");
            // Espera nuevo ON
            while(!sistema_on) {
                tecla = leer_teclado();
                if (tecla == 'O') {
                    Delay_ms(20);
                    while (leer_teclado() == 'O');
                    sistema_on = 1;
                    LATC.F0 = 1; // Activo alto: ya seleccionó una opción
                    mostrar_modo(modo_actual);
                    Delay_ms(300);
                }
            }
        }

        Delay_ms(10); // evitar uso excesivo de CPU
    }
}