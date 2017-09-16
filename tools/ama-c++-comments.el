(defun ama-process-one-file (in-dir fname out-dir)
  (let (ifname ofname)
    (setq ifname (concat in-dir "/" fname))
    (setq ofname (concat out-dir "/" fname))
    (with-temp-buffer
      (ama-file-load ifname)
      (ama-buffer-remove-c++-comment)
      (write-file ofname))))
;;(ama-process-one-file "/tmp" "SoLineSet3D.h" "/tmp/aaa")

(defun ama-process-one-dir (in-dir pat out-dir)
  (let (ifname ofname flst)
    (setq flst (ama-dir-list in-dir pat))
    (dolist (fname flst)
      (ama-process-one-file in-dir fname out-dir))))
;;(ama-process-one-dir "/scratch/ama/workspace/src/ImageProject/SoOD" "\\.h" "/tmp/aaa")
;;(ama-process-one-dir "/scratch/ama/workspace/src/ImageProject/SoOD" "\\.cc" "/tmp/aaa")

