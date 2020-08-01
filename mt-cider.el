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
(add-hook 'cider-mode-hook 'eldoc-mode)	; echo-area arglists
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

(define-key cider-repl-mode-map (kbd "C-c C-l")
  'cider-repl-clear-buffer)

;;; https://github.com/bhauman/lein-figwheel/wiki/Using-the-Figwheel-REPL-within-NRepl
;;; cider-cljs-lein-repl set in customizations – doesn't work here.

;;; https://stackoverflow.com/questions/18304271/how-do-i-choose-switch-leiningen-profiles-with-emacs-nrepl
(defun start-cider-repl-with-profile ()
  (interactive)
  (letrec ((profile (read-string "Enter profile name: "))
           (lein-params (concat "with-profile +" profile " repl :headless")))
    (message "lein-params set to: %s" lein-params)
    (set-variable 'cider-lein-parameters lein-params)
    (cider-jack-in '())))
