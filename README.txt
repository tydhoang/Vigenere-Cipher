/************************************************************
* README
* Tyler Hoang
************************************************************/
Required Files:
Lab6.asm
test_Lab6.asm

***********************************************************
Usage: Place test_Lab6.asm in the same folder as Lab6.asm.
Run test_Lab6.asm in MARS (MIPS Assembler and Runtime Simulator)
***********************************************************

This program includes a set of MIPS32 subroutines and some test code for those subroutines. These subroutines perform various encryption and decryption algorithms related to the Vigenere Cipher.

The Vignere cipher has the following properties:
- It operates over the alphabet of ASCII letters: [ABCDE.....XYZ] and [abcd....xyz]
- When encrypting/decrypting strings, it should ignore any other ASCII characters in the plaintext (spaces, punctuation, unprintable characters, etc.). The key should not advance over these characters.
- The keystring will only contain uppercase characters in the alphabet, [A-Z]. 
- Encryption and decryption are inverse operations. Any message encrypted with key can be decrypted with the same key, returning to the original plaintext.

Subroutines:
To interact correctly with the testing code, the program uses MIPS calling conventions. Information is passed into the subroutine using $a registers, and information is returned from the subroutine using the $v registers. The spec describes the specific role of each register. Furthermore, $s registers are meant to be preserved when subroutines are called, so their values are unchanged from the value it contained after the subroutine returns. After a subroutine is complete, the $pc points to the address of the instruction after the calling instruction (that is, the program counter should “return” to the calling code). “jal” is used to store the address of the return instruction in $ra, and “jr $ra” is used to return to the appropriate instruction. Note that calling a subroutine inside of another subroutine will overwrite $ra, so the $ra values are put on the stack.

Encrypting and Decrypting Characters:
To encrypt characters according to the rules of the Vigenere cipher, the alphabet is treated as a field of numbers in which it is appropriate to do arithmetic (that is, translate [A-Z] to [0-25] and do arithmetic on the integers). EncryptChar and DecryptChar never take inputs that are not upper or lowercase letters. You will need to handle upper and lowercase letters slightly differently. 

Encrypting and Decrypting Strings: 
To encrypt or decrypt a string, iteration occurs along the string with each character handled independently. In this case, iteration occurs over three strings simultaneously. Once the characters to operate on have been detected, EncryptString or DecryptString are called as appropriate. EncryptString and DecryptString do not handle encryption arithmetic.