(defun ama-paste ()
  (interactive)
  (insert (car kill-ring-yank-pointer)))

(defun ama-region-lines (pos1 pos2)
  ;;(message "%d %d" pos1 pos2)
  (let ((lines nil) ltxt)
    (save-excursion
      (goto-char pos1)
      (while (< (point) pos2)
        (setq ltxt (ama-line-current2text))
        (setq lines (append lines (list ltxt)))
        (forward-line 1)))
    lines))


(setq ama-region-add-line-lineno-count 0)
(defun ama-region-add-line-number-process-one-line (line)
  (let (txt)
    (message "line = %S" line)
    (setq txt (format "  %d %s" ama-region-add-line-lineno-count line))
    (setq ama-region-add-line-lineno-count (1+ ama-region-add-line-lineno-count))
    (insert "\n")
    (insert txt)
    ))

(defun ama-region-add-line-number-P (pos1 pos2)
  (interactive "r")
  (setq ama-region-add-line-lineno-count 0)
  (let (lines line alst alst2 txt)
    (setq lines (ama-region-lines pos1 pos2))
    (dolist (line lines)
      (ama-region-add-line-number-process-one-line line))))

;;(global-set-key (kbd "C-c C-x") 'ama-region-add-line-number-P)

(defun ama-region-fields-arrange (pos1 pos2 buf-name)
  (interactive "r\nBoutput:")
  (let (olst buffer)
    (setq olst (ama-line-fields-arrange pos1 pos2 ","
                                        (list 0 -4 -2)))
    ;;(#1 XLine YLine)
    (setq buffer (get-buffer-create buf-name))
    (save-current-buffer
      (set-buffer buffer)
      (erase-buffer)
      (save-excursion
        (dolist (o olst)
          ;;(message "olst = %S\n" o)
          (ama-dump-list2buffer o ",")
        )))))

(defun ama-cfunc-arraytext2c++-P (pos1 pos2 buf-name array-name)
  (interactive "r\nBoutput:\nsName:")
  (let (lines buffer line)
    (setq lines (ama-region-lines pos1 pos2))
    (setq buffer (get-buffer-create buf-name))
    (save-current-buffer
      (set-buffer buffer)
      (erase-buffer)
      (save-excursion
        (insert array-name "[] = {\n")
        (dolist (line lines)
          (ama-cfunc-arraytext2c++ line))
        (backward-delete-char 2)
        (insert "\n};\n")
        ))))

(defun ama-do-region-line-nth-item (pos1 pos2 n ofname)
  (let (lines line x1 olst buf)
    (setq lines (ama-region-lines pos1 pos2))
    (dolist (line lines)
      (setq x1 (ama-line-nth-item line n))
      (when x1
        (setq olst (append olst (list x1))))
      )
    (setq buf (get-buffer-create ofname))
    (save-current-buffer
      (set-buffer buf)
      (goto-char (point-max))
      (ama-buffer-save-list olst)
    )))

(defun ama-region-line-nth-item (pos1 pos2 n ofname)
  (interactive "r\nnNth:\nBOutput:")
  (ama-do-region-line-nth-item pos1 pos2 n ofname))

(defun ama-region-number-diff (pos1 pos2 ofname)
  (interactive "r\nBOutput:")
  ;;(message "pos1=%S pos2=%S ofname=%S" pos1 pos2 ofname)
  (let (lines line x1 olst buf N i)
    (setq lines (ama-region-lines pos1 pos2))
    (dolist (line lines)
      (setq x1 (ama-number-diff line))
      (setq olst (append olst (list x1))))
    
    (setq N (length olst))
    (setq buf (get-buffer-create ofname))
    (save-current-buffer
      (set-buffer buf)
      (goto-char (point-max))
      (dotimes (i N)
        (insert (format "%s -->  %f" (nth i lines) (nth i olst)))
        (newline)
        )
      )))
;;33.2 21.4
;;43.5 82

