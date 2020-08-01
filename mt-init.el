; -*- mode: emacs-lisp -*-

;;; TODO Clojure comments should begin "; " instead of ";"
;;; TODO Magit or Magit TODO extension for debugging stmts "(prn :"

;;; ☒□ Packages □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

;; (require 'package)
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(defvar mt-elisp-directory (file-name-directory load-file-name))
(use-package forge)			;required by magit
;;; ☒□ Magit □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

;;; TODO investigate why commits in Rawsugar are so slow
(use-package magit)

(use-package magit-todos)
(magit-todos-mode)

;;; Customizations for reference. Note other kinds of project structure
;;; are likely to require changes to magit-todos-exclude-globs, otherwise
;;; it picks up crap (it's supposed to only pick up tracked files but
;;; that is broken apparently).

 ;; '(magit-git-executable "/usr/local/bin/git")
 ;; '(magit-todos-branch-list t)
 ;; '(magit-todos-exclude-globs (quote ("/resources/*")))
 ;; '(magit-todos-keyword-suffix ":?")
 ;; '(magit-todos-scanner (quote magit-todos--scan-with-rg))

 ;; TODO would be nice if this was settable per-project but that looks hard
 ;; for custom keywords
;;  '(magit-todos-keywords (quote ("TODO" "HHH")))
;; (custom-set-variables  '(magit-todos-keywords (quote ("TODO" "TEMP" "HHH" "OBSO"))))

;;; ☒□ Clojure □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

(use-package cider
  :ensure t)

(setq load-prefer-newer t)

;;; autocompile
;;; Note: library has stupid rule that it will only REcompile
;; (require 'auto-compile)
;; (auto-compile-on-load-mode)
;; (auto-compile-on-save-mode)

(require 'mt-utils)
(require 'mt-patches)
(require 'mt-slime)
(require 'mt-el-hacks)
(require 'mt-mac-hacks)			;TODO conditionalize
(require 'mt-punctual)
(require 'mt-inversions)
(require 'mt-ucs)

(cond ((eq system-type 'gnu/linux)
       (require 'init-ubuntu))
      ((eq system-type 'darwin)
       (require 'init-mac)))

;;; ☒□ Customizations □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

;;; Enable alt-control-arrowkeys for moving between panes
;;; Should work but doesn't
;;; (windmove-default-keybindings '(meta control))
(global-set-key (vector (list 'meta 'control 'down)) 'windmove-down)
(global-set-key (vector (list 'meta 'control 'up)) 'windmove-up)
(global-set-key (vector (list 'meta 'control 'left)) 'windmove-left)
(global-set-key (vector (list 'meta 'control 'right)) 'windmove-right)

(setq windmove-wrap-around t )
(put 'set-goal-column 'disabled nil)

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
(global-set-key (kbd "M-s") 'ispell-word) ;was a bunch of regex highlight stuff that i never used eg hi-lock-face-buffer
(global-set-key (kbd "C-x g") 'magit-status)

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

;;; Bell controls:
(setq visible-bell nil)
;;; Flash modeline instead of a beep
(setq ring-bell-function (lambda ()
			   (invert-face 'mode-line)
			   (run-with-timer 0.1 nil 'invert-face 'mode-line)))

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
 '(tramp-default-method "scpx")
 '(vc-hg-program "/usr/local/bin/hg"))

;;; ☒□ Themes □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

;; (defun zenburn ()
;;   (interactive)
;;   (load "zenburn")
;;   (zenburn))

(when window-system
  (add-to-list 'custom-theme-load-path "/misc/repos/emacs-color-theme-solarized/")
  (load-theme 'solarized t)
  (setq darkness nil))

(defun invert-theme ()
  (interactive)
  (set-frame-parameter nil 'background-mode (if darkness 'light 'dark))
  (enable-theme 'solarized)
  (setf darkness (not darkness)))

;;; ☒□ Fonts and Unicode □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

(prefer-coding-system 'utf-8)

;;; Nicer fonts

(add-hook 'text-mode-hook (lambda () (variable-pitch-mode t))) ;+++ unfortunately this turns it on for html
(add-hook 'eww-mode-hook (lambda () (variable-pitch-mode t))) 
(add-hook 'org-mode-hook
	  (lambda ()
	    (variable-pitch-mode t)))
	    
(add-hook 'shell-mode-hook (lambda () (set-buffer-process-coding-system 'mule-utf-8 'mule-utf-8)))

;;; Smart quotes

;;; These are more trouble then they are worth, so turned off
;; (require 'smart-quotes)
;; (add-hook 'text-mode-hook (lambda () (turn-on-smart-quotes)))
;;  ;;; html-mode-hook runs text-mode-hook, which is seems wrong, but this compensates for some of the lossage
;; (add-hook 'html-mode-hook (lambda () (turn-off-smart-quotes))))

;;; ☒□ Org mode □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\M-`" 'other-window)	;Make M-` follow Mac convention, roughly 

;;; autocomplete needs to work
(add-hook 'org-mode-hook
	  (lambda (&rest ignore)
	    (outline-flag-region (point) (+ (point) 1) nil) ;opens subtree at point
	    (define-key org-mode-map
	      [(control return)] 'complete)))

;;; Bind Meta-option-Y to formatted-yank, which preserves bolt/italic/links etc.
(add-hook 'org-mode-hook
	  (lambda (&rest ignore)
	    (define-key org-mode-map
	      ;; (meta option y), aka [134217893]
	      (kbd "M-¥") 'formatted-yank)))

;;; export stopped working, this I am hoping fixes it.
;(require 'org-loaddefs)

;;; ☒□ File management  □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

;;; IDO mode, makes find file more autocompletey
(require 'ido)
(ido-mode t)

(eval-after-load 'tramp
 '(progn
    ;; Allow to use: /sudo:user@host:/path/to/file
    (add-to-list 'tramp-default-proxies-alist
		  '(".*" "\\`.+\\'" "/ssh:%h:"))))


(require 'saveplace) ; Saves and restores location within files
(setq-default save-place t)

;;; Show full pathnames in frame header
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;;; Put auto-save and backup files out of band 
;;; https://ogbe.net/emacsconfig.html
;;; Backup seems to only sometimes work, not sure why
;;; Breaks recover session, argh
;;; 12/5/2017 this was my old customization, I'm going to try more aggresive auto-save
;; (defvar backup-dir (expand-file-name "~/.emacs.d/emacs_backup/"))
;; (defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
;; (setq backup-directory-alist (list (cons ".*" backup-dir)))
;; (setq auto-save-list-file-prefix autosave-dir)
;; (setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))
;; (setq tramp-backup-directory-alist backup-directory-alist)
;; (setq tramp-auto-save-directory autosave-dir)


;;; Backups – http://www.emacswiki.org/emacs/BackupDirectory
;;; +++ Seems broken – moved to proper customization.
;; (setq
;;    backup-by-copying t      ; don't clobber symlinks
;;    backup-directory-alist
;;     '(("." . "~/.saves"))    ; don't litter my fs tree (something is smashing this var, it's now  ((".*" . "/var/folders/pg/y132_m3s05gdxrjggbt4_2280000gp/T/")))
;;    delete-old-versions t
;;    delete-by-moving-to-trash t
;;    kept-new-versions 6
;;    kept-old-versions 2
;;    version-control t)  

;; (setq backup-directory-alist
;;       `((".*" . ,temporary-file-directory)))
;; (setq auto-save-file-name-transforms
;;       `((".*" ,temporary-file-directory t)))




;;; ☒□ Java □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

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

;;; ☒□ Misc language support  □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))
(add-to-list 'auto-mode-alist '("\\.sparql$" . sparql-mode))
(add-to-list 'auto-mode-alist '("\\.rq$" . sparql-mode))

(require 'paren)

(setq show-paren-style 'expression) ; looks good with non-bold show-paren-match face
;(setq show-paren-style 'parenthesis)
(show-paren-mode 1)	
(setq show-paren-delay 0.33)

;;; Dash is a documentation browser (Mac only)
(global-set-key "\C-cd" 'dash-at-point)

(provide 'mt-init)

