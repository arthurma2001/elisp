;;pre-command-hook
;;post-command-hook

(defun ama-pre-command-test()
  (message "ama-pre-command-test() - %S" last-command))

(defun ama-post-command-test()
  (message "ama-post-command-test() - %S" last-command))

(defun ama-command-hook-test()
  (add-hook 'pre-command-hook 'ama-pre-command-test)
  (add-hook 'post-command-hook 'ama-post-command-test))
;(ama-command-hook-test)

