.section .text

main:
    # read input int to t0
    addi t0, zero, 4
    ecall
    add t1,zero,a0

    addi t0, zero, 4
    ecall
    add a0,t1, a0

    # print a0
    addi t0,zero,1
    ecall

    jr ra