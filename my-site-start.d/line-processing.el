;;;; Usage
;;control funcs
;;   ama-set-each-line-func #'func
;;   ama-set-sum-line-func #'bfunc
;;   ama-set-sum-line2tokens-func #'bfunc
;;defined funcs
;;   line-sum-first-token
;;   line-first-token
;;nth item
;;(setq global-ama-line-nth-item 0)
;;   

(defvar global-ama-saved-lines "" "Global saved lines")
(defun ama-save-lines (pos1 pos2)
  (interactive "rRegion:")
  (message "pos1=%S,pos2=%S" pos1 pos2)
  (let (line lines vars)
    (goto-char pos1)
    (while (< (point) pos2)
      (setq line (ama-get-current-line))
      (setq lines (append lines (list line)))
      (next-line 1))
    (setq global-ama-saved-lines lines)))
(global-set-key (kbd "C-c s") 'ama-save-lines)

(defvar global-ama-each-line-func "" "Global each line func")
(defun ama-set-each-line-func (bfunc)
  (setq global-ama-each-line-func bfunc))

(defvar global-ama-sum-line-func "" "Global sum line func")
(defun ama-set-sum-line-func (bfunc)
  (setq global-ama-sum-line-func bfunc))

(defvar global-ama-line2tokens-func "" "Global sum line2tokens func")
(defun ama-set-sum-line2tokens-func (bfunc)
  (setq global-ama-line2tokens-func bfunc))

(defun default-line2tokens-func (vars)
  (let (var)
    (dolist (var vars)
      (insert var " "))))
(setq global-ama-line2tokens-func #'default-line2tokens-func)    
  
(defun process-each-lines (lines bfunc)
  (let (line)
    (message "bfunc = %S" bfunc)
    (dolist (line lines)
      (apply bfunc (list line)))))

(defun ama-process-each-lines ()
  (interactive)
  (process-each-lines global-ama-saved-lines
                      global-ama-each-line-func))
(global-set-key (kbd "C-c a") 'ama-process-each-lines)

(defun process-sum-lines (lines bfunc sum)
  (message "process-sum-lines () - %S" lines)
  (let (line vars olst)
    (dolist (line lines)
      (setq vars (apply bfunc (list line)))
      (message "* vars = %S" vars)
      (setq olst (append olst vars)))
    (apply sum (list olst))))

(defun ama-process-sum-lines ()
  (interactive)
  (process-sum-lines global-ama-saved-lines
                     global-ama-sum-line-func
                     global-ama-line2tokens-func))
(global-set-key (kbd "C-c b") 'ama-process-sum-lines)


;;; Support funcs
(defvar global-ama-line-nth-item "" "Global saved lines")
(setq global-ama-line-nth-item 0)

(defmacro macro-line-nth-token (line nth)
  `(let (vars kword n i)
     (setq vars (split-string ,line))
     (setq i ,nth)
     (setq n (length vars))
     (when (and vars (< i n))
       (setq kword (nth i vars))
       (insert "  " kword "\n"))))

(defun line-nth-token (line)
  (macro-line-nth-token line global-ama-line-nth-item))
(ama-set-each-line-func #'line-nth-token)

(defmacro macro-line-sum-nth-token (line nth)
  `(let (vars (kword nil) n i)
     (setq vars (split-string ,line))
     (setq i ,nth)
     (setq n (length vars))
     (when (and vars (< i n))
       (setq kword (nth i vars)))
     (if kword
         (list kword)
       nil)))

(defun line-sum-nth-token (line)
  (macro-line-sum-nth-token line global-ama-line-nth-item))
(ama-set-sum-line-func #'line-sum-nth-token)

(defun ama-set-line-nth-item (n)
  (interactive "nNum:")
  ;;(message "n = %S" n))
  (setq global-ama-line-nth-item n))
(global-set-key (kbd "C-c n") 'ama-set-line-nth-item)

(defun line-each-last-word (line)
  (let (alst1 alst2 alst3 kword)
    (setq alst1 (split-string line))
    (setq alst2 (last alst1))
    (setq alst3 (split-string (car alst2) "/"))
    (setq kword (car (last alst3)))
    (insert "  " kword "\n")))

;;(line-each-last-word "+- diff -urN old/ProcDBUnitTest.C new/ProcDBUnitTest.C")
;;(ama-set-each-line-func #'line-each-last-word)

(defun line-sum-last-word (line)
  (let (alst1 alst2 alst3 kword)
    (setq alst1 (split-string line))
    (setq alst2 (last alst1))
    (setq alst3 (split-string (car alst2) "/"))
    (setq kword (car (last alst3)))
    (list kword)))

;;(line-sum-last-word "+- diff -urN old/ProcDBUnitTest.C new/ProcDBUnitTest.C")
;;(ama-set-sum-line-func #'line-sum-last-word)

;; shrink line to 74 char
(defun line-fixed-shrink (line)
  (message "* AAAA - line-fixed-shrink() - %S" line)
  (let (aline)
    (setq aline (substring line 0 74))
    (insert aline "\n")))
;;(ama-set-each-line-func #'line-fixed-shrink)


(defun ama-c++-refine-style (pos1 pos2)
  (interactive "rRegion:")
  (let ()
    (goto-char pos1)
    (while (< (point) pos2)
      (when (re-search-forward "{$" nil t 1)
        (setq kill-whole-line t)
        (goto-char (line-beginning-position))
        (kill-line)
        (next-line -1)
        (goto-char (line-end-position))
        (insert " {")))))
