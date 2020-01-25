;;; -*- encoding : utf-8; lexical-binding: t -*-

;;; Mac-specific hacks, many relying on Applescript

(require 'apples-mode)

(defun applescript-apply (f script)
  (apples-do-applescript
   script
   #'(lambda (result _ _2)
       (funcall f (parse-applescript result)))))

(defun parse-applescript (return-string)
  (cond ((string-prefix-p "{" return-string)
	 (mapcar #'parse-applescript (mapcar #'string-trim (split-string (string-trim return-string "[{}]" "[{}]") ","))))
	((string-prefix-p "\"" return-string)
	 (string-trim return-string "[ \"]*" "[ \"]*"))
	(t
	 return-string)))

(defun applescript-yank (script)
  (applescript-apply #'(lambda (x) (insert x)) script))

(defun applescript-yank-list (script)
  (applescript-apply #'(lambda (x) (dolist (item x) (insert item) (insert "\n"))) script))

;;; TODO something like this for Preview, returning file urls

(defconst applescript-get-chrome-url
  "tell application \"Google Chrome\"
	get URL of active tab of first window
end tell"
  )

(defconst applescript-get-chrome-window-urls
  "tell application \"Google Chrome\"
	get URL of tabs of first window
end tell"
  )

(defconst applescript-get-chrome-all-urls
  "tell application \"Google Chrome\"
	get URL of tabs of windows
end tell"
  )

(defun yank-chrome-url ()
  "Yank current URL from Chrome. C-u prefix yanks URLs from all tabs of current window, C-u C-u from all windows"
  (interactive)
   (case (car current-prefix-arg)
     (4 (applescript-yank-list applescript-get-chrome-window-urls))
     (16 (applescript-yank-list applescript-get-chrome-all-urls))
     (t (applescript-yank applescript-get-chrome-url))))

;;; TODO fucks up quotes. Maybe just replace with formatted-yank which works better?
(defun yank-chrome-selection ()
 "Yank current selection from Chrome"
  (interactive)
  (applescript-yank "tell application \"Google Chrome\"
	copy selection of active tab of first window
end tell
set theText to the clipboard" )
  )

;;; Doesn't work because applescript exec is asynchronous.
;;; Fix by using CPS consistently maybe?
;; (defun yank-chrome ()
;;   (interactive)
;;   (yank-chrome-selection)
;;   (insert "")
;;   (yank-chrome-url)))

;;; Idea_stupid: work in HTML mode as well
(defun link-chrome ()
  "Make an org-mode hyperlink from region to current chrome url"
  (interactive)
  (applescript-apply
   #'(lambda (url)
       (insert-around-region (concat "[[" url "][") "]]")
       (message "Linked %s" url))
   applescript-get-chrome-url))

(defvar screenshot-directory "~/Desktop/")

(defun file-modification-time (f)
  (let ((attrs (file-attributes f))) (nth 5 attrs)))

(defun latest-file (files)
  (car (sort files (lambda (a b)
		     (not (time-less-p (file-modification-time a)
				       (file-modification-time b)))))))

;; TODO bug, this doesn't always find the latest shot, order is off.
(defun yank-latest-screenshot ()
  (interactive)
  (org-include-image (latest-file (directory-files screenshot-directory t "Screen Shot"))))


;;; Idea_stupid: yank-latest-window-name (to label screenshots, among other uses). But need to have way to get at previous application.

(provide 'mt-mac-hacks)
