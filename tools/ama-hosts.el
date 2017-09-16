(defun ama-make-host (pname num mem cpu gpu gpumem)
  (format "%s%d %dG %d %d %dG" pname num mem cpu gpu gpumem))

(defun ama-make-host-txt (out-txt-name pname host-start host-end
                                       mem cpu gpu gpumem)
  (let (i nhost N txt)
    (setq N (+ (- host-end host-start) 1))
    (with-current-buffer (get-buffer-create out-txt-name)
      (dotimes (i N)
        (setq nhost (+ i host-start))
        (setq txt (ama-make-host pname nhost mem cpu gpu gpumem))
        (insert txt "\n")
        ))))
      
;;(ama-make-host-txt "aaaa.txt" "sth" 81 100 256  24    16   12)
;;(ama-make-host-txt "aaaa.txt" "sth" 101 130 256  24    4   12)
;;(ama-make-host-txt "aaaa.txt" "sth" 131 138 256  24    8   12)
