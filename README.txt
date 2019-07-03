README
Tyler Hoang

- This lab was surprisingly easy - having the test code work with my code was actually the hardest part. I also had issues at the very beginning with 'jr $ra'. I couldn't make my EncryptChar subprogram work independently because I originally had it branch to EncryptString. I didn't know how to use 'jal' and 'jr $ra' until Prof. Elkaim taught it in lecture. Once I understood what the $ra and $sp registers do, the rest of the implementation process was pretty straightforward. Investing a lot of time in Lab5 last week really helped out a lot on this lab. Unexpectedly, I found myself also having a lot of issues with the test code. I'm not sure if it was ever an issue with my own Lab6.asm code, but when I created a testDC subprogram, my output was always really weird when I'd call both testEC and testDC in the same run. I found myself having to always comment out one or the other in order for my output to be correct.
- I'm thinking this is due to a space issue. When my output for testEC was the full 30 character length, my output for my testDC would be nothing. When my output for testEC was 29 characters long, my output for my testDC would only show the first character of the target string. When my output for testEC was 28 characters, the output for my testDC would only show the first two characters. In order to get rid of this issue, I had to comment out one or the other during runs. This is probably where I spent most of my time because I wasn't sure if this was an issue with my code or not. I knew my target strings were null terminated so I know that's not the issue. In the end, I just disregarded it because I took it as an error in the test code, which isn't being graded.

UPDATE: Found out my result strings actually weren't null terminated and that was causing the issue.

1) The only additional test code I wrote was testDC and testDS in order to test my DecryptChar and DecryptString subprograms. Other than that, I just kept putting in random text into the plaintext segment of the tests. The only issue I encountered was the one I mentioned above.

2)The encrypted/decrypted character would be incorrect. This is due to the fact that the code for these subprograms utilizes arithmetic that only works for uppercase letters. The characters in the keystring are being subtracted by 65 in order to get them to be in a range between 0 - 25. Other characters would result in a number that is outside of that range. 

3)The subprogram would have to constantly store the same $ra in $sp during each iteration in order for it to exit properly. It should have a dedicated register to act as a counter. Once the register is a certain number, branch to 'jr $ra'.

4)The subprogram could prompt the user to input another argument, and then store the argument in another register that will be used in the subprogram. Or the test program can just treat other registers as registers that hold arguments.
