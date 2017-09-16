(defun ama-file-fname (fullpath)
  (file-name-nondirectory fullpath)
  )
;(ama-file-fname "./src/src.pro")

(defun ama-file-dname (fullpath)
  (file-name-directory fullpath)
  )
;(ama-file-dname "./src/src.pro")

(defun ama-file-load (fname)
  (when (file-exists-p fname)
    (insert-file-contents fname)))
;;(ama-file-load "/tmp/tmp.txt")

(defun ama-file-filter (fname pat)
  (string-match pat fname))
;; (ama-file-filter "ddd3rdxxx" "3rd")

(defun ama-file-list (dname pats)
  (let (flst fname olst pattern) 
    (setq flst (directory-files dname))
    (dolist (pattern pats)
      (dolist (fname flst)
        (when (ama-file-filter fname pattern)
          (setq olst (append olst (list fname))))))
    olst))

(defun ama-file-list-test ()
  (let (olst fname)
    (setq olst (ama-file-list "/tmp" (list "ama$" "jhu$")))
    (dolist (fname olst)
      (print fname))))
;;(ama-file-list-test)

(defun ama-file-save-list (ofname alst)
  (let (buf)
    (setq buf (get-buffer-create ofname))
    (set-buffer buf)
    (erase-buffer)
    (ama-buffer-save-list alst)
    (write-file ofname)
    (kill-buffer buf)
    ))
;;(ama-file-save-list "/tmp/tmp.txt" (list "33" "44" "1234"))

(defun ama-file-save-append-list (ofname alst)
  (let (buf)
    (setq buf (get-buffer-create ofname))
    (save-excursion
      (with-current-buffer buf
        (ama-buffer-save-list alst)
        ;;(write-file ofname)
        ))
    ))
;;(ama-file-save-append-list "/tmp/tmp.txt" (list "33" "44" "1234"))

(defun ama-file-save-multiple-list (ofname alst)
  (let (buf)
    (setq buf (get-buffer-create ofname))
    (set-buffer buf)
    (erase-buffer)
    (ama-buffer-save-multiple-list alst)
    (write-file ofname)
    (kill-buffer buf)
    ))
;;(ama-file-save-multiple-list "/tmp/tmp.txt" (list (list "33" "44" "1234")))

(defun ama-file-replace-string (fname sname tname ofname)
  (with-temp-buffer
    (ama-file-load fname)
    (ama-buffer-string-replace sname tname)
    (write-file ofname)
    ;;(ama-save-to-buffer ofname)
  ))
;;(ama-file-replace-string "/home/ama/work/elisp/tmp/segy03.csh" "test" "XImageViewer" "tmp_aaaa.txt")

(defun ama-file-line-keywords (fname)
  (let (olst)
    (with-temp-buffer
      (ama-file-load fname)
      (setq olst (ama-buffer-line-keywords)))
    olst))

(defun ama-file-line-keywords-test ()
  (let (olst fname)
    (setq olst (ama-file-line-keywords "/home/ama/tmp/tmp.txt"))
    (dolist (fname olst)
        (print fname))))
;;(ama-file-line-keywords-test)

(defun ama-file-keywords-exist (fname pats)
  (let (olst)
    (with-temp-buffer
      (ama-file-load fname)
      (setq olst (ama-buffer-keywords-exist pats)))
    olst))

(defun ama-file-keywords-exist-test()
  (let (alst fname)
    (setq alst (ama-file-keywords-exist "/home/ama/tmp/tomormo.c"
                                       (list "cdds_openpr"
                                             "cdds_prtmsg"
                                             "cdds_prterr"
                                             "XXXX")))
    (dolist (fname alst)
        (print fname))))
;;(ama-file-keywords-exist-test)

(defun ama-file-attr (fname n)
  (let (file-attrs)  
    (setq file-attrs (file-attributes fname 'string))
    (nth n file-attrs)))

(defun ama-file-time (fname)
  (ama-file-attr fname 6))
;;(ama-file-time "/tmp/tmp.txt")

(defun ama-file-size (fname)
  (ama-file-attr fname 7))
;;(ama-file-size "/tmp/tmp.txt")

(defun ama-file-regular-p (fname)
  (file-regular-p fname))
;;(ama-file-regular-p "/tmp/tmp.txt")

(defun ama-file-diff (fname1 fname2)
  ;;(message (format "diff %s %s" fname1 fname2))
  (if (= (ama-file-size fname1) (ama-file-size fname2))
      t
    nil))
;;(ama-file-diff "/tmp/tmp.txt" "/tmp/tmp2.txt")

(defun ama-file-string-multiple-replace (ifname pats ofname)
  (with-temp-buffer
    (ama-file-load ifname)
    (ama-buffer-string-multiple-replace pats)
    (write-file ofname)
    ;;(ama-save-to-buffer ofname)
  ))

(defun ama-file-build-cfunc-from-proto (ifname ofname spat tpat)
  (with-temp-buffer
    (ama-file-load ifname)
    (ama-buffer-build-cfunc-from-proto spat tpat)
    (write-file ofname)
    ;;(ama-save-to-buffer ofname)
  ))

(defun ama-file2lines (ifname)
  (let (lines)
    (with-temp-buffer
      (ama-file-load ifname)
      (setq lines (ama-buffer2lines))
      lines)))
;;(ama-file2lines "/tmp/tmp.txt")
  
(defun ama-file-make-copy-file (fname src-dir tgt-dir)
  (let (out-cmd)
    (setq out-cmd (format "cp %s/%s %s" src-dir fname tgt-dir))
  ))
;;(ama-file-make-copy-file "aaaa.txt" "/tmp" "/out")

(defun ama-file-make-copy-list (ifname src-dir tgt-dir out-file)
  (let (lines line cmd fname olst)
    (setq lines (ama-file2lines ifname))
    (dolist (line lines)
      (setq fname (ama-string-trim line))
      (when (not (ama-string-empty fname))
        (setq cmd (ama-file-make-copy-file fname src-dir tgt-dir))
        (when cmd
          (setq olst (append (list cmd) olst)))))
    (message "olst=%S" olst)
    (ama-file-save-list out-file olst))
  )
 ;;(ama-file-make-copy-list "/home/ama/tmp2.txt" "/home/ama/workspace/tomoui/msgui"                         "/scratch/ama/workspace/src/jiao" "aaaa.txt")
