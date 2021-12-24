.text
.align 2
.globl main
main:
        addi $sp, $sp, -4       # make space for 4 bytes/ 1 word
        sw $ra, 0($sp)          # save the value of ra starting at 0th byte of sp, so that we have correct return address for fxn that called main
        li $v0, 5               # prompt for integer
        syscall                 # ^
        move $a0, $v0           # copy read integer into a0
        jal _recurse            # new $ra set by jal
        move $a0, $v0           # v0 has return value of _recurse
        li $v0, 1               # print command
        syscall                 # ^
        lw $ra, 0($sp)          # load the location saved by ra in line 6 after we _recurse returns to main
        addi $sp, $sp, 4        # clear storage created
        li $v0, 0               # making main return 0
        jr $ra                  

_recurse:
        addi $sp, $sp, -8       # make space for 8 bytes/ 2 words
        sw $s0, 4($sp)          # save the value of s0 starting at 4th byte of sp
        sw $ra, 0($sp)          # save the value of ra starting at 0th byte of sp

        #base case
        beqz $a0, _restore    # if read int is 0 jump to restore where v0 is set to 2

        move $s0, $a0           # copy a0 into s0
        addi $a0, $a0, -1       # decrement a0 or N by 1

        jal _recurse            # make recursive call, returned value in $v0
        move $t0, $v0           # copy ret into another register t0
        addi $s0, $s0, -1       # decrement s0/N by 1 === N-1
        mul $t1, $s0, 3         # multiply s0 (N-1) by 3 and save into t1 == 3*(N-1) 
        addi $t0, $t0, 1        # t0 has f(N-1) (returned value from v0), increment that by 1 t0 = f(N-1) + 1
        add $v0, $t1, $t0       # sum 3*(N-1) and f(N-1)+1 and save in $v0 return variable
        lw $s0, 4($sp)          # load saved value of s0 back
        lw $ra, 0($sp)          # load save value of ra back
        addi $sp, $sp, 8        # delete space created
        jr $ra                  # jump to the call made by higher recurse (if any) or main

_restore:
        lw $s0, 4($sp)          # load saved value of s0 back
        lw $ra, 0($sp)          # load save value of a0 back
        addi $sp, $sp, 8        # delete space created
        li $v0, 2               # base case
        jr $ra                  # returns with value in $v0