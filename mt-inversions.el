;;; Apologies to ɯı⋊ ʇʇoɔS
;;; TODO Integrate with mt-ucs, which has conceptual inversions!

;;; Maps chars to their upside-down equivalent
;;; Source is in dia/src/uni-iun.lisp, elisp doesn't have #\ syntax so easier to maintain there.
(setq *inversion-table*
      '((33 . 161) (34 . 8222) (38 . 8523) (39 . 44) (40 . 41) (46 . 729) (51 . 400) (52 . 5421) (54 . 57) (55 . 163) (59 . 1563) (60 . 62) (63 . 191) (65 . 8704) (66 . 8712) (67 . 8835) (68 . 9686) (69 . 398) (70 . 8498) (71 . 8513) (74 . 383) (75 . 8906) (76 . 8514) (77 . 87) (80 . 1280) (81 . 908) (82 . 633) (84 . 8869) (85 . 8745) (86 . 581) (89 . 8516) (91 . 93) (95 . 8254) (97 . 592) (98 . 113) (99 . 596) (100 . 112) (101 . 601) (102 . 607) (103 . 595) (104 . 613) (105 . 305) (106 . 638) (107 . 670) (109 . 623) (110 . 117) (114 . 633) (116 . 647) (118 . 652) (119 . 653) (121 . 654) (123 . 125) (8756 . 8757) (44 . 39))
      )

(defun flip-char (c)
  (or (cdr (assoc c *inversion-table*))
      (car (rassoc c *inversion-table*))
      c))

(defun flip (s)
  (mapcar 'flip-car
	  (string-to-list s)))

(defun flip-string (s)
  (concat (reverse (mapcar 'flip-char
			   (string-to-list s)))))

(defun flip-region (start end)
  "Replace region with an flipped copy"
  (interactive "r")
  (let ((s (buffer-substring-no-properties start end)))
    (delete-region start end)
    (insert (flip-string s))))

(defun reverse-string (s)
  (concat (reverse (string-to-list s))))

;; +++ there seems to be an existing fn with this name!
(defun reverse-region (start end)
  (interactive "r")
  (let ((s (buffer-substring-no-properties start end)))
    (delete-region start end)
    (insert (reverse-string s))))

(provide 'mt-inversions)
