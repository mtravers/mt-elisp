;;; Not quite there.
;;; Uses ns from repl, should use that of current buffer
;;; For untrace, look at (:clojure.tools.trace/traced (meta #'kircher.views.dashboard/foo))

(defun nrepl-trace (f)
  "Trace or untrace f)"
  (interactive "P")
  (nrepl-read-symbol-name "Symbol: " 'nrepl-trace-def f))

(defun nrepl-trace-def (var)
  (let ((form (format "
 (do
     (use 'clojure.tools.trace)
     (trace-vars %s))"
		      var)))
    (nrepl-send-string form
		       (nrepl-handler (current-buffer))
		       nrepl-buffer-ns
		       (nrepl-current-tooling-session))))
 

