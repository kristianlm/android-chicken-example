(declare (uses posix-mtime))

#>
#include <GLES/gl.h>
#include "gl-utils.h"
<#

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
