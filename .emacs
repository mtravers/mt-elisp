; -*- mode: emacs-lisp -*-

;;; Symlink ~/.emacs here. TODO much of this should go into mt-init.el 

;;; When desperate: https://emacs.stackexchange.com/questions/ask

;;; Argh. Trying to find out who is fucking load-history. This is not working
;;; See end of file
;; (require 'cl)
;; (setq message-log-max 1000)
;; (advice-add
;;  'load :after
;;  #'(lambda (&rest foo)
;;      (unless (every #'stringp (mapcar #'car load-history))
;;        (message (prin1-to-string (list :FUCKED (length load-history) foo (first load-history)))))))

;;; Going Straight

(defvar bootstrap-version)

(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;; Automatically update packages

(use-package paradox
  :init
  (setq paradox-github-token t)
  (setq paradox-execute-asynchronously t)
  (setq paradox-automatically-star t))

(paradox-upgrade-packages)		;might be too slow to do this on startup?

(use-package org)

;;; Turn off electric indent
(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))

(use-package ox-reveal)

;;; Turning off some of this since not really using it

;;; Note: there doesn't seem to be a way to update other than to go to the repo dir
;;; ~/.emacs.d/straight/repos/org-roam
;;; and doing a pull.
'(use-package org-roam
      :after org
;;; this adds org-roam-mode to all buffers? Not what I want
;      :hook 
;      (after-init . org-roam-mode)
;      :straight (:host github :repo "jethrokuan/org-roam" :branch "develop")
      :custom
      (org-roam-directory "/opt/mt/working/org-roam/files")
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-show-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert)))
      )

;;; Blows out because fn is not defined yet
;;; Noticing that ALL my add-hooks are commented out...I must not understand how this actually works.
;(add-hook 'after-init-hook 'org-roam--build-cache-async)

'(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "/opt/mt/working/org-roam/files"))

