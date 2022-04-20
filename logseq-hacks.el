;;; Top goal: need to cleanup screenshots

;;; Yes its perverse to have Logseq hacks in Emacs. Some of this stuff is more generally useful and could be adapted to other purposes. 

;;; Want: point to a file, with minimal keystrokes append it to a given page.
;;; M-x dired-logseq-append

;;; TODO should be able to make a new page
;;; TODO should work from an image buffer, not just dired

(defvar logseq-repo "/opt/mt/repos/ammdi") 

(defun page-names ()
  ;; TODO trim ext, replace . with space, etc
  (directory-files (concat logseq-repo "/pages")))

(defun dired-logseq-append-image ()
  (interactive)
  (let* ((files (dired-get-marked-files t current-prefix-arg))
	 (page (ido-completing-read "Page: " (page-names))) ;would be nice if this was case-insensitive...not an option apparently
	 (page-file (concat logseq-repo "/pages/" page)))
    (dolist (file files)
      ;; move to assets
      (rename-file file (concat logseq-repo "/assets/"))
      ;; insert markdown 
      ;; TODO sometimes this gets errors, not sure why
      (append-to-file (format "%c- ![](%s)" ?\n (concat "../assets/" file))
		      page-file)
      nil
      )))

