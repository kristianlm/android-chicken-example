
;; place this in /sdcard/live-update.scm on your emulator/device
;; $ adb shell push live-update.scm /sdcard/

;; this file is loaded & evaluated whenever it's modified on the device,
;; useful for interactive development (even on your real device)

;; you can hot-swap this file during a running app
;; if parsing fails, game-cycle will call the old function definition


;; this will be evalutated only once
(set! y 0)

;; this will be called every game-loop
(define (live-update d)
  (set! y (+ 0.2 y))
  (glPushMatrix)
  (glTranslatef 0 1 0)
  (glRotatef y 0 0 1)
  (draw-sprite 0.0 0 0.0  .2  2.0)
  (draw-sprite 0.0 0 0.0 2.0   .2)
  (glPopMatrix))

