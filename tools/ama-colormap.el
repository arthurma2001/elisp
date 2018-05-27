(defun ama-rgb2color (r g b)
  (insert (format "    Color = 255, %d, %d, %d" r g b) "\n")
  )
  
;;<Point x="0.000000" o="0.000000" r="0.498039" g="0.788235" b="0.498039"/>
;;    Color = 255, r, g, b
(defun ama-xml-point2color (alst)
  (let (xlst x r g b n1 v1)
    (setq xlst (car (cdr alst)))
    (dolist (x xlst)
      (setq n1 (car x))
      (setq v1 (cdr x))
      (cond ((string= n1 "r") (setq r (string-to-number v1)))
            ((string= n1 "g") (setq g (string-to-number v1)))
            ((string= n1 "b") (setq b (string-to-number v1)))))
    (setq r (round (* r 256)))
    (setq g (round (* g 256)))
    (setq b (round (* b 256)))
    (ama-rgb2color r g b)
    ))

(defun ama-colormap-header ()
  (insert "!colormap file, it include color info and value info." "\n")
  (insert "<BaseInfo>" "\n")
  (insert "    NullColor = 0, 0, 0, 0" "\n");
  (insert "</BaseInfo>" "\n")
  )

(defun ama-create-colormap (out-path alst)
  (let (xlst name ofname buf)
    (setq name (cdr (car (car (cdr alst)))))
    (setq ofname (format "%s/%s.pal" out-path name))
    (setq xlst (cdr (cdr alst)))
    
    (setq buf (get-buffer-create ofname))
    (save-excursion
      (with-current-buffer buf
        (erase-buffer)
        (ama-colormap-header)
        (dolist (x xlst)
          (ama-xml-point2color x)
          )
        (write-file ofname))
      (kill-buffer buf)
    )))

(defun ama-xml-colormap-region (pos1 pos2 out-path)
  (interactive "r\nDoutput:")
  (let (alst x buf)
    (setq alst (libxml-parse-xml-region pos1 pos2))
    (setq alst (cddr alst))
    (message "%S" alst)
    (dolist (x alst)
      (ama-create-colormap out-path x))))

(defun ama-xml-colormap-test ()
  (let (alst out-path)
    (setq alst '(Point ((x . "0.000000") (o . "0.000000") (r . "0.498039") (g . "0.788235") (b . "0.498039"))))
    ;;(ama-alist-dump alst)
    ;;(ama-xml-point2color alst)
    
    (setq alst '(ColorMap ((name . "Accent") (space . "RGB")) (Point ((x . "0.000000") (o . "0.000000") (r . "0.498039") (g . "0.788235") (b . "0.498039"))) (Point ((x . "0.003922") (o . "0.003922") (r . "0.504821") (g . "0.785329") (b . "0.507190"))) (Point ((x . "0.007843") (o . "0.007843") (r . "0.511603") (g . "0.782422") (b . "0.516340"))) (Point ((x . "0.011765") (o . "0.011765") (r . "0.518385") (g . "0.779516") (b . "0.525490")))))
    (setq out-path "/tmp")
    (ama-create-colormap out-path alst)
    ))
;;(ama-xml-colormap-test)
;;    Color = 255, 85, 42, 85

;;<doc>
;;<ColorMap name="Accent" space="RGB">
;;<Point x="0.000000" o="0.000000" r="0.498039" g="0.788235" b="0.498039"/>
;;<Point x="0.003922" o="0.003922" r="0.504821" g="0.785329" b="0.507190"/>
;;<Point x="0.007843" o="0.007843" r="0.511603" g="0.782422" b="0.516340"/>
;;<Point x="0.011765" o="0.011765" r="0.518385" g="0.779516" b="0.525490"/>
;;</ColorMap>
;;</doc>
;;

(defun ama-txt-colormap-region (pos1 pos2 ofname)
  (interactive "r\nMoutput:")
  (let (lines line dlst r g b buf)
    (setq lines (ama-region-lines pos1 pos2))
    (message "%S" lines)

    (setq buf (get-buffer-create ofname))
    (save-excursion
      (with-current-buffer buf
        (erase-buffer)
        (ama-colormap-header)
        (dolist (line lines)
          (setq dlst (ama-string-to-numbers line))
          (setq r (nth 0 dlst))
          (setq g (nth 1 dlst))
          (setq b (nth 2 dlst))
          (ama-rgb2color r g b)
          )
        (write-file ofname))
      (kill-buffer buf)
    )))

;;####
(defun ama-format-cmap-line (nth r g b)
  (let (out-str)
    (setq out-str (format "%d %s %s %s" nth r g b))))

(defun ama-process-cmap-line (nth-color line)
  (let (alst)
    (setq alst (split-string line ","))
    (when (>= (length alst) 3)
      (ama-format-cmap-line nth-color (nth 0 alst) (nth 1 alst) (nth 2 alst)))
    ))
;;(ama-process-cmap-line 12 "120,0,133")


(defun ama-csv-colormap-region (pos1 pos2 ofname)
  (interactive "r\nMoutput:")
  (let (lines line buf nth-color txt)
    (setq lines (ama-region-lines pos1 pos2))
    (message "%S" lines)
    
    (setq nth-color 0)
    (setq buf (get-buffer-create ofname))
    
    (save-excursion
      (with-current-buffer buf
        (erase-buffer)
        (insert "# index red green blue" "\n")
        (dolist (line lines)
          (when (not (string-match-p "#" line))
            (setq txt (ama-process-cmap-line nth-color line))
            (insert "  " txt "\n")
            (setq nth-color (1+ nth-color)))
          )))
      ))
;;(defun ama-csv-colormap-region (pos1 pos2 ofname)
;; (string-match-p "#" "# xxxx")(defun ama-format-cmap-line (nth r g b)
  (let (out-str)
    (setq out-str (format "%d %s %s %s" nth r g b))))

(defun ama-process-cmap-line (nth-color line)
  (let (alst)
    (setq alst (split-string line ","))
    (when (>= (length alst) 3)
      (ama-format-cmap-line nth-color (nth 0 alst) (nth 1 alst) (nth 2 alst)))
    ))
;;(ama-process-cmap-line 12 "120,0,133")


(defun ama-csv-colormap-region (pos1 pos2 ofname)
  (interactive "r\nMoutput:")
  (let (lines line buf nth-color txt)
    (setq lines (ama-region-lines pos1 pos2))
    (message "%S" lines)
    
    (setq nth-color 0)
    (setq buf (get-buffer-create ofname))
    
    (save-excursion
      (with-current-buffer buf
        (erase-buffer)
        (insert "# index red green blue" "\n")
        (dolist (line lines)
          (when (not (string-match-p "#" line))
            (setq txt (ama-process-cmap-line nth-color line))
            (insert "  " txt "\n")
            (setq nth-color (1+ nth-color)))
          )))
      ))
;;(defun ama-csv-colormap-region (pos1 pos2 ofname)
;; (string-match-p "#" "# xxxx")
