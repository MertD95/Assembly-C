.data
result_message: .asciiz "The sum of 5 and 7 is: "

    .text
    .globl main

main:
    # Calculate the sum of 5 and 7
    li $t0, 5       # Load immediate value 5 into register $t0
    li $t1, 7       # Load immediate value 7 into register $t1
    add $t2, $t0, $t1 # Add the values in $t0 and $t1, result in $t2

    # Print the message
    li $v0, 4       # Load syscall for print string into $v0
    la $a0, result_message # Load address of the message into $a0
    syscall         # Make syscall to print the string

    # Print the sum result
    li $v0, 1       # Load syscall for print integer into $v0
    move $a0, $t2   # Move the sum result into $a0
    syscall         # Make syscall to print the integer

    # Exit the program
    li $v0, 10      # Load syscall for exit into $v0
    syscall         # Make syscall to exit