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

(provide 'mt-private)
