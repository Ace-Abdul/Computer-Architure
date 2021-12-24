.text
    # test addi, add, sub instructions

    #addi, add
    addi $r1, $r0, 16  # 0x10
    addi $r2, $r0, 31  # 0x1f
    add $r3, $r2, $r1  # 0x2f

    #sub
    addi $r1, $r0, -16  # 0xFFF0
    addi $r2, $r0, 16   # 0x10
    sub $r3, $r2, $r1   # 0x20

    halt

.data
