(defun ama-dump-font-list ()
  (let (flst f)
    (setq flst (font-family-list))
    (dolist (f flst)
      (print f)
      )))
(ama-dump-font-list)
;;(set-frame-font "FreeMono-34")
(set-frame-font "DejaVu Serif-30")



