.section .data
.menu:
    .word 0x206d6542
    .word 0x646e6976
    .word 0x4520216f
    .word 0x6c6f6373
    .word 0x75206168
    .word 0x6f20616d
    .word 0x6f616370
    .word 0x65704f0a
    .word 0x6f636172
    .word 0x0a3a7365
    .word 0x20202e31
    .word 0x616d6f73
    # .word 0x202e320a
    # .word 0x62757320
    # .word 0x63617274
    # .word 0x330a6f61
    # .word 0x6d20202e
    # .word 0x69746c75
    # .word 0x63696c70
    # .word 0x6f616361
    # .word 0x202e340a
    # .word 0x76696420
    # .word 0x6f617369
    # .word 0x6f430a0a
    # .word 0x7265766e
    # .word 0x73656f73
    # .word 0x2e350a3a
    # .word 0x65642020
    # .word 0x616d6963
    # .word 0x6170206c
    # .word 0x62206172
    # .word 0x72616e69
    # .word 0x360a6169
    # .word 0x6420202e
    # .word 0x6d696365
    # .word 0x70206c61
    # .word 0x20617261
    # .word 0x61786568
    # .word 0x69636564
    # .word 0x0a6c616d
    # .word 0x20202e37
    # .word 0x616e6962
    # .word 0x20616972
    # .word 0x61726170
    # .word 0x63656420
    # .word 0x6c616d69
    # .word 0x202e380a
    # .word 0x6e696220
    # .word 0x61697261
    # .word 0x72617020
    # .word 0x65682061
    # .word 0x65646178
    # .word 0x616d6963
    # .word 0x2e390a6c
    # .word 0x65682020
    # .word 0x65646178
    # .word 0x616d6963
    # .word 0x6170206c
    # .word 0x64206172
    # .word 0x6d696365
    # .word 0x310a6c61
    # .word 0x68202e30
    # .word 0x64617865
    # .word 0x6d696365
    # .word 0x70206c61
    # .word 0x20617261
    # .word 0x616e6962
    # .word 0x00616972

.opcao:
    .word 0x6e694d0A
    .word 0x6f206168
    .word 0x6f616370
    .word 0x0000203a

.insira:
    .word 0x72746e45
    .word 0x3a616461
    .word 0x00000020

.saida:
    .word 0x61732041
    .word 0x20616469
    .word 0x00206d65

.teveoverflow:
    .word 0x76756f48
    .word 0x766f2065
    .word 0x6c667265
    .word 0x2021776f
    .word 0x746c6f56
    .word 0x6f646e61
    .word 0x72617020
    .word 0x206f2061
    .word 0x756e656d
    .word 0x0000000a

.outdec:
    .word 0x69636564
    .word 0x206c616d
    .word 0x203a6865

.resto:
    .word 0x206d6f43
    .word 0x74736572
    .word 0x00203a6f

.section .text
menu:
    addi t0, zero, 3
    lui a0, %hi(.menu)
	addi a0, a0, %lo(.menu)
    addi a1, zero, 273
    #addi a1, zero, 273
    ecall
    jr ra

opcao:
    # printa a frase
    addi t0, zero, 3
    lui a0, %hi(.opcao)
	addi a0, a0, %lo(.opcao)
    addi a1, zero, 14
    ecall
    
    # pega o digito
    addi t0, zero, 4
    ecall
    add t4, zero, a0
    jr ra

saida:
    addi t0, zero, 3
    addi a0, zero, 0
    lui a0, %hi(.saida)
	addi a0, a0, %lo(.saida)
    addi a1, zero, 11
    ecall
    jr ra

teveoverflow:
    addi t0, zero, 3
    lui a0, %hi(.teveoverflow)
	addi a0, a0, %lo(.teveoverflow)
    addi a1, zero, 37
    ecall
    j main

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


    # Primeiro verifica overflow se os sinais forem iguais
    # isso por que se forem diferentes, o maior com o menor da 0

    # ainda nao implementado mesmo sinal
    #slti s0, t6, 0
    #slt s1, t2, t5
    #bne t1, t2, teveoverflow # Basicamente, verifica se o numero nao trocou de sinal    

    negativooutdec:
        bge t2, zero, printa    #
            addi t0, zero, 2
            addi a0, zero, 45   # isso aqui printa o sinal negativo
            ecall

            sub t2, zero, t2    # inverte o numero

        printa:                 # aqui printa
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

    ret

insira:
    addi t0, zero, 3
    lui a0, %hi(.insira)
	addi a0, a0, %lo(.insira)
    addi a1, zero, 10
    ecall
    ret

dec: # retorna decimal em a0
    addi sp, sp, -4
    sw ra, 0(sp)

    call insira

    lw ra, 0(sp)
    addi sp, sp, 4

    addi t0, zero, 4
    ecall
    ret

