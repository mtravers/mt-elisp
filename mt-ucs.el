;;; Unicode Hacks

;;; ucs-insert-matching
;;; ucs-char-insert-all-inversions
;;; utf-fixer

;;; M-x describe-char takes up half the screen,
;;; I want something simpler (just the char name)
;;; TODO – how about a mode where it just displays it, when it's a nonstandard char?
;;; M-x describe-char has elaborate logic that should be pulled out...

;;; Haven't used this yet but it looks like fun
;;; https://github.com/Codepoints/awesome-codepoints

(defun desc-char (pos)
  (interactive "d")
  (let* ((char (char-after pos))
	 (name (get-char-code-property char 'name)))
    (prin1 name)))

(defun ucs-insert-matching (pattern &optional word?)
  "Insert Unicode chars whose name matches PATTERN. A prefix arg means verbose (each char is on its own line with name)"
  (interactive "sPattern:")
  (if word? (setf pattern (format "\\<%s\\>" pattern)))
  (maphash #'(lambda (name char)
	       (when (string-match pattern name)
		 (ucs-insert char)
		 (when current-prefix-arg
		   (insert-tab)
		   (insert (car char-pair))
		   (insert ?\n))))
	   (ucs-names)))

(defun string-replace (this withthat in)
  "replace THIS with WITHTHAT' in the string IN"
  (when (string-match this in)
    (replace-match withthat nil nil in)))

(defun buffer-string-replace (from to)
  (goto-char (point-min))
  (while (search-forward from nil t)
    (replace-match to nil t)))

;;; Fixup files that get their encoding out of whack.
;;; Haha, this got turned into silliness due to an interesting bug.
;;; Use M-x toggle-enable-multibyte-characters (possibly twice) for the same effect.
(defun utf-fixer ()
  (interactive)
  (buffer-string-replace "“" "“")
  (buffer-string-replace "”" "”")
  (buffer-string-replace "’" "’")
  (buffer-string-replace "—" "—") 
  (buffer-string-replace "–" "–") 
  )

;;; Here we get funky

;;; Hey, where does the Mac char viewers “related characters” come from? It knows that ∃ and ∀ are related...that is useful!
(defvar *relations*
  '(("QUESTION MARK" "EXCLAMATION MARK")
    ("INVERTED " -)
    ("BOLD " -)
    (and or)
    (downwards upwards)			;+++ capture this and following as related
    (rightwards leftwards)
    (above below)
    (vertical horizontal)
    (top bottom)
    (left right)
    (greater-than less-than)
    ("GREATER THAN" "LESS THAN")
    (plus minus)
    (plus times) 
    (black white)
    (circle square) ; diamond
    (diamond square)
    (circled squared)
    ("CIRCLED " -)
    ("WITH DOT " -)
    (small big)
    (small large)
    (small capital)
    ("ERROR-BARRED " -)
    ("INVERSE " -)
    ("CIRCLED " -)
    ("WHITE " -)
    ))

;;; Only gives 1-away chars, eg
; (ucs-char-all-inversions "ERROR-BARRED WHITE CIRCLE")
; > ("ERROR-BARRED BLACK CIRCLE" "ERROR-BARRED WHITE SQUARE" "WHITE CIRCLE")
; need to do cross product

(defun ucs-char-insert-all-inversions (charname)
  (interactive "cCharacter")		;TODO this is wrong, look at M-x insert-char and do what it does
  (mapcar #'ucs-insert-char-by-name (ucs-char-all-inversions charname)))

(defun ucs-insert-char-by-name (charname)
  (ucs-insert (cdr (find charname (ucs-names) :test #'equal :key #'car))))

(defun ucs-char-all-inversions (charname)
  (mapcan #'(lambda (r) (ucs-invert-char charname r)) *relations*))

(defun rel-elt-string (elt)
  (cond ((stringp elt) elt)
	((eq elt '-) "")
	((symbolp elt) (upcase (symbol-name elt)))))

;;; +++ generalize to >2 elts in a relation
;;; +++ generalize to multiple words for a single elt of a relation
(defun ucs-invert-char (charname relation)
  (let ((a (rel-elt-string  (first relation)))
	(b (rel-elt-string  (second relation))))
    (append (ucs-invert-char-1 charname a b)
	    (ucs-invert-char-1 charname b a))))

(defun ucs-invert-char-1 (charname from to)
  (let ((char (ucs-find-char charname from to)))
    (if char (list char) nil)))

(defun ucs-find-char (orig-charname from to)
  (let ((new-charname (string-replace from to orig-charname)))
    (when (and new-charname
	       (find new-charname (ucs-names) :test #'equal :key #'car))
      new-charname)))


(defun ucs-transform (char transform)
  "Char is a ucs char name, transform is a transform, result a list (quite likely empty) of new chars"
  )

(require 'iso-transl)

;;; mt-punctal.el is an alternate way of doing this, but may as well have both
(define-key iso-transl-ctl-x-8-map [right] "→")
(define-key iso-transl-ctl-x-8-map [left] "←")
(define-key iso-transl-ctl-x-8-map [up] "↑")
(define-key iso-transl-ctl-x-8-map [down] "↓")
(define-key iso-transl-ctl-x-8-map [S-right] "⇒")
(define-key iso-transl-ctl-x-8-map [S-left] "⇐")
(define-key iso-transl-ctl-x-8-map [S-up] "⇑")
(define-key iso-transl-ctl-x-8-map [S-down] "⇓")
; ⇸ ↣ ⬎↛ ⇢  etc

(provide 'mt-ucs)
