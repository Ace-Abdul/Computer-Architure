.text
.align 2
.globl main
main:
        li $v0, 5           # loading 5 into $v0 then syscall reads integer. Read value returned in $v0
        syscall
        move $t1, $v0       # copying v0 into t1
        li $t0, 0           # incremented every loop
        li $t2, 7           # used as constant multiplier

_seven:
        beq $t0, $t1, _end  # break if t0 == t1
        addi $t0, $t0, 1    # t0++
        mul $a0, $t0, $t2   # Multiply t0 and t2 (7) and save in a0
        li $v0, 1
        syscall

        li $v0, 4
        la $a0, ent
        syscall
        j _seven
_end:
        li $v0, 0
        jr $ra

.data
 ent: .asciiz "\n"