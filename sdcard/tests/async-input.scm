
;; TODO: update to work with coroutines

(use srfi-1) ; for make-list and map-in-order

(define (call-aip aip n)
  (let loop [(n n)]
    (if (> n 0)
        (cons (read-async-input-port aip) (loop (sub1 n)))
        '())))
(define (in-from-Q Q)
  (let* [(read (lambda () (queue-remove! Q)))
         (ready? (lambda ()  (not (queue-empty? Q))))]
    (make-input-port read ready? always?)))


;; TODO: make multiple callers of (call-aip ..) and make sure it
;; returns both with #f and real value from the correct procedure.

(let* [(Q (make-queue))]
  (let* ([aip
          (new-async-input-port
           (in-from-Q Q)
           (lambda ()
             (read)))]
         [my-write (lambda (c) (map-in-order (cut queue-add! Q <>) (string->list c)))]
         [my-close (lambda () #f)]
         [mo (make-output-port my-write my-close)]
         )
    
    (assert (equal? (call-aip aip 20) (make-list 20 #f)))
    (display "(1 2 3" mo)
 
    (assert (equal? (call-aip aip 20) (make-list 20 #f)))
    (write-line "" mo)
    (display ")" mo)
    (assert (equal? (call-aip aip 20) (cons '(1 2 3) (make-list 19 #f))))))
