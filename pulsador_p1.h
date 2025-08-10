#ifndef _PULSADOR_P1_H_
#define _PULSADOR_P1_H_

#define PULSADOR_MODO    PORTC.F1  // RC1
#define PULSADOR_START   PORTC.F2  // RC2

static char prev_modo;
static char prev_start;

void Pulsadores_P1_Init() {
    TRISC.F1 = 1; // RC1 como entrada
    TRISC.F2 = 1; // RC2 como entrada
    // Activar pull-ups en RC1 y RC2
    WPUC.F1 = 1;
    WPUC.F2 = 1;

    Delay_ms(10); // Estabilizar lectura inicial

    // Guardar estado inicial de los botones
    prev_modo  = PULSADOR_MODO;
    prev_start = PULSADOR_START;
}

char Pulsador_Modo_Presionado() {
    char pressed = 0;
    if ((prev_modo == 1) && (PULSADOR_MODO == 0)) {
        Delay_ms(20); // debounce
        if (PULSADOR_MODO == 0) pressed = 1;
    }
    prev_modo = PULSADOR_MODO;
    return pressed;
}

char Pulsador_Start_Presionado() {
    char pressed = 0;
    if ((prev_start == 1) && (PULSADOR_START == 0)) {
        Delay_ms(20); // debounce
        if (PULSADOR_START == 0) pressed = 1;
    }
    prev_start = PULSADOR_START;
    return pressed;
}

#endif
