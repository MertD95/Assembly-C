.data
result_message: .asciiz "The factorial of 5 is: "

    .text
    .globl main

main:
    li $t0, 5       # $t0 will hold our N value, which is 5 in this case
    li $t1, 1       # $t1 will keep the running product, starts at 1 (since 1 is the multiplicative identity)

calculate_factorial:
    beq $t0, 1, end_loop  # If N is 1, we've finished calculating the factorial
    mul $t1, $t1, $t0     # Multiply the current product by N ($t0)
    sub $t0, $t0, 1       # Decrement N by 1
    j calculate_factorial # Jump back to start of loop

end_loop:
    # Print the result message
    li $v0, 4
    la $a0, result_message
    syscall

    # Print the factorial result
    li $v0, 1
    move $a0, $t1
    syscall

    # Exit the program
    li $v0, 10
    syscall
