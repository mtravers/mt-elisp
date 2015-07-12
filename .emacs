; -*- mode: emacs-lisp -*-
(add-to-list 'load-path (expand-file-name "/misc/repos/mt-elisp"))
(require 'mt-init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-lein-command "/usr/local/bin/lein")
 '(describe-char-unidata-list
   (quote
    (name old-name general-category decomposition numeric-value iso-10646-comment)))
 '(electric-pair-mode t)
 '(exec-path
   (quote
    ("/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin" nil "/usr/local/bin")))
 '(fill-column 100)
 '(global-auto-revert-ignore-modes (quote (archive-mode)))
 '(global-auto-revert-mode t)
 '(grep-find-ignored-directories
   (quote
    ("SCCS" "RCS" "CVS" "MCVS" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "logs" "log")))
 '(ibuffer-formats
   (quote
    ((mark modified read-only " "
	   (name 30 30 :left :elide)
	   " "
	   (size 9 -1 :right)
	   " "
	   (mode 16 16 :left :elide)
	   " " filename-and-process)
     (mark " "
	   (name 16 -1)
	   " " filename))))
 '(ido-show-dot-for-dired t)
 '(line-move-visual t)
 '(markdown-command "/usr/local/bin/markdown")
 '(mode-line-format
   (quote
    ("%e"
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
     mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification
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
       (quote help-echo)
       (concat
	(format-time-string "%c; ")
	(emacs-uptime "Uptime:%hh"))))
     (:eval
      (unless
	  (display-graphic-p)
	#("-%-" 0 3
	  (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")))))))
 '(ns-alternate-modifier (quote none))
 '(ns-command-modifier (quote meta))
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
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-special-blocks)))
 '(pivotal-api-token "23180f685c9c451bdd29c10eb35575be")
 '(safe-local-variable-values
   (quote
    ((package . net\.html\.generator)
     (package . net\.aserve\.client)
     (eval define-clojure-indent
	   (phase-context 2)
	   (defmethod-plan 2))
     (eval define-clojure-indent
	   (def-collect-plan-fn
	     (quote defun)))
     (eval define-clojure-indent
	   (defplan
	     (quote defun))
	   (def-aggregate-plan-fn
	     (quote defun)))
     (prompt-to-byte-compile)
     (eval define-clojure-indent
	   (codepoint-case
	    (quote defun)))
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
     (encoding . utf-8))))
 '(send-mail-function (quote smtpmail-send-it))
 '(sentence-end-double-space nil)
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 587)
 '(tramp-default-method "scpx")
 '(vc-hg-program "/usr/local/bin/hg"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "knobColor" :inverse-video nil :underline nil :slant normal :weight normal))))
 '(show-paren-match ((t (:background "#e9e2cb" :foreground "#259185" :inverse-video nil :underline nil :slant normal :weight normal))))
 '(variable-pitch ((t (:height 1.2 :width normal :family "Gill Sans")))))
