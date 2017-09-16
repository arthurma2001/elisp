(defun ama-replace2swapbyte ()
  (interactive)
  (let (line alst alst2 txt)
    (setq line (ama-line-current2text))
    (setq alst (split-string line))
    (when (>= (length alst) 2)
      (setq alst2 (split-string (car (last alst)) ";"))
      ;;(setq txt (format "  h->swapByte(&h->%s);" (car alst2)))
      (setq txt (ama-strings-combines (list "  swapByte(&h->"
                                           (car alst2)
                                           ");") ""))
      (message "txt = %S" txt)
      (ama-line-replace-current txt))
  ))

(defun ama-dummy-test ()
  (let (alst2 txt)
    (setq alst2 (list "tracl"))
    (setq txt (ama-strings-combines (list "  h->swapByte(&h->"
                                         (car alst2)
                                         ");") ""))
    (message "txt = %S" txt)))
;;(ama-dummy-test)

(defun ama-replace2swapbyte-region (pos1 pos2)
  (interactive "r")
  (save-excursion
    (goto-char pos1)
    (while (<= (point) pos2)
      (ama-replace2swapbyte)
      (next-line))
    ))

  unsigned int jobid;	/* job identification number */

(global-set-key (kbd "C-c C-x") 'ama-replace2swapbyte)
(global-set-key (kbd "<f4>") 'kmacro-end-and-call-macro)

