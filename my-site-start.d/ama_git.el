(defun ama-git-clean ()
  (interactive)
  (delete-matching-lines "~$")
  (delete-matching-lines "#$")
  (delete-matching-lines "o$")
  (replace-string "#	修改： " "git add")
  (replace-string "#	" "git add ")
  )

