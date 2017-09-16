(defun ama-buffer-save-list (alst)
  (let (x)
    (goto-char (point-min))
    (dolist (x alst)
      (insert (format "%s" x))
      (newline)
      )
    ))
;;(ama-buffer-save-list (list "33" "44"))

(defun ama-buffer-save-multiple-list (alst)
  (let (x flst ostr)
    (goto-char (point-min))
    (dolist (flst alst)
      (setq ostr "")
      (dolist (x flst)
        (setq ostr (format "%s %s" ostr x)))
      (insert (format "%s " ostr))
      (newline)
      )))
;;(ama-buffer-save-multiple-list (list (list "33" "44")))

(defun ama-buffer-print (buf-name message)
  (let (buf)
    (setq buf (get-buffer-create buf-name))
    (save-current-buffer
      (set-buffer buf)
      (goto-char (point-max))
      (insert message "\n"))
    ))
;;(ama-buffer-print "aaaa.txt" "This is a test")

(defun ama-buffer-clear (buf-name)
  (let (buf)
    (setq buf (get-buffer-create buf-name))
    (save-current-buffer
      (set-buffer buf)
      (erase-buffer))
    ))
;;(ama-buffer-clear "aaaa.txt")

(defun ama-buffer-delete (buf-name)
  (save-current-buffer
    (kill-buffer buf-name)))
;;(ama-buffer-delete "aaaa.txt")

(defun ama-buffer-save (buf-name ofname)
  (let (old-buf)
    (setq old-buf (get-buffer buf-name))
    (save-current-buffer
      (with-temp-buffer
        (insert-buffer-substring old-buf)
        (write-file ofname)
        ))))
;;(ama-buffer-save "aaaa.txt" "tmp01.txt")

(defun ama-buffer-fill-current (ofname)
  (let (old-buffer)
    (setq old-buffer (current-buffer))
    (save-current-buffer
      (set-buffer (get-buffer-create ofname))
      (erase-buffer)
      (save-excursion
        (insert-buffer-substring old-buffer)))))


(defun ama-buffer2lines ()
  (let ((lines nil) ltxt pos2)
    (save-excursion
      (setq pos2 (point-max))
      (goto-char (point-min))
      (while (< (point) pos2)
        (setq ltxt (ama-line-current2text))
        (setq lines (append lines (list ltxt)))
        (forward-line 1)))
    lines))
;;(ama-buffer2lines)

(defun ama-buffer-line-keywords()
  (let (lines line olst)
    (setq lines (ama-buffer2lines))
    (dolist (line lines)
      (setq keyword (ama-line-keywords line))
      (when keyword
        (setq olst (append olst (list keyword)))))
    olst))

(defun ama-buffer-scan-keyword (pat)
  (goto-char (point-min))
  (if (re-search-forward pat nil t)
      t
    nil))
;;(ama-buffer-scan-keyword "ama")

(defun ama-buffer-search (pat)
  (if (re-search-forward pat nil t)
      t
    nil))
;;(ama-buffer-search "ama-xxx")

(defun ama-buffer-keywords-exist (alst)
  (let (k olst)
    (dolist (k alst)
      (when (ama-buffer-scan-keyword k)
        (setq olst (append olst (list k))))
      )
    olst))
;;(ama-buffer-keyword-list (list "ama" "fname" "YYYY"))

(defun ama-buffer-string-replace (sname tname)
  (goto-char (point-min))
  (while (re-search-forward sname nil t)
    (replace-match tname t t))
  )
;;(ama-buffer-string-replace "THIS" "THAT")
;;THIS XXX

(defun ama-buffer-string-multiple-replace (plst)
  (let (sname tname p)
    (dolist (p plst)
      (setq sname (car p))
      (setq tname (car (cdr p)))
      (ama-buffer-string-replace sname tname))))

(defun ama-buffer-build-cfunc-from-proto (spat tpat)
  (goto-char (point-min))
  (while (and (< (point) (point-max))
              (ama-buffer-search spat))
    (ama-buffer-add-one-cfunc spat tpat)
    ))

(defun ama-buffer-remove-control-M ()
  "Remove ^M at end of line in the whole buffer."
  (interactive)
  (save-match-data
    (save-excursion
      (let ((remove-count 0))
        (goto-char (point-min))
        (while (re-search-forward (concat (char-to-string 13) "$") (point-max) t)
          (setq remove-count (+ remove-count 1))
          (replace-match "" nil nil))
        (message (format "%d ^M removed from buffer." remove-count))))))

(defun ama-copy-to-buffer (buffer start end)
  (interactive "BCopy to buffer: \nr")
  (let ((oldbuf (current-buffer)))
    (with-current-buffer (get-buffer-create buffer)
      (barf-if-buffer-read-only)
      (erase-buffer)
      (save-excursion
        (insert-buffer-substring oldbuf start end)))))

(defun ama-insert-buffer (buffer)
  "Insert after point the contents of BUFFER.
     Puts mark after the inserted text.
     BUFFER may be a buffer or a buffer name."
  (interactive "*bInsert buffer: ")
  (or (bufferp buffer)
      (setq buffer (get-buffer buffer)))
  (let (start end newmark)
    (save-excursion
      (save-excursion
        (set-buffer buffer)
        (setq start (point-min) end (point-max)))
      (insert-buffer-substring buffer start end)
      (setq newmark (point)))
    (push-mark newmark)))
;;(global-set-key (kbd "C-c C-p") 'ama-insert-buffer)

(defun ama-test-region (pos1 pos2)
  (interactive "r")
  (message "pos1=%S pos2=%S" pos1 pos2))
;;(global-set-key (kbd "C-c C-t") 'ama-test-region)

(defun ama-what-line ()
  "Print the current line number (in the buffer) of point."
  (interactive)
  (save-restriction
    (widen)
    (save-excursion
      (beginning-of-line)
      (message "Line %d"
               (1+ (count-lines 1 (point)))))))
;;(global-set-key (kbd "C-c C-t") 'ama-what-line)

(defun ama-buffer-search-keyword (pat)
  (if (search-forward pat nil t)
      (point)
    nil))
;;(ama-buffer-search-keyword "ama")

(defun ama-buffer-remove-c++-comment ()
  (let (pos1 pos2)
    ;;(goto-char (point-min))
    (setq pos1 (ama-buffer-search-keyword "/*"))
    (when pos1
      (setq pos1 (- pos1 2)))
    (setq pos2 (ama-buffer-search-keyword "*/"))
    (when (and pos1 pos2)
      (message "%S %S" pos1 pos2)
      (kill-region pos1 pos2)
      )))
;;(ama-buffer-remove-c++-comment)
