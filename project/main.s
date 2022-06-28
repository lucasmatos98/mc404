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
    addi t1, zero, 2;
    beq a0, t1, subtraction # if option == 2 then sub
    addi t1, zero, 3;
    beq a0, t1, multiplication # if option == 3 then mul
    

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

subtraction:
    # save first int to t1
    call readInt
    addi t1, a0, 0

    # save second int to t2
    call readInt
    addi t2, a0, 0

    # save difference to a0 and t1
    sub a0, t1, t2
    addi t1, a0, 0
    
    call checkIfNegative
    addi t2, a0, 0 # t2 = isNegative
    addi a0, t1, 0 # a0 = difference
    
    bne t2, zero, returnIsNegative
    
    call printPositive
    j end

multiplication:
    # save first int to t1 and a1
    call readInt
    addi t1, a0, 0
    addi a1, a0, 0
    
    # save second int to t2 and a2
    call readInt
    addi t2, a0, 0
    addi a2, a0, 0
    
    # check if first int is zero
    beq t1, zero, returnIsZero

    # check if second int is zero
    beq t2, zero, returnIsZero

    # check if first int is negative
    addi a0, t1, 0
    call checkIfNegative
    addi t3, a0, 0

    # check if second int is negative
    addi a0, t2, 0
    call checkIfNegative
    add t3, t3, a0
    # case one is negative and one is positive then t3 = 1, else t3 = 0 or t3 = 2
    
    # a0 = |t1| and a1 = |t2|
    addi a0, t1, 0
    call getAbsolute
    addi a1, a0, 0
    addi a0, t2, 0
    call getAbsolute

    # calculate product
    call multiply
    
    addi t1, a0, 1
    bne t3, t1, returnIsNegative
    
    call printPositive
    j end

returnIsZero:
    addi a0, zero, 0
    addi t0, zero, 1
    ecall
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
    slt a0, a0, zero # if argument is negative then a0 = 1
    ret

getAbsolute:
    # return absolute value
    call push
    call checkIfNegative

    # case is negative then negate and add one
    call pop
    addi a1, zero, 1
    beq a0, a1, negateAndAddOne

    # case is positive just return
    ret

multiply:
    addi a3, a0, 0
multiply_loop:
    addi a0, a3, 0
    addi a1, zero, -1
    bne a1, zero, multiply_loop
    ret

negateAndAddOne:
    # convert to absolute value
    not a0, a0 
    addi a0, a0, 1
    ret

print_minus_sign:
    addi t0, zero, 2
    addi a0, zero, 45
    ecall
    ret

printNegative:
    # make it positive
    call negateAndAddOne
    addi a1, a0, 0

    # print minus sign
    call print_minus_sign

    # print number
    addi a0, a1, 0
    call printPositive
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
    # TODO add menu options for SUB and MULT
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
# TODO add error message for division by zero
# TODO add error message for overflow