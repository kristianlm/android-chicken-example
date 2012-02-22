
;; custom coroutine that will yield when reading
;; from port would block. allows non-blocking IO (only I, actually,
;; for now)

(define (make-input-port-yield-coroutine thunk
                                         #!optional (port (current-input-port)))
  (let* ([cr (make-coroutine #f #f)] ; TODO: use letrec here?
         [reader
          (lambda ()
            (let loop ()
              (if (char-ready? port)
                   (read-char port)
                   (begin  (coroutine-yield cr #f)
                           (loop)))))]
         [in-port (make-input-port
                   reader
                   (lambda ()  (char-ready? port))
                   (lambda () (close-input-port port)))])
    (coroutine-thunk-set! cr
                          (lambda (cr) (thunk cr in-port)))
    cr))



