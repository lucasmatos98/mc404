# Mensagem de entrada
menu:
    addi t0, zero, 3
    lui a0, %hi(.menu)
    addi a0, a0, %lo(.menu)
    addi a1, zero, 102
    ecall
    jr ra

# Informa qual o valor digitado e armazena
escolha:
    addi t0, zero, 3
    addi a1, zero, 27
    lui a0, %hi(.escolha)
    addi a0, a0, %lo(.escolha)
    ecall

    addi t0, zero, 4
    ecall
    add t4, zero, a0
    jr ra

saida:
    addi t0, zero, 3
    addi a0, zero, 0
    lui a0, %hi(.saida)
	addi a0, a0, %lo(.saida)
    addi a1, zero, 10
    ecall
    jr ra


outdec:
    # Printa saida 'A saida em decimal eh:'
    addi sp, sp, -4
    sw ra, 0(sp)
    call saida
    lw ra, 0(sp)
    addi sp, sp, 4

    addi a0, zero, 0
    lui a0, %hi(.outdec)
	addi a0, a0, %lo(.outdec)
    addi a1, zero, 12
    ecall

    negativooutdec:
        bge t2, zero, printa   
            addi t0, zero, 2
            addi a0, zero, 45 
            ecall

            sub t2, zero, t2   

        printa:               
            addi t0, zero, 1
            addi a0, t2, 0
            ecall
        
        addi s3, zero, 4
        bne t4, s3, fimoutdec
            addi t4, zero, 0
            addi t2, t1, 0

            # printa resto
            addi t0, zero, 3
            addi a0, zero, 0
            lui a0, %hi(.resto)
            addi a0, a0, %lo(.resto)
            addi a1, zero, 11
            ecall
            j negativooutdec

        fimoutdec:

    j fim

insira:
    addi t0, zero, 3
    lui a0, %hi(.insira)
	addi a0, a0, %lo(.insira)
    addi a1, zero, 10
    ecall
    ret

# Retorna o decimal recebido
decimal:
    addi sp, sp, -4
    sw ra, 0(sp)
    call insira
    lw ra, 0(sp)
    addi sp, sp, 4
    addi t0, zero, 4
    ecall
    ret

# Retorna a string recebida
stringretorno:
    addi t0, zero, 3
    addi a1, zero, 40
    lui a0, %hi(.inserirconversao)
    addi a0, a0, %lo(.inserirconversao)
    ecall

    addi t0, zero, 6
    addi a1, zero, 32
    ecall
    ret

# Retorna o tamanho da string recebida
stringtamanho:
    addi s1, a0, 0
    addi s2, zero, 32
    addi t2, zero, 0

    lacotam:
        lbu t1, 0(s1)
        beq t1, s2, lacofinaltam
        beq t1, zero, lacofinaltam
        addi s1, s1, 1
        addi t2, t2, 1
        j lacotam
    
    lacofinaltam:
        addi t2, t2, -1
        ret

# String printada ao inverso, cada caractere por vez
stringinvertida:
    add s1, a0, a1
    addi s1, s1, -1
    addi t0, zero, 2

    lacoinversao:
        lbu a0, 0(s1)
        ecall
        addi s1, s1, -1
        addi a1, a1, -1
        bne a1, zero, lacoinversao

    fiminvertestr:
        addi a0, zero, 10
        ecall

    j fim

# MULTIPLICACAO


# Entradas: t5 e t6
# Saída: t2

# - O valor que multiplica (t5) é deslocado para a direita até que seja igual a 0
# - Já o valor a ser multiplicado (t6) é deslocado para a esquerda para ser somado quando for igual a 1


multiplicacao:
    addi t2, zero, 0

    lacom:
        addi s0, t5, 0
        slli s0, s0, 31
        srli s0, s0, 31
        beq s0, zero, desloc
            add t2, t2, t6
        
        desloc:
            srli t5, t5, 1
            slli t6, t6, 1
            bne t5, zero, lacom

    ret

# DIVISAO

# Dividendo: t5
# Divisor: t6
# Quociente: t2
# Resto: t1

