;;; -*- encoding : utf-8; lexical-binding: t -*-

;;; Mac-specific hacks, many relying on Applescript

(require 'apples-mode)

(defun applescript-apply (f script)
  (apples-do-applescript
   script
   #'(lambda (result _ _2)
       ;; pull out part in quotes
       (string-match "\"\\(.*\\)\"" result)
       (let ((actual (match-string 1 result)))
	 (funcall f actual)))))

;;; TODO if starts with a {, its an applescript list. Parse it and turn it into lines for inserton probably. Maybe use reader? or (s-split "," result)
  
(defun applescript-yank (script)
  (applescript-apply #'insert script))

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
 "Yank current URL from Chrome"
  (interactive)
  (applescript-yank
   (case (car current-prefix-arg)
     (nil applescript-get-chrome-url)
     (4 applescript-get-chrome-window-urls)
     (16 applescript-get-chrome-all-urls))))

(defun yank-chrome-selection ()
 "Yank current selection from Chrome"
  (interactive)
  (applescript-yank "tell application \"Google Chrome\"
	copy selection of active tab of first window
end tell
set theText to the clipboard" )
  )

;;; Idea_stupid: work in HTML mode as well
(defun link-chrome ()
  "Make an org-mode hyperlink from region to current chrome url"
  (interactive)
  (applescript-apply
   #'(lambda (url)
       (insert-around-region (concat "[[" url "][") "]]"))
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
