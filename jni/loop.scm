(declare (uses posix-mtime
               chicken-syntax
               ports
               tcp
               srfi-1
               srfi-18))

#>
#include <GLES/gl.h>
#include "gl-utils.h"
#include <android/log.h>

void logi (char* line) {
                        __android_log_print (ANDROID_LOG_INFO,
                                             "chicken-log",
                                             line);
}

<#

(define logi (foreign-lambda void "logi" c-string))

(logi "******************** running")

(define (make-log-wrapper-port)
  (make-output-port
   (lambda (string)
     (logi string))
   (lambda ()
     (logi "closing port")) ))

(current-output-port (make-log-wrapper-port))
(include "./headers/gl-bind.scm")


(define draw-sprite (foreign-lambda void "DrawSprite"
                               float float float ; x y z
                               float float)) ; w h


(define filename-live "/sdcard/live-update.scm")
(set! old-mtime 0)

(define-external (chicken_update) void
  (handle-exceptions
   exp (print-error-message  exp)
   (if (> (mtime filename-live) old-mtime)
       (begin
         (set! old-mtime (mtime filename-live))
         (load filename-live)))
   (live-update 1)))

(return-to-host)
