.text
.align 2

.globl main
main:
        add $sp, $sp, -28               # For saving ra which is changed when jaling
        sw $ra, 0($sp)                 
        li $t7, 0                       # Number of pizzas
        l.s $f10, PI                    # f10 contains PI
        l.s $f9, two                    # f9 contains 2.0
        l.s $f8, zero                   # f8 contains 0.000
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
        

        la $a0, pizName                 # load pizName into string 
        la $a1, DONE                    # load DONE into a1

        sw $t7, 4($sp)                 
        sw $t4, 8($sp) 
        jal strcmp
        lw $t7, 4($sp)
        sw $t4, 8($sp)                  

        beqz $v0, _prePrint             # Branch to end if pizName == DONE
        addi $t7, $t7, 1                # Increment number of pizzas t7 by 1

        # Prompting for pizza diameter
        li $v0, 4                       # Print
        la $a0, askDiam                 # Prompt for pizza diameter; v0 already set to 4 above
        syscall

        li $v0, 6                       # Read float
        syscall                         # Read float in $f0
        mov.s $f4, $f0                  # $f4 has float
        

        # Prompting for pizza cost
        li $v0, 4                       # Print
        la $a0, askCost                 # Prompt for pizza diameter
        syscall

        li $v0, 6                       # Read float
        syscall                         # Read float in $f0
        mov.s $f5, $f0                  # $f5 has float
        

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

        sw $t7, 12($sp)  
        sw $t4, 16($sp)
        sw $t5, 20($sp)
        s.s $f7, 24($sp)
        jal storeStr                    # takes care of storing pizName into SP
        lw $t7, 12($sp)  
        lw $t4, 16($sp)
        lw $t5, 20($sp)
        l.s $f7, 24($sp)


        s.s $f7, 64($t5)                # Storing float (4 bytes) in stack
        sw $0, 68 ($t5)                 # t0 is next field which is 0/null
        li $t6, 1                       # For condition of assigning Head
        beq $t7, $t6, _assignFirst      # Branch to section that assigns first pointer if this is the first pizza

        move $a2, $t4                   # $a0 becomes First
        move $a3, $t5                   # $a1 becomes Struct Pointer
        sw $t7, 12($sp)
        jal InsertSorted
        lw $t7, 12($sp)   
        la $t4, 0($v0)                   # Copy new head if any into t4
        j _read

_assignFirst:
        move $t4, $t5                   # t4 (First) = StructPointer
        j _read

_prePrint:
        beqz $t7, _end
        move $t2, $t4                   # current (t2) = first t2 becomes head (used for traversing as current)

_print:
        la $a0, 0($t2)                  # load the value of current node's string
        li $v0, 4                       # print string
        syscall

        la $a0, space                   # New line for next prompt
        li $v0, 4                       # \n in $a0
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
        add $sp, $sp, 28
        li $v0, 0                       # return 0 from main
        jr $ra

strcmp:
        lb $t2, 0($a0)                  # loading first char into t6
        lb $t3, 0($a1)                  # loading second char into t8
        bgt $t2, $t3, _1stGreater       # branch to return 1 if 1st one is larger
        bgt $t3, $t2, _2ndGreater       # branch to return -1 if 2nd one is larger
        beqz $t2, _same                 # If t6 and t8 are same and t6 is null/0 then they must be same string
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
        lb $t2, enter                   # t2 becomes nln

        lb $t6, 0($a1)                  # Load one char in t6
        beq $t6, $t2, _replace          # if read char is \n branch to replace
        sb $t6, 0($a0)                  # storing char of pizName into SP
        addi $a0, $a0, 1                # advancing to next char/byte
        addi $a1, $a1, 1
        j storeStr

_replace:
        sb $0, 0($a1)
        jr $ra

InsertSorted:
        addi $sp, $sp, -40
        sw $ra, 0($sp)

        la $t9, 0($a2)                  # precurrent for swapping
        la $t6, 0($a2)                  # Current = First
        la $t8, 0($a3)                  # StructPointer
        lw $t0, 68($t6)                 # t0 = current->next
        l.s $f4, 64($t6)                # $f4 = Current->ppd
        l.s $f5, 64($t8)                # $f5 = SP->ppd
        c.lt.s $f4, $f5                 # c=1 if f5 (SP) > f4(first)
        bc1t _SP_Larger_Than_First      
        c.eq.s $f4, $f5                # branch if PPDs are equal
        bc1t _eqPPD_First      

_preLoop:
        l.s $f4, 64($t6)                # $f4 = Current->ppd
        lw $t0, 68($t6)                 # current->next

_SP_Larger_Than_Current_at_Middle:
        c.lt.s $f4, $f5                 # c=1 if f5 (SP) > f4(Current)
        bc1t _SP_Larger_Than_Current