divisao:

    addi s5, t5, 0
    addi s6, t6, 0
    addi s3, zero, 1
    lacod1:
        slli s3, s3, 1
        slli s6, s6, 1
        bge s5, s6, lacod1

    srli s6, s6, 1
    srli s3, s3, 1
    addi t2, zero, 0
    lacod2:
        blt s5, s6, lacofinal
            add t2, t2, s3
            sub s5, s5, s6
        lacofinal:
            srli s6, s6, 1
            srli s3, s3, 1
            bne s3, zero, lacod2
    addi t1, s5, 0
    ret

# Recebe um numero decimal e retorna em binario
    # O tamanho é armazenado em a1
    
dectobin: 
    lui a0, %hi(binario)
    addi a0, a0, %lo(binario)

    # Contagem de bits
    # s0 = 0, print / s0 = 1, incrementa e print
    addi t6, zero, 0
    lacodecpbin:
        addi s0, t5, 0     
        slli s0, s0, 31    
        srli s0, s0, 31     
        addi s1, zero, 48

        beq s0, zero, guardado
            addi s1, s1, 1      

        guardado:
            sb s1, 0(a0)
            addi t6, t6, 1
        
        addi a0, a0, 1
        srli t5, t5, 1
        bne t5, zero, lacodecpbin 
    
    printadectobin:    
        sub a0, a0, t6
        addi a1, t6, 0

    ret

# Recebe um numero binario e retorna em decimal
bintodec:
    addi sp, sp, -4
    sw ra, 0(sp)
    call stringtamanho
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, t2, 0   
    addi t2, zero, 0 
    add a0, a0, s1   
    addi t5, zero, 1

    loopbintodec:
        lbu t1, 0(a0)
        addi t1, t1, -48
        beq zero, t1, bintodecinc
            add t2, t2, t5

        bintodecinc:
            slli t5, t5, 1
            addi a0, a0, -1
            beq s1, zero, fimbintodec
            addi s1, s1, -1
            j loopbintodec

    fimbintodec:
        ret

# Recebe um numero decimal e retorna em hexadecimal   
dectohex:
    addi t0, zero, 3
    addi a1, zero, 30
    lui a0, %hi(.hexa)
    addi a0, a0, %lo(.hexa)
    ecall
    blt zero, t5, lacodectohex
        sub t5, zero, t5

    lacodectohex:
        addi t6, zero, 16

        addi sp, sp, -4
        sw ra, 0(sp)
        call divisao
        lw ra, 0(sp)
        addi sp, sp, 4
        addi t6, zero, 9
        blt t6, t1, hexchar
            addi t1, t1, 48

            j salvahex

        hexchar:
            addi t1, t1, 55

        salvahex:
        sb t1, 0(s4)
        addi s4, s4, 1
        addi a2, a2, 1
        addi t6, zero, 16
        blt t2, t6, fimdectohex
                                
            addi t5, t2, 0
            j lacodectohex

    fimdectohex:
        addi t6, zero, 9
        blt t6, t2, fimhexchar
            addi t2, t2, 48
            j fimsalvahex
        fimhexchar:
            addi t2, t2, 55
        fimsalvahex:
        sb t2, 0(s4)
        addi s4, s4, 1
        addi a2, a2, 1
        addi a1, a2, 0
        
        lui a0, %hi(hexa)
        addi a0, a0, %lo(hexa)
        
    ret

# Recebe um numero hexadecimal e retorna em decimal
hextodec:
    addi sp, sp, -4
    sw ra, 0(sp)
    call stringtamanho
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, t2, 0  
    addi t2, zero, 0 
    add a0, a0, s1  
    addi s8, zero, 1
    addi s3, zero, 0

    lacohextodec:
        lbu t6, 0(a0)
        addi t1, zero, 57
        blt t1, t6, hextodecchar
            addi t6, t6, -48

            j salvahextodec

        hextodecchar:
            addi t6, t6, -55

        salvahextodec:
            addi t5, s8, 0
            addi sp, sp, -4
            sw ra, 0(sp)
            call multiplicacao
            lw ra, 0(sp)
            addi sp, sp, 4
            add s3, s3, t2
            addi a0, a0, -1
            beq s1, zero, fimhextodec
            slli s8, s8, 4
            addi t5, s8, 0
            addi s1, s1, -1

            j lacohextodec

    fimhextodec:
        addi t2, s3, 0
        ret

