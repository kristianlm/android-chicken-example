;; stolen from posix-common.scm

(declare
 (unit posix-mtime)
 (foreign-declare
#<<EOF

#include <sys/types.h>
#include <sys/stat.h>

static C_TLS struct stat C_statbuf;

#define C_stat(fn)          C_fix(stat((char *)C_data_pointer(fn), &C_statbuf))
#define C_fstat(f)          C_fix(fstat(C_unfix(f), &C_statbuf))

EOF
))

(define-foreign-variable _stat_st_mtime double "C_statbuf.st_mtime")


(define (##sys#stat file link err loc)
  (let ((r (cond ((fixnum? file) (##core#inline "C_fstat" file))
                 ((string? file)
                  (let ((path (##sys#make-c-string
			       (##sys#platform-fixup-pathname
				(##sys#expand-home-path file))
			       loc)))
                    (##core#inline "C_stat" path)  ) )
                 (else
		  (##sys#signal-hook
		   #:type-error loc "bad argument type - not a fixnum or string" file)) ) ) )
    (if (fx< r 0)
	(if err
	    (posix-error #:file-error loc "cannot access file" file) 
	    #f)
	#t)))


(define (mtime f)
  (##sys#stat f #f #t 'file-modification-time) _stat_st_mtime)