str: # retorna string em a0
    addi t0, zero, 6
    addi a1, zero, 32
    ecall
    ret

strlen: # recebe string em a0, conserva a0 e retorna tam em t2
    addi s1, a0, 0
    addi s2, zero, 32
    addi t2, zero, 0

    loopstrlen:
        lbu t1, 0(s1)
        beq t1, s2, fimstrlen
        beq t1, zero, fimstrlen
        addi s1, s1, 1
        addi t2, t2, 1
        j loopstrlen
    
    fimstrlen:
        addi t2, t2, -1
        ret

strinvertida: # recebe str em a0 e tamanho em a1
    add s1, a0, a1 # joga string pro final em s1
    addi s1, s1, -1
    addi t0, zero, 2
    loopinverte: # vai printando cada char
        lbu a0, 0(s1)
        ecall

        addi s1, s1, -1
        addi a1, a1, -1
        bne a1, zero, loopinverte

    fiminvertestr:

    ret

### opcoes

# SOMA
# recebe t5 e t6 (decimais)
# soma os dois e retorna em t2
soma:
    add t2, t5, t6
    ret

# SUBTRACAO
# recebe t5 e t6 (decimais)
# subtrai de t6 o t5 e retorna em t2 
sub:
    sub t2, t5, t6
    ret

# MULTIPLICACAO
# recebe t5 e t6 (decimais)
# multiplica t5 e t6 e retorna em t2 
mult:
    # Vou deslocando o multiplicador para a direita ate ele ser zero
    # isso garante que o loop, ai uso xor para ver se e 0 ou 1
    # e o multiplicando para esquerda para somar
    # se for 1 eu somo
    # t5 e o multiplicando e t5 o multiplicador
    # o primeiro digito eh guardado no s0
    addi t2, zero, 0
    loopmult:
        # verifica se o s0 eh um
        addi s0, t5, 0
        slli s0, s0, 31
        srli s0, s0, 31
        beq s0, zero, multdesloc; # if s0 == zero then multdesloc
            add t2, t2, t6
        
        multdesloc:  # faz os deslocamentos da multiplicacao
            srli t5, t5, 1
            slli t6, t6, 1
            bne t5, zero, loopmult # if t5 != zero then loopmult

    ret

# DIVISAO
# recebe t5 e t6 (decimais)
# divide t5 por t6 e retorna em t2 

errodivfracao:
ret

errodivzero:
ret

div: # divide t5 por t6, traz o resultado em t2 e o resto em t1
    # aqui verifica os erros
    # erro t6 menor q t5
    #blt t5, t6, errodivfracao # se t5 for menor que t6, a div target

    # erro div por 0
    beq t6, zero, errodivzero # erro de divisao por 0

    # pega tamanhos
    addi s5, t5, 0 # preserva t5
    addi s6, t6, 0 # preserva t6
    
    addi sp, sp, -4
    sw ra, 0(sp)
    call dectobin   # pega os tamanhos de t5 e t6
    lw ra, 0(sp)
    addi sp, sp, 4

    addi s7, a1, 0  # e salva em s7 e s8
    addi t5, s6, 0
    
    addi sp, sp, -4
    sw ra, 0(sp)
    call dectobin
    lw ra, 0(sp)
    addi sp, sp, 4

    addi s8, a1, 0

    sub s3, s7, s8 # diferenca de tamanho

    loopigualadiv: # iguala os dois usando s3
        slli s6, s6, 1
        addi s3, s3, -1
        bne s3, zero, loopigualadiv

    addi t2, zero, 0

    sub s3, s7, s8
    addi s3, s3, 1
    addi a1, s3, 0
    loopdiv: # dividendo vai ser s6 e divisor s5 e o resultado em t2
        addi s2, zero, 48
        blt s5, s6, fimloopdiv  # se dividendo for menor divisor, pula
            addi s2, zero, 49    # se der pra fazer a divisao, resultado vai 1
            sub s5, s5, s6

        fimloopdiv:
            sb s2, 0(a0)
            addi a0, a0, 1 # move s2 para proxima div

            srli s6, s6, 1
            addi s3, s3, -1
            bne s3, zero, loopdiv

    sb zero, 0(a0)
    sub a0, a0, a1
    addi sp, sp, -4
    sw ra, 0(sp)
    call bintodec
    lw ra, 0(sp)
    addi sp, sp, 4
    
    addi t1, s5, 0
    ret

