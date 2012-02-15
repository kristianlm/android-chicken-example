
;; place this in /sdcard/live-update.scm on your emulator/device
;; $ adb shell push live-update.scm /sdcard/

;; this file is loaded & evaluated at each game update,
;; useful for interactive development (even on your real device)

;; you can hot-swap this file during a running app
;; if parsing fails, game-cycle will call the old function definition
(define (live-update x)
  (print "hi from chicken android"))

