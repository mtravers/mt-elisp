;;; Find any def of SYM in all known namespaces
;;; TODO Way too slow to be usable, the iteration through namespaces needs to happen on other side of connection
;;; TODO tighter interaction, default the symbol to something reasonable
;;; TODO I suspect that the underlying machinery is continuation based and might thus have timing errors when used naively.

(defun cider-true-dwim (sym)
  (interactive "sSymbol: ")
  (let ((bindings (cider-var-bindings sym)))
    (when (car bindings)
      (cider-repl-set-ns (car (car bindings))))))

(defun cider-var-bindings (sym)
  (remove-if #'null
	     (mapcar #'(lambda (ns)
			 (cons ns (lookup-usefully sym ns)))
		     (cider-sync-request:ns-list))
	     :key #'cdr))

;;; Variant of cider-sync-request:lookup-ns in which you can specify nsq
(defun cider-sync-request:lookup-ns (symbol ns &optional lookup-fn)
  "Send \"lookup\" op request with parameters SYMBOL, NS and LOOKUP-FN."
  (let ((var-info (thread-first `("op" "lookup"
                                  "ns" ,ns
                                  ,@(when symbol `("sym" ,symbol))
                                  ,@(when lookup-fn `("lookup-fn" ,lookup-fn)))
                    (cider-nrepl-send-sync-request (cider-current-repl)))))
    (if (member "lookup-error" (nrepl-dict-get var-info "status"))
        nil
      var-info)))

(defun lookup-usefully (symbol ns)
  (nth 6 (cider-sync-request:lookup-ns symbol ns)))

