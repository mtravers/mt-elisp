(defun cljs-hello ()
  (interactive)
  (startup-shell "*cljs-server" "cd /misc/repos/cljs-hello; lein run -m cljs-hello.server/start")
  (startup-shell "*cljs-compile*" "cd /misc/repos/cljs-hello; lein cljsbuild auto")
  ;; doesn't work well under nrepl
  (startup-shell "*cljs-repl" "cd /misc/repos/cljs-hello; lein repl")
  (startup-shell "*cljs-server" "cd /misc/repos/cljs-hello; lein run -m cljs-hello.server/start"))

(provide 'side-projects)  
