	.data
	.align		# align on word boundary
A:
	.space 400	# allocate 100 words (400 bytes)

	.text
	.globl main

# s7 = -1
main:
	#main execution starts here
	andi	$s7,	$s7,	$zero
	addi	$s7,	$s7,	-1
	
	bne	$zero,	$s7,	test
mainloop:
	# body of while loop
	# jump to sieve
	# jump to findPrime
maintest:
	slt	$t0,	$t0,	$s7
	bne	$t0,	$zero,	startloop
# end main


# t0 = iterator
# t1 = array size value
# t9 = loop boolean
# v0 = point to sieve array
# v1 = current max prime
sieve:
	# sieve function, filters out the multiple of the current testing prime in $v1
	and	$t0,	$t0,	$zero
	and	$t0,	$t0,	$v1
	bne	$s7,	$zero,	sievetest
sieveloop:
	
	addi	$t0,	$t0,	1
sievetest:
	slt	$t9,	$t0,	$t1
	bne	$t9,	$zero,	sieveloop
# end sieve

# t0 = iterator
# t1 = array size value
# t9 = loop boolean
# v0 = pointer to sieve array
# v1 = current max prime
findPrime:
	# find prime function, find the next prime number to sieve out of the array
	and	$t0,	$t0,	$zero
	add	$t0,	$t0,	$v1
	bne	$s7,	$zero,	primetest
primeloop:
	#prime loop
	addi	$t0,	$t0,	1
primetest:
	slt	$t9,	$t0,	$t1
	bne	$t9,	$zero,	primeloop

# end findPrime
	li $v0, 10	# exit program
	syscall

	.end
