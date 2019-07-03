#Tyler Hoang | 1583540
#tydhoang@ucsc.edu
#3/9/18
#Lab 6: Vigenere Cipher 
#Section - 01F: Cory Ibanez

#Pseudocode:
#EncryptChar:
#	Subtract 65 from the plaintext character and the keystring character
#	If the plaintext is lowercase, subtract 90 from it instead of 65
#	Add both numbers together
#	Add 65 to that number
#	mod 26
#	Move the final number to $v0
#
#DecryptChar:
#	Same thing as EncryptChar, except we are subtracting instead of adding
#	mod -26 instead of mod26
#
#EncryptString:
#	Push $ra onto stack
#	Load the first byte of the plaintext and the first byte of the keystring
#	If the loaded plaintext byte is 0, end the subprogram
#	Check to see if the loaded plaintext byte is a letter
#		Check to see if the byte is greater than 122
#		Check to see if the byte is greater than 90, and less than 97
#		If it is either one of these conditions, just store the byte in $a2 without encryption
#	Check if the keystring has been fully iterated through
#		If it has, move the iterator back to the first byte of the keystring
#	Jump to EncryptChar to encrypt the character
#	Store the character in the current address in $a2
#	Iterate through all 3 addresses (plaintext, keystring, and target string)
#	Add 1 to the subprogram counter
#	If the counter is 30, end the subprogram
#	Add null terminator to end of the target string
#	Pop $ra off of stack
#
#DecryptString:
#	Same thing as EncryptString, except the subprogram jumps to DecryptChar to decrypt the character

#########################################################################################################################

# Subroutine EncryptChar
# 	Encrypts a single character using a single key character.
# input: 	$a0 = ASCII character to encrypt
# 		$a1 = key ASCII character
# output: 	$v0 = Vigenere-encrypted ASCII character
# Side effects: None
# Notes: 	Plain and cipher will be in alphabet A-Z or a-z
# 		key will be in A-Z
# Registers used:
#		$t0 = used to temporarily save the contents of $a0 before encryption
#		$t1 = used to temporarily save the contents of $a1 before encyrption
#		$t2 = the computed enrypted character
EncryptChar:
	move $t0 , $a0			#Move the contents of $a0 to $t0
	move $t1 , $a1			#Move the contents of $a1 to $t1
	bgt $t0 , 96 , __lowercase	#Branch to __lowercase if $t0 is greater than 96
	sub $t0 , $t0 , 65		#Subtract 65 from $t0
	sub $t1 , $t1 , 65		#Subtract 65 from $t1
	add $t2 , $t0 , $t1		#Add $t0 and $t1 together and store sum in $t2
	rem $t2 , $t2 , 26		#Store the remainder of $t2 divided by 26
	add $t2 , $t2 , 65		#Add 65 to $t2
	move $v0 , $t2			#Move the contents of $t2 to $v0
	jr $ra				#Jump to return address

	__lowercase:
	sub $t0 , $t0 , 97		#Subtract 97 from $t0		
	sub $t1 , $t1 , 65		#Subtract 65 from $t1
	add $t2 , $t0 , $t1		#Add $t0 and $t1 together and store sum in $t2
	rem $t2 , $t2 , 26		#Store the remainder of $t2 divided by 26
	add $t2 , $t2 , 97		#Add 97 to $t2
	move $v0 , $t2			#Move the contents of $t2 to $v0
	jr $ra				#Jump to return address

# Subroutine DecryptChar
# 	Decrypts a single character using a single key character.
# input: $	a0 = ASCII character to decrypt
# 		$a1 = key ASCII character
# output: 	$v0 = Vigenere-decrypted ASCII character
# Side effects: None
# Notes: 	Plain and cipher will be in alphabet A-Z or a-z
# 		key will be in A-Z. The difference here is that instead of adding,
#		the subprogram will be subtracting the characters and dividing by -26.
# Registers used:
#		$t0 = used to temporarily save the contents of $a0 before decryption
#		$t1 = used to temporarily save the contents of $a1 before decyrption
#		$t2 = the computed enrypted character
DecryptChar:
	move $t0 , $a0			#Move the contents of $a0 to $t0
	move $t1 , $a1			#Move the contents of $a1 to $t1
	bgt $t0 , 96 , __dlowercase	#Branch to __dlowercase if $t0 is greater than 96
	sub $t0 , $t0 , 65		#Subtract 65 from $t0
	sub $t1 , $t1 , 65		#Subtract 65 from $t1
	sub $t2 , $t0 , $t1		#Subtract $t1 from $t0 and store the result in $t2
	remu $t2 , $t2 , -26		#Store the unsigned remainder of $t2 divided by -26
	add $t2 , $t2 , 65		#Add 65 to $t2
	move $v0 , $t2			#Move the contents of $t2 to $v0
	jr $ra				#Jump to return address

	__dlowercase:
	sub $t0 , $t0 , 97		#Subtract 97 from $t0
	sub $t1 , $t1 , 65		#Subtract 65 from $t1
	sub $t2 , $t0 , $t1		#Subtract $t1 from $t0 and store the result in $t2
	remu $t2 , $t2 , -26		#Store the unsigned remainder of $t2 divided by -26
	add $t2 , $t2 , 97		#Add 97 to $t2
	move $v0 , $t2			#Move the contents of $t2 to $v0
	jr $ra				#Jump to return address

