.text
# Prime number search for the Duke 250/16 CPU by Tyler Bletsch
# Updated 2019-06-06

    # We're going to do proper stack discipline, so we start stack pointer $r6 at 0x8000
    addi $r6, $r0, 16 # 0x0010
    sll $r6, $r6, 4   # 0x0100
    sll $r6, $r6, 7   # 0x8000
    
    # call prime finder
    jal prime
    halt
    
# FUNCTION fib()
# iterative function to print prime numbers forever
# clobbers r1, r2, r3, r4, r5, r7 (but it never returns so that's okay)
prime:
    # r1: int x
    # r2: int d
    # r3: int x/2 (also div_result which we dont use)
    # r4: int mod_result
    # r5: bool prime
    
    # print 2 as a special case (this allows the loop to only consider odd numbers, cutting work in half)
    addi $r1, $r0, 2
    jal print_int
    
    #x=3
    addi $r1, $r0, 3
    #while 1
prime_loop:
    #    prime=true
    addi $r5, $r0, 1
    
    #    for (d=3; d<x/2; d+=2)
    addi $r2, $r0, 3
prime_subloop:
    srl $r3, $r1, 1 # r3 gets x/2 for comparison
    bge $r2, $r3, prime_subloop_end
    #        if (x%d == 0) { prime=false; break; }
    jal divmod # x and d already in r1,r2; get mod result in r4
    beq $r4, $r0, prime_then
    j prime_endif
prime_then:
    addi $r5, $r0, 0 # prime=false
    j prime_subloop_end # break
prime_endif:
    addi $r2, $r2, 2 # d+=2
    j prime_subloop
prime_subloop_end:

    #    if (prime) print x
    beq $r5, $r0, prime_printx_endif
    jal print_int # r1 has x
prime_printx_endif:

    #    x+=2
    addi $r1, $r1, 2
    
    # uncomment to quit after reaching the number below
    #addi $r5, $r0, 12
    #bge $r1, $r5, quit
    j prime_loop
    
quit:
    halt
    

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
# no other registers modified (including r1,r2)
divmod:
    # division by iteration - we subtract til we get negative, count how many times we had to (r3), and note what's left (r4)
    addi $r3, $r0, -1 # r3 starts at -1 and will count up as we subtract (-1 because the loop subtracts ceil(r1/r2) times)
    addi $r4, $r1, 0 # r4 starts at r1 and is what we subtract from; we'll then add the last $r2 back to get to the modulo at the end
dloop:
    sub $r4, $r4, $r2
    addi $r3, $r3, 1
    bge $r4, $r0, dloop
dloop_end:
    add $r4, $r4, $r2
    jr $r7


# FUNCTION puts(char* r1)
# outputs null-terminated string followed by a newline
# no registers modified (including r1)
puts:
    #stack saving
    addi $r6, $r6, -2
    sw $r1, 0($r6)
    sw $r2, 1($r6)
    add $r0, $r0, $r0   # a no-op: deal with how our CPU can't do lw right after sw
    
puts_loop:
    lw $r2, 0($r1)
    beq $r2, $r0, puts_loop_end
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
buffer: # char buffer[8] -- used to create a printable string of a integer by print_int
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
