
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

.section .data
vetor:
.word 00000000
.word 00000000
.word 00000000
.word 00000000
.word 00000000
