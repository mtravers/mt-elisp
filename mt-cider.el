(require 'cider)

;;; This implements the convention of foo.test.core as the test ns for foo.core.

;;; ⟥⟤⟥ Implement my preferred layout for tests.  ⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤

;;; Conflicts with Vital, so turned off, needs to be smart enough to do it on a per-project basis

'(defun cider-test-ns-fn (ns)
  (when ns
    (let* ((components (split-string ns "\\."))
	   (test-components (cons (first components) (cons "test" (rest components)))))
      (cider-string-join test-components "."))))

;;; Requires this in .emacs
'(custom-set-variables
  '(cider-test-infer-test-ns (quote cider-test-ns-fn)))

;;; TODO: some way to turn this on only for projectst that use this convention


;;; ⟥⟤⟥ Autocomplete ⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤⟥⟤

;;; Not really working

(require 'ac-cider)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))

(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)

(setq cider-prompt-for-project-on-connect nil)

;;; TODO this is being done too early and getting overwritten
;;; Patch to fix bug in indentation (Cider 0.10.0). Probably fixed in later versions.
(defun cider--get-symbol-indent (symbol)
  nil)

(define-key cider-repl-mode-map (kbd "C-c M-o")
  'cider-repl-clear-buffer)