(add-to-list 'load-path (expand-file-name "/opt/mt/repos/mt-elisp"))

(require 'mt-init)

(use-package exec-path-from-shell)

;;; https://github.com/purcell/exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;;; Makes ctrl-alt → move to next-right pane, etc.
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;;; TODO Magit-todos requires space between comment chars and tag (eg won't detecit ;;TODO).

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(backup-directory-alist '((".*" . "~/.saves") ("" . "")))
 '(cider-cljs-lein-repl
   "(do (require 'figwheel-sidecar.repl-api) (figwheel-sidecar.repl-api/start-figwheel!) (figwheel-sidecar.repl-api/cljs-repl))")
 '(cider-lein-command "/usr/local/bin/lein")
 '(cider-prompt-for-symbol nil)
 '(cider-repl-history-file "~/.emacs.d/cider-repl-history")
 '(cider-repl-use-pretty-printing t)
 '(clojure-defun-indents
   '(init-state render render-state will-mount should-update will-receive-props will-update did-update will-unmount))
 '(comint-process-echoes t)
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-enabled-themes '(zenburn))
 '(custom-safe-themes
   '("ea5822c1b2fb8bb6194a7ee61af3fe2cc7e2c7bab272cbb498a0234984e1b2d9" "0f0a885f4ce5b6f97e33c7483bfe4515220e9cbd9ab3ca798e0972f665f8ee4d" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "388902ac9f9337350975dd03f90167ea62d43b8d8e3cf693b0a200ccbcdd1963" "84890723510d225c45aaff941a7e201606a48b973f0121cb9bcb0b9399be8cba" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default))
 '(deft-default-extension "org" t)
 '(deft-directory "/opt/mt/working/org-roam/files" t)
 '(deft-recursive t t)
 '(deft-use-filter-string-for-filename t t)
 '(delete-old-versions t)
 '(describe-char-unidata-list
   '(name old-name general-category decomposition numeric-value iso-10646-comment))
 '(desktop-save-mode t)
 '(dired-kept-versions 3)
 '(display-line-numbers nil)
 '(electric-pair-mode t)
 '(electric-pair-skip-self t)
 '(exec-path
   '("/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin" nil "/usr/local/bin"))
 '(explicit-shell-file-name "bash")
 '(fci-rule-color "#383838")
 '(file-precious-flag t)
 '(fill-column 100)
 '(flycheck-clj-kondo-clj-executable "/usr/local/bin/clj-kondo")
 '(git-commit-summary-max-length 120)
 '(global-auto-revert-ignore-modes '(archive-mode))
 '(global-auto-revert-mode t)
 '(global-display-line-numbers-mode nil)
 '(grep-find-ignored-directories
   '("SCCS" "RCS" "CVS" "MCVS" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "logs" "log"))
 '(grep-save-buffers nil)
 '(ibuffer-formats
   '((mark modified read-only " "
	   (name 30 30 :left :elide)
	   " "
	   (size 9 -1 :right)
	   " "
	   (mode 16 16 :left :elide)
	   " " filename-and-process)
     (mark " "
	   (name 16 -1)
	   " " filename)))
 '(ido-show-dot-for-dired t)
 '(kept-new-versions 3)
 '(line-move-visual t)
 '(magit-git-executable "/usr/local/bin/git")
 '(magit-todos-branch-list t)
 '(magit-todos-exclude-globs '("/resources/*"))
 '(magit-todos-keyword-suffix ":?")
 '(magit-todos-keywords '("TODO" "TEMP" "HHH" "OBSO"))
 '(magit-todos-scanner 'magit-todos--scan-with-rg)
 '(markdown-command "/usr/local/bin/markdown")
 '(mode-line-format
   '("%e"
     (:eval
      (if
	  (display-graphic-p)
	  #(" " 0 1
	    (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display"))
	#("-" 0 1
	  (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole fr ame
mouse-3: Remove current window from display"))))
     mode-line-mule-info mode-line-client mode-line-modified mode-line-auto-compile mode-line-remote mode-line-frame-identification mode-line-buffer-identification
     #("   " 0 3
       (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display"))
     mode-line-position
     (vc-mode vc-mode)
     #("  " 0 2
       (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display"))
     mode-line-modes
     (which-func-mode
      ("" which-func-format
       #(" " 0 1
	 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display"))))
     (global-mode-string
      ("" global-mode-string
       #(" " 0 1
	 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display"))))
     "  "
     (:eval
      (propertize
       (format-time-string "%m/%d %H:%M")
       'help-echo
       (concat
	(format-time-string "%c; ")
	(emacs-uptime "Uptime:%hh"))))
     (:eval
      (unless
	  (display-graphic-p)
	#("-%-" 0 3
	  (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display"))))))
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(nrepl-sync-request-timeout 30)
 '(ns-alternate-modifier 'none)
 '(ns-command-modifier 'meta)
 '(org-export-html-style
   "<style type=\"text/css\">
html { font-family: DejaVu Sans; font-size: 12pt; }
.title  { text-align: center; }
.todo   { color: red; }
.done   { color: green; }
.tag    { background-color: #add8e6; font-weight:normal }
.target { }
.timestamp { color: #bebebe; }
.timestamp-kwd { color: #5f9ea0; }
.right  {margin-left:auto; margin-right:0px;  text-align:right;}
.left   {margin-left:0px;  margin-right:auto; text-align:left;}
.center {margin-left:auto; margin-right:auto; text-align:center;}
p.verse { margin-left: 3% }
pre {
border: 1pt solid #AEBDCC;
background-color: #F3F5F7;
padding: 5pt;
font-family: courier, monospace;
font-size: 90%;
overflow:auto;
}
table { border-collapse: collapse; }
td, th { vertical-align: top;  }
th.right  { text-align:center;  }
th.left   { text-align:center;   }
th.center { text-align:center; }
td.right  { text-align:right;  }
td.left   { text-align:left;   }
td.center { text-align:center; }
dt { font-weight: bold; }
div.figure { padding: 0.5em; }
div.figure p { text-align: center; }
div.inlinetask {
padding:10px;
border:2px solid gray;
margin:10px;
background: #ffffcc;
}
textarea { overflow-x: auto; }
.linenr { font-size:smaller }
.code-highlighted {background-color:#ffff00;}
</style>")
 '(org-export-html-style-include-default nil)
 '(org-export-preserve-breaks t)
 '(org-export-with-broken-links 'mark)
 '(org-modules
   '(org-bbdb org-bibtex org-docview org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-special-blocks))
 '(org-roam-directory "/opt/mt/working/org-roam/files")
 '(org-roam-graph-viewer "/Applications/Firefox.app/Contents/MacOS/firefox")
 '(org-timer-default-timer "5")
 '(package-selected-packages
   '(google-translate flyparens flylisp forge deft grip-mode emojify nov yo-moma exec-path-from-shell ess rainbow-blocks pdf-tools magit eyebrowse frames-only-mode slime cider yaml-mode workgroups2 w3m unicode-fonts twittering-mode ttl-mode sparql-mode smart-mode-line scala-mode2 save-visited-files rspec-mode rainbow-delimiters pivotal-tracker pig-mode markdown-mode link less-css-mode json-mode js2-mode htmlize helm-open-github helm-itunes groovy-mode gradle-mode fringe-helper eruby-mode dired-toggle-sudo dash-at-point connection color-theme cider-decompile bpe apples-mode ample-theme ack ac-nrepl ac-cider 2048-game))
 '(pdf-view-midnight-colors '("#DCDCCC" . "#383838"))
 '(safe-local-variable-values
   '((eval require 'org-roam-dev)
     (org-src-preserve-indentation)
     (eval and
	   (require 'ox-extra nil t)
	   (ox-extras-activate
	    '(ignore-headlines)))
     (eval require 'ox-texinfo+ nil t)
     (eval require 'org-man nil t)
     (eval add-hook 'after-save-hook 'org-html-export-to-html t t)
     (magit-todos-exclude-globs "index.js")
     (Default-character-style :SWISS :ROMAN :NORMAL)
     (Package . COMMON-LISP-USER)
     (Package . GEOMETRY)
     (cider-default-cljs-repl quote figwheel-main)
     (elisp-lint-indent-specs
      (if-let* . 2)
      (when-let* . 1)
      (let* . defun)
      (nrepl-dbind-response . 2)
      (cider-save-marker . 1)
      (cider-propertize-region . 1)
      (cider-map-repls . 1)
      (cider--jack-in . 1)
      (cider--make-result-overlay . 1)
      (insert-label . defun)
      (insert-align-label . defun)
      (insert-rect . defun)
      (cl-defun . 2)
      (with-parsed-tramp-file-name . 2)
      (thread-first . 1)
      (thread-last . 1))
     (checkdoc-package-keywords-flag)
     (magit-todos-exclude-globs "alzabo/pret/*")
     (Package . biolisp)
     (Package . ODD-STREAMS)
     (package . net\.aserve\.test)
     (bug-reference-bug-regexp . "#\\(?2:[[:digit:]]+\\)")
     (package . net\.html\.generator)
     (package . net\.aserve\.client)
     (eval define-clojure-indent
	   (phase-context 2)
	   (defmethod-plan 2))
     (eval define-clojure-indent
	   (def-collect-plan-fn 'defun))
     (eval define-clojure-indent
	   (defplan 'defun)
	   (def-aggregate-plan-fn 'defun))
     (prompt-to-byte-compile)
     (eval define-clojure-indent
	   (codepoint-case 'defun))
     (Package . FLEXI-STREAMS)
     (Package . CHUNGA)
     (Lowercase . Yes)
     (Package . XLIB)
     (Package . cl-user)
     (Package . HUNCHENTOOT)
     (readtable . xml)
     (package . cl-user)
     (Package . CL-INTERPOL)
     (Lowercase . T)
     (Package ANSI-LOOP "COMMON-LISP")
     (Syntax . Common-lisp)
     (Syntax . Common-Lisp)
     (Package . CL-USER)
     (Package . utils)
     (Syntax . ANSI-Common-Lisp)
     (TeX-master . "asp")
     (TeX-PDF-mode . t)
     (Package . CL-PPCRE)
     (Base . 10)
     (Package . DRAKMA)
     (Syntax . COMMON-LISP)
     (package . net\.aserve)
     (Package . CCL)
     (encoding . utf-8)))
 '(send-mail-function 'smtpmail-send-it)
 '(sentence-end-double-space nil)
 '(size-indication-mode t)
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 587)
 '(tool-bar-mode nil)
 '(tramp-default-method "scpx")
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(vc-follow-symlinks t)
 '(vc-hg-program "/usr/local/bin/hg")
 '(version-control t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 160 :width normal :foundry "nil" :family "Menlo"))))
 '(fixed-pitch ((t (:family "Dejavu Sans Mono"))))
 '(variable-pitch ((t (:height 1.2 :width normal :family "Gill Sans")))))


(defun link-region-2
    (&optional arg)
  (interactive "p")
  (or arg
      (setq arg 1))
  (dotimes
      (i arg)
    (call-kbd-macro
     [24 24 91 2 91 escape 120 121 97 110 107 45 99 104 114 117 109 backspace backspace 111 109 101 45 117 114 108 return 24 24 24 24 6 134217730 67108896 134217734 134217734 91 134217734 134217734 134217734])))
(defun link-selection-3
    (&optional arg)
  (interactive "p")
  (or arg
      (setq arg 1))
  (dotimes
      (i arg)
    (call-kbd-macro
     [24 24 91 2 91 escape 120 121 97 110 107 45 99 104 114 111 109 101 45 117 114 108 return 6 134217730 91 4 134217734 134217734 93])))

(defun blockquotify
    (&optional arg)
  (interactive "p")
  (or arg
      (setq arg 1))
  (dotimes
      (i arg)
    (call-kbd-macro
     [134217848 115 101 97 114 99 104 32 102 111 32 return 62 62 62 32 backspace return 6 backspace backspace 60 98 108 111 99 107 113 117 111 101 backspace 116 101 62 5 60 47 98 108 111 99 107 113 117 111 116 101 62])))

;;; API keys etc 
(require 'mt-secrets)

;;; For Rawsugar

(defun start-datomic ()
  (interactive)
  (startup-shell "*datomic-transactor*" "." "~/Downloads/datomic-pro-0.9.5951/bin/transactor ~/pici/repos/rawsugar/credentials/dev-transactor.properties")
  (startup-shell "*datomic-peer*" "." "~/Downloads/datomic-pro-0.9.5951/bin/run -m datomic.peer-server -h localhost -p 8998 -a myaccesskey,mysecret -d rawsugar-test,datomic:dev://localhost:4334/rawsugar-test"))



;;; Was causing problems, turn this on a bit at a time.
;(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;;; Definitely don't want this in code/shell, and probably don't want it at all. 
;(add-hook 'after-init-hook #'global-emojify-mode)

(add-to-list 'auto-mode-alist '("\\.ino" . c-mode)) ;Arduino

(with-eval-after-load 'magit
  (require 'forge))

;;; Problem: load-history gets corrupted with an entry whose car is not a string
;;; ((require . info) ... )
;;; Can't figure out why, so this hack.
(defun clean-load-history ()
  (setq load-history
	(remove-if-not #'(lambda (x) (stringp (car x))) load-history)))

;;; WHICH STILL DOES NOT SOLVE THE FUCKING PROBLEM!
;;; Because corruption happens AFTER .emacs, so need to run this by hand later
'(clean-load-history)


