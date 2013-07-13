;;; Not used, but who knows, may come in handy
(defun slime-mcl () 
  (interactive)
  (setq inferior-lisp-program "/misc/reposed/ccl/scripts/ccl64") ;newer version
  (slime-common))

;;; These are the two versions of ACL that are actually working at present
(defun slime-acl64-82 () 
  (interactive)
  (setq inferior-lisp-program "/Applications/AllegroCL64-82/alisp8")
  (slime-common))

(defun slime-acl-81 () 
  (interactive)
  (setq inferior-lisp-program "/Applications/AllegroCL-81/alisp")
  (slime-common))

(defun slime-abcl () 
  (interactive)
  (setq inferior-lisp-program "/misc/sourceforge/abcl/abcl")
  (require 'slime)
  ;; from alanr
  (setq swank::*use-dedicated-output-stream* t)
  ;; from ME -- get around stupid bug
  ;; no, causes even a worse one?
;;  (setq slime-log-events nil) ;;; 
  ;; something has this pinned to a bad value, so fix it.
  (setq slime-backend "swank-loader")

  (slime-setup)
  (slime-customize)
;;; from AlanR -- send output into REPL (I think this is abcl only)
  (setq slime-connected-hook
	(cons (lambda (&rest args)
		(set-process-filter
		 (slime-inferior-process)
		 (lambda (process string)
		   (slime-write-string string)))
		)
	      slime-connected-hook))
  )





