.macro PUSH %reg
    addi    $sp, $sp, -4      # Decrement stack pointer to make space
    sw      %reg, 0($sp)      # Store the value of the register onto the stack
.end_macro

# Define macro for popping a value from the stack into a register
.macro POP %reg
    lw      %reg, 0($sp)      # Load value from the stack into the register
    addi    $sp, $sp, 4       # Increment stack pointer to release space
.end_macro

# Data segment for storing static data
.data
.align 2                      # Align data on a halfword boundary for efficiency
mytime: .word 0x5957          # Initial time in hexadecimal format (23:27 in HH:MM)
timstr: .space 6              # Allocate 6 bytes for the time string "HH:MM\0".

# Text segment for storing the code
.text
.globl main

# Main function
main:
    la      $a0, timstr       # Load address of the time string into $a0
    li      $v0, 4            # Load system call code for print_string into $v0
    syscall                   # Execute system call to print the time string

    li      $a0, 4            # Load delay duration (in seconds) into $a0
    jal     delay             # Call delay function to slow down the program execution

    la      $a0, mytime       # Load address of current time into $a0
    jal     tick              # Call tick function to update the time

    la      $a0, timstr       # Load address of time string into $a0
    lw      $a1, mytime       # Load current time into $a1
    jal     time2string       # Call time2string function to convert time to string

    li      $a0, '\n'         # Load newline character into $a0
    li      $v0, 11           # Load system call code for print_char into $v0
    syscall                   # Execute system call to print newline

    j       main              # Jump back to the beginning of main to continuously update time

# Function to increment the time
tick:	
    lw      $t0, 0($a0)       # Load current time from memory into $t0
    addiu   $t0, $t0, 1       # Increment the time by 1
    # Check if the units place of minutes exceeds 9, if so, adjust other digits accordingly
    andi    $t1, $t0, 0xf     # Extract the units place of minutes
    sltiu   $t2, $t1, 0xa     # Check if the value is less than 10
    bnez    $t2, tiend        # If less than 10, no adjustment needed, go to end
    addiu   $t0, $t0, 0x6     # Adjust units place of minutes
    andi    $t1, $t0, 0xf0    # Extract tens place of minutes
    sltiu   $t2, $t1, 0x60    # Check if the value is less than 60
    bnez    $t2, tiend        # If less than 60, no adjustment needed, go to end
    addiu   $t0, $t0, 0xa0    # Adjust tens place of minutes
    andi    $t1, $t0, 0xf00   # Extract units place of hours
    sltiu   $t2, $t1, 0xa00   # Check if the value is less than 10
    bnez    $t2, tiend        # If less than 10, no adjustment needed, go to end
    addiu   $t0, $t0, 0x600   # Adjust units place of hours
    andi    $t1, $t0, 0xf000  # Extract tens place of hours
    sltiu   $t2, $t1, 0x6000  # Check if the value is less than 60
    bnez    $t2, tiend        # If less than 60, no adjustment needed, go to end
    addiu   $t0, $t0, 0xa000  # Adjust tens place of hours

tiend:	
    sw      $t0, 0($a0)       # Store updated time back to memory
    jr      $ra               # Return from the subroutine

# Function to convert a single hex digit to its ASCII representation
hexasc:
    andi    $t0, $a2, 0xF     # Extract the lowest 4 bits (a single hex digit)
    li      $v0, 0x30         # Load ASCII value of '0' into $v0
    add     $v0, $t0, $v0     # Add digit to ASCII '0' to get correct ASCII value
    ble     $t0, 0x9, calc    # If digit is less than or equal to 9, no adjustment needed
    addi    $v0, $v0, 0x7     # Adjust ASCII value for letters A-F

calc:
    jr      $ra               # Return from the subroutine

# Function to introduce a delay
delay:
    li      $t0, 0            # Initialize loop counter to 0
    li      $t1, 1000         # Set maximum count for delay loop
while: 
    ble     $a0, 1, calc      # Check if delay duration is less than or equal to 1
    sub     $a0, $a0, 1       # Decrement delay duration
    for:
    beq     $t0, $t1, while   # Exit inner loop if loop counter equals maximum count
    addi    $t0, $t0, 1       # Increment loop counter
    j       for               # Continue inner loop

# Function to convert time to string
time2string:
    # Process the high byte (Hours tens)
    andi    $t1, $a1, 0xf000    # Extract the tens place of hours
    srl     $t1, $t1, 12        # Shift to get the value of tens place
    PUSH    $ra                 # Push return address onto the stack
    move    $a2, $t1            # Move the tens place value to argument register $a2
    jal     hexasc              # Call hexasc to convert to ASCII
    POP     $ra                 # Restore return address from the stack
    sb      $v0, 0($a0)         # Store ASCII character for tens place of hours into memory

    # Process the second byte (Hours units)
    andi    $t1, $a1, 0x0f00    # Extract the units place of hours
    srl     $t1, $t1, 8         # Shift to get the value of units place
    PUSH    $ra                 # Push return address onto the stack
    move    $a2, $t1            # Move the units place value to argument register $a2
    jal     hexasc              # Call hexasc to convert to ASCII
    POP     $ra                 # Restore return address from the stack
    sb      $v0, 1($a0)         # Store ASCII character for units place of hours into memory

    # Store ':' between hours and minutes
    li      $t1, 0x3A           # Load ASCII value for ':' into $t1
    sb      $t1, 2($a0)         # Store ':' between hours and minutes in the time string

    # Process the third byte (Minutes tens)
    andi    $t1, $a1, 0x00f0    # Extract the tens place of minutes
    srl     $t1, $t1, 4         # Shift to get the value of tens place
    PUSH    $ra                 # Push return address onto the stack
    move    $a2, $t1            # Move the tens place value to argument register $a2
    jal     hexasc              # Call hexasc to convert to ASCII
    POP     $ra                 # Restore return address from the stack
    sb      $v0, 3($a0)         # Store ASCII character for tens place of minutes into memory

    # Process the fourth byte (Minutes units)
    andi    $t1, $a1, 0x000f    # Extract the units place of minutes
    PUSH    $ra                 # Push return address onto the stack
    move    $a2, $t1            # Move the units place value to argument register $a2
    jal     hexasc              # Call hexasc to convert to ASCII
    POP     $ra                 # Restore return address from the stack
    sb      $v0, 4($a0)         # Store ASCII character for units place of minutes into memory

    # Null-terminate the string
    li      $t1, 0x00           # Load ASCII NULL terminator
    sb      $t1, 5($a0)         # Store NULL terminator at the end of the time string

    jr      $ra                 # Return from the subroutine

# End of MIPS assembly code