# Subroutine EncryptString
# 	Encrypts a null-terminated string of length 30 or less,
# 	using a keystring.
# input: 	$a0 = Address of plaintext string
# 		$a1 = Address of key string
# 		$a2 = Address to store ciphertext string
# output: 	None
# Side effects: String at $a2 will be changed to the
# 		Vigenere-encrypted ciphertext.
# 		$a0, $a1, and $a2 may be altered
# Notes:	The subprogram iterates up to 30 characters in the plaintext,
#		iterates through the keystring (possibly multiple times), and
#		iterates through the target string location
# Registers used:
#		$t4 = counter that ensures the subprogram only iterates through 30 characters
#		$s0 = Saves the contents of $a0 before encryption
#		$s1 = Saves the contents of $a1 before encryption
#		$t3 = counter for the amount of times subprogram iterates through the keystring - 
#	`		if the loaded byte of keystring is 0, subtract $t3 from the address,
#			then set $t3 back to 0
EncryptString:
	addi $sp $sp , -4
	sw $ra , 0($sp)			#Push $ra onto stack

	__encryptstring:
		beq $t4 , 30 , __halt		#If the subprogram has iterated over 30 characters, exit the subprogram
		move $s0 , $a0			#Save the contents of $a0 in $s0
		move $s1 , $a1			#Save the contents of $a1 in $s1
		lb $a0 , 0($a0)			#Load the character at the 0th position of the plaintext
		lb $a1 , 0($a1)			#Load the character at the 0th position of the keystring
		beqz $a0 , __halt		#If there are no characters left in the plaintext, branch to __halt
	
		bgt $a0 , 122 , __notletter	#Checks to see if character is not a letter
		bgt $a0 , 90 , __checkcharacter	#If the character is above 90, branch to __checkcharacter to check if it is less than 97
		bgt $a0 , 64 , __checkKey	#After going through the first two conditions, the character must be a letter, branch to __checkKey
	
		__notletter: 
			sb $a0 , ($a2)			#Store the byte in $a2
			add $s1 , $s1 , -1		#Subtract 1 from $s1 to prevent the keystring from iterating
			b __continue			#Branch to __continue
	
		__checkcharacter:
			blt $a0 , 97 , __notletter	#If the character is greater than 90 and less than 97, character is not a letter, branch to __NotLetter
	
		__checkKey: 
			bnez $a1 , __encrypt		#If the loaded byte of the keystring is not 0, branch to __encrypt
			move $a1 , $s1			#Move the contents of $s1 to $a1
			sub $a1 , $a1 , $t3		#Set the address back to the first character of the keystring
			move $s1 , $a1			#Move the contents of $a1 to $s1
			lb $a1 , 0($a1)			#Load the first character of the keystring
			add $t3, $zero , 0		#Set $t3 back to 0
	
		__encrypt:
			jal EncryptChar 		#Jump to the EncryptChar subprogram
			sb $v0 , ($a2)			#Store the encrypted byte into $a2
			add $t3 , $t3 , 1		#Add 1 to $t3
	
		__continue: 
			move $a0 , $s0			#Move the contents of $s0 into $a0
			move $a1 , $s1			#Move the contents of $s1 into $a1
			add $a0 , $a0 , 1		#Iterate to the next character in the plaintext
			add $a1 , $a1 , 1		#Iterae to the next character in the keystring
			add $a2 , $a2 , 1		#Iterate to the next location in $a2
			add $t4 , $t4 , 1		#Add 1 to $t4 to keep track of amount of iterations
			
	b __encryptstring		#Branch back to __encryptstring
	
	__halt:
		add $t4 , $zero , 0
		sb $t4 , ($a2)			#Null terminate the string
		add $s0 , $zero , 0		#Set $s0 back to it's original contents
		add $s1 , $zero , 0		#Set $s0 back to it's original contents
		lw $ra , 0($sp)			#Pop $ra off of stack
		addi $sp , $sp , 4
		jr $ra				#Jump to the return address

