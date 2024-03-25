#include <stdio.h>

int main() {
    char s0 = 0x30;
    char t0 = 0x5b;

    while (s0 != t0) {
        putchar(s0); // syscall 11 prints one byte from a0 to the console

        s0++;
    }

    while (1) {
        // Loop forever
    }

    return 0;
}