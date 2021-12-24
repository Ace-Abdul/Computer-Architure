.text
    # test lw, sw instructions

    addi $r2, $r0, 3  # initializing r2=3,r3=4
    addi $r3, $r0, 4

    la $r4, val       # address is 1

    lw $r5, 0($r4)    # gets 300 (0x12c)
    lw $r6, 1($r4)    # gets 400 (0x190)
    sw $r2, 0($r4)    # val[0]=3
    sw $r3, 1($r4)    # val[1]=4

    addi $r2, $r0, 0  # reset r2,r3 to 0
    addi $r3, $r0, 0

    lw $r2, 0($r4)    # gets 3
    lw $r3, 1($r4)    # gets 4

    halt

.data
junk:
    .word 200  # addr=0. junk word we never use (so the address of val isn't just zero)
val: 
    .word 300  # addr=1
    .word 400  # addr=2
