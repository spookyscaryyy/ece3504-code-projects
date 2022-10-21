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

# s0 = pal_count
# s1 = word
# s2 = break cond for while loop
# s3 = conditional

# IDEALLY only use these insts: 
# sll (only by 1), srl (only by 1), sub, subi, slt, or, ori, 
# beq,  bne,  add,  addi,  and,  andi,  lui

main: 
    add  $s0, $0,  $0
    lui  $s1, 0x000F
    ori  $s1, $s1, 0x4240 
    addi $s2, $s2, 6        # load constants
    beq  $0,  $0,  mainWhileTest
    mainWhileBody:
        or   $a0, $s1, $0
        jal  isBinPal
        beq  $v0, $0, notPal
        or   $a0, $s1, $0
        ori  $v0, $0,  1
        syscall             # print word
        ori  $a0, $0,  10
        ori  $v0, $0,  11
        syscall             # print new line character
        addi $s0, $s0, 1
    notPal:
        addi $s1, $s1, 1
    mainWhileTest:
        slt  $s3, $s0, $s2
        bne  $s3, $0,  mainWhileBody

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

        beq  $t5, $0,  rBitChk  # (lbit == 0) -> check (rbit != 0)
        beq  $t6, $0,  False    # (rbit == 0 && lbit != 0) -> failure
        beq  $0,  $0,  success  # does not trigger any failure conditions
    rBitChk:
        bne  $t6, $0,  False    # (rbit != 0 && lbit == 0) -> failure
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