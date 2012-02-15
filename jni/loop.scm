
;(declare (uses ports))

(define-external (chicken_update) void
  (handle-exceptions
   exp (print-error-message  exp)
;   (with-output-to-string
;   (lambda ()
     (load "/sdcard/live-update.scm")
     (live-update 1)))

(return-to-host)
