
;; place this in /sdcard/live-update.scm on your emulator/device
;; $ adb shell push live-update.scm /sdcard/

;; this file is loaded & evaluated whenever it's modified on the device,
;; useful for interactive development (even on your real device)

;; you can hot-swap this file during a running app
;; if parsing fails, game-cycle will call the old function definition


(print "loading")

(require "/sdcard/init")
(require "/sdcard/coroutines")
(require "/sdcard/async-input")
(require "/sdcard/repl")

(use tcp)

(define *repl-coroutines* '())
(define (make-repl-coroutine i o)
  (make-input-port-yield-coroutine
   (lambda (cr in-port)
     (my-repl in-port o))
   i))

(define (process-remote)
  (when (tcp-accept-ready? *repl-socket*)    
    (define-values (in out) (tcp-accept *repl-socket*))
    (set! *repl-coroutines*
          (cons (make-repl-coroutine in out) *repl-coroutines*)))
  (set! *repl-coroutines* (filter coroutine-thunk *repl-coroutines*))
  (map coroutine-call *repl-coroutines*))

(let [(c 0.2)] 
  (glClearColor c c c 1))

(glEnable GL_BLEND)

(define (my-drawsprite s width)
  (draw-sprite 0 0 0 s width))

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
  (process-remote)
  (glClear GL_COLOR_BUFFER_BIT)
  (glPushMatrix)
  (glColor4f 1 1 1 0.5)
  (glRotatef y 0 0 1)
  ;; draw some kind of "star"
  (let [(ds (lambda (s w)
              (glRotatef 45 0 0 1)  (my-drawsprite s w)
              (glRotatef 45 0 0 1)  (my-drawsprite s w)
              (glRotatef 45 0 0 1)  (my-drawsprite s w)
              (glRotatef 45 0 0 1)  (my-drawsprite s w)))
        (p1 (sin (/ (current-milliseconds) 1000)))
        (p2 (- 1 (sin (/ (current-milliseconds) 1000))))]
    (glRotatef 22.5 0 0 1) (ds p1 0.2)
    (glRotatef 22.5 0 0 1) (ds (- 1 p1) 0.04))
  (glPopMatrix))

(print "load over")

