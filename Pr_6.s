                 .data

Titulo:          .asciiz "Práctica 6 de Principios de computadores. Potencia."
Base:            .asciiz "\nIntroduzca la base:\t"
Exponente:       .asciiz "Introduzca el exponente:\t"
Modo:            .asciiz "Introzuca 0 para hacerlo iterativo, otro número para recursivo:\t"
Resultado:       .asciiz "El resultado es:\t"
Indeterminacion: .asciiz "La operación no puede realizarse, es una indeterminación\n"

                 .text


#-----------------------------REGISTROS-------------------
# $f12-$f13  -  Base
# $a0        -  Exponente
# $f0        -  Resultado
# $t0        -  Contador
# $f16       -  Un 1 (Para poder dividir)

main:

    li $v0,4
    la $a0,Titulo
    syscall

    la $a0,Base
    syscall

    li $v0,7
    syscall
    mov.d $f12,$f0

    li $v0,4
    la $a0,Exponente
    syscall

    li $v0,5
    syscall
    move $a0,$v0

    add $sp,$sp,-16                 #Reservamos 4 words en pila para los argumentos
    jal Potencia


Imprimir:

    add $sp,$sp,16                  #Restauramos puntero de pila
    li $v0,4
    la $a0,Resultado
    syscall

    li $v0,3
    mov.d $f12,$f0
    syscall

fin:                                #Salida del sistema
    li $v0,10
    syscall


# ······························--- SUBRUTINA DE POTENCIA ---···································

Potencia:

    beq $a0,$zero,Comprobar

    sw $a0,12($sp)                  #Guardamos $a0

    li $v0,4
    la $a0,Modo
    syscall

    li $v0,5
    syscall
    move $t0,$v0

    lw $a0,12($sp)                  #Recuperamos $a0

    bgt $a0,$zero,nonegativo
                                    #Caso de que sea negativo
    add $sp,$sp,-8
    sw $ra,4($sp)                   #Guardamos $ra (al main) en pila

    sub $a0,$zero,$a0               #Pasamos exponente a positivo
    bne $t0,$zero,rec               #Saltamos a recursivo si fue la opcion eleginda

    jal iterativo                   #si no saltamos a iterativo
    j deshacercambio

rec:
    jal recursivo                   #Si no a recursivo

deshacercambio:                     #Deshacemos cambio

    li.d $f16,1.0
    div.d $f0,$f16,$f0              #Calculamos resultado final


    lw $ra,4($sp)
    addu $sp,$sp,8                  #Volvemos al main
    jr $ra

nonegativo:                         #Si no es negativo calculamos el resultado normal

    beq $t0,$zero,iterativo
    j recursivo


#·····························································································

iterativo:

   move $t0,$a0                     #Iniciamos contador a $a0
   sub  $t0,$t0,1                   #Restamos uno para iterar hasta $zero
   mov.d $f0,$f12                   #Iniciamos resultado a la base

bucle:
    beq $t0,$zero,salir             #Condicion de salida
    mul.d $f0,$f0,$f12              #Operacion
    sub $t0,$t0,1                   #Contamos iteracion
    j bucle

salir:
    jr $ra                          #Volvemos al main o a deshacer cambio

#······························································································

recursivo:

    beq $a0,0,uno                   #Caso base
    add $sp,$sp,8                   #Reservamos espacio para $ra
    sw $ra,4($sp)                   #Guardamos
    sub $a0,$a0,1                   #A la siguiente llamada le debe llegar $a0-1

    jal recursivo                   #Llamada recursiva

    lw $ra,4($sp)                   #Restauramos $ra
    mul.d $f0,$f0,$f12              #Operacion
    add $sp,$sp,-8                  #Restauramos $ra
    jr $ra

uno:
    li.d $f0,1.0                    #Caso base
    jr $ra


#··································---SUBRUTINAS---·······································

Comprobar:

    mtc1 $a0,$f4
    cvt.d.w $f4,$f4
    c.eq.d $f4,$f12
    bc1t indeterminacion            #Comprobamos si es indeterminacion

    li.d $f0,1.0                    #Si no ya sabemos que n^0 = 1 y salimos
    j Imprimir


indeterminacion:                    #Si es indeterminacion avisamos y salimos

    li $v0,4
    la $a0,Indeterminacion
    syscall

    j fin