# Subroutine DecryptString
# 	Decrypts a null-terminated string of length 30 or less,
# 	using a keystring.
# input: 	$a0 = Address of ciphertext string
# 		$a1 = Address of key string
# 		$a2 = Address to store plaintext string
# output: 	None
# Side effects: String at $a2 will be changed to the
# 		Vigenere-decrypted plaintext
# 		$a0, $a1, and $a2 may be altered
# Notes:	The same as EncryptString, except program jumps
#		to DecryptChar. The subprogram iterates up to 30 characters in the plaintext,
#		iterates through the keystring (possibly multiple times), and
#		iterates through the target string location
# Registers used:
#		$t4 = counter that ensures the subprogram only iterates through 30 characters
#		$s0 = Saves the contents of $a0 before decryption
#		$s1 = Saves the contents of $a1 before decryption
#		$t3 = counter for the amount of times subprogram iterates through the keystring - 
#	`		if the loaded byte of keystring is 0, subtract $t3 from the address,
#			then set $t3 back to 0
DecryptString:
	addi $sp $sp , -4
	sw $ra , 0($sp)			#Push $ra onto stack
	
	__decryptstring:
		beq $t4 , 30 , __dhalt		#If the subprogram has iterated over 30 characters, exit the subprogram
		move $s0 , $a0			#Save the contents of $a0 in $s0
		move $s1 , $a1			#Save the contents of $a1 in $s1
		lb $a0 , 0($a0)			#Load the character at the 0th position of the plaintext
		lb $a1 , 0($a1)			#Load the character at the 0th position of the keystring
		beqz $a0 , __dhalt		#If there are no characters left in the plaintext, branch to __dhalt
	
		bgt $a0 , 122 , __dnotletter	#Checks to see if character is not a letter
		bgt $a0 , 90 , __dcheckcharacter#If the character is above 90, branch to __dcheckcharacter to check if it is less than 97
		bgt $a0 , 64 , __dcheckKey	#After going through the firs two conditions, the character must be a letter, branch to __dcheckKey
	
		__dnotletter: 
			sb $a0 , ($a2)			#Store the byte in $a2
			add $s1 , $s1 , -1		#Subtract 1 from $s1 to prevent the keystring from iterating
			b __dcontinue			#Branch to __dcontinue
	
		__dcheckcharacter:		
			blt $a0 , 97 , __dnotletter	#If the character is greater than 90 and less than 97, character is not a letter, branch to __dnotletter
	
		__dcheckKey: 
			bnez $a1 , __decrypt		#If the loaded byte of the keystring is not 0, branch to __decrypt
			move $a1 , $s1			#Move the contents of $s1 to $a1
			sub $a1 , $a1 , $t3		#Set the address back to the first character of the keystring
			move $s1 , $a1			#Move the contents of $a1 to $s1
			lb $a1 , 0($a1)			#Load the first character of the keystring
			add $t3, $zero , 0		#Set $t3 back to 0
	
		__decrypt:
			jal DecryptChar 		#Jump to the DecryptChar subprogram
			sb $v0 , ($a2)			#Store the decrypted byte into $a2
			add $t3 , $t3 , 1		#Add 1 to $t3
	
		__dcontinue: 
			move $a0 , $s0			#Move the contents of $s0 into $a0
			move $a1 , $s1			#Move the contents of $s1 into $a1
			add $a0 , $a0 , 1		#Iterare to the next character in the plaintext
			add $a1 , $a1 , 1		#Iterate to the next character in the keystring
			add $a2 , $a2 , 1		#Iterate to the next location in $a2
			add $t4 , $t4 , 1		#Add 1 to $t4 to keep track of amount of iterations
			
	b __decryptstring		#Branch back to __decryptstring
	
	__dhalt: 
		add $t4 , $zero , 0
		sb $t4 , ($a2)			#Null terminate the string
		add $s0 , $zero , 0		#Set $s0 back to it's original contents
		add $s1 , $zero , 0		#Set $s1 back to it's original contents
		lw $ra , 0($sp)			#Pop $ra off of stack
		addi $sp , $sp , 4		
		jr $ra				#Jump to the return address
