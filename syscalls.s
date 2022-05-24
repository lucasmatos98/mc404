	addi	zero,zero,0 
kernel:             
	addi	sp,zero,1536
	call	main        
	addi	zero,zero,0 
	mv      s1,a0   
	addi	zero,zero,0 
	addi	zero,zero,0 
	auipc	ra,0x0      
	jalr	ra,0(ra)    
	addi	zero,zero,0 
	addi	zero,zero,0 

main:
    ######################################### 
    # this file will show you how to use    #
    # system calls in the BRISC-V emulator! #
    ######################################### 
    # 
    # let's start by loading an integer from the user
    # putting 4 in register t0 an calling ecall does that
    addi t0, zero, 4
    # after ecall is run, a box will pop up in the console
    # write a (small) number and press enter to continue 
    ecall
    # let's print that integer multiplied by two 
    slli a0, a0, 1
    addi t0, zero, 1
    ecall
    # now, let's try working with strings and memory
    # read a character 
    addi t0, zero, 5
    ecall
    # print the same character and a newline
    addi t0, zero, 2
    ecall
    addi t0, zero, 2
    addi a0, zero, 13 
    ecall
    # let's statically allocate a string "HELLO!"
    # we start this by creating a read-only data section
    .rodata
.HELLO:
    # strings should end with the null terminator \0
    # the null terminator's binary value is 0!
    # we split HELLO!\0 into two 32bit words:
    # HELL and O!00 - note that thats an "O!" and 2 zeros
    # we write HELL in ascii:
    # H - 0x48
    # E - 0x45
    # L - 0x4C
    # since this is a little-endian architecture, we 
    # write HELL in reverse - LEHH
    .word 0x4C4C4548
    # now we write the second part O!00
    .word 0x0000214F
    # this section is parsed when you load the program - 
    # not when the instruction pointer runs over it.
    # as soon as you loaded the program, you should see 
    # this string in the memory pane's data section, 
    # somewhere close to the bottom of it. 
    # 
    # now we can go back to a text section that has code
    .text
    # print the string "HELLO!\n"
    addi t0, zero, 3         # this is the string printing syscall 
    lui a0, %hi(.HELLO)      # this loads the top 20 bits 
                             # of .HELLO address into a0
    addi a0, a0, %lo(.HELLO) # this loads the bottom 12 bits
    addi a1, zero, 7         # length of the string
    ecall
    # print characters '!', '\n', '-'
    addi t0, zero, 2
    addi a0, zero, 33 
    ecall
    addi t0, zero, 2
    addi a0, zero, 13 
    ecall
    addi t0, zero, 2
    addi a0, zero, 45 
    ecall
    # load a string of length 10
    addi t0, zero, 6
    addi a0, sp, -10
    addi a1, zero, 10
    ecall
    # print the same string again 
    addi t0, zero, 3
    addi a0, sp, -10  # address of the string start
    addi a1, zero, 10  # length of the string
    ecall
    # finally, let's try and allocate some memory with SBRK 
    addi t0, zero, 7     # SBRK syscall 
    addi a0, zero, 16    # allocate 4 words
    ecall                # heap memory (purple) should be 
                         # 4 lines long in the memory pane
    # try and deallocate some memory with SBRK 
    addi t0, zero, 7     # SBRK syscall 
    addi a0, zero, -16   # deallocate 4 words
    ecall                # heap memory (purple) should be 
                         # 0 lines long in the memory pane
    # allocate too many words
    addi t0, zero, 7     # SBRK syscall 
    addi a0, zero, 10000 # allocate 2500 words
    ecall                # an error should pop up
    # return
	jr	ra
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	auipc	ra,0x0     
	jalr	ra,0(ra)   
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
