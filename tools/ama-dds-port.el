(setq load-path (cons "~/work/elisp/tools" load-path))
(load "ama-buffers.el")
(load "ama-files.el")
(load "ama-strings.el")
(load "ama-sets.el")
(load "ama-lists.el")
(load "ama-lines.el")
(load "ama-dirs.el")
(load "ama-regions.el")
(load "ama-cfuncs.el")
(load "ama-plists.el")
(load "ama-xmls.el")
(load "ama-diff.el")
(load "ama-xmls.el")
(load "ama-find-file.el")
(load "ama-svn01.el")

(defun ama-dds-funcs-list (fname)
  (let (flst f olst)
    (setq flst (ama-file-line-keywords fname))
    (dolist (f flst)
      (setq olst (append olst (list (car f)))))
    olst))
;; (ama-dds-funcs-list "/home/ama/src/ImageProject/doc/dds_funcs.txt")

(defun ama-dds-scan-funcs-exist (dname funcs)
  (let (flst f olst pats A O)
    (setq pats (list ".h$" ".c$"))
    (setq flst (ama-file-list dname pats))
    (dolist (f flst)
      (setq f (concat dname f))
      ;(print f)
      (setq A (ama-file-keywords-exist f funcs))
      ;(print A)
      (setq O (ama-set-union A O)))
    O))
;;(ama-dds-scan-funcs-exist "/tmp" (list "xxx"))
;;(ama-dds-scan-funcs-exist "/home/ama/src/ImageProject/tomo/" (list "cdds_openpr"))

(defun ama-dds-scan-funcs-exist-test ()
  (let (funcs olst f)
    (setq funcs (ama-dds-funcs-list "/home/ama/src/ImageProject/doc/dds-funcs.txt"))
    (setq olst (ama-dds-scan-funcs-exist "/home/ama/src/ImageProject/tomo/" funcs))
    (dolist (f olst)
      (print f))))
;;(ama-dds-scan-funcs-exist-test)

(defun ama-dds-scan-use-funcs (dlst funcs)
  (let (dname A B) 
    (dolist (dname dlst)
      (setq A (ama-dds-scan-funcs-exist dname funcs))
      (setq B (ama-set-union A B)))
    (print (format "len(B)=%d, B=%S" (length B) B))
    (print (format "(len(funcs)=%d, funcs=%S" (length funcs) funcs))
    B))

(defun ama-dds-scan-not-use-funcs (dlst funcs)
  (let (dname A B C O) 
    (dolist (dname dlst)
      (setq A (ama-dds-scan-funcs-exist dname funcs))
      (setq B (ama-set-union A B)))
    (print (format "len(B)=%d, B=%S" (length B) B))
    (print (format "(len(funcs)=%d, funcs=%S" (length funcs) funcs))
    (setq C funcs)
    (setq O (ama-set-exclusive C B))
    O))

(defun ama-dds-scan-not-use-funcs-test ()
  (let (funcs olst dlst f)
    (setq funcs (ama-dds-funcs-list "/home/ama/src/ImageProject/doc/dds-funcs.txt"))
    (setq dlst (list "/home/ama/src/ImageProject/tomo/"))
  ;;(setq dlst (list "/home/ama/workspace/tomo/src/src.hrctomo110115/1.tomormo/"))
    (setq olst (ama-dds-scan-not-use-funcs dlst funcs))
    (ama-buffer-clear "aaaa.txt")
    (dolist (f olst)
      (ama-buffer-print "aaaa.txt" f))))
;;(ama-dds-scan-not-use-funcs-test)
      
