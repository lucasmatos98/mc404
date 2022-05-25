lesser:
    addi t4, t3, 0; # t4 = t3 + 0
    jal checkGreater  # jump to checkGreater and save position to ra

greater:
    addi t5, t3, 0; # t5 = t3 + 0
    jal sum  # jump to sum and save position to ra

main:
# load a string of length 10
    lui s0,%hi(vetor)
    addi s0,s0,%lo(vetor)
    addi t3,zero,5
    addi t0, zero, 4
    addi a1, zero, 5
volta:
    ecall
    sw a0, 0(s0)
    addi s0,s0,4
    addi t3,t3,-1
    bne t3,zero,volta
    
    addi a2, zero, 5; # a2 = zero + 5
    lui s0,%hi(vetor)
    addi s0,s0,%lo(vetor)
    addi t4, zero, 2147483647; # t4 = zero + 2147483647
    
checkLesser:
    lw t3, 0(s0)
    blt t3, t4, lesser
checkGreater:
    bgt t3, t5, greater
sum:
    add t6, t6, t3; # t6 = t6 + t3    
    addi s0, s0, 4; # s0 = s0 + 4
    addi a2, a2, -1; # a2 = a2 -1
    bne a2, zero, checkLesser; # if s0 != zero then checkLesser

    addi t0, zero, 3
    lui a0, %hi(.more)

    addi a0, a0, %lo(.more)
    addi a1, zero, 7
    ecall

    addi t0, zero, 2
    addi a0, zero, 13 
    ecall

    add a0, t4, zero; # a0 = t4 + zero
    addi t0, zero, 1
    ecall

.section .data
vetor:
.word 00000000
.word 00000000
.word 00000000
.word 00000000
.word 00000000

.rodata
.more:
    .word 0x65726F6D
    
