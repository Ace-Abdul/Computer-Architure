.text
    # test blt, bne, jal, j, jr instructions
    # $r5 will have the 'test number' before each branch/jump
    # if $r6 is ever non-zero, something screwed up. (other failure conditions are also possible, of course)
    addi $r1, $r0, 15
    addi $r2, $r0, 16
    addi $r3, $r0, 16

    addi $r5, $r0, 1            # TEST 1
    bge $r1, $r3, fail          # branch is *NOT* taken
    
    addi $r5, $r0, 2            # TEST 2
    bge $r2, $r3, ge_equal      # branch is taken
    
    # TEST FAIL if you get here
    addi $r6, $r0, 22           # shouldn't be executed
    halt                        # shouldn't be executed
    
    
ge_equal:
    addi $r5, $r0, 3            # TEST 3
    bge $r3, $r1, ge_greater    # branch is taken
    
    # TEST FAIL if you get here
    addi $r6, $r0, 23           # shouldn't be executed
    halt                        # shouldn't be executed

ge_greater:
    addi $r5, $r0, 4            # TEST 4
    beq $r1, $r3, fail          # branch is *NOT* taken
    
    addi $r5, $r0, 5            # TEST 5
    beq $r2, $r3, eq_equal      # branch is taken
    
    # TEST FAIL if you get here
    addi $r6, $r0, 25           # shouldn't be executed
    halt                        # shouldn't be executed
    
eq_equal:
    addi $r5, $r0, 6            # TEST 6
    j continue_test             # jump over the following fail code
    
    # TEST FAIL if you get here
    addi $r6, $r0, 26           # shouldn't be executed
    halt                        # shouldn't be executed
    
continue_test:
    addi $r5, $r0, 7            # TEST 7
    jal my_func                 # procedure call
    # we should return here after my_func
    
    # END OF TESTS
    addi $r5, $r0, 10           # set r5 to 10 in celebration    
    halt                        # Natural end of program (halt loops forever here)

my_func:
    addi $r1, $r1, -5           # decrement $r1 down to 10
    addi $r5, $r0, 8            # TEST 8
    jr $r7                      # return
    
    # TEST FAIL if you get here
    addi $r6, $r0, 28           # shouldn't be executed
    halt                        # shouldn't be executed


fail:
    # TEST FAIL if you get here
    addi $r6, $r0, 20           #shouldn't be executed
    halt                        #shouldn't be executed

.data
