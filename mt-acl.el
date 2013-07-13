(defun lispme ()
  (interactive)
  (fi:common-lisp))

(defun lisp-setup ()
  (load (concat *acl-root* "eli/fi-site-init"))
  (setq fi:common-lisp-image-name (concat *acl-root* "lisp"))
;  (setq fi:common-lisp-directory "d:/mt") ;this has to be set to something or things won't work!
  (setq fi:common-lisp-directory "~/")
  (setq fi:common-lisp-image-file (concat *acl-root* "allegro.dxl"))
;  (setq fi:common-lisp-image-arguments '("-L" "c:/clinit.cl"))
  (push '("\\.bil$" . fi:common-lisp-mode) auto-mode-alist))
   
(defun acl5 ()
  (interactive)
  (setq *acl-root* "e:/Program Files/ACL501/")
  (lisp-setup))

(defun acl6 ()
  (interactive)
  (setq *acl-root* "e:/Program Files/ACL60/")
  (lisp-setup)
  (setq fi:common-lisp-image-name (concat *acl-root* "allegro-ansi"))
  (setq fi:common-lisp-image-file (concat *acl-root* "allegro-ansi.dxl")))

(defun acl61 ()
  (interactive)
  (setq *acl-root* "e:/Program Files/ACL61/")
  (lisp-setup)
  (setq fi:common-lisp-image-name (concat *acl-root* "allegro-ansi"))
  (setq fi:common-lisp-image-file (concat *acl-root* "allegro-ansi.dxl")))

(defun acl62 ()
  (interactive)
  (setq *acl-root* "/usr/local/acl/acl62/")
  (lisp-setup)
  (setq fi:common-lisp-image-name (concat *acl-root* "alisp"))
  (setq fi:common-lisp-image-file (concat *acl-root* "alisp.dxl")))

(defun acl7 ()
  (interactive)
  (setq *acl-root* "/misc/downloads/acl70/")
  (lisp-setup)
  (setq fi:common-lisp-image-name (concat *acl-root* "alisp"))
  (setq fi:common-lisp-image-file (concat *acl-root* "alisp.dxl")))

(defun acl81 ()
  (interactive)
  (setq *acl-root* "/misc/downloads/acl81/")
  (lisp-setup)
  (setq fi:common-lisp-image-name (concat *acl-root* "alisp"))
  (setq fi:common-lisp-image-file (concat *acl-root* "alisp.dxl")))




; end from Randy -----------------------------------

(defmacro push (thing sym)
  `(setq ,sym (cons ,thing ,sym)))

(push ".fasl" completion-ignored-extensions)
(push ".fsl" completion-ignored-extensions)

;;; below here, most is borrowed

(load "complete")

(setq running-emacs-20 (>= emacs-major-version 20))
(setq running-xemacs (string-match "Lucid" emacs-version))
(setq running-emacs-19 (>= emacs-major-version 19))
(setq running-fsf-emacs-19 (and running-emacs-19 (not running-xemacs)))
(setq running-emacs-18 (< emacs-major-version 19))
(setq running-x (eq window-system 'x))

;;; ********************
;;; Edebug is a source-level debugger for emacs-lisp programs.
;;;
(define-key emacs-lisp-mode-map "\C-xx" 'edebug-defun)


;;; ********************
;;; Font-Lock is a syntax-highlighting package.  When it is enabled and you
;;; are editing a program, different parts of your program will appear in
;;; different fonts or colors.  For example, with the code below, comments
;;; appear in red italics, function names in function definitions appear in
;;; blue bold, etc.  The code below will cause font-lock to automatically be
;;; enabled when you edit C, C++, Emacs-Lisp, and many other kinds of
;;; programs.

;; Definition stolen from later versions of font-lock.
(defun turn-on-font-lock ()
  (font-lock-mode 1))

(require 'font-lock)
(add-hook 'emacs-lisp-mode-hook	'turn-on-font-lock)
(add-hook 'lisp-mode-hook	'turn-on-font-lock)
(add-hook 'c-mode-hook		'turn-on-font-lock)
(add-hook 'c++-mode-hook	'turn-on-font-lock)
(add-hook 'perl-mode-hook	'turn-on-font-lock)
(add-hook 'tex-mode-hook	'turn-on-font-lock)
(add-hook 'texinfo-mode-hook	'turn-on-font-lock)

(display-time)
(setq display-time-day-and-date t)

(setq delete-old-versions t
      trim-versions-without-asking t)
(setq kept-old-versions 0)
(defun save-buffer-and-back-up (arg) (interactive "p")(save-buffer 16))
(global-set-key "\C-x\C-s" 'save-buffer-and-back-up)

(put 'eval-expression 'disabled nil)
(put 'upcase-region 'disabled nil)
(setq kill-ring-max 100)

(global-set-key "\M-s" 'tags-occur)

(fset 'undisplay-sexpr
   [(control r) d i s p l a y return left (control space) right right right right right right right right right (control w) (meta right) (control d) (meta x) e n d \0 backspace tab k tab])
(global-set-key "\C-\M-s" 'undisplay-sexpr)


(setq auto-mode-alist (cons (cons "\\.cl" 'lisp-mode) auto-mode-alist))

;;; nice idea but drives me nuts
; (defun insert-lparen () (interactive) (insert "("))
; (global-set-key "[" 'insert-lparen)
; (defun insert-rparen () (interactive) (insert ")") (blink-matching-open))
; (global-set-key "]" 'insert-rparen)
; (defun insert-lbracket () (interactive) (insert "["))
; (global-set-key "(" 'insert-lbracket)
; (defun insert-rbracket () (interactive) (insert "]") (blink-matching-open))
; (global-set-key ")" 'insert-rbracket)
(global-set-key [M-right] 'forward-sexp)
(global-set-key [M-down] 'forward-sexp)
(global-set-key [M-left] 'backward-sexp)
(global-set-key [M-up] 'backward-sexp)
(global-set-key "\M-o" 'other-window)

(setq transient-mark-mode t)
(setq mark-even-if-inactive t)

(global-set-key [?\C--] 'backward-char)
(global-set-key [?\C-`] 'forward-char)
(global-set-key [?\C-=] 'previous-line)
(global-set-key [?\C-\\] 'next-line)

(setq fi:lisp-mode-hook
	  (function
	   (lambda ()
	     (let ((map (current-local-map)))
	       (define-key map "\C-c."	'find-tag)
	       (define-key map "\C-c,"	'tags-loop-continue)
	       (define-key map "\e."	'fi:lisp-find-definition)
	       (define-key map "\e,"	'fi:lisp-find-next-definition)))))


