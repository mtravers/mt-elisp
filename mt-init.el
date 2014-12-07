; -*- mode: emacs-lisp -*-

(defvar mt-elisp-directory (file-name-directory load-file-name))

(add-to-list 'default-frame-alist '(font . "Monaco-14"))

;;; +++ right way to compile these?
(require 'mt-utils)
(require 'mt-patches)
(require 'mt-slime)
(require 'mt-el-hacks)
(require 'mt-punctual)
(require 'mt-inversions)
(require 'mt-ucs)

;;; Backups – http://www.emacswiki.org/emacs/BackupDirectory
;;; +++ Seems broken
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree (something is smashing this var, it's now  ((".*" . "/var/folders/pg/y132_m3s05gdxrjggbt4_2280000gp/T/")))
   delete-old-versions t
   delete-by-moving-to-trash t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)  

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;; Annotation
;;; doesn't work that well
;(load "/misc/reposed/annot/src/annot")

;;; Nicer fonts
(add-hook 'text-mode-hook (lambda () (variable-pitch-mode t))) ;+++ unfortunately this turns it on for html
(add-hook 'eww-mode-hook (lambda () (variable-pitch-mode t))) 
(add-hook 'org-mode-hook (lambda () (variable-pitch-mode t)))
(add-hook 'shell-mode-hook (lambda () (set-buffer-process-coding-system 'mule-utf-8 'mule-utf-8)))

;;; Smart quotes
(require 'smart-quotes)
(add-hook 'text-mode-hook (lambda () (turn-on-smart-quotes)))
;;; html-mode-hook runs text-mode-hook, which is seems wrong, but this compensates for some of the lossage
(add-hook 'html-mode-hook (lambda () (turn-off-smart-quotes))) 

;;; Completions
(dynamic-completion-mode t)

;;; Key customization
(define-key ctl-x-map "\C-r" 'revert-buffer)  ;C-x C-r is revert buffer
;;Z is too close to X for this to exist there:
(global-unset-key "\C-z")
;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; turn on font-lock mode
(global-font-lock-mode t)
;; enable visual feedback on selections
(setq-default transient-mark-mode t)

;; always end a file with a newline
(setq require-final-newline t)

;; stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; I keep hitting this accidently
(put 'downcase-region 'disabled nil)

;;; This isn't sticking, so try again
(setq indent-tabs-mode nil)
(setq tab-width 2)

(autoload 'ibuffer "ibuffer" "List buffers." t)

(add-hook 'text-mode-hook
          '(lambda () 
	     ;; see how this does
	     (toggle-truncate-lines 0)
	     (toggle-word-wrap 1)
	     ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(exec-path (quote ("/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin" nil "/usr/local/bin")))
 '(fill-column 100)
 '(grep-find-ignored-directories (quote ("SCCS" "RCS" "CVS" "MCVS" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "logs" "log")))
 '(ibuffer-formats (quote ((mark modified read-only " " (name 30 30 :left :elide) " " (size 9 -1 :right) " " (mode 16 16 :left :elide) " " filename-and-process) (mark " " (name 16 -1) " " filename))))
 '(ido-show-dot-for-dired t)
 '(mode-line-format (quote ("%e" (:eval (if (display-graphic-p) #(" " 0 1 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")) #("-" 0 1 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole fr ame
mouse-3: Remove current window from display")))) mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification #("   " 0 3 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")) mode-line-position (vc-mode vc-mode) #("  " 0 2 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")) mode-line-modes (which-func-mode ("" which-func-format #(" " 0 1 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")))) (global-mode-string ("" global-mode-string #(" " 0 1 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")))) "  " (:eval (propertize (format-time-string "%m/%d %H:%M") (quote help-echo) (concat (format-time-string "%c; ") (emacs-uptime "Uptime:%hh")))) (:eval (unless (display-graphic-p) #("-%-" 0 3 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")))))))
 '(ns-alternate-modifier (quote none))
 '(ns-command-modifier (quote meta))
 '(org-export-preserve-breaks t)
 '(org-modules (quote (org-bbdb org-bibtex org-docview org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-special-blocks)))
 '(safe-local-variable-values (quote ((Package . CL-PPCRE) (Base . 10) (Package . DRAKMA) (Syntax . COMMON-LISP) (package . net\.aserve) (Package . CCL) (encoding . utf-8))))
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 587)
 '(tool-bar-mode nil)
 '(tramp-default-method "scpx")
 '(vc-hg-program "/usr/local/bin/hg"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(variable-pitch ((t (:height 1.2 :width normal :family "Gill Sans")))))

(when window-system
  ;; enable wheelmouse support by default
  (mwheel-install)
  ;; use extended compound-text coding for X clipboard
  (set-selection-coding-system 'compound-text-with-extensions))

;;; Java stuff

(setq c-basic-offset 4)
(setq indent-tabs-mode nil)
(setq tab-width 2)

(defun java-mode-untabify ()
  (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "[ \t]+$" nil t)
        (delete-region (match-beginning 0) (match-end 0)))
      (goto-char (point-min))
      (if (search-forward "\t" nil t)
          (untabify (1- (point)) (point-max))))
  nil)

(add-hook 'java-mode-hook 
          '(lambda ()
             (make-local-variable 'write-contents-hooks)
             (add-hook 'write-contents-hooks 'java-mode-untabify)))

;;; Misc language stuff

;;; No, not there despite library installed, wtf
;;; (require 'ttl-mode)

(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))
(add-to-list 'auto-mode-alist '("\\.sparql$" . sparql-mode))
(add-to-list 'auto-mode-alist '("\\.rq$" . sparql-mode))
; broken apparently?
;(add-to-list 'auto-mode-alist '("\\.ttl$" . ttl-mode))

;;; Org mode

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;; autocomplete needs to work
(add-hook 'org-mode-hook
	  (lambda (&rest ignore)
	    (define-key org-mode-map
	      [(control return)] 'complete)))

;;; Ruby stuff

;; ;;; Probably all obso
;; (defun ruby-setup ()
;;   (add-to-list 'load-path "/misc/sourceforge/ruby/misc")
;;   (add-to-list 'load-path  "/misc/downloads/emacs-rails")
;;   (require 'inf-ruby)
;;   (require 'rails)
;;   ;; need to get rid of horrible tab behavior somehow. (+++ really linked with rails-minor-mode, but that has no hook?)
;;   (add-hook 'ruby-mode-hook
;; 	    (lambda ()
;; 	      (local-set-key (kbd "<tab>")
;; 			     'indent-for-tab-command))))

(defun ruby-setup ()
  ;; HAML
  (add-to-list 'load-path "/misc/reposed/haml-mode")
  (require 'haml-mode)
  (add-hook 'haml-mode-hook
	    (lambda ()
	      (setq indent-tabs-mode nil)
	      (define-key haml-mode-map "\C-m" 'newline-and-indent))))

;(ruby-setup)				;livin in the future
	  
;;; *** Useful hacks *************************** 

;; Sometimes frame size gets stuck, this can fix it
(defun set-current-frame-size (rows cols) "resize current frame to ROWS and COLUMNS"
  (interactive "nrows: \nncolumns: ")
  (let ((frame (car (cadr (current-frame-configuration)))))
    (set-frame-size frame cols rows)))

;;; *** Assorted trash *************************** 

;(add-to-list 'load-path (expand-file-name "~/emacs/site/semantic"))
;(add-to-list 'load-path (expand-file-name "~/emacs/site/speedbar"))
;(add-to-list 'load-path (expand-file-name "~/emacs/site/elib"))

;;; attempt to get rid of unreadable light green font color (not working)
;;; not working here
'(define-sldb-faces
  (restartable-frame-line
   "frames which are surely restartable"
   '(:foreground "dark green")))

(put 'set-goal-column 'disabled nil)

;;; For slime-js (+++ experimental)
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(global-set-key [f5] 'slime-js-reload)
(add-hook 'js2-mode-hook
          (lambda ()
            (slime-js-minor-mode 1)))

;;; IDO mode, giving it a shakeout
(require 'ido)
(ido-mode t)

;;; Textmate mode (also experimental)
;; (add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
;; (require 'textmate)
;; (textmate-mode)
;; (global-set-key (kbd "C-x C-g") 'textmate-goto-file)

(prefer-coding-system 'utf-8)

;; Solarize me!
(add-to-list 'custom-theme-load-path "/misc/reposed/emacs-color-theme-solarized/")
(load-theme 'solarized-dark t)
(setq darkness t)

;;; Actually since it is inverted, these set the opposite *ground
(set-face-background 'mode-line "#00aacc")
(set-face-foreground 'mode-line "#444444")

(defun invert-theme ()
  (interactive)
  (load-theme (if darkness 'solarized-light 'solarized-dark) t)
  (setf darkness (not darkness)))

;;; Trial run 
;;; (global-hl-line-mode -1)
(require 'paren)
(setq show-paren-style 'expression) ; looks good with non-bold show-paren-match face
;(setq show-paren-style 'parenthesis)
(show-paren-mode +1)
(setq show-paren-delay 0.33)

;;; Show full pathnames in frame header
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;;; Dash is great (Mac only)
(global-set-key "\C-cd" 'dash-at-point)

(define-minor-mode sensitive-mode
  "For sensitive files like password lists.
It disables backup creation and auto saving.

With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode."
  ;; The initial value.
  nil
  ;; The indicator for the mode line.
  " Sensitive"
  ;; The minor mode bindings.
  nil
  (if (symbol-value sensitive-mode)
      (progn
	;; disable backups
	(set (make-local-variable 'backup-inhibited) t)	
	;; disable auto-save
	(if auto-save-default
	    (auto-save-mode -1)))
    ;resort to default value of backup-inhibited
    (kill-local-variable 'backup-inhibited)
    ;resort to default auto save setting
    (if auto-save-default
	(auto-save-mode 1))))

(setq auto-mode-alist
 (append '(("\\.sensitive$" . sensitive-mode))
	 auto-mode-alist))

;;; Offer to create missing directories
;;; Source: https://iqbalansari.github.io/blog/2014/12/07/automatically-create-parent-directories-on-visiting-a-new-file-in-emacs/
(defun maybe-create-non-existent-directory ()
  (let ((parent-directory (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent-directory))
	       (y-or-n-p (format "Directory `%s' does not exist! Create it?" parent-directory)))
      (make-directory parent-directory t))))

(add-to-list 'find-file-not-found-functions #'maybe-create-non-existent-directory)

(provide 'mt-init)
