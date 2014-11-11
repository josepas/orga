.data

Pantalla: .word 0
azul:	  .word 0x062d9a
rojo:	  .word 0xdf2020
verde:	  .word 0x00cc00
.align 2

.text

# $s0 Recorre las direcciones de la pantalla
# $t0 color azul
# $t1 color rojo
# $t3 color verde
# #t2 contador de ciclo/Ancho de pantalla
############	INICIALIZACION DE PANTALLA	############
	la $s0 Pantalla
	lw $t0 azul
	lw $t1 rojo
	move $t2 $zero
	li $s7 0 

Cuaimonianos:			#Cada iteracion agrega un par de cuaimoniano
	sw $t0 0($s0)		#Cuaimoniano azul
	sw $t1 8($s0)		#Cuaimoniano rojo (separado por un espacio)
	addi $s0 $s0 16		#Apunta dos espacios despues del rojo
	addi $t7 $t7 16
	addi $t2 $t2 1
	bne $t2 8 Cuaimonianos
	
	la $s0 Pantalla
	li $t2 128
	mul $t2 $t2 31
	add $s0 $s0 $t2		#$s0 Apunta a la superficie lunar
	lw $t3 verde
	sw $t3 64($s0)		#Se coloca al jugador en el centro (16pixeles x 4bytes)
				#de la superdicie lunar
	
	li $v0 10
	syscall
	
