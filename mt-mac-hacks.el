;;; Mac-specific hacks, many relying on Applescript

(defun applescript-apply (f script)
  (require 'apples-mode)
  (apples-do-applescript
   script
   #'(lambda (result status script)
       ;; pull out part in quotes
       (string-match "\"\\(.*\\)\"" result)
       (let ((actual (match-string 1 result)))
	 (funcall f actual)))))
  
(defun applescript-yank (script)
  (applescript-apply #'insert script))

(defconst applescript-get-chrome-url
  "tell application \"Google Chrome\"
	get URL of active tab of first window
end tell"
  )

(defun yank-chrome-url ()
 "Yank current URL from Chrome"
  (interactive)
  (applescript-yank applescript-get-chrome-url))

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

(defun yank-latest-screenshot ()
  (interactive)
  ;; How did this 
  (org-include-image screenshot-directory
		     (car (last (directory-files screenshot-directory nil "Screen Shot")))))

;;; Idea_stupid: yank-latest-window-name (to label screenshots, among other uses). But need to have way to get at previous application.

(provide 'mt-mac-hacks)
