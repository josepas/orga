.data

alfab:		.asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
.align 2
mensaje: 	.space 4096
resultado: 	.space 4096
dicc:		.word 0 0 0	# Cabeza del diccionario (*inicio, tamano, *final)
nulo:		.asciiz " "
	
.text

# $s0 direccion de la cabeza del diccionario
# $s5 caracter a ser reemplazado por nulo (para indicar fin de cadena)
# $t2 contador de veces que se ha agregado
# $t3 itera sobre las direcciones de alfab
#################### INICIALIZAR EL DICCIONARIO ####################
main:	
	li $a0 12	
	li $v0 9
	syscall 	# Creo un Nodo (*Cadena, indice, *sig)
	
	sw $v0 dicc	# Actualizacion de *inicio
	la $s0 dicc				
	sw $v0 8($s0)	# Actualizacion de *final
	addi $t1 $s0 8
	move $t7 $t1
	
	li $a0 2
	li $v0 9
	syscall 	# Reservo el espacio para la cadena
	
	la $t1 alfab	# Obtengo la letra A
	
	lb $t2 0($t1)	# Meto la cadena y el carater nulo
	sb $t2 0($v0)
	sb $zero 1($v0)
	
	lw $t1 0($s0)	# Obtengo el apuntador al primero
	sw $v0 0($t1)	# Enlazo la A con el Nodo
	
	li $t1 1
	sw $t1 4($s0)	# Inicializo el tamano en 1
	
	la $t3 alfab
	addi $t3 $t3 1	# Inicio el iterador de la cadena en B
	li $t2 1	# Inicio el contador de iteracines en 1
	li $a0 1	# El tamano de las cadenas inic. es ctte.

itrInic:
	lb $s5 1($t3)
	sb $zero 1($t3)	# Reemplazo el siguiente caracter por uno nulo
	move $a1 $t3
	jal agregarAlDicc
	sb $s5 1($t3)	# Recupero el byte reemplazado
	
	addi $t3 $t3 1 	# Paso al siguiente caracter
	addi $t2 $t2 1
	bne $t2 27 itrInic
	
####################   LECTURA DE LA CADENA   ####################

	la $a0 mensaje  
	li $a1 255
	li $v0 8
	syscall

# $s1 inicio de la cadena
# $s2 guarda la letra en la que coloco el fin de cadena
# $s3 guarda el indice a imprimir
# $s4 tamano de la cadena a construir
####################           LZW            ####################

	la $t6 mensaje
	la $t4 resultado# Contador para agregar a la cadena resultado
	li $s4 1 			
	move $s1 $t6	# Inicializacion del inicio de la cadena a comparar
	
LZW:
	add $t5 $s1 $s4
	lb $s2 0($t5)
	sb $zero 0($t5)	# Delimito la cadena a buscar	 
	
	move $a0 $s1 
	jal buscarCadena
	
	beq $v0 -1 noExiste
	move $s3 $v0
	sb $s2 0($t5)	# Vuelvo a colocar la letra donde habia puesto el 0
	addi $s4 $s4 1	# Aumento el tamano de la cadena encontrada en 1
	
	beq $s2 10 imprimirResultado
	b LZW
		
noExiste: 
	sw $s3 0($t4)	# Meto en resultado el indicie previo $s3
	addi $t4 $t4 4
		
	move $a0 $s4	# Creo la cadena con el tamano $s4 para el char nulo
	move $a1 $s1
	jal agregarAlDicc
		
	sb $s2 0($t5) 	# Vuelvo a colocar la letra donde habia puesto el 0
	addi $s1 $t5 -1 # Nuevo comienzo de mi cadena
	li $s4 1	# Reseteo el tamano de la cadena
		
	b LZW
####################    FINALIZACION     ####################

imprimirResultado:
	sw $v0 0($t4)
	li $t1 -1
	sw $t1 4($t4)	# Agrego un -1 para marcar el final del resultado
	
	la $t0 resultado
	
itrImp:	
	lw $a0 0($t0)
	li $v0 1
	syscall		# Imprimo el indice 
	
	la $a0 nulo
	li $v0 4
	syscall		# Imprimo un espacio
	
	addi $t0 $t0 4
	lw $t1 0($t0)	# Paso al siguiente indice
	bne $t1 -1 itrImp
	
	li $v0 10
	syscall		# Cierro el programa

####################      FUNCIONES      ####################

#Entrada: $a0 dir. de un string
#	  $a1 dir. de otro string
#Salida:  $v0 = 0 si no son iguales
#	  $v0 = 1 si son iguales 
compararStrings:
itr1:		
	lb $t0 0($a0)
	lb $t1 0($a1)	# Cargo el primer caracter de ambas cadenas
	bne $t0 $t1 noSonIguales
	beqz $t0 sonIguales
	addi $a0 $a0 1
	addi $a1 $a1 1	# Paso al siguiente caracter
	b itr1
	
noSonIguales:
	move $v0 $zero
	jr $ra
	
sonIguales:
	li $v0 1
	jr $ra
	

#Entrada: $a0 cadena a buscar
#Salida:  $v0 = -1 si no se encontro la cadena
#	  $v0 = n si se encontro la cadena,donde n es el indice en el dic.
buscarCadena:
	lw $t0 4($s0)
	li $t1 0
	lw $t2 0($s0) # Apuntador al primero
	
itrdicc:	
	lw $a1 0($t2)	
	addi $sp $sp -16
	sw $ra 0($sp)
	sw $a0 4($sp)
	sw $t0 8($sp)
	sw $t1 16($sp)	# Empilo los registros usados en la subrutina
	jal compararStrings
	lw $ra 0($sp)
	lw $a0 4($sp)
	lw $t0 8($sp)
	lw $t1 16($sp)
	addi $sp $sp 16	# Desempilo los registros

	beq $v0 1 perteneceADicc
	addi $t1 $t1 1
	lw $t2 8($t2)
		
	blt $t1 $t0 itrdicc	
	
	li $v0 -1
	jr $ra
	
perteneceADicc:
	lw $v0 4($t2)	# Cargo el indice correspondiente
	jr $ra
	
#Entrada: $a0 tamano de la cadena a crear
#	  $a1 direccion de inicio de la cadena a crear
agregarAlDicc:
	addi $a0 $a0 1
	li $v0 9			
	syscall		# Creo la caja para la cadena
	move $t1 $v0	# Guardo la direccion donde cree la caja
	
llenarDicc:
	lb $t0 0($a1) 	# Obtengo la letra
	sb $t0 0($v0)	# Agrego la letra a la nueva caja
	addi $a1 $a1 1
	addi $v0 $v0 1
	bnez $t0 llenarDicc
	
	li $a0 12
	li $v0 9
	syscall		# Creo el nuevo nodo
	
			# Enlazo la nueva caja al dicc
	lw $t0 8($s0)	# Obtengo el apuntador al ultimo
	sw $v0 8($t0)	# Actualizo el apuntador al siguiente del ultimo previo
	sw $v0 8($s0)	# Actualizo el apuntador al ultimo
	
	sw $t1 0($v0)	# Enlazo el nodo a la cadena
	
	lw $t2 4($s0)
	sw $t2 4($v0)	# Agrego el indice al nuevo nodo
	addi $t2 $t2 1
	sw $t2 4($s0)	# Aumenta el tamano del dicc
		
	jr $ra