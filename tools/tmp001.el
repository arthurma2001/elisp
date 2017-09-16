
(defun ama-file-filter (fname pat)
  (string-match pat fname))
;; (ama-file-filter "ddd3rdxxx" "3rd")

(defun ama-listdir(dname pats)
  (let (alst fname olst) 
    (setq alst (directory-files dname))
    (dolist (fname alst)
      (when (ama-file-filter (fname pat))
        (print x))))


(string-match "3rd" "ddd3rdxxx")