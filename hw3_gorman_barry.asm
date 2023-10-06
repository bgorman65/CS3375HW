

# Data section
.data 

# Creating needed variables, arrays and strings for program
    msg_bigger: .asciiz "bigger.. \n"
    msg_same: .asciiz "same.. \n"
    msg_smaller: .asciiz "smaller.. \n"
    msg_largest_1: .asciiz "The largest number is "
    msg_largest_2: .asciiz ". \n"
    msg_occurances_1: .asciiz "The largest number is included "
    msg_occurances_2: .asciiz " times. \n"
    space: .asciiz " "
    newline: .asciiz "\n"
    length: .word 13
    array: .word 5, 2, 15, 3, 7, 15, 8, 9, 5, 2, 15, 3, 7



.text                                       
.globl main                                 

main:                                       
    
    la $t1, array                           # Getting adress of array into $t1
    li $t2, 0                               # Setting array counter
    lw $t3, length                          # Setting length into $t3 
    
    print_arr:                              # Label for the loop to print the array

        beq $t2, $t3, print_arr_end         # Checking for the end of the array
        lw $a0, ($t1)                       # Loading the value at the array pointer into $a0
        li $v0, 1                           # Loading print_int into $v0
        syscall                             # Calling print_int
        li $v0, 4                           # Loading print_str into $v0    
        la $a0, space                       # Loadind address of space into $a0
        syscall                             # Calling print_str
        addi $t2, $t2, 1                    # Incrementing array counter
        addi $t1, $t1, 4                    # Incrementing array pointer
        j print_arr                         # Repeating the loop

    print_arr_end:                          # Label to end the loop 

    la $a0, newline                         # Loading newline address into $a0
    syscall                                 # Calling print_str

    la $t1, array                           # Getting adress of array into $t1
    li $t2, 0                               # Setting array counter
    lw $t3, length                          # Setting length into $t3 
    li $t4, 0                               # Largest temp variables
    addi $sp, $sp, -4                       # Making space in stack pointer for return address
    sw $ra, 4($sp)                          # Storing the return address

    compare_loop:                           # Label for the compare loop

        beq $t2, $t3, compare_loop_end      # Checking for end of array
        
        lw $a1, ($t1)                       # Loading value from array into $a1
        jal compare_int                     # Calling compare_int
        beq $v1, 2, case0                   # Checking equivalence to 2
        beq $v1, 1, case1                   # Checking equivalence to 1
        beq $v1, 0, case2                   # Checking equivalence to 0

        case0:                              # Label for case 0

            move $t4, $a1                   # Setting largest variable
            li $t5, 1                       # Setting counter to one
            la $a0, msg_bigger              # Loadind address of message into $a0
            li $v0, 4                       # Loading print_str into $v0 
            syscall                         # Calling print_str
            j end_switch                    # Jumping to end of switch  

        case1:                              # Label for case 1
        
            addi $t5, $t5, 1                # Incrementing counter
            la $a0, msg_same                # Loadind address of message into $a0
            li $v0, 4                       # Loading print_str into $v0
            syscall                         # Calling print_str
            j end_switch                    # Jumping to end of switch

        case2:                              # Label for case 2
        
            la $a0, msg_smaller             # Loadind address of message into $a0
            li $v0, 4                       # Loading print_str into $v0
            syscall                         # Calling print_str
            j end_switch                    # Jumping to end of switch



        end_switch:                         # Label to end the switch case
                                
            addi $t2, $t2, 1                # Incrementing array counter
            addi $t1, $t1, 4                # Incrementing array pointer
        
    j compare_loop                          # Repeating the loop
    
    compare_loop_end:                       # Label to end loop
    
    li $v0, 4                               # Loading print_str into $v0    
    la $a0, msg_largest_1                   # Loading address of msg_largest_1 into $a0
    syscall                                 # Calling print_str    
    move $a0, $t4                           # Loading the largest element into $a0
    li $v0, 1                               # Loading print_int into $v0
    syscall                                 # Calling print_int
    li $v0, 4                               # Loading print_str into $v0    
    la $a0, msg_largest_2                   # Loading address of msg_largest_2 into $a0
    syscall                                 # Calling print_str
    la $a0, msg_occurances_1                # Loading address of msg_occurances_1 into $a0
    syscall                                 # Calling print_str
    li $v0, 1                               # Loading print_int into $v0
    move $a0, $t5                           # Loading count into $a0
    syscall                                 # Calling print_int
    li $v0, 4                               # Loading print_str into $v0    
    la $a0, msg_occurances_2                # Loading address of msg_occurances_2 into $a0
    syscall                                 # Calling print_str
    lw $ra, 4($sp)                          # Retreiving the return address
    addi $sp, $sp, 4                        # Restorign stack pointer
    jr $ra                                  # Jumping to return address to end program



# Creating the subtract function
subtract:                                   # Label for the subtract function
    
    sub $v1, $t4, $a1                       # Subtracting $a1 from $a0 and storing value in $v0
    jr $ra                                  # Jumping to return address




# Creating the compare function
compare_int:                                # Label for the compare function

    addi $sp, $sp, -4                       # Making space in stack pointer for return address
    sw $ra, 4($sp)                          # Storing the return address
    jal subtract                            # Calling subtract
    bgt $zero, $v1, bigger                  # Checking if $v1 is greater than 0
    beq $zero, $v1, equal                   # Checking if $v1 is equal to 0
    addi $v1, $zero, 0                      # Setting $v1 to 0 if cases arent met
    j end_compare_int                       # Jumping to end_compare_int

    bigger:                                 # Creating bigger label

        addi $v1, $zero, 2                  # Assigning 2 to $v1
        j end_compare_int                   # Jumping to end_compare_int

    equal:                                  # Creating equal label

        addi $v1, $zero, 1                  # Assigning 2 to $v1
        j end_compare_int                   # Jumping to end_compare_int

    end_compare_int:                        # Creating end_compare_int label

        lw $ra, 4($sp)                      # Retreiving the return address
        addi $sp, $sp, 4                    # Restorign stack pointer
        jr $ra                              # Returning to return address