(defvar global-ama-saved-lines "" "Global saved lines")

(defun ama-create-c++-imp (cname)
  "Create c++ header with implement"
  (interactive "sInput Class Name:")
  (let ((old-buffer (current-buffer))
        (txt nil) bdir temp-fname)
    (setq bdir (getenv "AmaElispBDir"))
    (setq temp-fname (concat bdir "/data/c++-imp-header.txt"))
    (with-temp-buffer
      (insert-file temp-fname)
      (replace-regexp "RoutineGUICanvas" cname)
      (setq txt (buffer-substring-no-properties (point-min) (point-max))))
    (insert txt)))
(global-set-key (kbd "C-c h") 'ama-create-c++-imp)

(defun ama-create-c++-imp-class (cname)
  (interactive "sInput Class Name:")
  (let ((old-buffer (current-buffer))
        (txt nil) bdir temp-fname)
    (setq bdir (getenv "AmaElispBDir"))
    (setq temp-fname (concat bdir "/data/c++-imp-class.txt"))
    (with-temp-buffer
      (insert-file temp-fname)
      (replace-regexp "RoutineGUICanvas" cname)
      (setq txt (buffer-substring-no-properties (point-min) (point-max))))
    (insert txt)))
(global-set-key (kbd "C-c b") 'ama-create-c++-imp-class)


(defun ama-get-line-text ()
  (let (pos1 pos2 txt)
    (setq pos1 (line-beginning-position))
    (setq pos2 (line-end-position))
    (setq txt (buffer-substring-no-properties pos1 pos2))
    txt))

(defun ama-dump-lines (lines)
    (dolist (line lines)
      (message "%S" line)))

(defun ama-region2lines (pos1 pos2)
  ;;(interactive "r")
  (message "%d %d" pos1 pos2)
  (let ((lines nil) ltxt)
    (save-excursion
      (goto-char pos1)
      (while (< (point) pos2)
        (setq ltxt (ama-get-line-text))
        (setq lines (append lines (list ltxt)))
        (forward-line 1)))
    ;;(ama-dump-lines lines)
    lines))

(setq *ama-c++-funcs-lines* nil)
(defun ama-c++-funcs-save (pos1 pos2)
  (interactive "r")
  (setq *ama-c++-funcs-lines* (ama-region2lines pos1 pos2)))
(global-set-key (kbd "C-c c") 'ama-c++-funcs-save)

(defun ama-remove-white-char ()
  ;;(interactive)
  (let (pos1 N)
    (setq pos1 (point))
    (re-search-forward "[[:alnum:]]" nil t 1)
    (goto-char (1- (point)))
    (setq N (- (point) pos1))
    ;;(message "N = %d" N)
    (goto-char pos1)
    (delete-char N)))

(defun ama-make-c++-lfunc (cname line)
  (let ((txt nil) pos1 pos2)
    (with-temp-buffer
      (insert line)
      (goto-char (point-min))
      (ama-remove-white-char)
      (forward-word 1)
      (setq pos1 (point))
      (re-search-forward "[[:alnum:]]" nil t 1)
      (goto-char (1- (point)))
      (setq pos2 (point))
      (goto-char pos1)
      (delete-char (- pos2 pos1))
      (insert (format " %s::" cname))
      (replace-regexp ";" "")
      (goto-char (point-max))
      (insert "\n{")
      (insert "\n}")
      (insert "\n")
      (setq txt (buffer-substring-no-properties (point-min) (point-max))))
    txt))
;;(ama-make-c++-lfunc "SavingAbbrev" "void test123 (int a, int b);")

(defun ama-c++-funcs-create (cname)
  (interactive "sInput Class Name:")
  (let (txt)
    (dolist (line *ama-c++-funcs-lines*)
      (setq txt (ama-make-c++-lfunc cname line))
      (insert txt)
      (insert "\n")
    )))
(global-set-key (kbd "C-c p") 'ama-c++-funcs-create)

(defun my-tr (str from to)
  (if (= (length to) 0)                 ; 空字符串
      (progn
        (setq from (append from nil))
        (concat
         (delq nil
               (mapcar (lambda (c)
                         (if (member c from)
                             nil c))
                       (append str nil)))))
    (let (table newstr pair)
      ;; 构建转换表
      (dotimes (i (length from))
        (push (cons (aref from i) (aref to i)) table))
      (dotimes (i (length str))
        (push
         (if (setq pair (assoc (aref str i) table))
             (cdr pair)
           (aref str i))
         newstr))
      (concat (nreverse newstr) nil))))
;;(my-tr "abc" "abc" "EFG")


(defconst *ama-vim-copy-paste-str nil)
(defun ama-lines-text (pos nline)
  (let (pos1 pos2 text)
    (save-excursion
      ;;(print (equal (read-char) ?a))
      (setq pos1 (line-beginning-position))
      (next-line (- nline 1))
      (setq pos2 (line-end-position))
      (setq *ama-vim-copy-paste-str
            (buffer-substring-no-properties pos1 pos2)))))

(defun ama-vim-paste-lines ()
  (interactive)
  (goto-char (line-beginning-position))
  (insert *ama-vim-copy-paste-str)
  (insert "\n"))

(defun ama-vim-copy-lines ()
  (interactive)
  (let ((myloop t) (nline 0) rchar)
    (while myloop
      (setq rchar (read-char))
      (if (and (>= rchar ?0) (<= rchar ?9))
          (setq nline (+ (* nline 10) (- rchar ?0)))
        (setq myloop nil)))
    (setq unread-command-events (list last-input-event))
    (print nline)
    (when (equal nline 0)
      (setq nline 1))
    (setq *ama-vim-copy-paste-str (ama-lines-text (point) nline))))

;;(global-set-key (kbd "C-c y") 'ama-vim-copy-lines)
;;(global-set-key (kbd "C-c p") 'ama-vim-paste-lines)


(defun next-user-buffer ()
  "Switch to the next user buffer in cyclic order.\n
User buffers are those not starting with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (next-buffer) )))

(defun previous-user-buffer ()
  "Switch to the previous user buffer in cyclic order.\n
User buffers are those not starting with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (previous-buffer) )))

(defun select-current-word ()
"Select the word under cursor.
“word” here is considered any alphanumeric sequence with “_” or “-”."
 (interactive)
 (let (pt)
   (skip-chars-backward "-_A-Za-z0-9")
   (setq pt (point))
   (skip-chars-forward "-_A-Za-z0-9")
   (set-mark pt)
 ))

(defun delete-current-word ()
"Delete the word under cursor.
  “word” here is considered any alphanumeric sequence with “_” or “-”."
 (interactive)
 (let (pt)
   (skip-chars-backward "-_A-Za-z0-9")
   (setq pt (point))
   (skip-chars-forward "-_A-Za-z0-9")
   (delete-region pt (point))
 ))

(defun select-current-line ()
  "Select the current line"
  (interactive)
  (end-of-line) ; move to end of line
  (set-mark (line-beginning-position)))

(defun to-unix-eol (fpath)
  "Change file's line ending to unix convention."
  (let (mybuffer)
    (setq mybuffer (find-file fpath))

    (set-buffer-file-coding-system 'unix) ; or 'mac or 'dos
;; do this or that

    (save-buffer)
    (kill-buffer mybuffer)
   )
)

(defadvice kill-ring-save (before slick-copy activate compile) "When called
  interactively with no active region, copy a single line instead."
  (interactive (if mark-active (list (region-beginning) (region-end)) (message
  "Copied line") (list (line-beginning-position) (line-beginning-position
  2)))))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (list (line-beginning-position)
        (line-beginning-position 2)))))

