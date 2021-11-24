
#lang racket

(define (encriptarMsg file llave)
    (define in (open-input-file file))
    (msgToList (read-line in) llave)
)

(define (msgToList msg llave)
    (listToInt (string->list msg) llave)
)

(define (listToInt lst llave [lstBits '()] [acc 0])

    (if (< acc (length lst))
        (listToInt lst llave (append lstBits (list (lstToBits (char->integer (list-ref lst acc))))) (+ acc 1))
        (divideList lstBits llave)
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

(define (divideList lst llave [lst1 '()] [lst2 '()] [acc 0])
    (define n (length lst))
    (if (< acc n)
        (if (= (modulo n 2) 0)
            (if (< acc (/ n 2))
                (divideList lst llave (append lst1 (list (list-ref lst acc))) lst2 (+ acc 1))
                (divideList lst llave lst1 (append lst2 (list (list-ref lst acc))) (+ acc 1))
            )
            (divideList (append lst (list "0000000")) llave)
        )
        (keyList (string-join lst1 "") (string-join lst2 "") llave)
    )     
)

(define (keyList L0 R0 llave [E1 '()] [lst2Aux '()])
    (define L0Lenght (length L0))
    (if (< acc n)
        
    )

)
(define (xorList L0 E1 [R1 '()])
    (if (empty? E1)
        (for/list ([i R0] [k (in-cycle (string-join (bitsLlave (string->list llave)) ""))])
            (keyList L0 R0 llave (append E1 (list (bitwise-xor (char->integer i) (char->integer k)))) lst2Aux)
        )
        R0
    )
)

