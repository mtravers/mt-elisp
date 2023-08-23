;;;  mt-cider-new --- mt's cider customizations
;;; ☒□ Clojure □☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒□☒

;;; Commentary:
;;; What is this, the Talmud?

;;; Code:

(use-package cider
  :ensure t)

;;; Flycheck, how did I live so long without this turned on?

;;; Requires clj-kondo on path (brew works)

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

(global-flycheck-mode)

;;; Let's try clj-refactor.
;;; No lets not
;(require 'clj-refactor)

'(defun my-clojure-mode-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "C-c C-m"))

(defun jackoff ()
  "A shorter way to start up cider in the normal case."
  (interactive)
  ;; tired of typing this
  (cider-jack-in-clj&cljs))


(provide 'mt-cider-new)

;;; mt-cider-new.el ends here

