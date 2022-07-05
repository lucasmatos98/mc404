

main:
    # save return address
    addi a0, ra, 0
    call push

    # print menu options
    # TODO uncomment before submission
    lui a0, %hi(.menu_start)
    addi a0, a0, %lo(.menu_start)
    addi t0, zero, 3 # 'print string' OS CALL
    addi a1, zero, 117 # string length
    ecall

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
    addi t1, zero, 4;
    beq a0, t1, div # if option == 4 then div
    

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
    addi s0, a0, 0
    call print_result_text
    addi a0, s0, 0
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
    
    addi s0, a0, 0
    call print_result_text
    addi a0, s0, 0

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
    
    # a0 = abs(t1) and a1 = abs(t2)Q
    addi a0, t1, 0
    call getAbsolute
    addi t1, a0, 0

    addi a0, t2, 0 # a0 = first multiplier
    call getAbsolute
    addi a1, t1, 0 # a1 = second multiplier

    # calculate product
    call multiply
    
    addi t1, zero, 1
    beq t3, t1, mult_div_return_is_negative
    
    addi s0, a0, 0
    call print_result_text
    addi a0, s0, 0

    call printPositive
    j end

div:
    # save first dividend to t1 and a1
    call readInt
    addi t1, a0, 0
    
    # save second divisor to t2 and a2
    call readInt
    addi t2, a0, 0

    # check if dividend is zero
    beq t1, zero, returnIsZero

    # check if divisor is zero
    beq t2, zero, division_by_zero

    # check if first int is negative
    addi a0, t1, 0
    call checkIfNegative
    addi t3, a0, 0

    # check if second int is negative
    addi a0, t2, 0
    call checkIfNegative
    add t3, t3, a0
    # case one is negative and one is positive then t3 = 1, else t3 = 0 or t3 = 2

    # a0 = abs(t1) and a1 = abs(t2)Q
    addi a0, t1, 0
    call getAbsolute
    addi t1, a0, 0

    addi a0, t2, 0 # a0 = divisor
    call getAbsolute
    addi a1, t1, 0 # a1 = dividend

    call divide

    addi t1, zero, 1
    beq t3, t1, mult_div_return_is_negative

    addi s0, a0, 0
    call print_result_text
    addi a0, s0, 0

    addi a0, a1, 0
    call print_div_remainder

    j end

print_result_text:
    lui a0, %hi(.result)
    addi a0, a0, %lo(.result)
    addi t0, zero, 3 # 'print string' OS CALL
    addi a1, zero, 27 # string length
    ecall
    ret

print_div_remainder:
    addi s0, a0, 0
    lui a0, %hi(.div_remainder)
    addi a0, a0, %lo(.div_remainder)
    addi t0, zero, 3 # 'print string' OS CALL
    addi a1, zero, 22 # string length
    ecall
    addi a0, s0, 0

    call printPositive
    ret

returnIsZero:
    addi a0, zero, 0
    addi t0, zero, 1
    ecall
    j end

returnIsNegative:
    addi s0, a0, 0
    call print_result_text
    addi a0, s0, 0
    call printNegative
    j end

mult_div_return_is_negative:
    addi s0, a0, 0
    call print_result_text
    addi a0, s0, 0
    addi a1, a0, 0
    call print_minus_sign
    addi a0, a1, 0
    call printPositive
    j end

readInt:
    lui a0, %hi(.read_int_text)
    addi a0, a0, %lo(.read_int_text)
    addi t0, zero, 3 # 'print string' OS CALL
    addi a1, zero, 20 # string length
    ecall

    addi t0, zero, 4 # 'read int' OS CALL
    ecall
    ret

checkIfNegative:
    lui a1, %hi(.aux)
    addi a1, a1, %lo(.aux)
    lw a1, 0(a1) # a1 = 2^31 = 10000000 00000000 00000000 00000000

    and a0, a0, a1
    slt a0, a0, zero # if argument is negative then a0 = 1
    ret

getAbsolute:
    # return absolute value
    addi a3, ra, 0
    call push
    call checkIfNegative
    addi a2, a0, 0 # a2 = isNegative

    # case is negative then negate and add one
    call pop
    addi a1, zero, 1
    beq a2, a1, invert

    # case is positive just return
    jr a3

invert:
    not a0, a0 
    addi a0, a0, 1
    jr a3

divide:
    addi a3, a0, 0 # a3 = divisor
    addi a0, zero, 0 # a0 = result
    addi a4, zero, 0
divide_loop:
    # case if dividend is less than divisor return
    blt a1, a3, finish_division 
    sub a1, a1, a3
    addi a4, a4, 1
    j divide_loop

finish_division:
    addi a0, a4, 0
    ret

division_by_zero:
    lui a0, %hi(.division_by_zero_text)
    addi a0, a0, %lo(.division_by_zero_text)
    addi t0, zero, 3 # 'print string' OS CALL
    addi a1, zero, 19 # TODO insert proper string length
    ecall
    j end

multiply:
    addi a3, a0, 0
    addi a0, zero, 0
multiply_loop:
    add a0, a0, a3
    addi a1, a1, -1
    bgt a1, zero, multiply_loop
    ret

negateAndAddOne:
    # convert to C2 value
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
.section .data
.aux:
    .word 0x80000000
.rodata

.error_message:
    .word 0x6163704f
    .word 0x6e69206f
    .word 0x696c6176
    .word 0x00006164

.division_by_zero_text:
    .word 0x4f525245 # TODO insert proper string
    .word 0x6944203a
    .word 0xe3736976
    .word 0x6f70206f
    .word 0x00302072

.menu_start:
    .word 0x6f637345 # menu
    .word 0x2061686c
    .word 0x20616d75
    .word 0x20736164
    .word 0x7265706f
    .word 0x656f6361
    .word 0x62612073
    .word 0x6f786961
    .word 0x0000003a
    .word 0x0000000a # pula linha
    .word 0x0000000a # pula linha
    .word 0x202d2031 # soma
    .word 0x616d6f73
    .word 0x00000000
    .word 0x0000000a # pula linha
    .word 0x202d2032 # subtracao
    .word 0x74627573
    .word 0xe3e76172
    .word 0x0000006f
    .word 0x0000000a # pula linha
    .word 0x202d2033 # multiplicacao
    .word 0x746c756d
    .word 0x696c7069
    .word 0xe3e76163
    .word 0x0000006f
    .word 0x0000000a # pula linha
    .word 0x202d2034 # divisao
    .word 0x69766964
    .word 0x006fe373
    .word 0x0000000a # pula linha

.result:
    .word 0x6572204f
    .word 0x746c7573
    .word 0x206f6461
    .word 0x6f206164
    .word 0x61726570
    .word 0x206f6163
    .word 0x00203ae9

.div_remainder:
    .word 0x6572204f
    .word 0x206f7473
    .word 0x64206164
    .word 0x73697669
    .word 0xe9206f61
    .word 0x0000203a

.read_int_text:
    .word 0x69736e49
    .word 0x75206172
    .word 0x706f206d
    .word 0x6e617265
    .word 0x203a6f64