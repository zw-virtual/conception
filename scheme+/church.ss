;; Church Encode
;; Definition: Church numerals are the representations of natural numbers under Church encoding.
;; The higher-order function that represents natural number n is a function that maps any function f to its n-fold composition.
;; In simpler terms, the "value" of the numeral is equivalent to the number of times the function encapsulates its argument.

;; Church Number
;; Zero
(define zero (lambda (f) (lambda (x) x)))
;; One
(define one (lambda (f) (lambda (x) (f x))))
;; Two
(define two (lambda (f) (lambda (x) (f (f x)))))
;; Three
(define three (lambda (f) (lambda (x) (f (f (f x))))))

;; Church Function
;; Succ (next n)
(define (succ n) (lambda (f) (lambda (x) (f ((n f) x)))))
;; Add (+ n m)
(define (add n m) (lambda (f) (lambda (x) ((((n succ) m) f) x))))
;; Pred (pred n)
(define (pred n) (lambda (f) (lambda (x) (((n (lambda (g) (lambda (h) (h (g f))))) (lambda (u) x)) (lambda (u) u)))))
;; Sub (- n m)
(define (sub n m) (lambda (f) (lambda (x) ((((m pred) n) f) x))))
;; Mult (* n m)
(define (mult n m) (lambda (f) (lambda (x) ((n (m f)) x))))
;; Exp (^ n m)
(define (exp n m) (lambda (f) (lambda (x) (((m n) f) x))))

;; True
(define true (lambda (a) (lambda b) a))
;; False
(define false (lambda (a) (lambda b) b))
;; And
(define and (lambda (p) (lambda (q) (p q p))))
;; OR
(define or (lambda (p) (lambda (q) (p p q))))
