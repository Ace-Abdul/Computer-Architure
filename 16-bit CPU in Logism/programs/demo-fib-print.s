.text
    # start stack pointer $r6 at 0x8000
    addi $r6, $r0, 16 # 0x0010
    sll $r6, $r6, 4   # 0x0100
    sll $r6, $r6, 7   # 0x8000
    
    jal fib
    halt
    
# FUNCTION fib()
# iterative function to print fibonaccis forever
# clobbers r1, r2, r3
fib:
    addi $r1, $r0, 0
    addi $r2, $r0, 1
fib_loop:
    jal print_int      # print r1
    add $r3, $r1, $r2  # r3=r1+r2
    addi $r1, $r2, 0   # r1=r2
    addi $r2, $r3, 0   # r2=r3
    j fib_loop
    

# FUNCTION print_int(unsigned int r1)
# outputs as unsigned decimal integer on stdout
# no registers modified (including r1)
print_int:
    # assume r1 is argument
    # all other registers used are callee saved
    
    #stack saving
    addi $r6, $r6, -6
    sw $r1, 0($r6)
    sw $r2, 1($r6)
    sw $r3, 2($r6)
    sw $r4, 3($r6)
    sw $r5, 4($r6)
    sw $r7, 5($r6) # save ra
    
    la $r5, buffer
    addi $r5, $r5, 7 # go to end of buffer (we're building right-to-left)
    #    while True:
ploop:
    #        m = n % 10  # into r4
    # r1 is already numerator
    addi $r2, $r0, 10 # divide by 10 for decimal output
    jal divmod
    
    #        output = str(m) + output
    # r4 has result; we add 0x30=48 to turn it into a printable character
    addi $r4, $r4, 30
    addi $r4, $r4, 18 # two steps because our immedate is only 6-bit signed
    
    addi $r5, $r5, -1 # back string pointer up; we're populating string right-to-left
    sw $r4, 0($r5)
    
    #        n = n / 10
    addi $r1, $r3, 0 # r1=r3, the result of division
    
    #        if n == 0: break
    beq $r1, $r0, ploop_end
    j ploop
ploop_end:

    addi $r1, $r5, 0 # r1=r5
    jal puts

    # stack collapse
    lw $r1, 0($r6)
    lw $r2, 1($r6)
    lw $r3, 2($r6)
    lw $r4, 3($r6)
    lw $r5, 4($r6)
    lw $r7, 5($r6) # restore ra
    addi $r6, $r6, 6
    
    jr $r7 # return


# FUNCTION divmod(unsigned int r1, unsigned int r2)
# returns $r3 = $r1 / $r2   ;   $r4 = $r1 % r2
# no other registers modified
divmod: 
    addi $r3, $r0, -1 # r3 starts at -1 and will count up as we subtract (-1 because the loop subtracts ceil(r1/r2) times)
    addi $r4, $r1, 0 # r4 starts at r1 and is what we subtract from; we'll then add the last $r2 back to get to the modulo at the end
dloop:
    sub $r4, $r4, $r2
    addi $r3, $r3, 1
    bge $r4, $r0, dloop
dloop_end:
    add $r4, $r4, $r2
    jr $r7


# FUNCTION puts (char* r1)
# outputs null-terminated string followed by a newline
# no other registers modified
# preserves r1's value
puts:
    #stack saving
    addi $r6, $r6, -2
    sw $r1, 0($r6)
    sw $r2, 1($r6)
    add $r0, $r0, $r0   # a no-op: deal with how our CPU can't do lw right after sw
    
puts_loop:
    lw $r2, 0($r1)
    beq $r2, $r0, puts_loop_end # break on null terminator
    output $r2
    addi $r1, $r1, 1
    j puts_loop
puts_loop_end:
    addi $r2, $r0, 10 # newline
    output $r2 # print newline
    
    # stack cleanup
    lw $r1, 0($r6) # restore ra
    lw $r2, 1($r6)
    addi $r6, $r6, 2
    
    jr $r7 # return


.data
buffer: # 8 words [0..7]
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
