;;; This implements the convention of foo.test.core as the test ns for foo.core.

(defun cider-test-ns-fn (ns)
  (when ns
    (let* ((components (split-string ns "\\."))
	   (test-components (cons (first components) (cons "test" (rest components)))))
      (cider-string-join test-components "."))))

;;; Requires this in .emacs
'(custom-set-variables
  '(cider-test-infer-test-ns (quote cider-test-ns-fn)))

;;; TODO: some way to turn this on only for projectst that use this convention
