#include <stdio.h>

char hexasc(int a2) {
    char v0;
    v0 = (a2 & 0xF) + '0';
    if ((a2 & 0xF) > 9) {
        v0 += 7;
    }
    return v0;
}

int main() {
    int a0 = 15; // change this to test different values

    char result = hexasc(a0);

    putchar(result);

    while (1) {
        // Loop forever
    }

    return 0;
}