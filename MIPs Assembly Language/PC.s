.text
.align 2

main:
        add $sp, $sp, -4                # For saving ra which is changed when jalling
        sw $ra, 0($sp)                 
        li $t7, 0                       # Number of pizzas
        li $t6, 1                       # For condition of assigning Head
        l.s $f10, PI                    # f10 contains PI
        l.s $f9, two                    # f9 contains 2.0
        l.s $f8, zero                   # f8 contains 0.000
        lb $s3, enter                     # s3 becomes nln
        # t0 is StructPoitner next pointer
        # t1 is pizName. Initialized below
        # t2 is current node pointer
        # t3 is first node next pointer
        # t4 is FIRST/HEAD. Initialized below
        # t5 is struct pointer

_read:
        # Prompting for pizza name. Branch if $a0 == "DONE"
        la $a0, askName                 # Prompt for pizza name
        li $v0, 4                       # Print string in $a0
        syscall

        li $v0, 8                       # Read string
        la $a0, pizName                 # Variable/buffer is pizName
        li $a1, 64                      # Size of string in $a1
        syscall
        
        # la $a0, enter                 # New line for next prompt
        # li $v0, 4                     # \n in $a0
        # syscall

        la $a0, pizName                 # load pizName into string 
        la $a1, DONE                    # load DONE into a1

        jal strcmp

        beqz $v0, _prePrint             # Branch to end if pizName == DONE

        #la $t1, pizName                # saving pizName into register

        addi $t7, $t7, 1                # Increment number of pizzas t7 by 1

        # Prompting for pizza diameter
        li $v0, 4                       # Print
        la $a0, askDiam                 # Prompt for pizza diameter; v0 already set to 4 above
        syscall

        li $v0, 6                       # Read float
        syscall                         # Read float in $f0
        mov.s $f4, $f0                  # $f4 has float

        # la $a0, enter                 # New line for next prompt
        # li $v0, 4                     # \n in $a0
        # syscall
        

        # Prompting for pizza cost
        li $v0, 4                       # Print
        la $a0, askCost                 # Prompt for pizza diameter
        syscall

        li $v0, 6                       # Read float
        syscall                         # Read float in $f0
        mov.s $f5, $f0                  # $f5 has float

        # la $a0, enter                 # New line for next prompt
        # li $v0, 4                     # \n in $a0
        # syscall
        

_calc:  # Pizza per dollar calculations
        c.eq.s $f4, $f8                 # c==1 if f4 (diamter) == 0.0
        l.s $f7, zero                   # f7 is ppd. Set ppd = 0
        bc1t _store                     # branch if c==1 with f7 (ppd) == 0

        c.eq.s $f5, $f8                 # c==1 if f5 (cost) == 0.0
        bc1t _store                     # branch if c==1 with f7 (ppd) == 0. This is set in line 51


        div.s $f4, $f4, $f9             # Divide diameter f4 by 2 save into f4
        mul.s $f4, $f4, $f4             # f4*= f4 (r^2)
        mul.s $f4, $f4, $f10            # f4*= π (πr^2)

        div.s $f7, $f4, $f5             # f7 = f4/f5 == (πr^2)/cost

_store:
        li $a0, 72                      # 72 bytes of memory for pointer to register
        li $v0, 9                       # syscalling when v0 is 9 is mallocing with a0 bytes of space
        syscall                         # Address of allocated memory is in $v0
        move $t5, $v0                   # t5 is malloced address in heap

        move $a0, $t5                   # $a0 becomes StructPointer
        la $a1, pizName                 # a1 is pointer to space in memory where string is stored
        jal storeStr                    # takes care of storing pizName into SP

        #li $t0, 0                      # Make next field point to null
        #addi $sp, $sp, -72             # Creating 64 bytes of memory in stack. Name is 64; float is 4; next pointer is 4
        #sw $t1, 0($t5)                  # Storing t1 (pizName; 64 bytes) in stack
        s.s $f7, 64($t5)                # Storing float (4 bytes) in stack
        sw $0, 68 ($t5)                 # t0 is next field which is 0/null
        beq $t7, $t6, _assignFirst      # Branch to section that assigns first pointer if this is the first pizza

        #li $s0,2
        j _sort    

_assignFirst:
        move $t4, $t5                   # t4 (head) = StructPointer
        j _read

_sort:
        sw $t5, 68($t4)                 # td->next = $t5        68($t4) is the next pointer of head, $t5 is the new node/malloced space
        j _read
        #sw $t3, 68($t4)                # t3 is FIRST's (t4) next
        #move $t3, $t5                  # t3 is the FIRST's next node. We store sp (new node) into next field of the head $t3

_prePrint:
        move $t2, $t4                   # current (t2) = first t2 becomes head (used for traversing as current)

_print:
        la $a0, 0($t2)                  # load the value of current node's string
        li $v0, 4                       # print string
        syscall

        la $a0, space                 # New line for next prompt
        li $v0, 4                     # \n in $a0
        syscall

        l.s $f12, 64($t2)               # load the value of current node's float into f12 for printing
        li $v0, 2                       # print float
        syscall

        la $a0, enter                   # New line for next prompt
        li $v0, 4                       # \n in $a0
        syscall

        lw $t2, 68($t2)                 # Current points to next field of i.e: current->current.next

        beqz $t2, _end                  # Branch to _end if current-> is 0/null
        j _print                        # Else repeat print
        
        
_end:
        lw $ra, 0($sp)                  # load saved returned address
        add $sp, $sp, 4
        li $v0, 0                       # return 0 from main
        jr $ra

strcmp:
        lb $s1, 0($a0)                  # loading first char into t6
        lb $s2, 0($a1)                  # loading second char into t7
        bgt $s1, $s2, _1stGreater       # branch to return 1 if 1st one is larger
        bgt $s2, $s1, _2ndGreater       # branch to return -1 if 2nd one is larger
        beqz $s1, _same                 # If s1 and s2 are same and s1 is null/0 then they must be same string
        addi $a0, $a0, 1                # advance to beginning of next char in a0
        addi $a1, $a1, 1                # advance to beginning of next char in a1
        j strcmp

_1stGreater:
        li $v0, 1
        jr $ra

_2ndGreater:
        li $v0, -1
        jr $ra
_same:
        li $v0, 0
        jr $ra

storeStr:
#       li $s1, 0                       # number of bytes iterate over
#       a0 is Structpointer, a1 is pizName, nln byte in s3

        lb $s0, 0($a1)                  # Load one char in s0
        beq $s0,$s3 _replace            # if read char is \n branch to replace
        sb $s0, 0($a0)                  # storing char of pizName into SP
        addi $a0, $a0, 1                # advancing to next char/byte
        addi $a1, $a1, 1
        j storeStr

_replace:
        sb $0, 0($a1)
        jr $ra





.data
PI: .float 3.14159265358979323846 
two: .float 2.0
zero: .float 0.0
space: .asciiz " "
DONE: .asciiz "DONE\n"
pizName: .space 64
#First: .space 128
askName: .asciiz "Pizza name: "
askDiam: .asciiz "Pizza diameter: "
askCost: .asciiz "Pizza cost: "
enter: .asciiz "\n"