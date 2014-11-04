# pro13.asm
         .data
string:  .asciiz "Esto es una cadena\n"
item:    .word 99
array:   .word 11,22,33,44,55,66,77,88,99
#-----------------------#
         .text
         .globl main
main:
#-----------------------#(1)
       la $a0,string
       li $v0,4         # print string
       syscall
#-----------------------#(2)
      lw $a0,item
      li $v0,1          # print entero
      syscall
#-----------------------#(3)
      li $v0,5          # read entero
      syscall
#-----------------------#(4)
      li $v0,8          # read string
      la $a0,string
      li $a1,28
      syscall
      li $v0,4          #print string
      syscall
#-----------------------#(5)
      li $t0,3
      li $t1,4
      mul $t2,$t1,$t0
      lw $a0,array($t2)
      li $v0,1          #print entero
      syscall
#-----------------------#(6)
      li $v0,10         #EXIT
      syscall
