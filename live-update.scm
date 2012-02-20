
;; place this in /sdcard/live-update.scm on your emulator/device
;; $ adb shell push live-update.scm /sdcard/

;; this file is loaded & evaluated whenever it's modified on the device,
;; useful for interactive development (even on your real device)

;; you can hot-swap this file during a running app
;; if parsing fails, game-cycle will call the old function definition


(print "loading")

(require "/sdcard/init")
(require "/sdcard/async-input")
(use tcp)


(define aip
  (let [(line-number 0)]
    (new-async-input-port
     i
     (lambda ()
       (set! line-number (fx+ 1 line-number))
       (display (conc "@" line-number "> ") o)
       (handle-exceptions
        exn
        (with-output-to-port o
          (lambda () 
            (print-error-message exn)
            (print-call-chain)) )

        (let [(sexp (read))]
          (logi (conc "eval: " sexp))
          (with-output-to-port o
            (lambda ()
              (with-error-output-to-port o
                                         (lambda ()
                                           (display  (eval sexp))
                                           (write-char #\newline)))))))))))

(let [(c 0.2)] 
  (glClearColor c c c 1))
;; this will be called every game-loop
(define (live-update d)
  (set! y (+ 0.2 y))
  (read-async-input-port aip)
  (glClear GL_COLOR_BUFFER_BIT)
  (glPushMatrix)
  (glTranslatef 0 1 0)
  (glRotatef y 0 0 1)
  (draw-sprite 0.0 0 0.0  .2  2.0)
  (draw-sprite 0.0 0 0.0 2.0   .2)
  (glPopMatrix))


(print "load over")



