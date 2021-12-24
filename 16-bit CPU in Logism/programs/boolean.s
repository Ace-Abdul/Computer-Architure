.text
    # test nor, nand instrctions

    #nor
    addi $r1, $r0, 28		# 0x001c
    addi $r2, $r0, 26		# 0x001a

    nor $r3, $r1, $r2       # 0x001c nor 0x001a == 0xffe1
    # can achieve OR with two NORs because NOR can also be used to derive NOT as follows:
    nor $r4, $r3, $r3       # 0x001e
    nor $r5, $r0, $r0       # 0 nor 0 = 0xffff
    
    #nand
    nand $r3, $r1, $r2      # 0x001c nand 0x001a == 0xffe7
    # can achieve AND with two NANDs because NAND can also be used to derive NOT as follows:
    nand $r4, $r3, $r3      # 0x0018
    nand $r6, $r0, $r0      # 0 nand 0 = 0xffff

    halt

.data
