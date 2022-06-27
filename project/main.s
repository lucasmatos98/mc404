main:
    # save return address
    addi sp, sp, -4
    sw ra, 0(sp)

    # print menu options
    lui a0, %hi(.menu_start)
    addi a0, a0, %lo(.menu_start)
    addi t0, zero, 3 # 'print string' OS CALL
    addi a1, zero, 25 # string length
    ecall

    # read option
    addi t0, zero, 4; # 'read int' OS CALL
    ecall

    # jump to chosen operation
    addi t1, zero, 1
    beq a0, t1, sum; # if option == 1 then sum

    # show error message
    lui a0, %hi(.error_message)
    addi a0, a0, %lo(.error_message)
    addi t0, zero, 3 # 'print string' OS CALL
    addi a1, zero, 22 # string length
    ecall
end:
    # load return address and exit
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
sum:
    # save first int to t1
    addi t0, zero, 4; # 'read int' OS CALL
    ecall
    addi t1, a0, 0

    # save second int to t2
    addi t0, zero, 4 # redundant
    ecall
    addi t2, a0, 0

    # save sum to a0 and print it
    add a0, t1, t2

    # check if it is negative
    andi t3, a0, 2147483648
    
    # TODO

    addi t0, zero, 1
    ecall
    
    # exit
    j end

.rodata
.menu_start:
    .word 0x6F6F6843 # 43 68 6F 6F
    .word 0x6F206573 # 73 65 20 6F
    .word 0x61726570 # 70 65 72 61
    .word 0x6E6F6974 # 74 69 6F 6E
    .word 0x29310A3A # 3A 0A 31 29
    .word 0x4D555320 # 20 53 55 4D
    .word 0x0000000A
.error_message:
    .word 0x4F525245 # 45 52 52 4F
    .word 0x49203A52 # 52 3A 20 49
    .word 0x6C61766E # 6E 76 61 6C
    .word 0x6F206469 # 69 64 20 6F
    .word 0x6F697470 # 70 74 69 6F
    .word 0x00000A6E # 6E
    .text