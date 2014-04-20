;;; -*- encoding : utf-8 -*-
;;; ::: Word count

;;; ::: Augment dired to launch files with 'l' (launch) and 'r' (reveal in finder)

(defun dired-launch-command ()
  (interactive)
  (dired-do-shell-command 
   (ecase system-type	      
     (gnu/linux 
      (if (search "redhat" system-configuration)
	  "gvfs-open"
	"gnome-open"))	;right for gnome (ubuntu), not necessarily for other systems
     (darwin "open"))
   nil
   (dired-get-marked-files t current-prefix-arg)))

;;; Uses script found here (place in ~/bin/reveal)
;;; http://mrox.net/blog/2008/08/09/learning-the-terminal-on-the-mac-part-4-bringing-finder-and-terminal-together/
(defun dired-reveal-command ()
  (interactive)
  (dired-do-shell-command 
   (ecase system-type	      
     (darwin "~/bin/reveal"))
   nil
   (dired-get-marked-files t current-prefix-arg)))

(add-hook 'dired-load-hook
	  (lambda (&rest ignore)
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
(defun startup-shell (name command)
  (send-to-shell (shell name) command))

;;; Another thing that is almost there but not quite
;;; might need (require 'ansi-color)
(defun ansi-color-buffer ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

;;; ⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯

(defvar *last-decoration*)

(defun random-decoration ()
  (let* ((lines (read-lines "/Volumes/revenant/b/j/borders.txt")))
    (nth (random (length lines)) lines)))

(defun insert-decorative-border ()
  (interactive)
  (let ((line (random-decoration)))
    (setq *last-decoration* line)
    (insert line)))

(defun insert-decorative-border-last ()
  (interactive)
  (insert *last-decoration*))

(defun insert-decorative-frame ()
  (interactive)
  (insert-decorative-frame-1 (random-decoration)))

(defun insert-decorative-frame-last ()
  (interactive)
  (insert-decorative-frame-1 *last-decoration*))

(defun insert-decorative-frame-1 (border)
  (setq *last-decoration* border)
  (insert border)
  (insert "\n\n")
  (insert border)
  (previous-line))

;;; Amazingly there is nothing like this to be found.
;;; Found here, very useful: http://ergoemacs.org/emacs/elisp_idioms_batch.html
(defun read-lines (fPath)
  "Return a list of lines of a file at FPATH."
  (with-temp-buffer
    (insert-file-contents fPath)
    (split-string (buffer-string) "\n" t)))
    
(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

(provide 'mt-el-hacks)