(defun ama-dds-build-not-use-funcs (tomodir)
  (let (funcs olst dlst0 dlst xlst f)
    (setq dlst0 (list "1.tomormo" "4.tomocip"
                     "7.tomosolver"  "tomohelp"
                     "tomottisolver" "2.tomodip"
                     "5.tomopick"  "8.dds2segy" "tomomask"
                     "3.tomohrn2vol"  "6.tomoray"  "tomottiray"))
    (dolist (dname dlst0)
      (setq dlst (append dlst (list (concat tomodir dname "/")))))

    (setq funcs (ama-dds-funcs-list "/home/ama/src/ImageProject/doc/dds-funcs.txt"))
    (setq funcs (sort funcs #'string-lessp))
    
    (setq xlst (ama-dds-scan-use-funcs dlst funcs))
    (setq xlst (sort xlst #'string-lessp))
    (setq olst (ama-set-exclusive funcs xlst))
    
    (ama-buffer-clear "aaaa.txt")
    (dolist (f olst)
      (ama-buffer-print "aaaa.txt" f))
    olst))
;;(ama-dds-build-not-use-funcs "/home/ama/workspace/tomo/src/src.hrctomo110115/")

(defun ama-dds-remove-not-use-funcs (cdds_fname not-use-funcs ofname)
  (let (func)
    (with-temp-buffer
      (ama-file-load cdds_fname)
      (dolist (func not-use-funcs)
        (ama-buffer-remove-cfunc func)
        )
      (write-file ofname))))

(defun ama-dds-build-smallest-cfunc (tomodir)
  (let (not-use-funcs cdds_fname ofname)
    (setq not-use-funcs (ama-dds-build-not-use-funcs tomodir))
    (ama-file-save-list "/home/ama/tmp/dds-not-use-funcs.txt" not-use-funcs)
    (setq cdds_fname "/home/ama/src/ImageProject/DDS3/cdds.h")
    (setq ofname "/home/ama/tmp/smallest-cdds.h")
    (print (format "ama-dds-build-smallest-cfunc () - begin"))
    (ama-dds-remove-not-use-funcs cdds_fname not-use-funcs ofname)
    ))
;;(ama-dds-build-smallest-cfunc "/home/ama/workspace/tomo/src/src.hrctomo110115/")

(defun ama-dds-create-mapping-file ()
  (let (klst0 fname ofname pats)
    (setq fname "/home/ama/src/ImageProject/doc/dds-funcs.txt")
    (setq ofname "/home/ama/src/ImageProject/doc/dds-bgds-funcs.txt")
    (setq pats (list (list "cdds" "bgds")
                     (list "cddx" "bgdx")))
    (setq klst0 (ama-file-line-keywords fname))
    (setq klst0 (ama-list-item-list klst0 0))
    (setq klst1 (ama-list-mappings klst0 pats))
    (ama-file-save-multiple-list ofname klst1)
    ))
;;(ama-dds-create-mapping-file)

(defun ama-bgds-create-cfuns-h ()
  (let (d2b_mappings ifname ofname)
    (setq ifname "/home/ama/tmp/smallest-cdds.h")
    (setq ofname "/home/ama/tmp/smallest-cbgds.h")
    (setq d2b_mappings (ama-file-line-keywords "/home/ama/src/ImageProject/doc/dds-bgds-funcs.txt"))
    (setq d2b_mappings (append d2b_mappings (list (list "DDS_" "BDS_"))))
    (setq d2b_mappings (append d2b_mappings (list (list "BIN_TAG" "CUBE_TAG"))))
    (ama-file-string-multiple-replace ifname d2b_mappings ofname)
  ))
;;(ama-bgds-create-cfuns-h)

(defun ama-dds-build-bgds-dds.c (ifname ofname spat tpat)
  (ama-file-build-cfunc-from-proto ifname ofname spat tpat)
  )

(defun ama-bgds-create-bgds-dds.c ()
  (let (d2b_mappings ifname ofname)
    (setq ifname "/home/ama/tmp/smallest-cbgds.h")
    (setq ofname "/home/ama/tmp/smallest-bgds-cdds.c")
    (ama-dds-build-bgds-dds.c ifname ofname "bgd" "cdd")
  ))
;;(ama-bgds-create-bgds-dds.c)

;; replace dds by bgds api
(defun ama-dds-replace-api-bgds (dname out_dname)
  (let (flst out_fname f f0 olst xpats0 xpats A O)
    (setq pats (list ".h$" ".c$"))
    (setq flst (ama-file-list dname pats))
    (setq xpats (list (list "cdds" "bgds")
                      (list "cddx" "bgdx")
                      (list "RANK_MAX" "BDS_RANK_MAX")
                      (list "AXISNAME_MAX" "BDS_AXISNAME_MAX")
                      (list "BIN_TAG" "BDS_TAG")
                      (list "SYM_TAG" "BDS_STAG")
                      (list "FIELD_TAG" "BDS_FIELD_TAG")
                      (list "setargcv" "bgds_setargcv")
                      ))
    ;(setq xpats (ama-list-item-list xpats0 0))
    (print (format "xpats = %S" xpats))
    (dolist (f0 flst)
      (setq f (concat dname f0))
      (setq out_fname (concat out_dname f0))
      (setq A (ama-file-string-multiple-replace f xpats out_fname))
    ))
  )
;;(ama-dds-replace-api-bgds "/home/ama/tmp/aaa/" "/home/ama/tmp/bbb/")

(defun ama-dds-replace-api-bgds-all (tomodir outdir)
  (let (funcs olst dlst0 dlst xlst f)
    (setq dlst0 (list "1.tomormo" "4.tomocip"
                     "7.tomosolver"  "tomohelp"
                     "tomottisolver" "2.tomodip"
                     "5.tomopick"  "8.dds2segy" "tomomask"
                     "3.tomohrn2vol"  "6.tomoray"  "tomottiray"))
    (dolist (dname dlst0)
      (setq dname1 (concat tomodir dname "/"))
      (setq dname2 (concat outdir dname "/"))
      (print (format "%S --> %S" dname1 dname2))
      (ama-dds-replace-api-bgds dname1 dname2))
    ))
(defun ama-dds-replace-api-bgds-all-test ()
  (let (tomodir outdir)
    (setq tomodir "/home/ama/workspace/tomo/src/src.hrctomo110115/")
    ;;(setq outdir "/home/ama/workspace/tomo/src/src.sthc/")
    (setq outdir "/home/ama/tmp/src.sthc/")
    (ama-dds-replace-api-bgds-all tomodir outdir)))
;;(ama-dds-replace-api-bgds-all-test)

;; build test script
;;(ama-dir-common-filenames-buffer "/data0/scratch/ama/projects/tomo/jobsd60" "/data0/scratch/ama/projects/tomo/jobsd60.old/" "aaaa.txt" "_@")

(defun ama-dds-make-diff-cmd (line)
  (let (xlst file1 file2 cmd)
    (setq xlst (split-string line))
    (when (> (length xlst) 3)
      (setq file1 (ama-string-replace (nth 2 xlst) "_@" ""))
      (setq file2 (ama-string-replace (nth 4 xlst) "_@" ""))
      (setq cmd (format "DiffModel ddsfile=%s ddsfile1=%s" file1 file2)))
    cmd))

(defun ama-dds-make-diff-cmd-test ()
  (let (line)
    (setq line "Binary files /data0/scratch/ama/projects/tomo/jobsd60/bp2dv97e60d60-pick-v13-1x4-r3_@ and /data0/scratch/ama/projects/tomo/jobsd60.old//bp2dv97e60d60-pick-v13-1x4-r3_@ differ")
    (ama-dds-make-diff-cmd line)
    ))
;;(ama-dds-make-diff-cmd-test)

(defun ama-dds-make-diff-cmd-region (pos1 pos2)
  (interactive "r")
  (let (lines olst cmd)
    (setq lines (ama-region-lines pos1 pos2))
    (dolist (line lines)
      (setq cmd (ama-dds-make-diff-cmd line))
      (setq olst (append olst (list cmd))))
    (ama-file-save-list "bbbb.txt" olst)))


(defun ama-dds-step6-make-diff-cmd ()
  ;;(interactive)
  (let (line cmd)
    (setq line (ama-line-current2text))
    (goto-char (line-beginning-position))
    (kill-line 1)
    (setq cmd (format "diff %s ../jobsd60.old/%s" line line))
    (insert cmd "\n")
    ))
;;(global-set-key (kbd "C-c C-x") 'ama-dds-step6-make-diff-cmd)
;;bp2dv97e60d60-tomottiray-az2.r03.del
