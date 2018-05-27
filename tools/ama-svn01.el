(defun ama-svn-process-00 (file1 file2)
  (if (not (file-exists-p file2))
      (insert "svn add " file1 "\n")
    (insert "svn update " file1 "\n")))
   
;;(ama-svn-process00 "DataIO/Makefile" "/home/ama/src/ImageProject/DataIO/Makefile")
;;   "/home/ama/src/ImageProject/DataIO/Makefile"))

(defun ama-svn-process (dir1 dir2 pname diff-fname outfile)
  (let (filelist fname  buffer  file1 file2)
    (setq filelist (ama-diff-filelist diff-fname))
    (setq buffer (get-buffer-create outfile))
    (save-excursion
      (with-current-buffer buffer
        (erase-buffer)
        (dolist (file filelist)
          (setq file1 (format "%s%s" dir1 file))
          (setq file2 (format "%s%s" dir2 file))
          (when (and file1 file2)
            (insert (format "\ncp %s %s\n" file1 file2))
            (if (not (file-exists-p file2))
                (insert "svn add " file2 "\n")
              (insert "svn update " file2 "\n")))
          )))))

(defun ama-svn-process-test ()
  (let (pname dir1 dir2 diff-fname outfile )
    (setq pname "Base")
    (setq diff-fname "/home/ama/workspace/port2thunder/src/ImageProject/src/BasicLib/base_list01.txt")
    (setq dir1 (format "/home/ama/workspace/port2thunder/src/ImageProject/src/BasicLib/%s/" pname))
    (setq dir2 (format "/home/ama/workspace/thunder/trunk/src/lib/%s/" pname))
    (setq outfile "aaaa.txt")
    (message (format "pname=%s\n" pname))
    (message (format "diff-fname=%s\n" diff-fname))
    (message (format "dir1=%s\n" dir1))
    (message (format "dir2=%s\n" dir2))
    
    (ama-svn-process dir1 dir2 pname diff-fname outfile)
    ))
;;(ama-svn-process-test)
