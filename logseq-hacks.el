;;; Random things for working with both Emacs and Logseq
;;;   which I have to admit is probably a dumb thing to do. Should just use org-roam in Emacs. Nevertheless.

;;; ⧄⧅⧄ Utilities  ⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅

(defun page-names ()
  ;; TODO Really file names. Would be better if trim ext, replace . with space, etc.
  (directory-files (concat (magit-toplevel default-directory) "/pages")))

;;; TODO should be able to make a new page when prompted
;;; TODO would be nice if this was case-insensitive...not an option apparently
(defun get-page-name ()
  (ido-completing-read "Page: " (page-names)))

;;; ⧄⧅⧄ logseq-append-region ⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅

;;; TODO append the current region to a given page

;;; ⧄⧅⧄ dired-logseq-append-image ⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅

;;; Used this for curating accumulated screeshots. These days I always paste them in directly, so this is not used much

(defun dired-logseq-append-image ()
  (interactive)
  (let* ((files (dired-get-marked-files t current-prefix-arg))
	 (page (get-page-name))
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

;;; TODO should work from an image buffer, not just dired
;;; TODO dired-logseq-append works like above but for text files

;;; ⧄⧅⧄ open-in-logseq ⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅⧄⧅

;;; When visiting a Logseq file in Emacs, this will open it in Logseq.
;;; TODO doesn't work for journal pages, they use title:

(defun logseq-page ()
  ;;; TODO verify that this is indeed a logseq file
  ;;; Returns (graph page-name) pair
  ;;; TODO need to look to see if there is title: element
  (let ((page-name (file-name-sans-extension
		    (file-name-nondirectory
		     (buffer-file-name (current-buffer)))))
	(graph (file-name-nondirectory
		(substring
		 (magit-toplevel default-directory)
		 0 -1))))
    (list graph page-name)))

(defun logseq-url (graph page)
  (format "logseq://graph/%s?page=%s" graph (url-encode-url page)))

(defun open-in-logseq ()
  (interactive)
  (let* ((logseq-page (logseq-page)))
    (when logseq-page
      (browse-url (logseq-url (car logseq-page) (cadr logseq-page))))))

(provide 'logseq-hacks)
