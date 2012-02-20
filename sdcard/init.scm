

;; this will be evalutated only once

(define y 0)

;; in case live-update fails itself, we
;; main.c will call this without failing
(define (live-update d ) #f)

(define s (tcp-listen 1234))

;; TODO: make this non-blocking!
(print "********** PLEASE CONNECT YOUR DEBUGGER")
(define-values (i o) (tcp-accept s))
(print "***********************  INIT LOADED")

