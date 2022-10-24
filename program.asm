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
    lui  $t0, 0x000F
    ori  $t0, $t0, 0x462F 
    beq  $t0, $0, False # if (word == 0) {return false}
    lui  $t1, 0x8000    # load constants
    addi $t2, $0, 1
    addi $t3, $0, 32
    addi $t4, $0, 0
    
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
        beq  $t6, $t2, False    # (rbit != 0 && lbit == 0) -> failure
    success:
        srl  $t1, $t1, 1
        sll  $t2, $t2, 1    # bit shifts
        addi $t4, $t4, 1    # i++
    forTest:
        slt  $t7, $t4, $t3   # (i < width/2)
        bne  $t7, $0, forBody
    
    # Return section
    addi $t7, $0,  1
    beq  $t7, $t7, done            # return true
    False:
        addi  $t7, $0,  0
        beq   $t7, $t7, done        # return false

    done:
        beq  $t7, $t7, done