#lang racket
(require racket/set)
(define (read-input) (file->list "../input"))
(define (find-dup lst [state (cons 0 (set 0))])
  (let ([result (find-dup-iter lst state)])
   (case (car result)
     ['ok (cdr result)]
     ['error (find-dup lst (cdr result))])))
(define (find-dup-iter lst state)
  (if (null? lst) (cons 'error state)
   (let ([state-set (cdr state)] [new-sum (+ (car state) (car lst))])
   (cond
     [(set-member? state-set new-sum) (cons 'ok new-sum)]
     [else (find-dup-iter (cdr lst) (cons new-sum (set-add state-set new-sum)))]))))
(println (foldr + 0 (read-input)))
(println (find-dup (read-input)))
