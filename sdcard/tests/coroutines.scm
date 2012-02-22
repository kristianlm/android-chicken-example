
(let ([cr (make-coroutine
           (lambda (cr)
             (print "step 1") (coroutine-yield cr 1)
             (print "step 2") (coroutine-yield cr 2)
             (print "step 3") (coroutine-yield cr 3)
             (print "step 4") (coroutine-yield cr 4)
             (print "step 5") (coroutine-yield cr 5) 'done) #f)])
  (print "call 1 = " (coroutine-call cr))
  (print "call 2 = " (coroutine-call cr))
  (print "call 3 = " (coroutine-call cr))
  (print "call 4 = " (coroutine-call cr))
  (print "call 5 = " (coroutine-call cr))
  (print "call 6 = " (coroutine-call cr))
  (print "call 7 = " (coroutine-call cr))
  (print "call 8 = " (coroutine-call cr))
  (print (coroutine-thunk cr) (coroutine-return cr)))

