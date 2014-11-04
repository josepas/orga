# pro11.asm
#  SEGMENTO DE DATOS
       .data                # *** SEGMENTO DE DATOS ***
Valor: .word 8,9,10,11      # Defino arreglo 4 palabras (decimal).
                            # 
       .byte 0x1a,0x0b,10   # Defino los 3 primeros bytes de la
                            # siguiente palabra (hex. y dec.).
       .align 2             # Para que el siguiente dato en mem.
                            # este alineado en palabra
Carac: .ascii "Hola"        # Cadena de caracteres
       .asciiz ",MIPS"      # Cadena de caracteres terminada
                            # con el caracter nulo.
       .align 2             # Las dos cadenas anteriores, junto
                            # con el NULL final, ocupan 10 bytes,
                            # por lo que alineo el siguiente dato
                            # para que empieze en una palabra
id:   .word 1               # Usado como Indice del arreglo "valor"

#
#    SEGMENTO DE TEXTO
      .text                 # *** SEGMENTO DE TEXTO ***
      .globl main           # Etiqueta main visible a otros archivos
main:                       # Rutina principal
      lw $s0,Valor($zero)   # 
                            # 
      lw $s4,id             # En $s4 ponemos el indice del arreglo
      addi $s6,$zero,4      # S6 se inicializa con 4
      sll $s5,$s4,2       # En $s5 ponemos id*4   
      lw $s1,Valor($s5)     # 
      addi $s4,$s4,1        # Incrementamos el Indice del arreglo
      sll $s5,$s4,2     
      lw $s2,Valor($s5)     # Carga en $s2 valor[2]
      addi $s4,$s4,1        # Incrementamos el Indice del arreglo
      sll $s5,$s4,2
      lw $s3,Valor($s5)     # 

      li $v0,10             # Exit
      syscall
