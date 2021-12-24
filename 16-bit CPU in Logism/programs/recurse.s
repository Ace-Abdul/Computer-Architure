.text
# Compute fibonaccis using recursion
# We'll need some calling conventions to pull this off
# Registers:
#  r0   zero
#  r1   argument (like a#)
#  r2   caller-saved (like t#)
#  r3-4 callee-saved (like s#)
#  r5   return value (like v#)
#  r6   stack pointer (like sp)
#  r7   return address (like ra)

# Calculate fib(5) (which, via recursion, will end up using fib(4)..fib(0))
main:
    # Load the addr of stack pointer (32768 -- we'll pull this from memory)
    la $r1, stack       # get the address of the stack pointer from global memory
    lw $r6, 0($r1)      # set start of stack
    
    addi $r1, $r0, 4    # set argument to 4
    jal fib             # r5 (return value) should be 5, as fib(4)==5
    la $r1, result
    sw $r5, 0($r1)      # store the result into global memory
    halt

fib:
    addi $r6, $r6, -3   # reserve 3 words on stack (r6 is stack pointer, like $sp)
    sw $r3, 0($r6)      # save callee-saved regs r3,r4
    sw $r4, 1($r6)
    sw $r7, 2($r6)      # save return address r7 (like $ra)

    addi $r2, $r0, 1
    bge $r2, $r1, _base_case # check base case of if f(n) = 0 or 1 return 1
    
    # recursion case
    add $r3, $r0, $r1   # r3 gets r1 (the argument) for safe keeping
    addi $r1, $r1, -1   # set argument for recursion fib(n-1)
    jal fib             # do fib(n-1)    
    add $r4, $r0, $r5   # get answer into r4 for safe keeping
    addi $r1, $r3, -2   # set argument for recursion fib(n-2)
    jal fib             # do fib(n-2)
    add $r5, $r5, $r4   # sum fib(n-1) and fib(n-2) and put into our return value
    j _return           # goto return

    # base case
_base_case:
    addi $r5, $r0, 1    # base case for fib(0) or fib(1) is 1, set that return value

_return:
    lw $r3, 0($r6)      # restore callee-saved regs r3,r4
    lw $r4, 1($r6)      
    lw $r7, 2($r6)      # restore return address r7 (like $ra)
    addi $r6, $r6, 3    # collapse stack frame (r6 is stack pointer, like $sp)
    jr $r7              # return

.data
stack: .word 32767      # address of the top of the stack -- used for initializaiton
result: .word 0         # the answer will be stored here before the program ends