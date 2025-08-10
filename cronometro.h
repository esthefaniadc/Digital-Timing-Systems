#ifndef _CRONOMETRO_H_
#define _CRONOMETRO_H_

// Variables estáticas para el cronómetro
static unsigned char minutos = 0;
static unsigned char segundos = 0;
static unsigned char decimas = 0;

// Inicializa el cronómetro
void Cronometro_Init() {
    minutos = 0;
    segundos = 0;
    decimas = 0;
}

// Reinicia el cronómetro
void Cronometro_Reset() {
    minutos = 0;
    segundos = 0;
    decimas = 0;
}

// Llamar cada ciclo del main (cada 10 ms, pues Delay_ms(10) en el main)
// Solo se debe llamar cuando el cronómetro está activo
void Cronometro_Tick() {
    static unsigned char ms10_count = 0;
    ms10_count++;
    if(ms10_count >= 10) { // 10*10ms = 100ms = 0.1s (décima)
        ms10_count = 0;
        decimas++;
        if(decimas >= 10) {
            decimas = 0;
            segundos++;
            if(segundos >= 60) {
                segundos = 0;
                minutos++;
                if(minutos >= 100) { // Tope 99:59.9
                    minutos = 0;
                }
            }
        }
    }
}

// Muestra el tiempo en la segunda línea del LCD: MM:SS.d
void Cronometro_Mostrar() {
    char buffer[9]; // MM:SS.d + null
    char minStr[4], segStr[4];

    ByteToStrWithZeros(minutos, minStr);   // " 00"
    ByteToStrWithZeros(segundos, segStr);  // " 00"

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

#endif