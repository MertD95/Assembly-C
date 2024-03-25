.data
result_message: .asciiz "The sum of the first 10 natural numbers is: "

    .text
    .globl main

main:
    li $t0, 10      # $t0 will keep our N value, which is 10
    li $t1, 0       # $t1 will keep the current sum, starts at 0
    li $t2, 1       # $t2 will keep our current number to add, starts at 1

loop:
    add $t1, $t1, $t2   # Add current number $t2 to sum $t1
    addi $t2, $t2, 1    # Increment current number by 1
    bne $t2, $t0, loop  # If $t2 is not equal to N ($t0), loop again
    add $t1, $t1, $t2   # Add the last number since loop exits one early

    # Print the result message
    li $v0, 4
    la $a0, result_message
    syscall

    # Print the sum result
    li $v0, 1
    move $a0, $t1
    syscall

    # Exit the program
    li $v0, 10
    syscall
