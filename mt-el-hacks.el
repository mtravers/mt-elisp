;;; -*- encoding : utf-8; lexical-binding: t -*-

(require 'cl-lib)

;;; ◇⟐◈ Dired augmentation ◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐

;;; Launch files with 'l' 
;;; Reveal files in finder with 'r'
;;; OS specific; needs filling in for others
(defun dired-launch-command ()
  "Open marked files (or the file the cursor is on) from dired."
  (interactive)
  (let* ((files (dired-get-marked-files t current-prefix-arg))
         (n (length files))
	 (opener (cond
		  ((eq system-type 'gnu/linux)
		   (if (search "redhat" system-configuration)
			"gvfs-open"
		     "xdg-open"))					;right for gnome (ubuntu), not necessarily for other systems
		  ((eq system-type 'darwin)
		   "open"))))
    (when (or (<= n 3)
              (y-or-n-p (format "Open %d files?" n)))
      (dolist (file files)
        (call-process opener
                      nil 0 nil file)))))

(defun dired-reveal-command ()
  "Reveal in Finder. Relies on shell script"
  (interactive)
  (dired-do-shell-command 
   (ecase system-type	      
     (darwin (concat mt-elisp-directory "bin/reveal")))
   nil
   (dired-get-marked-files t current-prefix-arg)))

;;; Alternate method on OSX if for some reason reveal script isn't working
'(apples-do-applescript "tell application \"Finder\"
	open POSIX file \"<fnam>\"
end tell")

(add-hook 'dired-mode-hook
	  (lambda (&rest _)
	    (define-key dired-mode-map
	      (kbd "C-c C-s") 'dired-toggle-sudo)
	    (define-key dired-mode-map
	      "l" 'dired-launch-command)
	    (define-key dired-mode-map
	      "r" 'dired-reveal-command)))

;;; Filter went away!
(require 'seq)

(defun file-buffers ()
  (seq-filter #'buffer-file-name (buffer-list)))

;;; see also http://www.emacswiki.org/emacs/SearchBuffers
(defun search-all-buffers (arg string)
  "Search all file buffers (or with prefix, all buffers) for a given string."
  (interactive "P\nsSearch: ")
  (multi-occur (if arg
		   (buffer-list)
		 (file-buffers))
	       string))

;;; Region is a Ruby-formatted backtrace line (eg "/project/ruby/vendor/plugins/rspec/lib/spec/runner.rb:45")
;;; TODO: better handling of directory defaults
;;; TODO: would be nice if there was a copied string (eg from browser error page) but no region it would use that.
;;; TODO: error handling
;;; TODO: handle missing line number
(defun visit-region (start end)
  (interactive "r")
  (let* ((s (buffer-substring-no-properties start end))
	 (_ (string-match "\\([[:alnum:]@_/\\.-]+\\):\\([[:digit:]]*\\)" s))
	 (file (match-string 1 s))
	 (line (string-to-number (match-string 2 s)))
;	 (buffer (find-file file))
;trying this way for awhile
;note also we could skip find entirely, just find buffer and pass to goto-line
	 (buffer (find-file-other-window file)) 
	 )
    ;; TODO this gets a warning, but the advice to use forward-line seems dumb
    (goto-line line buffer)))

(define-key global-map
  "\C-\M-g" 'visit-region)

(defun send-to-shell (buffer command)
  (with-current-buffer buffer
    (let ((command (concat command "\n")))
      (goto-char (point-max))
      (insert command)
      (comint-send-input))))

;;; Start a shell with a command.
;;; Useful for scripted setup of dev environments
;;; eg:   (startup-shell "*server*" "/project/ruby" "script/server")
;;; TODO would be nice to have errors in one of these alert the user. 
(defun startup-shell (name dir &rest commands)
  (send-to-shell (shell name)
		 (string-join (cons (format "cd %s" dir) commands)
			      "; ")))

;;; ◇⟐◈ Decorativeness ◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐

(defvar border-file (concat mt-elisp-directory "data/borders.txt"))

;;; TODO this should be per-buffer
(defvar *last-decoration*)

(defun random-decoration ()
  (let* ((lines (read-lines border-file)))
    (nth (random (length lines)) lines)))

(defun insert-decorative-border ()
  (interactive)
  (let ((line (random-decoration)))
    (setq *last-decoration* line)
    (insert line)))

(defun insert-decorative-border-last ()
  (interactive)
  (insert *last-decoration*))

;;; TODO doesn't actually work, and not very necessary. Fix or delete.
;;; Might assume start < end and that might not always be the case
(defun insert-decorative-frame (start end)
  (interactive "r")
  (insert-decorative-frame-1 (random-decoration) start end))

(defun insert-decorative-frame-last (start end)
  (interactive "r")
  (insert-decorative-frame-1 *last-decoration* start end))

;; Crudely tries to surround the region. Oddly region ~= selection and no easy way to get selection?
(defun insert-decorative-frame-1 (border start end)
  (setq *last-decoration* border)
  (goto-char end)
  (insert "\n")
  (insert border)
  (insert "\n")
  (goto-char start)
  (insert "\n")
  (insert border)
  (insert "\n")
  (forward-line -1))

(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;;; Keyboard macros
(defun call-kbd-macro (m) (let ((last-kbd-macro m)) (call-last-kbd-macro)))

(defun append-to-file (string filename)
  (write-region string nil filename t))

(defun save-kbd-macro (symbol)
  (interactive "SName for last kbd macro (saved to ~/.emacs): ")
  (name-last-kbd-macro symbol)
  (let ((def `(defun ,symbol (&optional arg)
		(interactive "p")
		(or arg (setq arg 1))
		(dotimes (i arg)
		  (call-kbd-macro ,(symbol-function symbol))))))
    (append-to-file (pp-to-string def) "~/.emacs")
    ))

;;; I'm getting lazy.

(defun yank-quote ()
  "Make an org-mode blockquote from current browser selection as in yank-chrome-selection"
  (call-kbd-macro
   [91 2 91 escape 120 121 97 110 107 45 99 104 114 32 117 32 return 24 24 6 67108896 134217730 134217730 91 5]))

(defun quick-quotes ()
  "Converts my weird ⫸ notation into proper orgmode block quotes"
  (interactive)
  (while (search-forward "
⫸ " nil t)
    (delete-char -2)
    (insert "#+BEGIN_QUOTE
" )
    (end-of-line)
    (insert "
#+END_QUOTE" )))

;;; https://imgur.com/E4EkEMf
(defun donuts ()
  (interactive)
  (insert "🍩🍩🍩"))

(defun org-include-image (file)
  (let* ((pos (position 47 file :from-end t))
	 (filename (substring file (+ pos 1)))
	 (filename-clean (replace-regexp-in-string "\s" "_" filename))
	 (current-directory default-directory))
    (copy-file file
	       (concat current-directory filename-clean))
    (insert (format "\nfile:%s\n" filename-clean))))

;;; TODO apply to DIRED? But can do by hand like:
;;; (dolist (f '( "Screen Shot 2018-06-20 at 8.54.30 PM.png" "Screen Shot 2018-06-20 at 9.00.40 PM.png"... )) (org-include-image  "/Users/mt/Dropbox/work-macbook/to-home/"  f))

;;; org-mode link from region to topmost chrome page
(defun insert-around-region (before after)
  (let ((start (min (mark t) (point)))
	(end (max (mark t) (point))))
    (save-excursion
      (goto-char end)
      (insert after)
      (goto-char start)
      (insert before))))

;;; Offer to create missing directories
;;; Source: https://iqbalansari.github.io/blog/2014/12/07/automatically-create-parent-directories-on-visiting-a-new-file-in-emacs/
(defun maybe-create-non-existent-directory ()
  (let ((parent-directory (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent-directory))
	       (y-or-n-p (format "Directory `%s' does not exist! Create it?" parent-directory)))
      (make-directory parent-directory t))))

(add-to-list 'find-file-not-found-functions #'maybe-create-non-existent-directory)

;; Sometimes frame size gets stuck, this can fix it
(defun set-current-frame-size (rows cols) "resize current frame to ROWS and COLUMNS"
  (interactive "nrows: \nncolumns: ")
  (let ((frame (car (cadr (current-frame-configuration)))))
    (set-frame-size frame cols rows)))


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

;;; Has a dependency on magit, but I expect to always have that loaded.
;;; See also M-x projectile-run-shell
(defun schnell ()
  "Like shell but picks more intelligent buffer names, knows about git repos and will use toplevel if available"
  (interactive)
  (let* ((default-directory (or (magit-toplevel default-directory)
				default-directory))
	 (name (car (last (split-string-and-unquote default-directory "/")))))
    (shell (generate-new-buffer-name (concat "*shell " name "*") ))))

;;; source: https://emacs.stackexchange.com/questions/12121/org-mode-parsing-rich-html-directly-when-pasting
;;; Requires osascript (pre-installed on macs?) and pandoc (brew)
;;; Here rather than mt-mac-hacks.el because it might work on other platforms.

;;; TODO Pandoc introduces spurious _, haven't figured out how to fix that.
;;; TODO dies if selection contains image, generally could be less fragile
;;; TODO version of this that takes input from buffers/regions
;;; TODO only works from Browser, change name to reflect that.

(defun formatted-yank ()
  "Convert clipboard contents from HTML to Org and then paste (yank)."
  (interactive)
  (kill-new (shell-command-to-string "osascript -e 'the clipboard as \"HTML\"' | perl -ne 'print chr foreach unpack(\"C*\",pack(\"H*\",substr($_,11,-3)))' | pandoc -f html -t org"))
  (yank))


;;; IBuffer for shells – add a last command column

(define-ibuffer-column last (:name "Last")
  (ignore-errors (ring-ref comint-input-ring 0)))

;;; defcustom 
(setq ibuffer-formats
      '((mark modified read-only locked
	      " " (name 18 18 :left :elide)
	      " " (size 9 -1 :right)
	      " " (mode 16 16 :left :elide) " " filename-and-process)
	(mark " " (name 16 -1) " " filename)
	;; Added
	(mark " " (name 18 18) " " (filename 35 35 :left :elide) " " last)
	)
      )

;;; TODO
(defun shells ()
  ;; open an ibuffer with proper filtering and format...not obvious how to do that
  )

(defun sgrep-read-files (regexp)
  "sgrep support: A simplified version of grep-read-files that always defaults to *"
  (let* ((default "*")
	 (files (completing-read
		 (concat "Search for \"" regexp
			 "\" in files matching wildcard"
			 (if default (concat " (default " default ")"))
			 ": ")
		 'read-file-name-internal
		 nil nil nil 'grep-files-history "*")))
    (and files
	 (or (cdr (assoc files grep-files-aliases))
	     files))))

(defun sgrep (regexp &optional files dir confirm)
  "rgrep except it defaults to:
- (1) searching all files
- (2) searching from repo root dir (TODO or perhaps root/src as an option)"
  (interactive
   (progn
     (grep-compute-defaults)
     (cond
      ((and grep-find-command (equal current-prefix-arg '(16)))
       (list (read-from-minibuffer "Run: " grep-find-command
				   nil nil 'grep-find-history)))
      ((not grep-find-template)
       (error "grep.el: No `grep-find-template' available"))
      (t (let* ((regexp (grep-read-regexp))
		(files (sgrep-read-files regexp))		       ;(1)
		(default-directory (magit-toplevel default-directory)) ;(2)
		(dir (read-directory-name "Base directory: "
					  nil default-directory t))
		(confirm (equal current-prefix-arg '(4))))
	   (list regexp files dir confirm))))))
  (when (and (stringp regexp) (> (length regexp) 0))
    (unless (and dir (file-accessible-directory-p dir))
      (setq dir default-directory))
    (if (null files)
	(if (not (string= regexp (if (consp grep-find-command)
				     (car grep-find-command)
				   grep-find-command)))
	    (compilation-start regexp 'grep-mode))
      (setq dir (file-name-as-directory (expand-file-name dir)))
      (let ((command (rgrep-default-command regexp files nil)))
	(when command
	  (if confirm
	      (setq command
		    (read-from-minibuffer "Confirm: "
					  command nil nil 'grep-find-history))
	    (add-to-history 'grep-find-history command))
          (grep--save-buffers)
	  (let ((default-directory dir))
	    (compilation-start command 'grep-mode))
	  ;; Set default-directory if we started rgrep in the *grep* buffer.
	  (if (eq next-error-last-buffer (current-buffer))
	      (setq default-directory dir)))))))

(defun replace-all (from to)
  (save-excursion
    (mark-whole-buffer)			;this gets a compiler warning, but save-excursion should make it ok?
    (while (search-forward from nil t)
      (replace-match to nil t))))

;;; Convert HTML blockquotes to org equivalent.
;;; See formatted-yank above for a more general approach
(defun html-to-org ()
  (interactive)
  (replace-all "<blockquote>" "
#+BEGIN_QUOTE
")
  (replace-all "<\/blockquote>" "
#+END_QUOTE
"))



;;; Return a tree of package dependencies 
;;; (note: don't even use the package system any more, these are useless)

(defun package-dependencies-one (name)
  (let ((package (assoc name package-alist)))
    (when package (mapcar #'car (package-desc-reqs (second package))))))

(defun package-dependencies (name)
  (cons name
	(mapcar #'package-dependencies (package-dependencies-one name))))

(defun all-package-dependencies ()
  (mapcar #'package-dependencies
	  (mapcar #'car package-alist)))


(provide 'mt-el-hacks)




