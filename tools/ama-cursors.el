(defun ama-cursor-move-next-non-empty-line-P ()
  (interactive)
  (ama-line-skip-empty))
(global-set-key (kbd "M-n") 'ama-cursor-move-next-non-empty-line-P)