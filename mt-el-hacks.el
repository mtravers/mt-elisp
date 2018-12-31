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

(add-hook 'dired-load-hook
	  (lambda (&rest _)
	    (define-key dired-mode-map
	      (kbd "C-c C-s") 'dired-toggle-sudo)
	    (define-key dired-mode-map
	      "l" 'dired-launch-command)
	    (define-key dired-mode-map
	      "r" 'dired-reveal-command)))

(defun file-buffers ()
  (filter #'buffer-file-name (buffer-list)))

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
(defun startup-shell (name dir command)
  (send-to-shell (shell name) (format "cd %s;%s" dir command)))

;;; Another thing that is almost there but not quite
;;; might need (require 'ansi-color)
(defun ansi-color-buffer ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

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
  "Make an org-mode blockqupte from current browser selection as in yank-chrome-selection"
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

(defvar screenshot-directory "~/Desktop/")

(defun org-include-image (directory file)
  (let* ((file-clean (replace-regexp-in-string "\s" "_" file))
	 (current-directory default-directory))
    (copy-file (concat directory file)
	       (concat current-directory file-clean))
    (insert (format "\nfile:%s\n" file-clean))))

;;; TODO apply to DIRED? But can do by hand like:
;;; (dolist (f '( "Screen Shot 2018-06-20 at 8.54.30 PM.png" "Screen Shot 2018-06-20 at 9.00.40 PM.png"... )) (org-include-image  "/Users/mt/Dropbox/work-macbook/to-home/"  f))

;;; org-mode link from region to topmost chrome page
;;; TODO should print and confirm link probably

;;; not right yet, what if point/mark are inverted?
;;; TODO should restore point
(defun insert-around-region (before after)
  (insert after)
  (goto-char (mark t))
  (insert before))


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

(provide 'mt-el-hacks)


