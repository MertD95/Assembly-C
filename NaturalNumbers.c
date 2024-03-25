#include <stdio.h>

const char *result_message = "The sum of the first 10 natural numbers is: ";

int main() {
    int t0 = 10; // N value
    int t1 = 0;  // Current sum
    int t2 = 1;  // Current number to add

    // Loop to calculate sum
    while (t2 != t0) {
        t1 += t2;   // Add current number t2 to sum t1
        t2++;       // Increment current number by 1
    }
    t1 += t2; // Add the last number since loop exits one early

    // Print the result message
    printf("%s", result_message);

    // Print the sum result
    printf("%d", t1);

    return 0;
}