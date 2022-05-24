# we write MC404! in ascii:
# M 0x4D
# C 0x43
# 4 0x34
# 0 0x30
# 4 0x34
# ! 0x21
main:
    .rodata
.HELLO:
    .word 0x3034434D
    .word 0x00002134
    .text
    addi t0, zero, 3
    lui a0, %hi(.HELLO)

    addi a0, a0, %lo(.HELLO)
    addi a1, zero, 7
    ecall