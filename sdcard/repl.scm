

(define (my-repl i o)
  (let* ([show-prompt
          (let ([line-number 0])
            (lambda ()
              (set! line-number (fx+ 1 line-number))
              (display (conc "@" line-number "> ") o)))])
    (handle-exceptions
     exn
     (with-output-to-port o
       (lambda () 
         (print-error-message exn)
         (print-call-chain)))
     (let loop ()
       (show-prompt)
       (let [(sexp (read i))]
;         (logi (conc "eval: " sexp))
         (with-output-to-port o
           (lambda ()
             (with-error-output-to-port o
                                        (lambda ()
                                          (display (eval sexp))
                                          (write-char #\newline))))))
       (loop)))))
