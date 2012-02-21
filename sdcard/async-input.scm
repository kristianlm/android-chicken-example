

(define-record async-input-port input-port continuation)

(set! RETURN #f)
(define (new-async-input-port input-port thunk)
  (define new-aip (make-async-input-port input-port #f))
  (define reset-proc
    (lambda (ret)
      (begin
        (let [(final-return-value (thunk))]
          (async-input-port-continuation-set! new-aip reset-proc)
          (RETURN final-return-value)))))
  (async-input-port-continuation-set! new-aip
                                      reset-proc)
  new-aip)

(define (read-async-input-port port)
  (assert (async-input-port? port))
  (assert (procedure? (async-input-port-continuation port)))

  (call/cc
   (lambda (return)
     (set! RETURN return)
     (let* ([my-read
             (lambda ()
               (call/cc
                (lambda (cc) (async-input-port-continuation-set! port cc)))
               (if (char-ready? (async-input-port-input-port port))
                   (read-char (async-input-port-input-port port))
                   (begin
                     (RETURN #f ))))]  ; not ready yet
            
            [my-ready (lambda () (char-ready? (async-input-port-input-port port)))]
            [my-close (lambda () (close-input-port (async-input-port-input-port port)))]
            [p (make-input-port
                my-read
                my-ready
                my-close)])
       (with-input-from-port p
         (lambda () 
           ((async-input-port-continuation port) #f) ))))))


