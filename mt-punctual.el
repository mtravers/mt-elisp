;;; see M-x abbrev-mode; also http://www.emacswiki.org/emacs/typopunct.el
;;; Would have used abbrev-mode but it stupidly encodes a restriction to alphanumerics in C code!
;;; TODO: make into a mode so it can be toggled easily
;;; TODO: an easy undo. (But using C-Q space to terminate works to suppress)
;;; See http://stackoverflow.com/questions/18620187/how-can-i-revert-fancy-lambdas-after-an-edit

(defvar punctuals 
  '(("--" "–")
    ("---" "—")
    ("-->" "→")
    ("<--" "←")
    ("<-->" "↔")
    ("==>" "⇒")
    ("<==" "⇐")
    ("<==>" "⇔")
    ("--v" "↓")
    ("--^" "↑")
    ("v--^" "↕")			;reaching!
    ("==v" "⇓")
    ("==^" "⇑")
    ("v==^" "⇕")
    ("<o" "⩹")				;idiosyncratic!
    ("o>" "⩺")
    ("<<" "⪡")				;these are actually used, at least in coding
    (">>" "⪢")
    (">>>" "⫸")				
    ("<<<" "⫷")
    ("lambda" "λ")			;this one is dangerous
    ("pi" "π")
    ))

(add-hook 'post-self-insert-hook 'maybe-punctual)

(defun maybe-punctual ()
  (when (equal (char-syntax last-command-event) ?\ )
    (let (end start str def)
      (forward-char -1)
      (setq end (point))    
      (skip-syntax-backward "^ ")
      (setq start (point))
      (setq str (buffer-substring-no-properties start end))
      (setq def (assoc str punctuals))
      (if def
	  (progn
	    (delete-region start end)
	    (insert (cadr def)))
	(goto-char end)	)
      (forward-char 1)
      )))

;;; An experiment. Not that useful like this, ∵ there aren't too many 1-word unicode chars, and fewer still useful ones. ("THEREFORE" was the motivating example).
(defun unicode-punctal ()
  (interactive)
  (dolist (chardef (ucs-names))
    (push (list (car chardef)
		(string (cdr chardef)))
	  punctuals)))

(provide 'mt-punctual)
