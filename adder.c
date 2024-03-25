#include <stdio.h>

const char *result_message = "The sum of 5 and 7 is: ";

int main() {
    int t0 = 5;
    int t1 = 7;
    int t2;

    // Calculate the sum of 5 and 7
    t2 = t0 + t1;

    // Print the message
    printf("%s", result_message);

    // Print the sum result
    printf("%d", t2);

    return 0;
}