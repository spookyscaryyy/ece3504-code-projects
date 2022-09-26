	.data
	.align	2	# align on word boundary
Array:	
	.space 400	# allocate 100 words (400 bytes)

	.text
	.globl main

# REGISTER MAPPINGS
# any unlisted registers are unused

# s0 = array pointer
# s1 = 100 = array size - used for < 100
# s2 = 101 = array size +1 - used for <= 100
# s3 = current selected prime number
# s4 = store 1

# t0 = boolean for any while loops
# t1 = iterator
# t2 = array indexing
# t3 = array grabbing
# t4 = 2nd boolean

# uses a while loop to sieve, then find the next prime number.
# exits when the next prime number cannot be found within the array
main:
	#main execution starts here
	la		$s0,	Array
	addi	$s1,	$zero,	100
	addi	$s2,	$s1,	1
	addi	$s3,	$zero,	2
	addi	$s4,	$zero,	1

	# initialize array to 1-100
	add 	$t2,	$s0,	$zero
	add		$t1,	$s4,	$zero

	bne		$zero,	$s1,	inittest
	initloop:
		sw 		$t1,	0($t2)
		addi 	$t2,	$t2,	4
		addi 	$t1,	$t1,	1
	inittest:
		slt 	$t0,	$t1,	$s2
		bne 	$t0,	$zero,	initloop
	
		bne		$zero,	$s1,	maintest	# enter loop
	mainloop:
		# body of main while loop

		# start of sieve
			add		$t1,	$s3,	$s3			# i = prime + prime
			bne		$zero,	$s1,	sievetest	# enter loop
		sieveloop:
			# body of sieve while loop
			addi	$t2,	$t1,	-1			# i - 1
			sll 	$t2,	$t2,	2			# prepare for indexing
			add		$t2,	$s0,	$t2			# array[i-1]
			sw		$zero,	0($t2) 				# array[i-1] = 0
			add		$t1,	$t1,	$s3			# i = i + prime
		sievetest:
			slt		$t0,	$t1,	$s2			# i <= 100
			bne		$t0,	$zero,	sieveloop	# while (i <= 100)
		# end of sieve


		# start of prime finding
			add		$t1,	$zero,	$s3			# i = 0 + prime
			add		$t2,	$zero,	$t1			# copy iterator
			sll 	$t2,	$t2,	2			# prepare for indexing
			add		$t2,	$s0,	$t2			# array[i] index
			bne 	$zero,	$s1,	primetest	# enter loop
		primeloop:
			addi	$t1,	$t1,	1			# i++;
			addi	$t2,	$t2,	4			# grab next array index
		primetest:
			lw 		$t3,	0($t2)				# grab array[i]
			slt		$t0,	$t1,	$s1			# i < 100
			slt 	$t4,	$t3,	$s4			# array[i] < 1
			and		$t0,	$t0,	$t4			# array[i] == 0 && i < 100
			bne		$t0,	$zero,	primeloop	# while (array[i] == 0 && i < 100)

			addi	$s3,	$t1,	1			# prime = i + 1;
		# end of prime finding


	maintest:
		slt		$t0,	$s3,	$s1			# prime < 100
		bne		$t0,	$zero,	mainloop	# while (prime < 100)
	# end main

	li $v0, 10	# exit program
	syscall

	.end