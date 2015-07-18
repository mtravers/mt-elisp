;;; -*- encoding : utf-8 -*-

;;; ◇⟐◈ Dired augmentation ◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐

;;; Launch files with 'l' 
;;; Reveal files in finder with 'r'
;;; OS specific and have only filled in the ones I am using.

(defun dired-launch-command ()
  (interactive)
  (setq current-prefix-arg t)		;ensure just current file rather than marked set
  (dired-do-shell-command 
   (ecase system-type	      
     (gnu/linux 
      (if (search "redhat" system-configuration)
	  "gvfs-open"
	"gnome-open"))	;right for gnome (ubuntu), not necessarily for other systems
     (darwin "open"))
   nil
   (dired-get-marked-files t current-prefix-arg)))

(defun dired-reveal-command ()
  (interactive)
  (dired-do-shell-command 
   (ecase system-type	      
     (darwin (concat mt-elisp-directory "bin/reveal")))
   nil
   (dired-get-marked-files t current-prefix-arg)))

(add-hook 'dired-load-hook
	  (lambda (&rest ignore)
	    (define-key dired-mode-map
	      (kbd "C-c C-s") 'dired-toggle-sudo)
	    (define-key dired-mode-map
	      "l" 'dired-launch-command)
	    (define-key dired-mode-map
	      "r" 'dired-reveal-command)))

;;; ::: Search all buffers (enormously useful)

;;; TODO Should probably filter out some buffers, maybe limit to files only (especially existing *Occurs* buffers!)
;;; TODO order is weird, not sure why, buffer-list appears to return things in a good order.
;;; see also http://www.emacswiki.org/emacs/SearchBuffers
;;; See also M-x multi-occur-in-matching-buffers
(defun search-all-buffers (string)
  (interactive "sSearch: ")
  (occur-1 string nil (buffer-list nil)))

;;; Region is a Ruby-formatted backtrace line (eg "/project/ruby/vendor/plugins/rspec/lib/spec/runner.rb:45")
;;; TODO: better handling of directory defaults
;;; TODO: would be nice if there was a copied string (eg from browser error page) but no region it would use that.
;;; TODO: error handling
;;; TODO: handle missing line number
;;; TODO analog for Clojure backtraces (which can be java or clojure) (Cider seems to handle this so not really necessary)
;;; Surely this is already in emacs somewhere?
(defun visit-region (start end)
  (interactive "r")
  (let* ((s (buffer-substring-no-properties start end))
	 (ignore (string-match "\\([[:alnum:]@_/\\.-]+\\):\\([[:digit:]]*\\)" s))
	 (file (match-string 1 s))
	 (line (string-to-number (match-string 2 s)))
;	 (buffer (find-file file))
;trying this way for awhile
;note also we could skip find entirely, just find buffer and pass to goto-line
	 (buffer (find-file-other-window file)) 
	 )
    (goto-line line buffer)))

(define-key global-map
  "\C-\M-g" 'visit-region)

(defun send-to-shell (buffer command)
  (with-current-buffer buffer
    (let ((start (point-max))
	  (command (concat command "\n")))
      (goto-char start)
    (insert-string command)
    (comint-send-string (get-buffer-process buffer) command))))

;;; Start a shell with a command 
;;; eg:   (startup-shell "*server*" "cd /project/ruby; script/server")
;;; TODO would be nice to have errors in one of these alert the user. 
(defun startup-shell (name command)
  (send-to-shell (shell name) command))

;;; Another thing that is almost there but not quite
;;; might need (require 'ansi-color)
(defun ansi-color-buffer ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

;;; ◇⟐◈ Decorativeness ◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐◈◆◈⟐◇⟐

(defvar border-file (concat mt-elisp-directory "data/borders.txt"))

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
  (previous-line))

(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;;; ??? What was this for?
(defun yank-current-file-name ()
  "Insert file name of current buffer.
If repeated, insert text from buffer instead."
  (interactive)
  (if (buffer-file-name (current-buffer))
      (kill-new (buffer-file-name (current-buffer)))
    (beep)))
	 
(defun applescript-yank (script)
  (require 'apples-mode)
  (apples-do-applescript
   script
   #'(lambda (url status script)
       ;; comes back with quotes which we strip off
       (insert (subseq url 1 (1- (length url))))))
  )

(defun yank-chrome-url ()
 "Yank current URL from Chrome"
  (interactive)
  (applescript-yank "tell application \"Google Chrome\"
	get URL of active tab of first window
end tell"))

(defun yank-chrome-selection ()
 "Yank current selection from Chrome"
  (interactive)
  (applescript-yank "tell application \"Google Chrome\"
	copy selection of active tab of first window
end tell
set theText to the clipboard" )
  )

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

(provide 'mt-el-hacks)
