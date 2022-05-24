.section .text

main:
    # read input int to a1
    addi t0, zero, 4
    ecall
    add a1,zero,a0

    # read input int to a2
    addi t0, zero, 4
    ecall
    add a2,zero, a0

    # save state
    add a3,zero,a2
    
    # corrects var
    addi a1,a1,-2

loop:
    add a2,a2,a3
    addi a1,a1,-1
    bge a1, zero, loop

    #move result to a0
    add a0,zero,a2

    # print a0
    addi t0,zero,1
    ecall

    jr ra