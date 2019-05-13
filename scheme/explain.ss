;;; Conception in Scheme, from a-little-schemer.
;;; author: zbye.EvenMe
;;; date: 2019-05-08


;;; Q: What is Atom?
;;; A: String of characters.
(define atom?
  (lambda (e) (not (pair? e))))
(quote atom) ;;; => atom


;;; Q: What is List?
;;; A: Collection of Atoms enclosed by parentheses
(quote (a1 a2)) ;;; => (a1 a2)


;;; Q: What is Car?
;;; A: Car is defined only for non-empty list.
(car '(a 1 b 2)) ;;; => a


;;; Q: What is Cdr?
;;; A: Cdr is defined only for non-empty list.
;;;    The Result of Cdr is always another list.
(cdr '(a b c)) ;;; => (b c)


;;; Q: What is Lat?
;;; A: Lat is defined as A list of atoms.
(define lat?
  (lambda (l)
    (cond [(null? l) #t]
          [(atom? (car l)) (lat? (cdr l))]
          [else #f])))


;;; Q: What is Null?
;;; A: Null is defined as #(quote ()).
;;;    #(null? e) is false for everything,
;;;    except the empty list.
(null? (quote ())) ;;; => #t


;;; Q: What is Eq?
;;; A: Eq compares the storage address of two S-expressions.
(eq? 'a 'b) ;;; => #f


;;; Q: What is Member?
;;; A: See below.
(define member?
  (lambda (e lat)
    (cond [(null? lat) #f]
          [(eq? e (car lat)) #t]
          [else (member? e (cdr lat))])))


;;;  ======================================
;;;  Always ask null? as the First
;;;  Question in expressing Any Function.
;;;  ======================================


;;; Q: What is Rember?
;;; A: See blow.
(define rember
  (lambda (e lat)
    (cond [(null? lat) '()]
          [(eq? e (car lat)) (cdr lat)]
          [else (cons (car lat) (rember e (cdr lat)))])))


;;; Q: what is Firsts?
;;; A: See blow.
(define firsts
  (lambda (l)
    (cond [(null? l) '()]
          [(pair? (car l))
           (cons (caar l) (firsts (cdr l)))]
          [else (cons (car l) (firsts (cdr l)))])))


;;;  =================================================
;;;  When building a list, describe the first element,
;;;  and then cons it onto the natural recursion.
;;;  =================================================


;;; Q: what is InsertR?
;;; A: See blow.
(define insertR
  (lambda (new old lat)
    (cond [(null? lat) '()]
          [(eq? old (car lat))
           (cons (car lat) (cons new (cdr lat)))]
          [else (cons (car lat) (insertR new old (cdr lat)))])))

;;; Q: What is Multi-rember
;;; A: See blow
(define multi-rember
  (lambda (e lat)
    (cond [(null? lat) '()]
          [(eq? e (car lat)) (multi-rember e (cdr lat))]
          [else (cons (car lat) (multi-rember e (cdr lat)))])))


;;;  =================================================
;;;  Always change at least one argument while recurr-
;;;  ing and must closer to termination.
;;;  =================================================


;;; Q: What is Tup?
;;; A: A list of numberics.
(define tup?
  (lambda (lat)
    (define (iter lat)
      (cond [(null? lat) #t]
            [(number? (car lat)) (iter (cdr lat))]
            [else #f]))
    (if (null? lat) #f (iter lat))))


;;; Q: What is Pick?
;;; A: Returns the nth el of lat.
(define pick
  (lambda (n lat)
    (cond [(null? lat) '()]
          [(zero? (- n 1)) (car lat)]
          [else (pick (- n 1) (cdr lat))])))

;;; Q: What is Rempick?
;;; A: Returns lat excluding the nth el.
(define rempick
  (lambda (n lat)
    (cond [(null? lat) '()]
          [(zero? (- n 1)) (cdr lat)]
          [else (cons (car lat) (rempick (- n 1) (cdr lat)))])))


;;; What is rember*?
;;; A: See below.
(define rember*
  (lambda (e l)
    (cond [(null? l) '()]
          [(atom? (car l))
           (cond [(eq? e (car l)) (rember* e (cdr l))]
                 [else (cons (car l) (rember* e (cdr l)))])]
          [else (cons (rember* e (car l)) (rember* e (cdr l)))])))


;;;  =================================================
;;;  When recurring on a list of S-expressions, l, ask
;;;  three questions about it:
;;;  (null? l), (atom? (car l)), and else.
;;;  =================================================
(define occur*
  (lambda (e l)
    (define (add1 x) (+ x 1))
    (cond [(null? l) 0]
          [(atom? (car l))
           (cond [(eq? e (car l))
                  (add1 (occur* e (cdr l)))]
                 [else (occur* e (cdr l))])]
          [else (+ (occur* e (car l))
                   (occur* e (cdr l)))])))


;;; ************************************************
;;; * Simplify only after the function is correct. *
;;; ************************************************


;;; Q: How to implements a simple interpretation.
;;; A: See below. [For (+ 2 3)]
(define interp
  (lambda (expr)
    (define (exec op expr init-value)
      (cond [(null? expr) init-value]
            [else (op (interp (car expr))
                      (exec op (cdr expr) init-value))]))
    (cond [(atom? expr) expr]
          [else (let [(operator (car expr))
                      (operands (cdr expr))]
                  (cond [(eq? '+ operator) (exec + operands 0)]
                        [(eq? '* operator) (exec * operands 1)]))])))


;;; Q: If zero is '(), implement necessary function?
;;; A: See blow.
(define zero '())
(define zero? (lambda (n) (null? n)))
(define add1 (lambda (n) (cons '() n)))
(define sub1 (lambda (n) (cdr n)))
(define add (lambda (n m) (cond [(zero? m) n] [else (add (add1 n) (sub1 m))])))


;;; Q: What is Set?
;;; A: List with atoms only appears less than once.
(define set?
  (lambda (lat)
    (cond [(null? lat) #t]
          [(member? (car lat) (cdr lat)) #f]
          [else (set? (cdr lat))])))


;;; Q: How to convert lat to Set?
;;; A: See below.
(define lat->set
  (lambda (lat)
    (cond [(null? lat) '()]
          [(member? (car lat) (cdr lat))
           (lat->set (cdr lat))]
          [else (cons (car lat)
                      (lat->set (cdr lat)))])))


;;; Q: What is intersect?
;;; A: List of same elements depends on set1, set2.
(define intersect
  (lambda (set1 set2)
    (cond [(null? set1) '()]
          [(member? (car set1) set2)
           (cons (car set1)
                 (intersect (cdr set1) set2))]
          [else (intersect (cdr set1) set2)])))


;;; Q: What is union?
;;; A: List of all existed elements in set1, set2.
(define union
  (lambda (set1 set2)
    (cond [(null? set1) set2]
          [(member? (car set1) set2)
           (union (cdr set1) set2)]
          [else (cons (car set1)
                      (union (cdr set1) set2))])))


;;; **************************************************
;;; *             Lambda the Ultimate                *
;;; **************************************************

;;; Curry the function means converting one multi-args
;;; function to multiple nesting single-arg unctions.


;;; Q: How to Abstract common patterns with a new functions?
;;; A: See below.
(define insert-d
  (lambda (fun)
    (lambda (new old l)
      (cond [(null? l) '()]
            [(eq? (car l) old)
             (fun new old (cdr l))]
            [else (cons (car l)
                        ((insert-d fun) new old (cdr l)))]))))
(define seq-L
  (lambda (new old l)
    (cons new (cons old l))))

(define seq-R
  (lambda (new old l)
    (cons old (cons new l))))

(define seq-S
  (lambda (new old l)
    (cons new l)))

(define seq-T
  (lambda (new old l) l))

(define insert-L (insert-d seq-L))
(define insert-R (insert-d seq-R))
(define insert-S (insert-d seq-S))
(define rember-T (lambda (a l) ((insert-d seq-T) #f a l)))


;;; Q: Abstract once and once again?
;;; A: Yes, see below.
(define multi-rember$
  (lambda (e lat fun)
    (cond [(null? lat) (fun '() '())]
          [(eq? (car lat) e)
           (multi-rember$ e
                          (cdr lat)
                          (lambda (newlat seen)
                            (fun newlat (cons (car lat) seen))))]
          [else (multi-rember$ e
                               (cdr lat)
                               (lambda (newlat seen)
                                 (fun (cons (car lat) newlat) seen)))])))


;;; Q: What is Looking?
;;; A: Keep looking from lat until the elt is not a numberic.
(define looking
  (lambda (e lat)
    (define (keep-looking e pos lat)
      (cond [(null? lat) #f]
            [(number? pos)
             (keep-looking e (pick pos lat) lat)]
            [else (eq? e pos)]))
    (define (pick pos lat)
      (cond [(null? lat) '()]
            [(= pos 1) (car lat)]
            [else (pick (- pos 1) (cdr lat))]))
    (keep-looking e (pick 1 lat) lat)))


;;; Q: What is Eternity?
;;; A: It's unnatural recursion and the most partial function.
(define eternity (lambda (x) (eternity x)))


;;; Q: What is Shift?
;;; A: See below.
(define shift
  (lambda (l)
    (cond [null? ])))


;;; Q: Approval a funny process?
;;; A: See below.
(define unknown
  (lambda (n)
    (cond [(= n 1) 1]
          [(even? n) (unknown (/ n 2))]
          [else (unknown (+ 1 (* n 3)))])))


;;; Q: Generate Function without Definition?
;;; A: See blew.
;;; ((lambda (proc) (proc proc))) runs as process-bootstrap

;;; length without using keyword: define.
((lambda (le)
   ;; invoke itself.
   ((lambda (f) (f f))
    (lambda (f) (le (lambda (x) ((f f) x))))))
 ;; actual needed function.
 (lambda (length)
   (lambda (l)
     (cond [(null? l) 0]
           [else (+ 1 (length (cdr l)))]))))


;;; extract high-order abstractrion of recurison.
(define Y
  (lambda (actual)
    ((lambda (f) (f f))
     (lambda (f) (actual (lambda (x) ((f f) x)))))))


;;; length is the process {(lambda (f) (le (lambda (x ((f f) x)))))}.
;;; le is the process {(lambda (length) ...)}.


;;; Q: What is the Value of All of This?
;;; A: See below.
(define (build s1 s2)
  (cons s1 (cons s2 '())))

(define new-entry build)

(define extend-table cons)

(define first (lambda (l) (car l)))

(define second (lambda (l) (cadr l)))

(define look-in-entry
  (lambda (name entry entry-f)
    (define (look-in-entry-help name names values entry-f)
      (cond [(null? names) (entry-f name)]
            [(eq? (car names) name) (car values)]
            [else (look-in-entry-help name (cdr names) (cdr values) entry-f)]))
    (look-in-entry-help name (first entry) (second entry) entry-f)))


(define apply-closure
  (lambda (closure vals)
    (meaning (body-of closure)
             (extend-table (new-entry (formals-of closure) vals)
                           (table-of closure)))))


(define meaning
  (lambda (e table)
    ((expression-to-action e) e table)))
