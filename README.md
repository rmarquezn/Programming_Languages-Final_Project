# Feistel Cipher

## Members
* Vicente Santamaría - A01421801
* Rodrigo Marquez - A01022943

## Description
As the final project, we will be implementing a feistel cipher algorithm in Racket, which will take a message from a file and return another file with the encrypted message using 2 rounds of the feistel cipher.
Feistel Cipher model is a structure or a design used to develop many block ciphers such as DES. Feistel cipher may have invertible, non-invertible and self invertible components in its design. Same encryption as well as decryption algorithm is used. A separate key is used for each round. However same round keys are used for encryption as well as decryption.

## Lenguage
The project will be developed in [Racket](https://racket-lang.org/)

## Topics

1. File I/O
2. Encrytpion

## Detailed Description
* Create a list of all the Plain Text characters. 
* Convert the Plain Text to Ascii and then 8-bit binary format. 
* Divide the binary Plain Text string into two halves: left half (L1)and right half (R1) 
* Generate a random binary keys (K1 and K2) of length equal to the half the length of the Plain Text for the two rounds.

## Explanation
We expecto our program to encrypt and decrypt files using the feistel cipher so we can learn how complex it is to implement an encryption algorithm in Racket.

## References
[GeeksforGeeks Feistel Cipher](https://www.geeksforgeeks.org/feistel-cipher/)
