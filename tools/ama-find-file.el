(defun ama-find-file (dname fname)
  (interactive "D\nsfilename:")
  (let (out-lst buf)
    (ama-dir-traverse dname
                      #'(lambda (x)   (when (string-match fname (file-name-nondirectory x))
                                        (setq out-lst (append out-lst (list x))))))
    (when out-lst
      (setq buf (get-buffer-create "*ama-find-file*"))
      (save-excursion
        (with-current-buffer buf
          (erase-buffer)
          (dolist (x out-lst)
            (insert x "\n"))
          )
    ))))