dectobin: # recebe um decimal em t5 e retorna em a0 e tamanho em a1
    addi t6, zero, 0  # conta quantos bits tem
    loopdectobin:
        addi s0, t5, 0     #
        slli s0, s0, 31    # pega o primeiro bit sempre
        srli s0, s0, 31    # 
        addi s1, zero, 48

        beq s0, zero, salvabin; # se s0 == zero ele vai direto para o print
            addi s1, s1, 1      # senao, ele soma um antes de printar

        salvabin:
            sb s1, 0(a0)
            addi t6, t6, 1
        
        addi a0, a0, 1
        srli t5, t5, 1 # Tira o primeiro binario
        bne t5, zero, loopdectobin # if t5 != zero then loopmult
    
    printadectobin:    # printa o binario pegando
        sub a0, a0, t6 
        addi a1, t6, 0

    ret

bintodec: # recebe palavra em a0 e retorna dec em t2
    addi sp, sp, -4
    sw ra, 0(sp)
    call strlen
    lw ra, 0(sp)
    addi sp, sp, 4

    addi s1, t2, 0   # tamanho da string
    addi t2, zero, 0 # reseta t2
    addi s3, zero, 0
    add a0, a0, s1   # joga a0 pro final

    addi t5, zero, 1
    loopbintodec:
        addi t6, zero, 2
        lbu t1, 0(a0)
        addi t1, t1, -48
        beq zero, t1, bintodecinc; # if t0 == t1 then target
            add s3, s3, t5

        bintodecinc:
            addi sp, sp, -4
            sw ra, 0(sp)
            call mult
            lw ra, 0(sp)
            addi sp, sp, 4
            
            addi t5, t2, 0
            addi a0, a0, -1

            beq s1, zero, fimbintodec
            addi s1, s1, -1
            j loopbintodec

    fimbintodec: # verifica negativo do bin to dec
        addi t2, s3, 0
        ret
    
dectohex:
    addi s4, sp, -40
    addi a2, zero, 0
    loopdectohex: # Enquanto o res da divisao for maior que 16, fica no loop 
        addi a0, zero, 0
        addi t6, zero, 16 # t6 eh sempre 16

        addi sp, sp, -4
        sw ra, 0(sp)
        call div   # pega os tamanhos de t5 e t6
        lw ra, 0(sp)
        addi sp, sp, 4

        # aqui converte o resultado para o seu respectivo ASCII
        # se menor que 9 ele so soma 10, senao, soma 55 
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
        addi t6, zero, 16 # t6 eh sempre 16
        blt t2, t6, fimdectohex # se o res da div for menor que 16, vai po fim
                                # caso nao, salva resto na pilha e res como t5
            addi t5, t2, 0
            j loopdectohex

    fimdectohex: # salva o ultimo resto e resultado
        addi t6, zero, 10
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
        
        sub a0, s4, a1
        
    ret

hextodec:
    
    ret

bintohex:

    ret

hextobin:

    ret

### final

escolhas:
    # Cada funcao usa um BEQ
    # somo RA pra evitar loop

    # vai para aritmetica
    addi t3, zero, 5
    blt t4, t3, aritmetica

    # vai para decimais
    addi t3, zero, 7
    blt t4, t3, decimais

    # vai para binarias
    addi t3, zero, 9
    blt t4, t3, binarias

    # vai para hexadecimais
    addi t3, zero, 11
    blt t4, t3, hexadecimais

    j final

    aritmetica:
        call dec        # pega os dois decimais
        addi t5, a0, 0  # e salva para t5 e t6
        call dec        #
        addi t6, a0, 0  #

        addi t3, zero, 1
        addi ra, ra, 16
        beq t4, t3, soma

        addi t3, zero, 2
        addi ra, ra, 12
        beq t4, t3, sub

        addi t3, zero, 3
        addi ra, ra, 12
        beq t4, t3, mult

        addi t3, zero, 4
        addi ra, ra, 12
        beq t4, t3, div

        call outdec
        j main

    decimais:
        call dec
        addi t5, a0, 0

        addi t3, zero, 5
        addi ra, ra, 12
        beq t4, t3, dectobin

        addi t3, zero, 6
        addi ra, ra, 16
        beq t4, t3, dectohex
        
        call strinvertida
        j main

    binarias:
        call str

        addi t3, zero, 7
        addi ra, ra, 12
        beq t4, t3, bintodec
        call outdec

        addi t3, zero, 8
        beq t4, t3, bintohex

        j main

    hexadecimais:
        addi t3, zero, 9
        beq t4, t3, hextodec

        addi t3, zero, 10
        beq t4, t3, hextobin

main:
    # Usando t5 e t6 como os registradores para operacoes 
    # t4 para opcao t3 para switch case
    # t2 para resultado
    # O menu para as 4 informacoes, saida e 
    # nao achado tmb
    # vai de 1 a 5, sendo 5 a saida e um invalido
    # se o numero nao for de 1 a 5, eh invalido

    # salva e recupera servem para
    # salvar os valores de a0, a1 e t0
    # muito util para recuperar rapidamente
    call menu
    call opcao
    call escolhas
    
    final: