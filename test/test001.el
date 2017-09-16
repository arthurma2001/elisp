;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.
;; YYYYY

(current-time)
(current-time-string)
(current-time-zone)
(current-line2text)
(format-seconds "%H %M %S" 3756)

(defun test-passwd ()
  (read-passwd "Password:" t nil))
;;(test-passwd)

(defun ama-paste ()
  (interactive)
  (insert (car kill-ring-yank-pointer)))

(cons 'foo ())
(car '(1 2))
(third '(1 2 3))
(make-sparse-keymap)

(progn (print 'foo) (print 'bar))
(insert "changed")

(defun foo (a &optional b &rest c)
  (let (sum)
    (setq sum a)
    (when b
      (setq sum (+ sum b)))
    (when c
      (dolist (v c)
        (setq sum (+ sum v))))
    sum))

(foo 12)
(foo 12 13)
(foo 12 13 1 2 3 4 5)

(defmacro count-loop (ctrl func)
  (let (i1 i2 i)
    (setq i1 (caar ,ctrl))
    (setq i2 (caaar ,ctrl))
    (setq i i1)
    (while (< i i2)
;;count-loop (VAR [FROM TO [INC]]) BODY ???

;;???      
(count-loop (i 0 10)
            (print i))
            
(emacs-version)
(print emacs-build-time)
(1+ 134217727)
(print 15.0e2)
?X ?q ?\a ?\b ?\t ?\n ?\f ?\r ?\d ?\\
?A ?\M-A ?\C-\S-O

(defun wraper (f1 f0 a b)
  (print "wraper()")
  (funcall f1 f0 a b))
(defun afun1 (f0 a b)
  (print "afun1()")
  (funcall f0 a b))
(defun afun0 (a b)
  (print "afun0()")
  (print a)
  (print b)
  (+ a b))
(wraper 'afun1 'afun0 32 48)

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

(defun ama-create-c++-header ()
  (interactive)
  (let (name txt)
    (setq name (car (split-string (buffer-name) "\\.")))
    (setq txt (make-c++-header "/home/ama/work/elisp/c++-header-template.txt" name))
    (insert-string txt)))

(defun ama-txt2xml (txt mark)
  (format "<%s>%s</%s>" mark txt mark))

(defun ama-insert-txts2xml (tlst mark)
  (dolist (txt tlst)
    (insert "\n")
    (insert (ama-txt2xml txt mark))))
;(ama-insert-txts2xml (list "AAAA" "BBBB") "item")

(defun ama-files-txt2xml (dname mark)
  (interactive "DDir:\nsMark:")
  (message "dname = %S" dname)
  (message "mark = %S" mark)
  (let (flst)
    (setq flst (directory-files dname))
    (ama-insert-txts2xml flst mark)
  ))

;; (defun ama-insert-file-replace (fname spat tpat)
;;   (insert-file fname)
;;   (replace-string spat tpat)
;;   )
;; 
;; (defun ama-c++-create-header ()
;;   (interactive)
;;   (let ((fname "/home/ama/work/elisp/c++-header-template.txt")
;;         (spat "tempClass")
;;         (tpat (split-string (buffer-name) "\\\.")))
;;     (ama-insert-file-replace fname spat tpat)))

(defun ama-add-curr-linenum (n)
  (let (lstr)
    (setq lstr (format "%d." n))
    (goto-char (line-beginning-position))
    (forward-word)
    (backward-word)
    (insert lstr)))

(defun ama-add-linenum (pos1 pos2)
  (interactive "rRegion:")
  (let ((num 1))
    (goto-char pos1)
    (while (< (point) pos2)
      (ama-add-curr-linenum num)
      (next-line)
      (setq num (1+ num)))))
