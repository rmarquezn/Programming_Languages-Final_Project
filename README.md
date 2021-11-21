# Feistel Cipher

## Members
* Vicente Santamaría - A01421801
* Rodrigo Marquez - A01022943

## Description
As the final project, we will be implementing a feistel cipher algorithm in Racket, which will take a message from a file and a key and return another file with the encrypted message using 2 rounds of the feistel cipher, then it will ask the user for the key to decrypt the message.
Feistel Cipher model is a structure or a design used to develop many block ciphers such as DES. Feistel cipher may have invertible, non-invertible and self invertible components in its design. Same encryption as well as decryption algorithm is used. A separate key is used for each round. However same round keys are used for encryption as well as decryption.

## Language
The project will be developed in [Racket](https://racket-lang.org/)

## Topics
1. File I/O
2. Encryption
3. Functional Programming
4. Lists
5. Recursion

## Detailed Description
* The input block to each round is divided into two halves that can be denoted as L and R for the left half and the right half.
* In each round, the right half of the block, R, goes through unchanged. But the left half, L, goes through an operation that depends on R and the encryption key. First, we apply an encrypting function ‘f’ that takes two input − the key K and R. The function produces the output f(R,K). Then, we XOR the output of the mathematical function with L.
* In real implementation of the Feistel Cipher, such as DES, instead of using the whole encryption key during each round, a round-dependent key (a subkey) is derived from the encryption key. This means that each round uses a different key, although all these subkeys are related to the original key.
* The permutation step at the end of each round swaps the modified L and unmodified R. Therefore, the L for the next round would be R of the current round. And R for the next round be the output L of the current round.
* Above substitution and permutation steps form a ‘round’. The number of rounds are specified by the algorithm design.
* Once the last round is completed then the two sub blocks, ‘R’ and ‘L’ are concatenated in this order to form the ciphertext block.

## Example

## Explanation
We expect our program to encrypt and decrypt files using the feistel cipher so we can learn how complex it is to implement an encryption algorithm in Racket.

## References
[GeeksforGeeks Feistel Cipher](https://www.geeksforgeeks.org/feistel-cipher/)
