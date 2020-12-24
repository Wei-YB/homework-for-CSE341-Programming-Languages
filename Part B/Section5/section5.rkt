#lang racket
(provide (all-defined-out))

(define x 3)    ; val x = 3
(define y (+ x 2))  ; + is a function, call it here

(define cube1
    (lambda (x)
        (* x (* x x))))
(define cube2
    (lambda (x)
        (* x x x)))

(define (cube3 x)
    (* x x x))

(define (pow1 x y))
    (if (= y 0)
        1
        (* x (pow1 x (- y 1))))

(define pow2
    (lambda (x)
        (lambda (y)
            (pow1 x y))))

(define three-to-the (pow2 3))

(define sixteen1 (pow1 4 2))
(define sixteen2 ((pow2 4) 2))

#lang racket
(provide (all-defined-out))

(define (my-thunk th)
    (mcons #f th))

(define (my-force p)
    (if (mcar p)
        (mcdr p)
        (begin (set-mcar! p #t)
                (set-mcdr! p ((mcdr p)))
                (mcdr p))))

(define (slow-add x y)
    (letrec ([slow-id (lambda (y z)
                        (if (= 0 z)
                            y
                            (slow-id y (- z 1))))])
    (+ (slow-id x 500000000) y)))

(define (my-mult x y-thunk)
    (cond   [(= x 0) 0]
            [(= x 1) (y-thunk)]
            [#t (+ (y-thunk) (my-mult (- x 1) y-thunk))]))

(define seven-thunk (lambda () (slow-add 3 4)))
(define seven-promise (my-thunk seven-thunk))