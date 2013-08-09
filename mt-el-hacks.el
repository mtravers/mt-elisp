;;; -*- encoding : utf-8 -*-
;;; ::: Word count

;;: Not necessary M-x count-words is in Emacs 24
(defun word-count nil "Count words in buffer" (interactive)
  (shell-command-on-region (point-min) (point-max) "wc -w"))

(defun word-count-region nil "Count words in region" (interactive)
  (shell-command-on-region (point) (mark) "wc -w"))

;;; ::: Augment dired to launch files with 'l' (launch) and 'r' (reveal)

(defun dired-launch-command ()
  (interactive)
  (dired-do-shell-command 
   (case system-type	      
     (gnu/linux 
      (if (search "redhat" system-configuration) ;no idea
	  "gvfs-open"
	"gnome-open"))	;right for gnome (ubuntu), not for other systems
     (darwin "open"))
   nil
   (dired-get-marked-files t current-prefix-arg)))

;;; Uses script found here (in ~/bin/reveal)
;;; http://mrox.net/blog/2008/08/09/learning-the-terminal-on-the-mac-part-4-bringing-finder-and-terminal-together/
(defun dired-reveal-command ()
  (interactive)
  (dired-do-shell-command 
   (case system-type	      
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

;;; +++ Should probably filter out some buffers, maybe limit to files only (especially existing *Occurs* buffers!)
;;; +++ order is weird, not sure why, buffer-list appears to return things in a good order.
;;; see also http://www.emacswiki.org/emacs/SearchBuffers
;;; See also M-x multi-occur-in-matching-buffers
(defun search-all-buffers (string)
  (interactive "sSearch: ")
  (occur-1 string nil (buffer-list nil)))

;;; Region is a Ruby-formatted backtrace line (eg "/misc/cdd/cdd/ruby/vendor/plugins/rspec/lib/spec/runner.rb:45")
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

;;; Args are files with attributes
(defun file-newer (fa fb)
  (let ((a (nth 5 fa))
	(b (nth 5 fb)))
    (or (> (car a) (car b)) (and (= (car a) (car b)) (> (cadr a) (cadr b))))))

;;; +++ move this to separate file (for publication)
(defun j ()
  (interactive)
  (let* ((files (directory-files-and-attributes "/Volumes/revenant/b/j/" t "^\\w*\\.org$"))
	 (sorted (sort files #'file-newer))
	 (newest (car (car sorted))))
    (find-file newest)
    (goto-char (point-max))		;go to end
    ))

;;; Another thing that is almost there but not auite
;;; might need (require 'ansi-color)
(defun ansi-color-buffer ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

;;; ⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯⤰⤯
(defvar *last-decoration*)

(defun insert-random-decoration ()
  (interactive)
  (let* ((lines (read-lines "/Volumes/revenant/b/j/borders.txt"))
	 (line (nth (random (length lines)) lines)))
    (setq *last-decoration* line)
    (insert line)))

(defun insert-last-decoration ()
  (interactive)
  (insert *last-decoration*))

;;; Amazingly there is nothing like this to be found.
;;; Found here, very useful: http://ergoemacs.org/emacs/elisp_idioms_batch.html
(defun read-lines (fPath)
  "Return a list of lines of a file at FPATH."
  (with-temp-buffer
    (insert-file-contents fPath)
    (split-string (buffer-string) "\n" t)))
    

;;; +++ Hook for .log files


(provide 'mt-el-hacks)
