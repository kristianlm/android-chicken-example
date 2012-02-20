

(define-record async-input-port input-port continuation)

(set! RETURN #f)
(define (new-async-input-port input-port proc)
  (define new-aip (make-async-input-port input-port #f))
  (define reset-proc
    (lambda (ret)
      (begin
        (let [(final-return-value (proc))]
          (async-input-port-continuation-set! new-aip reset-proc)
          (RETURN final-return-value)))))
  (async-input-port-continuation-set! new-aip
                                      reset-proc)
  new-aip)

(define (read-async-input-port async-input-port)
  (assert (async-input-port? async-input-port))
  (assert (procedure? (async-input-port-continuation async-input-port)))

  (call/cc
   (lambda (return)
     (set! RETURN return)
     (let* [(my-read
             (lambda ()
               (call/cc
                (lambda (cc) (async-input-port-continuation-set! async-input-port cc)))
               (if (char-ready? i )
                   (read-char i)
                   (begin
                     (RETURN #f )))))    ; not ready jet
            
            (my-ready (lambda () (char-ready? i)))
            (my-close (lambda () (close-input-port i)))
            (p (make-input-port
                my-read
                my-ready
                my-close))]
       (with-input-from-port p
         (lambda () 
           ((async-input-port-continuation async-input-port) #f) ))))))
