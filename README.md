# Feistel Cipher

## Members
* Vicente Santamaría - A01421801
* Rodrigo Márquez - A01022943

## Description
As the final project, we will be implementing a feistel cipher algorithm in Elixir, which will take a message from a file and a key and return another file with the encrypted message using 2 rounds of the feistel cipher, then it will ask the user for the key to decrypt the message.  
Feistel Cipher model is a structure or a design used to develop many block ciphers such as DES. Feistel cipher may have invertible, non-invertible and self invertible components in its design. Same encryption as well as decryption algorithm is used. A separate key is used for each round. However same round keys are used for encryption as well as decryption.

For this assignment we will upgrade our code to include as many subjects seen in the class as we can so we can make our algorithm work as efficiently as possible.

## Language
The project will be developed in [Elixir](https://elixir-lang.org/)

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
input plaintext: 011110100001  
function: f(a,b,c)=c,a,b  

### Encryption

**Step 1:** *Divide plaintext in half (L0 and R0)*  
L0 = 011110  
R0 = 100001  
  
**Step 2:** *E1 = f(R0)*  
E1 = f(100) + f(001) = 010100  
  
**Step 3:** *L1 = R0, R1 = L0 XOR E1*  
L1 = 100001  
R1 = 011110 XOR 010100 = 001010  
  
**Step 4:** *E2 = f(R1)*  
E2 =  f(001) + f(010) = 100001  
  
**Step 5:** *L2 = R1, R2 = L1 XOR E2*  
L2 = 001010  
R2 = 100001  XOR 100001 = 000000  

**Step 6:** *Encrypted plaintext = L2 + R2*  
Encrypted plaintext = 001010000000  

### Decryption

**Step 1:** *Divide back the encrypted plaintext (L2, R2)*  
L2 = 001010  
R2 = 000000  
  
**Step 2:** *R1 = L2, L1 =  R2 XOR E2*  
R1 = 001010  
L1 = 000000 XOR 100001 = 100001  
  
**Step 3:** *R0 = L1, L0 = R1 XOR E1*  
R0 = 100001
L0 = 001010 XOR 010100 = 011110  
  
**Step 4:** *Decrypted plaintext = L0 + R0 = Input plaintext*  
Decrypted plaintext = 011110100001  
  
*In this example we produce E using a simple function whose only parameter is R, in our implementation we will be creating a function which takes R as the first parameter and makes use of a key to which oonly the user has access to as a second parameter to produce E.*  

![Example Diagram](docs/feistel.png)  
![Encryption Example](docs/enc.PNG)
![Desencripcion Texto](docs/des.PNG)

## Explanation
We expect our program to encrypt and decrypt files using the feistel cipher so we can learn how complex it is to implement an encryption algorithm in Racket.

## References
[GeeksforGeeks Feistel Cipher](https://www.geeksforgeeks.org/feistel-cipher/)  
[Tutorialspoint Feistel Block Cipher](https://www.tutorialspoint.com/cryptography/feistel_block_cipher.htm)  
[Project Code Mastery Feistel Encoding (Video)](https://www.youtube.com/watch?v=fenzYD2J9vs)  
[Project Code Mastery Feistel Decoding (Video)](https://www.youtube.com/watch?v=shEr8AcIqvI)  
[Computerphile Feistel Cipher (Video)](https://www.youtube.com/watch?v=FGhj3CGxl8I)
