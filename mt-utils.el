;;; Found here, very useful: http://ergoemacs.org/emacs/elisp_idioms_batch.html
(defun read-lines (fPath)
  "Return a list of lines of a file at FPATH."
  (with-temp-buffer
    (insert-file-contents fPath)
    (split-string (buffer-string) "\n" t)))
    
;;; Args are files with attributes
(defun file-newer (fa fb)
  (let ((a (nth 5 fa))
	(b (nth 5 fb)))
    (or (> (car a) (car b)) (and (= (car a) (car b)) (> (cadr a) (cadr b))))))

(provide 'mt-utils)
