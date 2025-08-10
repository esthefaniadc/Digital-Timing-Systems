#ifndef _KEYPAD_P1_H_
#define _KEYPAD_P1_H_

// Mapa de teclas Keypad 4x4 (simbolos matemáticos como letras)
const char tecla_map[4][4] = {
    {'7','8','9','A'}, // A = ÷
    {'4','5','6','B'}, // B = ×
    {'1','2','3','C'}, // C = -
    {'O','0','E','D'}  // O = ON/C, E = =, D = +
};

// Definiciones para PORTB
#define FILAS_TRIS   TRISB
#define FILAS_PORT   PORTB
#define FILAS_LAT    LATB

char leer_teclado() {
    char fila, col;

    FILAS_TRIS = 0b11110000; // RB0-RB3 salidas (filas), RB4-RB7 entradas (columnas)
    FILAS_LAT = 0x0F;        // Filas en alto (RB0-RB3), columnas sin modificar

    for (fila = 0; fila < 4; fila++) {
        FILAS_LAT = 0x0F;            // Todas filas en alto
        FILAS_LAT &= ~(1 << fila);   // Activa fila (baja)
        Delay_us(20);

        for (col = 0; col < 4; col++) {
            if (!(FILAS_PORT & (1 << (col + 4)))) { // Si columna baja (tecla presionada)
                while (!(FILAS_PORT & (1 << (col + 4)))); // Espera que se suelte (antirrebote)
                return tecla_map[fila][col];
            }
        }
    }
    return 0; // Ninguna tecla presionada
}

#endif