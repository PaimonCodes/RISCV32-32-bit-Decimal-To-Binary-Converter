##
## 32-bit Integer to Binary Converter 


# assign s1 = quotient, s2 = remainder, s3 = amount of bits, t1 = 2 = divisor

.data
    integer: .word 4294967295            # values from 0 to 4294967295

    output: .string "Binary = "
    newline: .string "\n"

.text

.globl _start

_start:
    # Calculate the amount of bits will be represented
    lw s0, integer
    mv t0, s0
    li t2, 0x1
    jal log2n
    addi s3, t1, 0x1

    # Get -*(bits need) for stack initialization
    sub t0, x0, s3

    # Initialize stack to hold the result
    add sp, sp, t0            # create stack to hold the result
    add t0, x0, x0            # i = 0
    addi t1, x0, 0x2          # Set divisor = 2
    jal s5, convertToBinary   # Begin converting

    li a0, 0x4
    la a1, output             # load Output message
    ecall
    addi t0, s3, -0x1         # The range of the used stack is [0(sp) - [bits_amount - 1](sp)] inclusive
    jal printResult           # Print the stored binary values off the stack
    addi sp, sp, s3           # Release stack

    jal x0, Exit

log2n:
    # log2n algorithm
    # Calculate floor[log2n] without fractional part
    srl t0, t0, t2     # n >> 1
    add t1, t1, t2     # bits++
    blt t2, t0, log2n   # 1 < n, loop again
    jalr ra

convertToBinary:    # Positive integer to binary conversion process
    # Do division and get quotient and remainder
    jal division
    
    # Store in stack the remainder
    add s4, t0, sp
    sb s2, 0(s4)                
    addi t0, t0, 0x1

    # Reset division parameters for next possible iteration
    add t3, x0, x0              # Reset t3 repetion iterator
    addi t1, x0, 0x2            # Reset t1 divisor = 2 (binary)
    mv s0, s1                   # Set new dividend to be the quotient

    # Check if quotient is 0, if it is not, continue dividing by 2
    bne s1, x0, convertToBinary 

    # If quotient = 0, finish and return
    jalr s5

division:
    # Slow division algorithm
    # parameters -- s0 is the dividend and t1 is the divisor, t3 repetition iterator
    # return the results in registers s1, and s2
    # Quotient s1, Remainder s2

    CheckParams:
        # Do checks (0/Divisor), (n/n)
        beq s0, x0, ResultIs0                   # Check if 0/Divisor
        beq s0, t1, ResultIs1                   # Check if (n/n)
        jal x0, Init
    
    ResultIs0:
        addi s1, x0, 0                          # Set Quotient = 0
        addi s2, x0, 0                          # Set Remainder = 0
        jal x0, exitDivision                    # Go to exitDivision

    ResultIs1:
        addi s1, x0, 0x1                        # Set Quotient = 1
        addi s2, x0, 0                          # Set Remainder = 0
        jal x0, exitDivision                    # Go to exitDivision
    
    Init:
        # Initialize parameters
        add s1, x0, x0
        addi t4, x0, 0x1F                       # Repetitions
        add s2, x0, s0                          # Set Initial Remainder = Dividend
        slli t1, t1, 0x1E                       # Shift left 30 bits the divisor

    Iterate:
        addi t3, t3, 0x1                        # Increment repetition
        sub s2, s2, t1                          # Rem = Rem - Div
        bge s2, zero, SLLQ1                     # If Rem > 0, go to SLLQ1

        # Else
        add s2, s2, t1                          # Restore Remainder                           
        slli s1, s1, 0x1                        # Shift left Quotient 1 bit, setting least bit = 0
        jal x0, ShiftDivisorRight               # Go to ShiftDivisorRight

    SLLQ1:
        slli s1, s1, 0x1                        # Shift left Quotient 1 bit
        ori s1, s1, 0x1                         # Set least bit of Quotient to 1

    ShiftDivisorRight:
        srli t1, t1, 0x1                        # Shift right divisor 1 bit
        blt t3, t4, Iterate                     # Check if iterator is less than repetition constant

    exitDivision:
        jalr ra                                 # return to main


printResult:
    # Print starting from the bottom to the top of the stack
    li a0, 0x1
    add t1, sp, t0
    lb a1, 0(t1)
    ecall
    addi t0, t0, -1

    # Check if all items in stack are printed
    # If not, continue printing
    bge t0, x0, printResult

    # Print newline
    li a0, 0x4
    la a1, newline
    ecall
    jalr ra

Exit:
    li a0, 0xA
    ecall

