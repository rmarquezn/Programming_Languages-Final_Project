
#lang racket

(define (leerMsg file)
    (define in (open-input-file file))
    (msgToList (read-line in))
)

(define (msgToList msg)
    (listToInt (string->list msg))
)

(define (listToInt lst [lstBits '()] [acc 0])

    (if (< acc (length lst))
        (listToInt lst (append lstBits (list (lstToBits (char->integer (list-ref lst acc))))) (+ acc 1))
        (divideList lstBits)
    )
)

(define (lstToBits n)
    (cond [(< n 2) (number->string n)]
    [else (string-append (lstToBits (quotient n 2)) (number->string (remainder n 2)))])
)

(define (divideList lst [lst1 '()] [lst2 '()] [acc 0])
    (define n (length lst))
    (if (< acc n)
        (if (= (modulo n 2) 0)
            (if (< acc (/ n 2))
                (divideList lst (append lst1 (list (list-ref lst acc))) lst2 (+ acc 1))
                (divideList lst lst1 (append lst2 (list (list-ref lst acc))) (+ acc 1))
            )
            0
        )
        lst1
    )
        
)

