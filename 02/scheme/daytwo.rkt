#lang racket
(define (read-input) (file->lines "../input"))

(define (part-one)
  (let ([freqs (map letter-freq (read-input))])
   (* (length (filter (lambda (x) (member 2 x)) freqs))
      (length (filter (lambda (x) (member 3 x)) freqs)))))

(define (letter-freq str)
  (map length (group-by identity (string->list str))))

(define (part-two)
  (let ([data (read-input)])
    (stream-first-non-null
      (stream-map (lambda (x) (stream-first-non-null
                                (stream-map (lambda (y) (find-one-different x y))
                                            data)))
                  data))))

(define (find-one-different x y)
  (let ([common (string-find-common x y)])
    (if (= (- (string-length x) 1) (string-length common)) common null)))

(define (string-find-common x y)
  (list->string (map car (filter (lambda (x) (equal? (car x) (cdr x)))
                                 (map cons (string->list x) (string->list y))))))

(define (stream-first-non-null str)
  (let ([filtered (stream-filter (lambda (x) (not (null? x))) str)])
    (if (stream-empty? filtered) null (stream-first filtered))))

(println (part-one))
(println (part-two))
