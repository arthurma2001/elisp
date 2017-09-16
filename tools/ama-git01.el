(defun ama-git-clean ()
  (interactive)
  (delete-matching-lines "~$")
  (delete-matching-lines "#$")
  (delete-matching-lines "o$")
  (replace-string "modified:" "git add")
  (replace-string "deleted:" "git rm")
  )

(defun ama-git-process-one-line (line)
  (insert "git add " line "\n")
  )

(defun ama-git-add (pos1 pos2)
  (interactive "r")
  (setq off 0)
  (let (lines line alst alst2 txt)
    (setq lines (ama-region-lines pos1 pos2))
    (dolist (line lines)
      (ama-git-process-one-line line))))
