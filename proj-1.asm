	.data
	.align	2	# align on word boundary
Array:	
	.space 400	# allocate 100 words (400 bytes)

	.text
	.globl main

# REGISTER MAPPINGS
# any unlisted registers are unused

# s0 = array pointer
# s1 = current selected prime number

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
	addi	$s1,	$zero,	2

	# initialize array to 1-100
	addi 	$t2,	$s0,	0				# copy array pointer
	addi	$t1,	$zero,	1				# i = 1

	bne		$zero,	$s1,	inittest		# enter loop
	initloop:
		sw 		$t1,	0($t2)				# grab array[i]
		addi 	$t2,	$t2,	4			# prepare for indexing - next array element
		addi 	$t1,	$t1,	1			# # i++;
	inittest:
		slti	$t0,	$t1,	101			# i <= 100
		bne 	$t0,	$zero,	initloop	# while (i <= 100)
	
		bne		$zero,	$s1,	maintest	# enter loop
	mainloop:
		# body of main while loop

		# start of sieve
			add		$t1,	$s1,	$s1			# i = prime * 2
			bne		$zero,	$s1,	sievetest	# enter loop
		sieveloop:
			# body of sieve while loop
			addi	$t2,	$t1,	-1			# i - 1
			add 	$t2,	$t2,	$t2			# prepare for indexing
			add 	$t2,	$t2,	$t2			# prepare for indexing
			add		$t2,	$s0,	$t2			# array[i-1]
			sw		$zero,	0($t2) 				# array[i-1] = 0
			add		$t1,	$t1,	$s1			# i = i + prime
		sievetest:
			slti	$t0,	$t1,	101			# i <= 100
			bne		$t0,	$zero,	sieveloop	# while (i <= 100)
		# end of sieve


		# start of prime finding
			addi	$t1,	$s1,	0			# i = 0 + prime
			addi	$t2,	$t1,	0			# copy iterator
			add 	$t2,	$t2,	$t2			# prepare for indexing
			add 	$t2,	$t2,	$t2			# prepare for indexing
			add		$t2,	$s0,	$t2			# array[i] index
			bne 	$zero,	$s1,	primetest	# enter loop
		primeloop:
			addi	$t1,	$t1,	1			# i++;
			addi	$t2,	$t2,	4			# grab next array index
		primetest:
			lw 		$t3,	0($t2)				# grab array[i]
			slti	$t0,	$t1,	99			# i < 99
			slti	$t4,	$t3,	1			# array[i] < 1
			and		$t0,	$t0,	$t4			# array[i] == 0 && i < 100
			bne		$t0,	$zero,	primeloop	# while (array[i] == 0 && i < 100)

			addi	$s1,	$t1,	1			# prime = i + 1;
		# end of prime finding


	maintest:
		slti	$t0,	$s1,	100			# prime < 100
		bne		$t0,	$zero,	mainloop	# while (prime < 100)
	# end main

	li $v0, 10	# exit program
	syscall

	.end