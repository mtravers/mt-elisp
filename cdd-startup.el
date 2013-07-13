;;;+++ use me
(defun ruby-shell (name command)
  (startup-shell name (concatenate 'string
				   "cd /misc/cdd/cdd/ruby; "
				   command)))
		 
(defun cdd-startup ()
  (interactive)
  (startup-shell "*server*" "cd /misc/cdd/cdd/ruby; script/server")
  (startup-shell "*console*" "cd /misc/cdd/cdd/ruby; script/console")
  (startup-shell "*processor*" "cd /misc/cdd/cdd/ruby; script/processor")
;;; no, this interferes with *processor*
;  (startup-shell "*recalculator*" "cd /misc/cdd/cdd/ruby; script/recalculator")
  (startup-shell "*catalina*" "sudo /usr/local/Cellar/tomcat6/6.0.33/bin/catalina.sh run")
  (startup-shell "*java*" "cd /misc/cdd/java; ant tomcat.deploy")
  (startup-shell "*solr*" "cd /misc/cdd/cdd/ruby; rake solr:ensure_running")
  (startup-shell "*test*" "cd /misc/cdd/cdd/ruby"))

(defun cdd-startup-selenium ()
  (interactive)
  (startup-shell "*selenium-server*" "cd /misc/cdd/cdd/ruby; rake selenium:server
")  
  (startup-shell "*selenium-solr*" "cd /misc/cdd/cdd/ruby; RAILS_ENV=test rake solr:ensure_running")  )
  

;;; +++ Testing setups

(provide 'cdd-startup)


