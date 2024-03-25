#include <stdio.h>

int mytime = 0x5957;
char timstr[6];

void delay(int seconds) {
    int i, j;
    for (i = 0; i < seconds; ++i) {
        for (j = 0; j < 1000000; ++j) {
            // Introduce delay
        }
    }
}

void tick() {
    int t0 = mytime;
    t0++;
    if ((t0 & 0xF) >= 10) {
        t0 += 0x6;
        if (((t0 >> 4) & 0x0F) >= 6) {
            t0 += 0xA0;
            if (((t0 >> 8) & 0x0F) >= 10) {
                t0 += 0x600;
                if (((t0 >> 12) & 0x0F) >= 6) {
                    t0 += 0xA000;
                }
            }
        }
    }
    mytime = t0;
}

char hexasc(int a2) {
    char v0;
    v0 = (a2 & 0xF) + '0';
    if ((a2 & 0xF) > 9) {
        v0 += 7;
    }
    return v0;
}

void time2string(char *timstr, int mytime) {
    timstr[0] = hexasc((mytime >> 12) & 0xF);
    timstr[1] = hexasc((mytime >> 8) & 0xF);
    timstr[2] = ':';
    timstr[3] = hexasc((mytime >> 4) & 0xF);
    timstr[4] = hexasc(mytime & 0xF);
    timstr[5] = '\0';
}

int main() {
    char newline = '\n';

    while (1) {
        time2string(timstr, mytime);
        printf("%s", timstr);
        delay(4);
        tick();
        printf("\r"); // Move cursor to the beginning of the line
    }

    return 0;
}