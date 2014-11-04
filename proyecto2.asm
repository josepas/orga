	.data
alfab:	.asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		.align 2
mensaje: .space 1024

resultado: .space 1024

	
dicc:	.word 0 0 0 	# Cabeza del dicc
					# (*inicio, tamano, *final)
	.text
	
main:
	
	# s0 mantengo la direccion del diccionario
	
	#	
	############### INICIALIZAR EL DICCIONARIO ######################
	
	li $a0 12				#	
	li $v0 9				#
	syscall					# Creo un Nodo (*Cadena, indice, *sig)
	
	sw $v0 dicc				# Actualizacion de *inicio
	la $s0 dicc				
	sw $v0 8($s0)			# Actualizacion de *final
	addi $t1 $s0 8
	move $t7 $t1
	
	li $a0 2
	li $v0 9
	syscall 				# Reservo el espacio para la cadena
	
	la $t1 alfab			# Obtengo la letra A
	
	lb $t2 0($t1)			# meto la cadena  y el carater nulo
	sb $t2 0($v0)
	sb $zero 1($v0)
	
	lw $t1 0($s0)			# obtengo el apuntador al primero
	sw $v0 0($t1)			# Enlazo la A con el Nodo
	
	li $t1 1
	sw $t1 4($s0)			# Inicializo el tamano en 1
	
	la $t3 alfab
	addi $t3 $t3 1			# Inicio el iterador de la cadena en B
itr:	bgt $t1 25 fin
			# $t3 iterador en el alfabeto
			li $a0 12
			li $v0 9
			syscall			# Reservo el espacio del nodo
			
			lw $t4 8($s0)	# Obtengo el apuntador al ultimo
			sw $v0 8($t4)	# Actualizo el apuntador al siguiente del ultimo
			sw $v0 8($s0)	# Actualizo el apuntador al ultimo
			
			li $a0 1
			li $v0 9		# Espacio para la cadena
			syscall
			
			lb $t4 0($t3) 	# Obtengo la letra 
			
			sb $t4 0($v0)   # La meto en la caja
			sb $zero 1($v0)
			lw $t2 8($s0) 	# obtengo el apuntador al nuevo ultimo
			sw $t1 4($t2)	# Coloco el indice en el nodo
			sw $v0 0($t2) 	# la enlazo con el nodo 
			
			addi $t1 $t1 1
			addi $t3 $t3 1
			
		b itr
fin:
	li $t1 26
	sw $t1 4($s0)
	
############ 

#################### LECTURA DE LA CADENA #######################

	#lectura de la cadena con la que se va a trabajar
	la $a0 mensaje  
	li $a1 255
	li $v0 8
	syscall
	
################
	
############ LZW ################
	la $t6 mensaje
	li $s4 1 		# registro para el tamano de la nueva cadena a comparar
	move $s1 $t6
LZW:
	lb $t7 0($t6)

	add $t5 $s1 $s4		# 
	lb $s2 0($t5) 		#
	sb $zero 0($t5)		# delimitar la cadena a buscar	 
	
	buscarCadena
	
	bne $v0 -1
	move $s3 $v0
	addi $s4 $s4 1
	
	
	bne $t7 0 LZW
				

	
	
	
	
########### Finalizacion del programa

	li $v0 10
	syscall

############ FUNCIONES #################

#Entrada: $a0 dir. de un string
#		  $a1 dir. de otro string
#Salida:  $v0 = 0 si no son iguales
#		  $v0 = 1 si son iguales 
compararStrings:
itr1:		
	lb $t0 0($a0)
	lb $t1 0($a1)
	bne $t0 $t1 noSonIguales
	beqz $t0 sonIguales
	addi $a0 $a0 1
	addi $a1 $a1 1
	b itr1
	
noSonIguales:
	move $zero $v0
	jr $ra
sonIguales:
	li $v0 1
	jr $ra
	

#Entrada: $a0 cadena a buscar
#Salida:  $v0 = -1 si no se encontro la cadena
#		  $v0 = n si se encontro la cadena,donde n es el indice en el dic.
buscarCadena:
	lw $t0 4($s0)
	li $t1 0
	lw $t2 0($s0) # apuntador al primero
	
	
itrdicc:	
		lw $a1 0($t2)
		
		addi $sp $sp -8
		sw $ra 0($sp)
		sw $a0 4($sp)
		jal compararStrings
		beq $v0 1 perteneceADicc
		lw $ra 0($sp)
		lw $a0 4($sp)
		addi $sp $sp 8
		
		addi $t1 $t1 1
		lw $t2 8($t2)
		
	blt $t1 $t0 itrdicc	
	
	li $v0 -1
	jr $ra
	
perteneceADicc:
	lw $v0 4($t2)
	jr $ra
	
#########			

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	 
	
	

