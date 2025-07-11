;;;  mt-cider-new --- mt's cider customizations

;;; TODO why does it always ask for lein, must be a way to stop that
;;; cider-jack-in-default is lein, but it doesn't seem to work
;;; (also supposed to infer from project).

;;; ☒□ Clojure □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

;;; Code:

(use-package cider
  :ensure t
  )

;;; Flycheck, how did I live so long without this turned on?

;;; Requires clj-kondo on path (brew works)

;; turned off for now, it might be causing perf issues? (No doesn't help, so turned back on)
(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config (require 'flycheck-clj-kondo)
  )

(global-flycheck-mode)


;;; Let's try clj-refactor.
;;; No lets not
;(require 'clj-refactor)

(defun my-clojure-mode-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1)			; for adding require/use/import statements
  (goto-address-mode 1)			;TODO probably want this on everywhere, not just Clojure
  (cljr-add-keybindings-with-prefix "C-c C-m") ; This choice of keybinding leaves cider-macroexpand-1 unbound
  )

; (add-hook 'clojure-mode-hook #'my-clojure-mode-hook)


(defun jackoff ()
  "A shorter way to start up cider in the normal case."
  (interactive)
  ;; tired of typing this
  (cider-jack-in-clj&cljs))


(provide 'mt-cider-new)

;;; mt-cider-new.el ends here

