.text
    # test shift instructions

    # stepping sll from 1
    addi $r1, $r0, 1
    sll $r1, $r1, 1     # 2
    sll $r1, $r1, 1     # 4
    sll $r1, $r1, 1     # 8
    sll $r1, $r1, 1     # 16
    sll $r1, $r1, 1     # 32
    sll $r1, $r1, 1     # 64
    sll $r1, $r1, 1     # 128
    sll $r1, $r1, 1     # 256
    sll $r1, $r1, 1     # 512
    sll $r1, $r1, 1     # 1024
    sll $r1, $r1, 1     # 2048
    sll $r1, $r1, 1     # 4096
    sll $r1, $r1, 1     # 8192
    sll $r1, $r1, 1     # 16384
    sll $r1, $r1, 1     # 32768
    add $r4, $r1, $r0     # ** save this 0x8000 for use in the srl test later
    sll $r1, $r1, 1     # 0
    sll $r1, $r1, 1     # 0

    # leaping sll from 0xffff
    addi $r2, $r0, -1   # -1 = 65535 = 0xffff
    sll $r2, $r2, 2     # 65532
    sll $r2, $r2, 2     # 65520
    sll $r2, $r2, 2     # 65472
    sll $r2, $r2, 3     # 65024
    sll $r2, $r2, 4     # 57344
    sll $r2, $r2, 3     # 0

    # stepping srl from 0xffff
    addi $r3, $r0, -1   # 0xffff = 65535 = -1
    srl $r3, $r3, 1     # 32767
    srl $r3, $r3, 1     # 16383
    srl $r3, $r3, 1     # 8191
    srl $r3, $r3, 1     # 4095
    srl $r3, $r3, 1     # 2047
    srl $r3, $r3, 1     # 1023
    srl $r3, $r3, 1     # 511
    srl $r3, $r3, 1     # 255
    srl $r3, $r3, 1     # 127
    srl $r3, $r3, 1     # 63
    srl $r3, $r3, 1     # 31
    srl $r3, $r3, 1     # 15
    srl $r3, $r3, 1     # 7
    srl $r3, $r3, 1     # 3
    srl $r3, $r3, 1     # 1
    srl $r3, $r3, 1     # 0
    srl $r3, $r3, 1     # 0

    # leaping srl from 0x8000
    # r4 should be 0x8000=32768 from before
    srl $r4, $r4, 2     # 8192
    srl $r4, $r4, 2     # 2048
    srl $r4, $r4, 2     # 512
    srl $r4, $r4, 3     # 64
    srl $r4, $r4, 4     # 4
    srl $r4, $r4, 3     # 0

    halt

.data
