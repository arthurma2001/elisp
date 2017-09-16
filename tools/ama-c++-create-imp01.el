(defun ama-replace-current-buffer (sname tname)
  (goto-char (point-min))
  ;;(replace-string sname tname)                           
  (while (re-search-forward sname nil t)
    (replace-match tname t)))

(defun make-c++-imp (temp-file name)
  (let (txt)
    (with-temp-buffer
      (insert-file temp-file)
      (ama-replace-current-buffer "XtempClass" name)
      (setq txt (buffer-substring-no-properties
                 (point-min) (point-max))) )
    txt))

(defun ama-c++-create-imp ()
  (interactive)
  (let (temp-fname name txt)
    (setq temp-fname "/home/ama/emacs/myconfig/tools/c++-imp-template01.txt")
    (setq name (car (split-string (buffer-name) "\\.")))
    (setq txt (make-c++-imp temp-fname name))
    (insert-string txt)))

