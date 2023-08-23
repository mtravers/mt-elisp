;;; -*- encoding : utf-8; lexical-binding: t -*-

;;; Mac-specific hacks, many relying on Applescript
;;; TODO apples-mode is broken and this won't load, so it is diked

(use-package apples-mode)

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

(defun applescript-get-browser-url (browser)
  (format "tell application \"%s\"
	get URL of active tab of first window
end tell"
	  browser))

(defun applescript-get-browser-window-urls (browser)
  (format "tell application \"%s\"
	get URL of tabs of first window
end tell"
	  browser))

(defun applescript-get-browser-all-urls (browser)
  (format "tell application \"%s\"
	get URL of tabs of windows
end tell"
	  browser))

;;; Note: these have stopped working in the standed Mac Emacs, but they work OK in the more nativey implementation https://github.com/railwaycat/homebrew-emacsmacport

(defun yank-browser-url (browser)
  "Yank current URL from Browser. C-u prefix yanks URLs from all tabs of current window, C-u C-u from all windows."
  (case (car current-prefix-arg)
    (4 (applescript-yank-list
	(applescript-get-browser-window-urls browser)))
    (16
     (applescript-yank-list
      (applescript-get-browser-all-urls browser)))
    (t
     (applescript-yank
      (applescript-get-browser-url browser)))))

(defconst brave "Brave Browser")
(defconst chrome "Google Chrome")

(defun yank-brave-url ()
 (interactive)
 (yank-browser-url brave))

;;; Not working for very unknown reasons. The Brave version works (most of the time?).
(defun yank-chrome-url ()
 (interactive)
 (yank-browser-url chrome))

;;; TODO fucks up quotes. Maybe just replace with formatted-yank which works better?
(defun yank-chrome-selection ()
 "Yank current selection from Chrome."
  (interactive)
  (applescript-yank "tell application \"Google Chrome\"
	copy selection of active tab of first window
end tell
Set theText to the clipboard" )
  )

;;; Doesn't work because applescript exec is asynchronous.
;;; Fix by using CPS consistently maybe?
;; (defun yank-chrome ()
;;   (interactive)
;;   (yank-chrome-selection)
;;   (insert "")
;;   (yank-chrome-url)))

;;; TODO not mac specific
;;; TODO surely there is an existing command to do this? Yes, org-insert-link
(defun link (url)
  "Make an org-mode hyperlink from region."
  (interactive "surl: ")
  (insert-around-region (concat "[[" url "][") "]]")
  (message "Linked %s" url))

;;; Idea_stupid: work in HTML mode as well
;;; TODO this leaves pointer in shitty place
(defun link-browser (browser)
  "Make an org-mode hyperlink from region to current browser url"
  (applescript-apply #'link
		     (applescript-get-browser-url browser)))


(defun link-chrome ()
  (interactive)
  (link-browser chrome))

(defun link-brave ()
  (interactive)
  (link-browser brave))

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

;;; TODO: yank-keep, gets latest note from keep.
;;; No idea how to actually do that, probably involves implementing a client for Google API, which sounds like a pain. 

;;; Close! Probably should copy browser selection to clipboard
(defun transclude-chrome ()
  (interactive)
  (yank-chrome-url)			;at the beginning outside BLOCKQOUTE? Can always be moved
  (insert "\n#+BEGIN_BLOCKQUOTE\n")
  (formatted-yank)
  ;alt (yank-chrome-selection)		;except should preserve italics etc (Formatted-yank) but that has its own problems
  (insert "\n#+END_BLOCKQUOTE\n")
  )

(provide 'mt-mac-hacks)
;;; mt-mac-hacks.el ends here
