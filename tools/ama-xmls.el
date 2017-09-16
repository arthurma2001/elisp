(defun ama-tab-format (ntab elem)
  (dotimes (i ntab)
    (insert "  ") )
  (format "%S" elem))
;;(ama-tab-format 4 "XXX")

(defun print-elements-of-list (list ntab)
  "Print each element of LIST on a line of its own."
  (let (elem)
    (while list
      (if (listp list)
          (setq elem (car list))
        (progn 
          (setq elem list)
          (setq list nil)))
        
      (if (listp elem)
          (print-elements-of-list elem (1+ ntab))
        (insert (ama-tab-format ntab elem)  "\n"))
      (when list
        (setq list (cdr list))))))
;;(print-elements-of-list '(ColorMap ((name . Accent) (size . 32)))) 

(defun ama-alist-dump (alst)
  (print-elements-of-list alst 0)
  (insert (format "%S" alst) "\n"))

(defun ama-xml-parse-region (pos1 pos2 out-buf-name)
  (interactive "r\nBoutput:")
  (let (out buf)
    (setq out (libxml-parse-xml-region pos1 pos2))
    (setq buf (get-buffer-create out-buf-name))
    (save-excursion
      (with-current-buffer buf
        (erase-buffer)
        (ama-alist-dump out)
        ))
    ))

