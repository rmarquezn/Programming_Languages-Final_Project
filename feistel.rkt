;;; Feistel Cipher
;;; Rodrigo Márquez - A01022943
;;; Vicente Santamaría - A01421801

#lang racket

;;; Se pide el nombre del archivo que contiene el mensaje con extensión  ".txt"
;;; y la llave del usuario.
(define (encriptarMsg file llave)
    (define in (open-input-file file))
    (msgToList (read-line in) llave 2)
)

;;; Convierte el mensaje a una lista de caracteres
(define (msgToList msg llave vueltas)
    (listToInt (string->list msg) llave vueltas)
)

;;; Convierte cada caracter a su equivalente en entero con "char->integer"
(define (listToInt msg llave vueltas [msgBits '()] [acc 0])
    (if (< acc (length msg))
        (if (< (string-length (lstToBits (char->integer (list-ref msg acc)))) 7)
            (listToInt msg llave vueltas (append msgBits (list 
            (string-append "0" (lstToBits (char->integer (list-ref msg acc))))))
            (+ acc 1))
            (listToInt msg llave vueltas (append msgBits (list (lstToBits 
            (char->integer (list-ref msg acc))))) (+ acc 1))
        )
        (divideMsg msgBits llave vueltas)
    )
)

;;; Conovierte la llave a una lista con su equivalente en binario
(define (bitsLlave lstLlave [lstLlaveBits '()] [acc 0])
    (if (< acc (length lstLlave))
        (bitsLlave lstLlave (append lstLlaveBits (list (lstToBits (char->integer 
        (list-ref lstLlave acc))))) (+ acc 1))
        lstLlaveBits
    )
)

;;; Convierte cada elemento de la llave a binario
(define (lstToBits n)
    (cond 
        [(< n 2) (number->string n)]
        [else (string-append (lstToBits (quotient n 2)) (number->string 
        (remainder n 2)))]
    
    )
)

;;; Se usa para convertir un numero entero a su equivalente binario
(define (bin->dec n) 
    (if (zero? n)
        n
        (+ (modulo n 10) (* 2 (bin->dec (quotient n 10))))
    )
)

;;; Divide el mensaje en 2 partes (izquierda y derecha)
(define (divideMsg msg llave vueltas [L0 '()] [R0 '()] [acc 0]) ;;Step 2
    (define n (length msg))

    (if (< acc n)
        (if (= (modulo n 2) 0)
            (if (< acc (/ n 2))
                (divideMsg msg llave vueltas (append L0 
                (list (list-ref msg acc))) R0 (+ acc 1))
                (divideMsg msg llave vueltas L0 (append R0 
                (list (list-ref msg acc))) (+ acc 1))
            )
            ; Si el mensaje es impar se agrega un 0 al final para hacer la
            ; división equitativa
            (divideMsg (append msg (list "0000000")) llave vueltas)
        )
        (getE1 (string-join L0 "") (string-join R0 "") llave vueltas 1)
    )     
)

;;; Step 3
;;; Se obtienen E1 y E2 (En = Rn-1 XOR llave)
(define (getE1 L0 R0 llave vueltas contVueltas [E1 ""] [accR0 0] [accLlave 0])
    (define nR0 (string-length R0))
    (define llaveBits (string-join (bitsLlave (string->list llave)) ""))
    (define nLlave (string-length llaveBits))

    (if (= accLlave nLlave)
        (getE1 L0 R0 llave vueltas contVueltas E1 accR0 0)
            (if (< accR0 nR0)
                (getE1 L0 R0 llave vueltas contVueltas (string-append E1 
                (number->string (bitwise-xor (char->integer
                (string-ref R0 accR0)) 
                (char->integer (string-ref llaveBits accLlave))))) (+ accR0 1) 
                (+ accLlave 1))
                (getR1 L0 R0 llave vueltas E1 contVueltas)
        )        
    )
)

;;; Step 4
;;; Se obtienen L1, L2 y R1, R2
;;; Ln = Rn-1
;;; Rn = Ln-1 XOR En
;;; Se concatenan L2 y R2 para guardar el mensaje encriptado en un archivo de
;;; texto
(define (getR1 L0 R0 llave vueltas E1 contVueltas [R1 ""] [accL0 0] [R2 ""] 
[accR2 0]) 
    (define nL0 (string-length L0))
    (define nE1 (string-length E1))
    (define nR2 (string-length R0))

    (if (< accL0 nL0)
        (getR1 L0 R0 llave vueltas E1 (+ contVueltas 1) (string-append R1 
        (number->string (bitwise-xor (char->integer (string-ref L0 accL0)) 
        (char->integer (string-ref E1 accL0))))) (+ accL0 1) accR2)
        (if (= vueltas (- contVueltas nL0 ))
            (display-to-file (string-append R0 R1) "encriptado.txt" 
            #:exists 'truncate)
            (getE1 R0 R1 llave vueltas (+ 1 (- contVueltas nL0 )))
        )
    )
    (if (and (= vueltas (- contVueltas nL0 )) (= accL0 nL0))
        (display "¡Mensaje encriptado correctamente!")
        (display "")
    )
)

;;; Se piden el nombre del archivo que contiene el mensaje encriptado y la
;;; llave del usuario
(define (desencriptarMsg file llave)
    (define in (open-input-file file))
    (divideMsgEncry (string->list (read-line in)) llave 2)
)

;;; Se divide el mensaje a la mitad
(define (divideMsgEncry msgEncry llave vueltas [L '()] [R '()] [acc 0])
    (define n (length msgEncry))

    (if (< acc n)
        (if (< acc (/ n 2))
            (divideMsgEncry msgEncry llave vueltas (append L (list 
            (list-ref msgEncry acc))) R (+ acc 1))
            (divideMsgEncry msgEncry llave vueltas L (append R (list 
            (list-ref msgEncry acc))) (+ acc 1))
        )
        (descrygetE (process R) (process L) llave vueltas 1)
    )
)

;;; Convierte los caracteres a string y los une
(define (process lst)
    (apply string-append                ; append all the strings
        (map (lambda (e)                ; create a list of strings
            (if (char? e)               ; if it's a char
                (string e)              ; convert it to string
                (number->string e)))    ; same if it's a number
                lst)
    )
)

;;; Obtenemos E2 y E1
;;; En = Ln XOR llave
(define (descrygetE R L llave vueltas contVueltas [E ""] [accL 0] [accLlave 0])
    (define nL (string-length L))
    (define llaveBits (string-join (bitsLlave (string->list llave)) ""))
    (define nLlave (string-length llaveBits))

    (if (= accLlave nLlave)
        (descrygetE R L llave vueltas contVueltas E accL 0)
        (if (< accL nL)
            (descrygetE R L llave vueltas contVueltas (string-append E 
            (number->string (bitwise-xor (char->integer (string-ref L accL)) 
            (char->integer (string-ref llaveBits accLlave))))) (+ accL 1) 
            (+ accLlave 1))
            (descrygetL R L llave vueltas E contVueltas)
        )
    )
)

;;; Obtenemos L1, L0 y R1, R0
;;; Ln = Rn+1 XOR En+1
;;; Rn = Ln+1
(define (descrygetL R L llave vueltas E contVueltas [L1 ""] [accL1 0])
    (define nR (string-length R))

    (if (< accL1 nR)
        (descrygetL R L llave vueltas E (+ 1 contVueltas) (string-append L1 
        (number->string (bitwise-xor (char->integer (string-ref R accL1)) 
        (char->integer (string-ref E accL1))))) (+ accL1 1))
        (if (= vueltas (- contVueltas nR ))
            (splitBits (string-append L1 R))
            (descrygetE L1 L llave vueltas (+ 1 (- contVueltas nR )))
        )
    )
)

;;; Separa los bits en bloques de 7 para después convertirlos a su equivalente
;;; entero y luego a caracter para después concatenar los caracteres y guardar
;;; el mensaje desencriptado en un nuevo archivo
(define (splitBits stringbits [acc 0] [msgDesencriptado ""] [bitsAux ""])
    (define n (string-length stringbits))

    (if (< acc n)
        (if (and (= (modulo acc 7) 0) (> acc 0))
            (splitBits stringbits (+ 1 acc) (string-append msgDesencriptado 
            (make-string 1 (integer->char (bin->dec (string->number bitsAux))))) 
            (string-append "" (make-string 1 (string-ref stringbits acc))))
            (splitBits stringbits (+ acc 1) msgDesencriptado 
            (string-append bitsAux (make-string 1 (string-ref stringbits acc))))
        )
        (string-append "El mensaje desencriptado es: " 
        (string-append msgDesencriptado (make-string 1 
        (integer->char  (bin->dec (string->number bitsAux))))))
    )
)
