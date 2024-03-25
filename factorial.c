#include <stdio.h>

const char *result_message = "The factorial of 5 is: ";

int main() {
    int t0 = 5; // N value
    int t1 = 1; // Running product

    // Calculate factorial
    while (t0 != 1) {
        t1 *= t0; // Multiply the current product by N
        t0--;     // Decrement N by 1
    }

    // Print the result message
    printf("%s", result_message);

    // Print the factorial result
    printf("%d", t1);

    return 0;
}