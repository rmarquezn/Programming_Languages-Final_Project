
#lang racket

(define (encriptarMsg file llave vueltas)
    (define in (open-input-file file))
    (msgToList (read-line in) llave vueltas)
)
(define (msgToList msg llave vueltas)
    (listToInt (string->list msg) llave vueltas)
)
(define (listToInt msg llave vueltas [msgBits '()] [acc 0])

    (if (< acc (length msg))
        (listToInt msg llave vueltas (append msgBits (list (lstToBits (char->integer (list-ref msg acc))))) (+ acc 1))
        (divideMsg msgBits llave vueltas)
    )
)
(define (bitsLlave lstLlave [lstLlaveBits '()] [acc 0])
    (if (< acc (length lstLlave))
        (bitsLlave lstLlave (append lstLlaveBits (list (lstToBits (char->integer (list-ref lstLlave acc))))) (+ acc 1))
        lstLlaveBits
    )
)
(define (lstToBits n)
    (cond 
        [(< n 2) (number->string n)]
        [else (string-append (lstToBits (quotient n 2)) (number->string (remainder n 2)))]
    
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
                (divideMsg msg llave vueltas (append L0 (list (list-ref msg acc))) R0 (+ acc 1))
                (divideMsg msg llave vueltas L0 (append R0 (list (list-ref msg acc))) (+ acc 1))
            )
            (divideMsg (append msg (list "0000000")) llave vueltas)
        )
        (getE1 (string-join L0 "") (string-join R0 "") llave vueltas 1)
    )     
)

(define (getE1 L0 R0 llave vueltas contVueltas [E1 ""] [accR0 0] [accLlave 0]) ;Step 3
    (define nR0 (string-length R0))
    (define llaveBits (string-join (bitsLlave (string->list llave)) ""))
    (define nLlave (string-length llaveBits))

    (if (= accLlave nLlave)
        (- accLlave nLlave)
        (if (< accR0 nR0)
            (getE1 L0 R0 llave vueltas contVueltas (string-append E1 (number->string (bitwise-xor (char->integer (string-ref R0 accR0)) (char->integer (string-ref llaveBits accLlave))))) (+ accR0 1) (+ accLlave 1))
            (getR1 L0 R0 llave vueltas E1 contVueltas)
        )        
    )
)

(define (getR1 L0 R0 llave vueltas E1 contVueltas [R1 ""] [accL0 0] [R2 ""] [accR2 0]) ;Step 4
    (define nL0 (string-length L0))
    (define nE1 (string-length E1))
    (define nR2 (string-length R0))
    (if (< accL0 nL0)
        (getR1 L0 R0 llave vueltas E1 (+ contVueltas 1) (string-append R1 (number->string (bitwise-xor (char->integer (string-ref L0 accL0)) (char->integer (string-ref E1 accL0))))) (+ accL0 1) accR2)
        (if (= vueltas (- contVueltas nL0 ))
            (display-to-file (string-append R0 R1) "encriptado.txt" #:exists 'truncate)
            (getE1 R0 R1 llave vueltas (+ 1 (- contVueltas nL0 )))
        ) 
    )
)


(define (desencriptarMsg file llave vueltas)
    (define in (open-input-file file))
    (divideMsgEncry (string->list (read-line in)) llave vueltas)
)

(define (divideMsgEncry msgEncry llave vueltas [L '()] [R '()] [acc 0])
    (define n (length msgEncry))
    (if (< acc n)
        (if (< acc (/ n 2))
            (divideMsgEncry msgEncry llave vueltas (append L (list (list-ref msgEncry acc))) R (+ acc 1))
            (divideMsgEncry msgEncry llave vueltas L (append R (list (list-ref msgEncry acc))) (+ acc 1))
        )
        (process L)
    )
)

(define (process lst)
  (apply string-append                   ; append all the strings
         (map (lambda (e)                ; create a list of strings
                (if (char? e)            ; if it's a char
                    (string e)           ; convert it to string
                    (number->string e))) ; same if it's a number
              lst)))