# Recebe um numero binario e retorna em hexadecimal
bintohex:
    addi sp, sp, -4
    sw ra, 0(sp)
    call bintodec
    lw ra, 0(sp)
    addi sp, sp, 4
    add t5, zero, t2
    addi sp, sp, -4
    sw ra, 0(sp)
    call dectohex
    lw ra, 0(sp)
    addi sp, sp, 4

    ret

# Recebe um numero hexadecimal e retorna em binario
hextobin:
    addi sp, sp, -4
    sw ra, 0(sp)
    call hextodec
    lw ra, 0(sp)
    addi sp, sp, 4
    add t5, zero, t2
    addi sp, sp, -4
    sw ra, 0(sp)
    call dectobin
    lw ra, 0(sp)
    addi sp, sp, 4

    ret

selecao:
    # Decimal
    addi t3, zero, 7
    blt t4, t3, dec

    # Binario
    addi t3, zero, 9
    blt t4, t3, bin

    # Hexadecimail
    addi t3, zero, 11
    blt t4, t3, hex

    j fim

    dec:
        call decimal
        addi t5, a0, 0
        addi t3, zero, 5
        addi ra, ra, 16
        beq t4, t3, dectobin
        beq t4, t3, stringinvertida
        addi t3, zero, 6
        addi ra, ra, 16
        beq t4, t3, dectohex
        beq t4, t3, stringinvertida
        
        j fim

    bin:
        call stringretorno
        addi t3, zero, 7
        addi ra, ra, 12
        beq t4, t3, bintodec
        beq t4, t3, outdec
        addi t3, zero, 8
        addi ra, ra, 16
        beq t4, t3, bintohex
        beq t4, t3, stringinvertida

        j fim

    hex:
        call stringretorno
        addi t3, zero, 9
        addi ra, ra, 12
        beq t4, t3, hextodec
        beq t4, t3, outdec
        addi t3, zero, 10
        addi ra, ra, 16
        beq t4, t3, hextobin
        beq t4, t3, stringinvertida

        j fim

# Registradores: t6 e t5
# Opcao selecionada: t4
# Resultado das operacoes: t2
main:
    addi sp, sp, -4
    sw ra, 0(sp)
    call menu
    call escolha
    call selecao

fim:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

.section .data
.insira:
    .word 0x72746e45
    .word 0x3a616461
    .word 0x00000020

.resto:
    .word 0x206d6f43
    .word 0x74736572
    .word 0x00203a6f

.hexa:
    .word 0x6572204f
    .word 0x746c7573
    .word 0x206f6461
    .word 0x63206164
    .word 0x65766e6f
    .word 0x6f617372
    .word 0x72617020
    .word 0x65682061
    .word 0x65646178
    .word 0x616d6963
    .word 0x3ae9206c
    .word 0x00000020

binario:
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

.outdec:
    .word 0x63656420
    .word 0x6c616d69
    .word 0x203ae920

.outstr:
    .word 0x72747320
    .word 0x3a676e69
    .word 0x00000020

.menu:
    .word 0x766e6f43
    .word 0x6f737265
    .word 0x0a3a7365
    .word 0x65442e35
    .word 0x61702063
    .word 0x42206172
    .word 0x360a6e69
    .word 0x6365442e
    .word 0x72617020
    .word 0x65482061
    .word 0x2e370a78
    .word 0x206e6942
    .word 0x61726170
    .word 0x63654420
    .word 0x422e380a
    .word 0x70206e69
    .word 0x20617261
    .word 0x0a786548
    .word 0x65482e39
    .word 0x61702078
    .word 0x44206172
    .word 0x310a6365
    .word 0x65482e30
    .word 0x61702078
    .word 0x42206172
    .word 0x00006e69

.escolha:
    .word 0x0000000a
    .word 0x706f2041
    .word 0x206f6163
    .word 0x6f637365
    .word 0x6469686c
    .word 0x6f662061
    .word 0x00203a69

.inserirconversao:
    .word 0x69736e49
    .word 0x6f206172
    .word 0x6d756e20
    .word 0x206f7265
    .word 0x20657571
    .word 0x65736564
    .word 0x6320616a
    .word 0x65766e6f
    .word 0x72657472
    .word 0x0000203a

.saida:
    .word 0x61732041
    .word 0x20616469
    .word 0x00006d65

.section .text