_SP_equal_Current_at_Middle:
        c.eq.s $f4, $f5                # branch if PPDs are equal
        bc1t _eqPPD_Two                 # branch if PPDs are equal

_Current_Larger_Than_SP:
        c.lt.s $f5, $f4                 # c=1 if f4 (Current) > f5(SP)
        bc1t _Check_If_Current_Next_is_Null

_Current_equal_SP:
        c.eq.s $f4, $f5,                # branch if PPDs are equal
        bc1t _eqPPD_Three        # branch if PPDs are equal


_moveCurrent:
        la $t9, 0($t6)                   # pre current = current          
        la $t6, 0($t0)                   # current = current->next
        j _preLoop

_eqPPD_First:
        la $a0, 0($t6)                 # loading arguments for stcmp
        la $a1, 0($t8)

        sw $t6, 4($sp)
        sw $t8, 8($sp)  
        sw $t7, 12($sp)  
        sw $t4, 16($sp)
        sw $t5, 20($sp)
        sw $t9, 24($sp)
        sw $a2, 28($sp)
        sw $a3, 32($sp)
        s.s $f7, 36($sp)
        jal strcmp
        lw $t6, 4($sp)
        lw $t8, 8($sp)  
        lw $t7, 12($sp)  
        lw $t4, 16($sp)
        lw $t5, 20($sp)
        lw $t9, 24($sp)
        lw $a2, 28($sp)
        lw $a3, 32($sp) 
        l.s $f7,36($sp) 

        bgtz $v0, _SP_Larger_Than_First
        beqz $t0, _Check_If_Current_Next_is_Null
        j _preLoop

_eqPPD_Two:
        la $a0, 0($t6)                 # loading arguments for stcmp
        la $a1, 0($t8)
        sw $t6, 4($sp)
        sw $t8, 8($sp)  
        sw $t7, 12($sp)  
        sw $t4, 16($sp)
        sw $t5, 20($sp)
        sw $t9, 24($sp)
        sw $a2, 28($sp)
        sw $a3, 32($sp)
        s.s $f7,36($sp) 
        jal strcmp
        lw $t6, 4($sp)
        lw $t8, 8($sp)  
        lw $t7, 12($sp)  
        lw $t4, 16($sp)
        lw $t5, 20($sp)
        lw $t9, 24($sp)
        lw $a2, 28($sp)
        lw $a3, 32($sp)
        l.s $f7,36($sp) 
               
        bgtz $v0, _SP_Larger_Than_Current
        beqz $t0, _Check_If_Current_Next_is_Null
        j _Current_Larger_Than_SP

_eqPPD_Three:
        la $a0, 0($t6)                 # loading arguments for stcmp
        la $a1, 0($t8)

        sw $t6, 4($sp)
        sw $t8, 8($sp)  
        sw $t7, 12($sp)  
        sw $t4, 16($sp)
        sw $t5, 20($sp)
        sw $t9, 24($sp)
        sw $a2, 28($sp)
        sw $a3, 32($sp)
        s.s $f7,36($sp) 
        jal strcmp 
        lw $t6, 4($sp)
        lw $t8, 8($sp)  
        lw $t7, 12($sp)  
        lw $t4, 16($sp)
        lw $t5, 20($sp)
        lw $t9, 24($sp)
        lw $a2, 28($sp)
        lw $a3, 32($sp)  
        l.s $f7,36($sp) 

        bgtz $v0, _Check_If_Current_Next_is_Null
        j _moveCurrent

_Check_If_Current_Next_is_Null:
        beqz $t0, _makechange           # if current->ppd > struct->ppd AND Current-> next is null we attach current->next to struct
        j _Current_equal_SP
        
_makechange:
        sw $t8, 68($t6)                 # current->next = SP
        la $v0, 0($a2)                  # v0 is return and copied into new First
        lw $ra, 0($sp)                  # restoring $ra back
        addi $sp, $sp, 40  
        jr $ra

_SP_Larger_Than_First:
        sw $t6, 68($t8)                 # SP->next = first
        la $v0, 0($t8)                  # is return and copied into new First
        lw $ra, 0($sp)                  # restoring $ra back
        addi $sp, $sp, 40  
        jr $ra

_SP_Larger_Than_Current:
        sw $t8, 68($t9)                 # precurrent->next = SP
        sw $t6, 68($t8)                 # SP->next = current
        la $v0, 0($a2)                  # is return and copied into new First
        lw $ra, 0($sp)                  # restoring $ra back
        addi $sp, $sp, 40  
        jr $ra

.data
PI: .float 3.14159265358979323846 
two: .float 2.0
zero: .float 0.0
space: .asciiz " "
DONE: .asciiz "DONE\n"
pizName: .space 64
askName: .asciiz "Pizza name: "
askDiam: .asciiz "Pizza diameter: "
askCost: .asciiz "Pizza cost: "
enter: .asciiz "\n"