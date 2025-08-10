#include "lcd_p1.h"
#include "keypad_p1.h"
#include "pulsador_p1.h"
#include "cronometro.h"

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
            Lcd_Out(1,1," Cronometro");
            break;
        case MODO_TEMPORIZADOR:
            Lcd_Out(1,1," Temporizador");
            break;
        case MODO_FRECUENCIMETRO:
            Lcd_Out(1,1," Frecuencimetro");
            break;
    }
    Lcd_Out(2,1," "); // Limpia segunda l�nea
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

    // Inicializaci�n de cron�metro
    Cronometro_Init();

    // Mensaje de bienvenida
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1,1," Presione O (ON)");
    Lcd_Out(2,1,"para iniciar");

    // Espera hasta que se presione y suelte 'O'
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

    // Bucle principal
    while(1) {
        // Cambiar modo con RC1
        if (Pulsador_Modo_Presionado()) {
            modo_actual++;
            if (modo_actual > MODO_FRECUENCIMETRO)
                modo_actual = MODO_CRONOMETRO;
            conteo_activo = 0;
            mostrar_modo(modo_actual);

            // Reinicia cron�metro al cambiar de modo
            if(modo_actual == MODO_CRONOMETRO) {
                Cronometro_Reset();
            }
            Delay_ms(120);
        }

        // Iniciar/detener con RC2 (pulsador f�sico)
        if (Pulsador_Start_Presionado()) {
            conteo_activo = !conteo_activo;
            mostrar_modo(modo_actual);
            Delay_ms(120);
        }

        // Iniciar/detener con '0' del keypad en modo cron�metro
        tecla = leer_teclado();
        if (modo_actual == MODO_CRONOMETRO && tecla == '0') {
            conteo_activo = !conteo_activo;
            mostrar_modo(modo_actual);
            Delay_ms(200);
            while(leer_teclado() == '0');
        }

        // L�gica de cada modo
        if(modo_actual == MODO_CRONOMETRO) {
            if(conteo_activo) {
                Cronometro_Tick();
            }
            Cronometro_Mostrar();
        }
        // (Temporizador y frecuenc�metro se implementar�n despu�s)

        // Permitir volver a modo selecci�n con 'O'
        tecla = leer_teclado();
        if (tecla == 'O') {
            Delay_ms(20);
            while (leer_teclado() == 'O');
            sistema_on = 0;
            conteo_activo = 0;
            LATC.F0 = 0; // Activo bajo: vuelve a modo selecci�n
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1," Presione O (ON)");
            Lcd_Out(2,1,"para iniciar");
            while(!sistema_on) {
                tecla = leer_teclado();
                if (tecla == 'O') {
                    Delay_ms(20);
                    while (leer_teclado() == 'O');
                    sistema_on = 1;
                    LATC.F0 = 1; // Activo alto
                    mostrar_modo(modo_actual);
                    Delay_ms(300);
                }
            }
        }

        Delay_ms(10); // periodo base del sistema (~10ms)
    }
}