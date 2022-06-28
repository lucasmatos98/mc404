main:
    # save return address
    addi a0, ra, 0
    call push

    # print menu options
    # TODO uncomment before submission
    # lui a0, %hi(.menu_start)
    # addi a0, a0, %lo(.menu_start)
    # addi t0, zero, 3 # 'print string' OS CALL
    # addi a1, zero, 25 # string length
    # ecall

    # read option
    addi t0, zero, 4 # 'read int' OS CALL
    ecall

    # jump to chosen operation
    addi t1, zero, 1
    beq a0, t1, sum # if option == 1 then sum

    # show error message
    lui a0, %hi(.error_message)
    addi a0, a0, %lo(.error_message)
    addi t0, zero, 3 # 'print string' OS CALL
    addi a1, zero, 22 # string length
    ecall

    j end
end:
    # load return address and exit
    call pop
    addi ra, a0, 0
    jr ra
    
sum:
    # save first int to t1
    call readInt
    addi t1, a0, 0

    # save second int to t2
    call readInt
    addi t2, a0, 0

    # save sum to a0 and t1
    add a0, t1, t2
    addi t1, a0, 0

    call checkIfNegative
    addi t2, a0, 0 # t2 = isNegative
    addi a0, t1, 0 # a0 = sum

    bne t2, zero, returnIsNegative

    call printPositive
    j end

returnIsNegative:
    call printNegative
    j end

readInt:
    addi a0, zero, 4 # 'read int' OS CALL
    ecall
    ret


checkIfNegative:
    # check if it is negative
    andi a0, a0, 2147483648 # 2^31
    ret

printNegative:
    # make it positive
    not a0, a0 
    addi a1, a0, 1

    # print minus sign
    addi t0, zero, 2
    addi a0, zero, 45
    ecall

    # print number
    addi a0, a1, 0
    addi t0, zero, 1
    ecall
    ret

printPositive:
    addi t0, zero, 1
    ecall
    ret

push:
    addi sp, sp, -4
    sw a0, 0(sp)
    ret
pop:
    lw a0, 0(sp)
    addi sp, sp, 4
    ret

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