;;; from org-html.el
(defun org-html-handle-links (org-line opt-plist)
  "Return ORG-LINE with markup of Org mode links.
OPT-PLIST is the export options list."
  (let ((start 0)
	(current-dir (if buffer-file-name
			 (file-name-directory buffer-file-name)
		       default-directory))
	(link-validate (plist-get opt-plist :link-validation-function))
	type id-file fnc
	rpl path attr desc descp desc1 desc2 link)
    (while (string-match org-bracket-link-analytic-regexp++ org-line start)
      (setq start (match-beginning 0))
      (setq path (save-match-data (org-link-unescape
				   (match-string 3 org-line))))
      (setq type (cond
		  ((match-end 2) (match-string 2 org-line))
		  ((save-match-data
		     (or (file-name-absolute-p path)
			 (string-match "^\\.\\.?/" path)))
		   "file")
		  (t "internal")))
      (setq path (org-extract-attributes path))
      (setq attr (get-text-property 0 'org-attributes path))
      (setq desc1 (if (match-end 5) (match-string 5 org-line))
	    desc2 (if (match-end 2) (concat type ":" path) path)
	    descp (and desc1 (not (equal desc1 desc2)))
	    desc (or desc1 desc2))
      ;; Make an image out of the description if that is so wanted
      (when (and descp (org-file-image-p
			desc org-export-html-inline-image-extensions))
	(save-match-data
	  (if (string-match "^file:" desc)
	      (setq desc (substring desc (match-end 0)))))
	(setq desc (org-add-props
		       (concat "<img src=\"" desc "\" "
			       ;; mt added nil check
			       (when (and attr (save-match-data (string-match "width=" attr)))
				 (prog1 (concat attr " ") (setq attr "")))
			       "alt=\""
			       (file-name-nondirectory desc) "\"/>")
		       '(org-protected t))))
      (cond
       ((equal type "internal")
	(let
	    ((frag-0
	      (if (= (string-to-char path) ?#)
		  (substring path 1)
		path)))
	  (setq rpl
		(org-html-make-link
		 opt-plist
		 ""
		 ""
		 (org-solidify-link-text
		  (save-match-data (org-link-unescape frag-0))
		  nil)
		 desc attr nil))))
       ((and (equal type "id")
	     (setq id-file (org-id-find-id-file path)))
	;; This is an id: link to another file (if it was the same file,
	;; it would have become an internal link...)
	(save-match-data
	  (setq id-file (file-relative-name
			 id-file
			 (file-name-directory org-current-export-file)))
	  (setq rpl
		(org-html-make-link opt-plist
				    "file" id-file
				    (concat (if (org-uuidgen-p path) "ID-") path)
				    desc
				    attr
				    nil))))
       ((member type '("http" "https"))
	;; standard URL, can inline as image
	(setq rpl
	      (org-html-make-link opt-plist
				  type path nil
				  desc
				  attr
				  (org-html-should-inline-p path descp))))
       ((member type '("ftp" "mailto" "news"))
	;; standard URL, can't inline as image
	(setq rpl
	      (org-html-make-link opt-plist
				  type path nil
				  desc
				  attr
				  nil)))

       ((string= type "coderef")
	(let*
	    ((coderef-str (format "coderef-%s" path))
	     (attr-1
	      (format "class=\"coderef\" onmouseover=\"CodeHighlightOn(this, '%s');\" onmouseout=\"CodeHighlightOff(this, '%s');\""
		      coderef-str coderef-str)))
	  (setq rpl
		(org-html-make-link opt-plist
				    type "" coderef-str
				    (format
				     (org-export-get-coderef-format
				      path
				      (and descp desc))
				     (cdr (assoc path org-export-code-refs)))
				    attr-1
				    nil))))

       ((functionp (setq fnc (nth 2 (assoc type org-link-protocols))))
	;; The link protocol has a function for format the link
	(setq rpl
	      (save-match-data
		(funcall fnc (org-link-unescape path) desc1 'html))))

       ((string= type "file")
	;; FILE link
	(save-match-data
	  (let*
	      ((components
		(if
		    (string-match "::\\(.*\\)" path)
		    (list
		     (replace-match "" t nil path)
		     (match-string 1 path))
		  (list path nil)))

	       ;;The proper path, without a fragment
	       (path-1
		(first components))

	       ;;The raw fragment
	       (fragment-0
		(second components))

	       ;;Check the fragment.  If it can't be used as
	       ;;target fragment we'll pass nil instead.
	       (fragment-1
		(if
		    (and fragment-0
			 (not (string-match "^[0-9]*$" fragment-0))
			 (not (string-match "^\\*" fragment-0))
			 (not (string-match "^/.*/$" fragment-0)))
		    (org-solidify-link-text
		     (org-link-unescape fragment-0))
		  nil))
	       (desc-2
		;;Description minus "file:" and ".org"
		(if (string-match "^file:" desc)
		    (let
			((desc-1 (replace-match "" t t desc)))
		      (if (string-match "\\.org$" desc-1)
			  (replace-match "" t t desc-1)
			desc-1))
		  desc)))

	    (setq rpl
		  (if
		      (and
		       (functionp link-validate)
		       (not (funcall link-validate path-1 current-dir)))
		      desc
		    (org-html-make-link opt-plist
					"file" path-1 fragment-1 desc-2 attr
					(org-html-should-inline-p path-1 descp)))))))

       (t
	;; just publish the path, as default
	(setq rpl (concat "<i>&lt;" type ":"
			  (save-match-data (org-link-unescape path))
			  "&gt;</i>"))))
      (setq org-line (replace-match rpl t t org-line)
	    start (+ start (length rpl))))
    org-line))

;;; From progmodes/compile.el 
;;; Patch to call org-show-context, so rgrep on org files isn't completely stupid
(defun compilation-next-error-function (n &optional reset)
  "Advance to the next error message and visit the file where the error was.
This is the value of `next-error-function' in Compilation buffers."
  (interactive "p")
  (when reset
    (setq compilation-current-error nil))
  (let* ((screen-columns compilation-error-screen-columns)
	 (first-column compilation-first-column)
	 (last 1)
	 (msg (compilation-next-error (or n 1) nil
				      (or compilation-current-error
					  compilation-messages-start
					  (point-min))))
	 (loc (compilation--message->loc msg))
	 (end-loc (compilation--message->end-loc msg))
	 (marker (point-marker)))
    (setq compilation-current-error (point-marker)
	  overlay-arrow-position
	    (if (bolp)
		compilation-current-error
	      (copy-marker (line-beginning-position))))
    ;; If loc contains no marker, no error in that file has been visited.
    ;; If the marker is invalid the buffer has been killed.
    ;; So, recalculate all markers for that file.
    (unless (and (compilation--loc->marker loc)
                 (marker-buffer (compilation--loc->marker loc))
                 ;; FIXME-omake: For "omake -P", which automatically recompiles
                 ;; when the file is modified, the line numbers of new output
                 ;; may not be related to line numbers from earlier output
                 ;; (earlier markers), so we used to try to detect it here and
                 ;; force a reparse.  But that caused more problems elsewhere,
                 ;; so instead we now flush the file-structure when we see
                 ;; omake's message telling it's about to recompile a file.
                 ;; (or (null (compilation--loc->timestamp loc)) ;A fake-loc
                 ;;     (equal (compilation--loc->timestamp loc)
                 ;;            (setq timestamp compilation-buffer-modtime)))
                 )
      (with-current-buffer
          (compilation-find-file
           marker
           (caar (compilation--loc->file-struct loc))
           (cadr (car (compilation--loc->file-struct loc))))
        (let ((screen-columns
               ;; Obey the compilation-error-screen-columns of the target
               ;; buffer if its major mode set it buffer-locally.
               (if (local-variable-p 'compilation-error-screen-columns)
                   compilation-error-screen-columns screen-columns))
              (compilation-first-column
               (if (local-variable-p 'compilation-first-column)
                   compilation-first-column first-column)))
          (save-restriction
            (widen)
            (goto-char (point-min))
            ;; Treat file's found lines in forward order, 1 by 1.
            (dolist (line (reverse (cddr (compilation--loc->file-struct loc))))
              (when (car line)		; else this is a filename w/o a line#
                (beginning-of-line (- (car line) last -1))
                (setq last (car line)))
              ;; Treat line's found columns and store/update a marker for each.
              (dolist (col (cdr line))
                (if (compilation--loc->col col)
                    (if (eq (compilation--loc->col col) -1)
                        ;; Special case for range end.
                        (end-of-line)
                      (compilation-move-to-column (compilation--loc->col col)
                                                  screen-columns))
                  (beginning-of-line)
                  (skip-chars-forward " \t"))
                (if (compilation--loc->marker col)
                    (set-marker (compilation--loc->marker col) (point))
                  (setf (compilation--loc->marker col) (point-marker)))
                ;; (setf (compilation--loc->timestamp col) timestamp)
                ))))))
    (compilation-goto-locus marker (compilation--loc->marker loc)
                            (compilation--loc->marker end-loc))
    (org-show-context 'compile)
    (setf (compilation--loc->visited loc) t)))


(provide 'mt-patches)
