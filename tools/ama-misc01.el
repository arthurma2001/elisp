(defun dos2unix ()
  "Not exactly but it's easier to remember"
  (interactive)
  (set-buffer-file-coding-system 'unix 't) )

(defun dos2unix (buffer)
  "Automate M-% C-q C-m RET C-q C-j RET"
  (interactive "*b")
  (save-excursion
    (goto-char (point-min))
    (while (search-forward (string ?\C-m) nil t)
      (replace-match (string ?\C-j) nil t))))

(defun ama-c++-build-one-define (name)
  ;;(insert (concat "#define THMOD_" (upcase name)))
  ;;(insert "        ""\"" name "\"" "\n")
  
  ;(insert "addModule (new GRtm3DToolboxModule (")
  ;(insert (concat "THMOD_" (upcase name)))
  ;(insert "));" "\n")

  (insert "registerDialog " "\n")
  (insert (concat "(THMOD_" (upcase name)))
  (insert ", new GRtm3DToolboxModuleDialogLauncher (pwin, ");
  (insert (concat "(THMOD_" (upcase name)))
  (insert ")));" "\n")
  
  ;(insert "GRtm3DToolboxModuleDialogManager::Instance().registerDialog" "\n")
  ;(insert "  (new GRtm3DToolboxModuleDialogLauncher (myIns, ")
  ;(insert (concat "THMOD_" (upcase name)))
  ;(insert "));" "\n")
  )
;;(ama-c++-build-one-define "bg2dds")

(defun ama-c++-process-build-defines (lines)
  (let (line alst)
    (dolist (line lines)
      (setq alst (split-string line))
      (dolist (a alst)
        (ama-c++-build-one-define a)
      ))
    ))

(defun ama-c++-process-build-defines-test ()
  (ama-c++-process-build-defines (list
    "bdfilter  bganglerotate bgfcreate bggettrace "
    "bgrmfilehead   bgsethdrs  bgstack bin2bs bsconv bsfileadd "
    "bsfilemerge bsfilesum bsgettrace bsrange "
    "bssetfh bssetoffset bsstrip bstransp bstransp3d "
    "compress dataedit datamute datasplit dds2bg "
    "dipxdipy2azimuthdip fheditor fhprint fileadd "
    "filediv getdelta gethdr gettrace hdinfo hdprint "
    "hdscan imagereduce imagestack interpol MakeModel "
    "mod3da OrthMod QCModel QCStatus regmodel resample "
    "scanindex segyhdmerge setheader stabilitycheck "
    "stripfheader transmodel transp3d "
    )))
(ama-c++-process-build-defines-test)

(defun ama-gui-lineedit (key comment default tab4)
  (insert "\n")
  (when tab4 (insert tab4))
  (insert "$" key "{" "\n")
  
  (when tab4 (insert tab4))
  (insert "    gui=lineedit" "\n")
  
  (when default
    (when tab4 (insert tab4))
    (insert "      defaults=" (format "%S" default) "\n"))
  
    (when tab4 (insert tab4))
    (insert "    comments= " comment "\n")
    
    (when tab4 (insert tab4))
    (insert "}" "\n")
  )
;;(ama-gui-lineedit "fx" "XXXX" "3 4 5" "    ")

(defun ama-gui-file (key comment default tab4)
  (insert "\n")
  (when tab4 (insert tab4))
  (insert "$" key "{" "\n")
  
  (when tab4 (insert tab4))
  (insert "    gui=filewidget" "\n")
  
  (when default
    (when tab4 (insert tab4))
    (insert "      defaults=" (format "%S" default) "\n"))
  
  (when tab4 (insert tab4))
  (insert "    comments= " comment "\n")
  
  (when tab4 (insert tab4))
  (insert "}" "\n")
  )
;;(ama-gui-file "fx" "XXXX" "3 4 5"  "    ")

(defun ama-gui-module-component (line tab4)
  (let (alst key)
    (setq alst (split-string line "="))
    (when (> (length alst) 1)
      (setq key (car alst))
      (setq key (ama-string-trim key))
      (setq comment (car (cdr alst)))
      (cond ((ama-string-find key "file")  (ama-gui-file key comment nil tab4))
            (t (ama-gui-lineedit key comment nil tab4)))
      )))

;;(ama-gui-module-component "   verbose=0   flag to show run information: 0 min, 3 max")
;(ama-gui-module-component  "infile=     file names for input datasets")
;;(split-string  "infile=     file names for input datasets" "  " t)

(defun ama-gui-module-gui (pos1 pos2 out-buf-name)
  (interactive "r\nBoutput:")
  (let (lines line buf str0 str1 str2 title tab4)
    (setq lines (ama-region-lines pos1 pos2))
    
    (setq line (car lines))
    (when (ama-string-find line ":")
      (setq tab4 "    ")
      (setq lines (cdr lines))
      ;;(setq str0 (ama-string-trim " Optional Parameter:"))
      (setq str0 (ama-string-trim line))
      (setq str1 (ama-string-replace str0 ":" "_"))
      (setq str2 (ama-string-replace str1 " " "_"))
      (setq title str2))
  
    (setq buf (get-buffer-create out-buf-name))
    (save-excursion
      (with-current-buffer buf
        ;;(erase-buffer)
        (goto-char (max-char))
        (when title
          (insert "$" title "{" "\n"))
        (dolist (line lines)
          (ama-gui-module-component line tab4))
        (when title
          (insert "}" "\n"))
        ))
    ))
(global-set-key (kbd "<f12>") 'ama-gui-module-gui)

; Optional Parameter:
;   verbose=0   flag to show run information: 0 min, 3 max
;   maxclip=    the max clip value

(defun ama-gui-comment (out-buf-name)
  (interactive "Boutput:")
  (let ((oldbuf (current-buffer))
        (newbuf nil) start end)
    (setq start (point-min))
    (setq end (point-max))
    (setq newbuf (get-buffer-create out-buf-name))
    (save-excursion
      (with-current-buffer newbuf
        ;;(erase-buffer)
        (goto-char (max-char))
        (insert "$introduction{" "\n");
        (insert "    gui=combobox" "\n");
        (insert "    defaults=introduction " "\n");
        (insert "    comments=\\" "\n");
        (insert-buffer-substring oldbuf start end)
        (insert "}" "\n")
      ))))
(global-set-key (kbd "<f11>") 'ama-gui-comment)