(global-set-key (kbd "C-<prior>") 'previous-user-buffer) ; Ctrl+PageDown
(global-set-key (kbd "C-<next>") 'next-user-buffer) ; Ctrl+PageUp
(global-set-key (kbd "C-c C-l") 'select-current-line)
(global-set-key (kbd "C-c C-w") 'select-current-word)

;;(defun ama-empty-str (s)
;;  (not (string-match "[A-Za-z]+" s)))
(defun ama-empty-str (s)
  (not (string-match "[[:alnum:]]" s)))

(defun ama-empty-line ()
  ;;(interactive)
  (let (b e s r)
    (setq b (line-beginning-position))
    (setq e (line-end-position))
    (setq s (buffer-substring-no-properties b e))
    (setq r (ama-empty-str s))
    ;;;(message "%d,%d,%S %S" b e s r)
    r))

(defun ama-intent-cpp ()
  (message "ama-intent-cpp")
  (interactive)
  (when (re-search-forward "^[ \t]+{" nil t)
    (goto-char (1- (point)))
    (delete-char 1)
    (if (ama-empty-line)
        (progn (delete-region (line-beginning-position) (line-end-position))
               (kill-line)))
    (forward-line -1)
    (goto-char (line-end-position))
    (insert-char ?  1)
    (insert-char ?{ 1)))
(global-set-key (kbd "C-c C-j") 'ama-intent-cpp)

(defun ama-other-window-backward (&optional n)
  "move to previous window"
  (interactive "p")
  (if n
      (other-window (- n))
    (other-window -1)))
(global-set-key (kbd "C-x C-o") 'ama-other-window-backward)
;;(describe-function 'ama-other-window-backward)
(move-to-window-line -1)

(defun ama-read-only-if-symlink ()
  (if (file-symlink-p buffer-file-name)
      (progn
        (setq buffer-read-only t)
        (message "File is a symlink"))))
(add-hook 'find-file-hooks 'ama-read-only-if-symlink)

(defun ama-after-init-hook ()
  (print "ama-after-init-hook ()"))
(add-hook 'after-init-hook 'ama-after-init-hook)

(defun ama-after-load-hook (fname)
  (print (format "ama-after-load-hook (%S)" fname)))
(add-hook 'after-load-functions 'ama-after-load-hook)

(defun ama-make-c++-cases (alst)
  (insert "\n")
  (dolist (a alst)
    (insert "case " a ":\n")))

(defun ama-print-list (alst)
  (dolist (a alst)
    (print a)))
                
(defun ama-split-region-to-c++-cases (rpos1 rpos2)
  (interactive "r")
  (let (astr alst)
    (setq astr (buffer-substring-no-properties rpos1 rpos2))
    (setq alst (split-string astr ","))
    ;;(ama-print-list alst)
    (ama-make-c++-cases alst)))

(defun ama-load-file (mpath)
  ;;;(interactive)
  (let (bname)
    (setq bname (file-name-nondirectory mpath))
    (setq mybuf (get-buffer-create bname))
    (with-current-buffer mybuf
      (erase-buffer)
      (insert-file-contents  mpath))))
;;;(find-file "/tmp/tmp.txt")
;;;(ama-load-file "/tmp/tmp.txt")

(defun ama-load-region-file (rpos1 rpos2)
  (interactive "r")
  (let (filename)
    (setq filename (buffer-substring-no-properties rpos1 rpos2))
    (ama-load-file filename)))
;;;(global-set-key (kbd "C-c C-r") 'ama-load-region-file)

(defun number-to-bin-string (number)
  (require 'calculator)
  (let ((calculator-output-radix 'bin)
        (calculator-radix-grouping-mode nil))
    (calculator-number-to-string number)))
;;;(number-to-bin-string 256)              ; => "100000000"

(defun string-emptyp (s)
  (not (string< "" s)))
;;;(string-emptyp nil)

(defun ama-goto-line-first-char ()
  ;;(interactive)
  (goto-char (line-beginning-position))
  (re-search-forward "[[:space:]]+" nil t 1))

(defun ama-goto-line-last-char ()
  ;;(interactive)
  (goto-char (line-end-position))
  (re-search-backward "[[:alnum:]]" nil t 1)
  (goto-char (1+ (point))))

(defun ama-quote-current-line ()
  ;;(interactive)
  (ama-goto-line-first-char)
  (insert "\"")
  (ama-goto-line-last-char)
  (insert "\""))

(defun ama-quote-region-lines (rpos1 rpos2)
  (interactive "r")
  (let* ((pos1 (min rpos1 rpos2))
         (pos2 (max rpos1 rpos2))
         (pos pos1))
    (goto-char pos)
    (while (< pos pos2)
      (ama-quote-current-line)
      (forward-line 1)
      ;;;(message "%d" pos)
      (setq pos (point)))))

(defun ama-match-keyword (str wlst)
  (let ((cnt 0))
    (dolist (s wlst)
      (if (string= str s)
          (setq cnt (1+ cnt))))
    (if (equal cnt 0)
        nil
      t)))

(defun ama-combine-strings (slst sep)
  (let ((ostr "")
        (i 0)
        (n (length slst)))
    (dolist (s slst ostr)
      (if (< i (- n 1))
          (setq ostr (concat ostr s sep))
        (setq ostr (concat ostr s)))
      (setq i (1+ i)))
    ostr))

(defun ama-match-keyword (str wlst)
  (let ((cnt 0))
    (dolist (s wlst)
      (if (string= str s)
          (setq cnt (1+ cnt))))
    (if (equal cnt 0)
        nil
      t)))

(defun ama-current-line-text ()
  (let* ((rpos1 (line-beginning-position))
         (rpos2 (line-end-position))
         qstr)
    (setq qstr (buffer-substring-no-properties rpos1 rpos2))
    qstr))
;;;(ama-current-line-text)
        
(defun ama--insert-str-tolist (istr strs klst)
  (let ((olst nil) (inserted nil))
    (dolist (s strs)
      (when (and (not inserted) (not (ama-match-keyword s klst)))
        (setq olst (cons istr olst))
        (setq inserted t))
      (print olst)
      (setq olst (cons s olst)))
    (reverse olst)))

(setq ama-c++-keywords-list (list "static" "int" "void"))
(defun ama-c++-insert-classname (ltext class)
  (let* (strs olst)
    (setq strs (split-string ltext))
    (setq olst (ama--insert-str-tolist class strs ama-c++-keywords-list))
    (print "OOOO:")
    (ama-combine-strings olst " ")))
;;;(ama-c++-insert-classname "static int A ();" "BufImp::")

(defun ama-c++-insert-classname-region (buffer rpos1 rpos2)
  (interactive
   (list (read-buffer "Append to buffer: " (other-buffer
                                            (current-buffer) t))
         (region-beginning) (region-end)))
  (let* ((oldbuf (current-buffer))
         (olst nil)
         (append-to (get-buffer-create buffer)))
    (save-excursion
      (let* ((pos1 (min rpos1 rpos2))
             (pos2 (max rpos1 rpos2))
             (pos pos1) point)
        (goto-char pos)
        (while (< pos pos2)
          (setq olst (cons (ama-c++-insert-classname
                            (ama-current-line-text) "myImp::") olst)))
        (forward-line 1)
        (setq pos (point))))
    (print "AAAA:")
    (print olst)))

;;      ;;;(set-buffer append-to)
;;    (setq point (point))
;;    (barf-if-buffer-read-only)
;;    (with-current-buffer append-to
;;      (dolist (s olst)
;;        (insert s "\n")))))
;;
;;    void    setShots(ShotRec* shots);
;;    void    unloadShots();
;;    void    setReceivers(ShotRec* recr);
;;    void    unloadReceivers();

(defun insert-p-tag()
  (interactive)
  (insert "<p></p>")
  (backward-char 4))

(defun select-current-line ()
  (interactive)
  (end-of-line)
  (set-mark (line-beginning-position)))

(defun ama-process-empty-c++-bracket ()
  (interactive)
  (let* ((restr "[[:blank:]]*{[[:blank:]]*"))
    (while (search-forward-regexp restr)
      (goto-char (line-beginning-position))
      (kill-line)
      (kill-line)
      (previous-line 1)
      (goto-char (line-end-position))
      (insert " {")
      )))

(defun ama-current-line-remove-nth-word (n)
  (goto-char (line-beginning-position))
  (forward-word n)
  (kill-word 1))

(defun ama-region-remove-nth-word (n)
  (let (pos1 pos2)
    (setq pos1 (region-beginning))
    (setq pos2 (region-end))
    (save-excursion
      (goto-char (1+ pos1))
      (while (< (point) pos2)
        (ama-current-line-remove-nth-word n)
        (next-line 1)))))

(defun ama-region-remove-column (n)
  (interactive "p")
  (message "n = %S" n)
  (ama-region-remove-nth-word (- n 1)))

(global-set-key (kbd "C-c d") 'ama-region-remove-column)

(defun ama-replace-current-buffer (sname tname)
  (goto-char (point-min))
  ;;(replace-string sname tname)                           
  (while (re-search-forward sname nil t)
    (replace-match tname)))

(defun make-c++-header (temp-file name)
  (let (txt)
    (with-temp-buffer
      (insert-file temp-file)
      (ama-replace-current-buffer "XtempClass" name)
      (setq txt (buffer-substring-no-properties
                 (point-min) (point-max))) )
    txt))

(defun ama-c++-create-header ()
  (interactive)
  (let (name txt bdir temp-fname)
    (setq bdir (getenv "AmaElispBDir"))
    (setq temp-fname (concat bdir "/data/c++-header-template.txt"))
    (setq name (car (split-string (buffer-name) "\\.")))
    (setq txt (make-c++-header temp-fname name))
    (insert-string txt)))

(defun ama-c++-test-header ()
  (interactive)
  (let (name txt bdir temp-fname)
    (setq bdir (getenv "AmaElispBDir"))
    (setq temp-fname (concat bdir "/data/gtest-template-header01.txt"))
    (setq name (car (split-string (buffer-name) "\\.")))
    (setq txt (make-c++-header temp-fname name))
    (insert-string txt)))

(defun ama-split-query (aline)
  (message "line = %S" aline)
  (let (q n v alst line pos1 pos2)
    (with-temp-buffer
      (insert aline)
      (setq pos1 (line-beginning-position))
      (setq pos2 (line-end-position) )
      (replace-regexp "[\]\[\\\.\";]" " " nil pos1 pos2)
      (setq line (buffer-substring-no-properties pos1 pos2))
      (setq alst (split-string line))
      (setq q (nth 0 alst))
      (setq n (nth 2 alst))
      (setq v (nth 4 alst))
      (list q n v)
  )))

;;BIND_MYSQL_NAME_VALUE(query, name, val)
(defun ama-replace-query (aline is-string)
  (let (alst)
    (setq alst (ama-split-query aline))
    ;;(message "alst = %S" alst)
    (goto-char (line-beginning-position))
    ;;(end-of-line)
    (kill-line)
    (if is-string
        (insert "BIND_MYSQL_NAME_SVALUE("  (nth 0 alst)
                ",\"" (nth 1 alst) "\","
                (nth 2 alst) ");")
      (insert "BIND_MYSQL_NAME_VALUE("  (nth 0 alst)
              ",\"" (nth 1 alst) "\","
              (nth 2 alst) ");")
      )))

(defun ama-mysql-query-replace-string ()
  (interactive)
  (let (name txt pos1 pos2)
    (setq pos1 (line-beginning-position))
    (setq pos2 (line-end-position) )
    (setq line (buffer-substring-no-properties pos1 pos2))
    (ama-replace-query line t)))

(defun ama-mysql-query-replace-val ()
  (interactive)
  (let (name txt pos1 pos2)
    (setq pos1 (line-beginning-position))
    (setq pos2 (line-end-position) )
    (setq line (buffer-substring-no-properties pos1 pos2))
    (ama-replace-query line nil)))

;;(ama-replace-query "query.def[\"name\"] = name;" )
(global-set-key (kbd "C-c e") 'ama-mysql-query-replace-string)
(global-set-key (kbd "C-c f") 'ama-mysql-query-replace-val)

(defun ama-replace-current-line (newstr)
  (goto-char (line-beginning-position))
  (kill-line)
  (insert newstr))

(defun ama-replace-dbstore ()
  (interactive)
  (ama-replace-current-line "STORE_MYSQL_QUERY(query, res);"))

(global-set-key (kbd "C-c g") 'ama-replace-dbstore)

(defun ama-get-current-line ()
  (let (pos1 pos2 txt)
    (setq pos1 (line-beginning-position))
    (setq pos2 (line-end-position))
    (setq txt (buffer-substring-no-properties pos1 pos2))
    txt))
;;(ama-get-current-line) ;;;

(defun line-split-c++-variable (line)
  (let (alst1 alst2 alst3 alst4 i olst)
    (setq alst1 (split-string line ";")) ;; comment
    (setq alst2( car alst1))
    (setq alst3 (split-string alst2 ","))
    ;;(message "alst3 = %S" alst3)
    (setq olst (last (split-string (car alst3))))
    ;;(message "olst = %S" olst)
    (setq alst4 (cdr alst3))
    (when alst4
      (dolist (var alst4)
        (setq olst (append olst (list var)))))
    ;;(message "olst = %S" olst)
    olst))


(defun lines-split-c++-variable (lines)
  (let (line vars olst)
    (dolist (line lines)
      (setq vars (line-split-c++-variable line))
      (setq olst (append olst vars)))
    olst))

(defun process-lines-split-c++-variable (lines pfunc)
  (let (line vars olst)
    (dolist (line lines)
      (setq vars (line-split-c++-variable line))
      (setq olst (append olst vars)))
    (dolist (var olst)
      (apply pfunc (list var)))))

(defun ama-process-region-split-c++-variable (pos1 pos2 pfunc)
  (let (line lines)
    (goto-char pos1)
    (while (< (point) pos2)
      (setq line (ama-get-current-line))
      (setq lines (append lines (list line)))
      (next-line 1))
    (process-lines-split-c++-variable lines pfunc)))

(defun ama-c++-copy-class (pos1 pos2)
  (interactive "rRegion:")
  (message "pos1=%S,pos2=%S" pos1 pos2)
  (ama-process-region-split-c++-variable pos1 pos2 
       #'(lambda(x) (insert "  " x " = rhs." x ";\n"))))

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

(defun ama-saved-c++-copy-class ()
  (interactive)
  (process-lines-split-c++-variable 
       global-ama-saved-lines
       #'(lambda(x) (insert "  " x " = rhs." x ";\n"))))
(global-set-key (kbd "C-c h") 'ama-saved-c++-copy-class)

(defun ama-saved-c++-dump-class ()
  (interactive)
  (process-lines-split-c++-variable 
       global-ama-saved-lines
       #'(lambda(x) (insert "  cout << " "\"" x " = \" << " x ";\n"))))
(global-set-key (kbd "C-c i") 'ama-saved-c++-dump-class)

(defun make-c++-diff (x)
  (insert "  if (" x " != rhs." x ")\n")
  (insert "    cout << " "\"" x ": \" << " x " << \", \" << rhs." x ";\n"))

(defun ama-saved-c++-diff-class ()
  (interactive)
  (process-lines-split-c++-variable 
       global-ama-saved-lines
       #'(lambda(x) (make-c++-diff x))))
(global-set-key (kbd "C-c j") 'ama-saved-c++-diff-class)

(defun make-c++-include(line)
  (let (alst)
    ;;(setq line "| data_set                   - ProcDBDataSet")
    (setq alst (split-string line))
    (message "XXX = %S" (car (last alst)))
    ;(insert "\n")
    (insert "#include \"" (car (last alst)) ".H" "\"\n")))

(defun ama-saved-c++-include ()
  (interactive)
  (process-lines-split-c++-variable 
       global-ama-saved-lines #'make-c++-include))
(global-set-key (kbd "C-c k") 'ama-saved-c++-include)

;;1- diff -urN old/DuDBArchiveJob.C new/DuDBArchiveJob.C
(defun split-last-keyword (line)
  (let (alst blst)
    (setq alst (split-string line))
    (setq blst (last alst))
    (setq name (car (last (split-string (car blst) "/"))))))

(defun lines-split-last-keyword (lines)
  (let (var olst)
  (dolist (line lines)
    (setq var (split-last-keyword line))
    (setq olst (append olst (list var))))
  olst))

(defun ama-split-last-keyword ()
  (interactive)
  (let (lines keywords)
    (setq lines global-ama-saved-lines)
    ;;(setq lines (ama-region-to-lines pos1 pos2))
    (setq keywords (lines-split-last-keyword lines))
    ;(message "keywords = %S" keywords)))
    (dolist (v keywords)
      (insert v " "))))
(global-set-key (kbd "C-c k") 'ama-split-last-keyword)

;;proc_db_dataset_file_update: proc_db_dataset_file_update.o libProcDB.a
(defun line-first-token (line)
  (let (vars)
    (setq vars (split-string line ":"))
    (if vars
        (car vars)
      nil)))

(let (line bfunc xx)
  (setq line "proc_db_dataset_file_update: proc_db_dataset_file_update.o libProcDB.a ")
  (setq bfunc #'line-first-token)
  (setq xx (apply bfunc (list line)))
  (when xx
    (message "xx = %S" xx)))

(defun ama-first-token ()
  (interactive)
  (let (lines keywords bfunc)
    (setq lines global-ama-saved-lines)
    ;;(setq lines (ama-region-to-lines pos1 pos2))
    (setq keywords (lines-split-last-keyword lines))
    ;(message "keywords = %S" keywords)))
    (dolist (v keywords)
      (insert v " "))))
(global-set-key (kbd "C-c k") 'ama-split-last-keyword)

(defun ama-line-rename-file (cmd out-prefix out-suffix ext)
  (let (line fname)
    (setq line (current-line2text))
    (setq fname (car (split-string line "\\.")))
    (goto-char (line-beginning-position))
    (kill-line 1)
    (insert cmd " ")
    (insert line)
    (insert " " out-prefix fname out-suffix ext)
    (insert "\n") ))

(defun ama-rename-cpp2C ()
  (interactive)
  (let (line fname)
    (ama-line-rename-file "mv" "" "" ".C")))
(global-set-key (kbd "C-c m") 'ama-rename-cpp2C)

(defun ama-rename-hpp2H ()
  (interactive)
  (let (line fname)
    (ama-line-rename-file "mv" "" "" ".H")))
;;(global-set-key (kbd "C-c m") 'ama-rename-hpp2H)
