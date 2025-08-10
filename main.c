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

    // Configuraci�n de puertos digitales
    ANSELB = 0x00; // Keypad digital
    ANSELD = 0x00; // LCD digital
    ANSELC = 0x00; // Pulsadores digitales

    // Configuraci�n de RC0 como salida para se�al de estado
    TRISC.F0 = 0; // RC0 salida
    LATC.F0 = 0;  // Activo bajo: en pantalla de selecci�n

    // Inicializaci�n de m�dulos
    LCD_P1_Init();
    Pulsadores_P1_Init();

    // Inicializaci�n de variables
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
            while (leer_teclado() == 'O'); // esperar liberaci�n
            sistema_on = 1;
            LATC.F0 = 1; // Activo alto: ya seleccion� una opci�n
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

        // Aqu� ir�a la l�gica de cada modo
        if (conteo_activo) {
            switch (modo_actual) {
                case MODO_CRONOMETRO:
                    // TODO: l�gica cron�metro
                    break;
                case MODO_TEMPORIZADOR:
                    // TODO: l�gica temporizador
                    break;
                case MODO_FRECUENCIMETRO:
                    // TODO: l�gica frecuenc�metro
                    break;
            }
        }

        // Si quieres permitir volver al modo selecci�n con 'O':
        tecla = leer_teclado();
        if (tecla == 'O') {
            Delay_ms(20);
            while (leer_teclado() == 'O');
            sistema_on = 0;
            conteo_activo = 0;
            LATC.F0 = 0; // Activo bajo: vuelve a modo selecci�n
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
                    LATC.F0 = 1; // Activo alto: ya seleccion� una opci�n
                    mostrar_modo(modo_actual);
                    Delay_ms(300);
                }
            }
        }

        Delay_ms(10); // evitar uso excesivo de CPU
    }
}