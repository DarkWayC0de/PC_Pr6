                 .data

Titulo:             .asciiz "Práctica 6 de Principios de computadores. Potencia."
Modo:               .asciiz "\nIntrozuca 0 para hacerlo iterativo, otro número para recursivo:\t"
Exponente:          .asciiz "Introduzca el exponente:\t"
Base:               .asciiz "Introduzca la base:\t"
Resultado:          .asciiz "El resultado es:\t"

                 .text


#-----------------------------REGISTROS-------------------
# $f12-$f13  -  Base
# $a0        -  Exponente
# $f0        -  Resultado
# $t0        -  Contador
# $f16       -  Un 1 (Para poder dividir)

main:
    add $sp,$sp,-32                 #Reservamos 1 doble como primer argumento,3 argumentos simples,relleno para multiplo
                                    #de 8 $ra y relleno para  multiplo de 8
    sw $ra, 24($sp)                 #Guardamos ra de main

    li $v0,4
    la $a0,Titulo
    syscall

    li $v0,4
    la $a0,Modo
    syscall

    li $v0,5
    syscall
    move $t0,$v0

    li $v0,4
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

    beq $t0,$zero,ite

    jal potenciaRC
    j terminar

ite:
    jal potenciaIT

terminar:

    li $v0,4
    la $a0,Resultado
    syscall

    li $v0,3
    mov.d $f12,$f0
    syscall

    lw $ra, 24($sp)
    add $sp,$sp,-32 #restauramos la pila
    jr $ra


# ······························--- SUBRUTINAS DE POTENCIA ---···································
# ...................................ITERATIVA...................................................
potenciaIT:
    add $sp,$sp,-32                 #Reservamos 1 doble como primer argumento,3 argumentos simples,relleno para multiplo
                                    #de 8 $ra y relleno para  multiplo de 8
    sw $ra, 24($sp)                 #guaramos en pila $ra
    s.d $f12, 32($sp)               #guardamos los argumentos
    sw $a0,40($sp)

    beq $a0,$zero,exponentezeroIT

    bgt $a0,$zero,nonegativoIT
                                    #Caso de que sea negativo
    sub $a0,$zero,$a0               #Pasamos exponente a positivo

    jal calculoIT

    li.d $f16,1.0
    div.d $f0,$f16,$f0

    j finpotenciaIT
nonegativoIT:

    jal calculoIT


    j finpotenciaIT
exponentezeroIT:

    jal Comprobar

finpotenciaIT:
    lw $ra,24($sp)                  #restauramos $ra
    addu $sp,$sp,32                 #restauramos la pila
    jr $ra                          #volvemos al main



calculoIT:
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

#·········································RECURSIVA····················································
potenciaRC:
    add $sp,$sp,-32                 #Reservamos 1 doble como primer argumento,3 argumentos simples,relleno para multiplo
                                    #de 8 $ra y relleno para  multiplo de 8
    sw $ra, 24($sp)                 #guaramos en pila $ra
    s.d $f12, 32($sp)               #guardamos los argumentos
    sw $a0,40($sp)

    beq $a0,$zero,exponentezeroRC
    bgt $a0,$zero,nonegativoRC

    sub $a0,$zero,$a0               #Pasamos exponente a positivo

    jal potenciaRC


    li.d $f16,1.0
    div.d $f0,$f16,$f0              #Calculamos resultado correcto
    j finRC
nonegativoRC:
        sub $a0,$a0,1                   #A la siguiente llamada le debe llegar $a0-1

        jal potenciaRC                   #Llamada recursiva

        mul.d $f0,$f0,$f12
        j finRC

exponentezeroRC:
    jal Comprobar

finRC:
    lw $ra,24($sp)                  #restauramos ra
    addu $sp,$sp,32                 #restauramos pila
    jr $ra


#··································---SUBRUTINAS---·······································

Comprobar:
    li.d $f0,1.0
    jr $ra
