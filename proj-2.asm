.globl  main 
.data 
.text 
   
# t0 = word
# t1 = lmask
# t2 = rmask
# t3 = width
# t4 = i
# t5 = lbit
# t6 = rbit
# t7 = function result and conditional

# IDEALLY only use these insts: 
# sll (only by 1), srl (only by 1), sub, subi, slt, or, ori, 
# beq,  bne,  add,  addi,  and,  andi,  lui
main: 
 
    addi $a0, $0,  0
    jal  isBinPal
    or   $s0, $v0, $0

    addi $a0, $0,  5
    jal  isBinPal
    or   $s1, $v0, $0

    lui  $a0, 0x000F
    ori  $a0, $a0, 0x462F
    jal  isBinPal
    or   $s2, $v0, $0

    addi $a0, $0,  6
    jal  isBinPal
    or   $s3, $v0, $0

# s0 = 0
# s1 = 1
# s2 = 1
# s3 = 0

    ori  $v0, $0,  10 
    syscall 
 
isBinPal: 
    or   $t0, $0, $a0   # load word into t0
    beq  $t0, $0, False # if (word == 0) {return false}
    lui  $t1, 0x8000    # load constants
    addi $t2, $0, 1
    addi $t3, $0, 32
    add  $t4, $0, $0
    
    beq  $0,  $0,  whileTest
    # While loop section
    whileBody:
        srl  $t1, $t1, 1
        addi $t3, $t3, -1
    whileTest:
        and  $t7, $t0, $t1
        beq  $t7, $0,  whileBody
    
    srl  $t3, $t3, 1        # setup width/2 to be used in for loop       
    beq  $0,  $0, forTest
    # For loop section
    forBody:
        and  $t5, $t1, $t0
        and  $t6, $t2, $t0      # set lbit and rbit
        beq  $t5, $0,  lBitZ    # (lbit == 0)
        beq  $t6, $0,  success    # (rbit == 0)
        beq  $0,  $0,  False
    lBitZ:
        bne  $t6, $0,  success  # (rbit != 0)
    success:
        srl  $t1, $t1, 1
        sll  $t2, $t2, 1    # bit shifts
        addi $t4, $t4, 1    # i++
    forTest:
        slt  $t7, $t4, $t3   # (i < width/2)
        bne  $t7, $0, forBody
    
    # Return section
    addi $v0, $0, 1
    jr   $ra            # return true
    False:
        add  $v0, $0, $0
        jr   $ra        # return false

#bool isBinPal(uint32_t word) 
#{ 
 
#}

# completed section

#    if (word == 0) 
#        return false; 
#    uint32_t lmask = 0x80000000; 
#    uint32_t rmask = 0x00000001; 
#    uint32_t width = 32; 
#    while ((word & lmask) == 0) { 
#        lmask >>= 1; 
#        width--; 
#    }
#    for (uint32_t i = 0; i < (width / 2); i++) { 
#        uint32_t lbit = lmask & word; 
#        uint32_t rbit = rmask & word; 
#        if (((lbit == 0) && (rbit != 0)) || 
#            ((lbit != 0) && (rbit == 0))) 
#            return false; 
#        lmask >>= 1; 
#        rmask <<= 1; 
#    } 
#    return true; 