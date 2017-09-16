(defun ama-svn-process (file1 file2)
  (if (not (file-exists-p file2))
      (insert "svn add " file1 "\n")
    (insert "svn update " file1 "\n")))
   
(ama-svn-process "DataIO/Makefile" "/home/ama/src/ImageProject/DataIO/Makefile")

   "/home/ama/src/ImageProject/DataIO/Makefile"))
