;;; *** SLIME and Lisp *************************** 

; I'm assuming using this ancient version of slime is no longer a good idea?
; (add-to-list 'load-path "/misc/repos/slime")
; (add-to-list 'load-path "/misc/repos/slime/contrib")
(setq slime-net-coding-system 'utf-8-unix)

(defun slime-common ()
  (use-package slime)
  (slime-customize)
  (slime-setup '(slime-repl))
  ;; has to come late
  (set-face-foreground 'slime-repl-output-face "darkblue")
  )

(defun mt-slime ()
  (interactive)
  (slime-common)
  (let ((current-prefix-arg '-))
    (slime)))
  
(defun slime-customize ()
  ;; put this back to how we like it
  ;; vanished?
  '(define-key inferior-slime-mode-map
    [(control return)] 'complete)
  '(define-key slime-repl-mode-map
    [(control return)] 'complete)
  )

;;; This is the more official way to start slime and it permits arguments.
;;; To use: M-- M-x slime.  Ugh.
(setq slime-lisp-implementations
      `(
	(ptools-hg ("/Applications/AllegroCL/alisp8" "-I" "/Volumes/Burroughs/travers/aic-new/aic/pathway-tools/ptools/beta/ptools_darwin.dxl" "--" "-exe-no-preload-patches" "-no-patch")
		   :env (; "DYLD_LIBRARY_PATH=/Users/travers/pathway-tools/aic-export/pathway-tools/ptools/15.5/exe"
			 "PATH=$PATH:/usr/local/git/bin:/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/Users/travers/bin"
			 "PTOOLS_ORG_ROOTS=~/ptools-local/pgdbs/registry/"
			 "PTOOLS_LOCAL_PATH=~/ptools-local/"
			 "DISPLAY=:0.0"))
	(acl-82 ("/Applications/AllegroCL64/alisp8")
		)
	(mcl ("/opt/reposed/ccl/dx86cl64")
	     :env ("CCL_DEFAULT_DIRECTORY=/misc/reposed/ccl"))
	(sbcl ("/opt/homebrew/bin/sbcl"))
	))


;;; CMULISP/ILISP
;(add-to-list 'load-path (expand-file-name "~/downloads/ilisp-5.12.0/"))
;(autoload 'cmulisp     "ilisp" "Inferior CMU Common Lisp." t)
;(setq cmulisp-program      "/usr/lib/cmucl/bin/lisp")
;;; for more, see ilisp.emacs in ilisp directory

(provide 'mt-slime)
