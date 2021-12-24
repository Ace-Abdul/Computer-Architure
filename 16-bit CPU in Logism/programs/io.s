.text
    # test input, output instructions
    addi $r1, $r0, 10       # put junk in $r1 to make sure input ovewrites it
    
    # we do the following three times without a loop since we're not testing branches here.
    # each itertion will read a char (assumed to be a lower case letter), 
    # convert it to upper case by subtracting 32, 
    # then output it. 

    input $r1               # read char (a lower case letter)
    addi $r2, $r1, -32      # convert to upper case
    output $r2              # output it
    
    input $r1               # read char (a lower case letter)
    addi $r2, $r1, -32      # convert to upper case
    output $r2              # output it
    
    input $r1               # read char (a lower case letter)
    addi $r2, $r1, -32      # convert to upper case
    output $r2              # output it

    halt
