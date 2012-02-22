

;; simple coroutines aka cooperative-threads functionality
;; using continuations.

;; threads need to yield explicitly
(define-record coroutine thunk return)

(define (coroutine-yield cr arg)
  (call/cc
   (lambda (continue)
     (coroutine-thunk-set! cr continue)
     (let ([return (coroutine-return cr)])
       (coroutine-return-set! cr #f) ; can only return to here once
       (return arg)))))

(define (coroutine-call cr)
  (if (coroutine-thunk cr)
      (call/cc
       (lambda (return)
         (coroutine-return-set! cr return)
         (let ([exit-code ((coroutine-thunk cr) cr)]
               [return (coroutine-return cr)])
           (coroutine-thunk-set! cr #f) ; continue-point now invalid
           (coroutine-return-set! cr #f) ; return-point also invalid
           (return exit-code))))
      (warning (conc "coroutine " cr " is dead"))))


