main:
    # save current ra to heap
    addi sp, sp, -4
    sw ra, 0(sp)

    call read
    call sort

    # load ra from heap
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
read:
    # save 5 int to memory
    lui s0,%hi(vetor)
    addi s0,s0,%lo(vetor)
    addi t1,zero,5
    addi t0, zero, 4
    addi a1, zero, 5
loop:
    ecall
    sw a0, 0(s0)
    addi s0,s0,4
    addi t1,t1,-1
    bne t1,zero,loop
    addi s0, s0, -4
    ret
# sort vector
sort:
    addi a2, s0, 0
    addi t1, zero, 1
sort_outer_loop:
    addi t6, zero, 5
sort_loop:
    lw t2, 0(s0)
    lw t3, -4(s0)
    blt t2, t3, switch
continue_sort:
    addi s0, s0, -4
    addi t6, t6, -1
    bgt t6, t1, sort_loop
    addi t1, t1, 1
    addi s0, a2, 0
    bne t1, t6, sort_outer_loop
    ret
    


switch:
    sw t2, -4(s0)
    sw t3, 0(s0)
    j continue_sort
    
.section .data
vetor:
.word 00000000
.word 00000000
.word 00000000
.word 00000000
.word 00000000