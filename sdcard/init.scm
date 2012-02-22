

;; this will be evalutated only once

(define y 0)

;; in case live-update fails itself, we
;; main.c will call this without failing
(define (live-update d ) #f)

;; a global listening socket for remote-repl
(define *repl-socket* (tcp-listen 1234))

