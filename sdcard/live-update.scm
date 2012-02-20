
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
  (let* [(show-prompt
          (let [(line-number 0)]
            (lambda ()
              (set! line-number (fx+ 1 line-number))
              (display (conc "@" line-number "> ") o))))
        (repl
         (lambda ()
           (handle-exceptions
            exn
            (with-output-to-port o
              (lambda () 
                (print-error-message exn)
                (print-call-chain)))
            (begin (show-prompt)
              (let [(sexp (read))]
               (logi (conc "eval: " sexp))
               (with-output-to-port o
                 (lambda ()
                   (with-error-output-to-port o
                                              (lambda ()
                                                (display  (eval sexp))
                                                (write-char #\newline))))))))))]
    (new-async-input-port i repl)))

(let [(c 0.2)] 
  (glClearColor c c c 1))

(define (my-drawsprite)
  (draw-sprite 0 0 0 2 .3))

(begin  ;; setup viewport
  (glMatrixMode GL_PROJECTION)
  (glLoadIdentity)
  (let [(w 1.6)
        (h 2.4)]
    (glFrustumf (- w) w (- h) h 5 10))
  (glMatrixMode GL_MODELVIEW)
  (glLoadIdentity)
  (glTranslatef 0 0 -6))

(glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)

;; this will be called every game-loop
(define (live-update d)
  (set! y (+ 0.2 y))
  (read-async-input-port aip)
  (glClear GL_COLOR_BUFFER_BIT)
  (glPushMatrix)
  (glColor4f 1 1 1 0.5)
  (glRotatef y 0 0 1)
  ;; draw some kind of "star"
  (let [(ds (lambda ()
              (glRotatef 45 0 0 1)  (my-drawsprite)  
              (glRotatef 45 0 0 1)  (my-drawsprite)  
              (glRotatef 45 0 0 1)  (my-drawsprite)  
              (glRotatef 45 0 0 1)  (my-drawsprite)))]
    (ds) (glRotatef 22.5 0 0 1) (ds))
  (glPopMatrix))

(print "load over")



