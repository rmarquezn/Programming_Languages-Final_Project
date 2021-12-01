;;; Feistel Cipher
;;; Rodrigo Márquez - A01022943
;;; Vicente Santamaría - A01421801

#lang racket

(define (encriptarMsg file llave)
    (define in (open-input-file file))
    (msgToList (read-line in) llave 2)
)

(define (msgToList msg llave vueltas)
    (listToInt (string->list msg) llave vueltas)
)

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

(define (bitsLlave lstLlave [lstLlaveBits '()] [acc 0])
    (if (< acc (length lstLlave))
        (bitsLlave lstLlave (append lstLlaveBits (list (lstToBits (char->integer 
        (list-ref lstLlave acc))))) (+ acc 1))
        lstLlaveBits
    )
)

(define (lstToBits n)
    (cond 
        [(< n 2) (number->string n)]
        [else (string-append (lstToBits (quotient n 2)) (number->string 
        (remainder n 2)))]
    
    )
)

(define (bin->dec n) 
    (if (zero? n)
        n
        (+ (modulo n 10) (* 2 (bin->dec (quotient n 10))))
    )
)

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
            (divideMsg (append msg (list "0000000")) llave vueltas)
        )
        (getE1 (string-join L0 "") (string-join R0 "") llave vueltas 1)
    )     
)

;Step 3
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

;Step 4
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


(define (desencriptarMsg file llave)
    (define in (open-input-file file))
    (divideMsgEncry (string->list (read-line in)) llave 2)
)

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

(define (process lst)
    (apply string-append                ; append all the strings
        (map (lambda (e)                ; create a list of strings
            (if (char? e)               ; if it's a char
                (string e)              ; convert it to string
                (number->string e)))    ; same if it's a number
                lst)
    )
)


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

