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

(defun ama-xml-to-json-line (line)
  (let (wlst)
    ;;(message line)
    (when (string-match "=" line)
      (setq wlst (split-string line "=\""))
      (when (>= (length wlst) 2)
        (insert (format "\"%s\" : \"%s, \n" (ama-string-trim (nth 0 wlst)) (nth 1 wlst))))
  )))
;;(ama-xml-to-json-line "name=\"maxDepth\"")

(defun ama-xml-region-to-json (buffer start end)
  (interactive "BCopy to buffer: \nr")
  ;(message (format "buffer=%S, %d, %d" buffer start end))

  (let ( (oldbuf (current-buffer))
         pos1 pos2 name token1 tokens e1)
    (with-temp-buffer
      (save-excursion
        (insert-buffer-substring oldbuf start end))
      (goto-char 1)
      (search-forward "<")
      (setq pos1 (point))
      (search-forward " ")
      (setq pos2 (- (point) 1))
      (setq name (buffer-substring-no-properties pos1 pos2))
      (message "name=%s" name)
      
      (search-forward ">")
      (setq pos3 (point))
      (goto-char pos2)
      (setq e1 t)
      (while (and e1 (< (point) pos3))
        (setq pos1 (point))
        (setq e1 (search-forward "\"" nil t 2))
        ( when e1
          (setq pos2 (point))
          (setq token1 (buffer-substring-no-properties pos1 pos2))
          ;;(message "token1=%s" token1)
          (setq tokens (append tokens (list token1))))
        )

      (with-current-buffer (get-buffer-create buffer)
        (barf-if-buffer-read-only)
        (insert (format "\"%s\" : {\n" name))
        (dolist (token1 tokens)
          (ama-xml-to-json-line token1))
        (insert (format "},\n")))
      )))
(global-set-key (kbd "\C-c\C-t") 'ama-xml-region-to-json)

;;<parameter name="maxDepth" display="Migration Depth" unit="m"  type="double" range="100 100000" default="3000" />



