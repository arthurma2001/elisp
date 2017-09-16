(setq abbrev-file-name
      "~/.abbrev_defs")
;;(setq save-abbrevs t)
(quietly-read-abbrev-file)

;;(define-abbrev-table 'global-abbrev-table '(
;;            ("#s"    "#include <>" "")
;;            ("#i"    "#include \"\"" "")
;;            ("#ifn"  "#ifndef")
;;            ("#e"    "#endif /* */" "")
;;            ("#ifd"  "#ifdef")
;;            ("imain" "int\nmain (int ac, char **av[])\n{\n\n}" "")
;;            ("if"    "if () {\n}\n" "")
;;            ("else"  "else {\n}\n"  "")
;;            ("while" "while () {\n}\n" "")
;;            ("for"   "for (;;) {\n}\n" "")
;;            ("pr"    "printf (\"\")" "")))
;;
(setq default-abbrev-mode t)
;;abbrev-mode
;;edit-abbrevs-map
;;(list-abbrevs)
;;mfs-abbrev-mode-alias
;;(load-path "/homedirs/arthurma/emacs/myconfig/my-site-start.d/msf-abbrev.el")

(defun is-white-char (ch)
  (eq ch ? ))

(defun ama-get-abbrev-keyword ()
  ;;(interactive)
  (save-excursion
    (let (pos pos1 pos2 xstr)
      (goto-char (- (point) 1))
      (setq pos (point))
      (setq pos2 pos)
      (while (and (not (eolp))
                  (not (is-white-char (char-after))))
        (setq pos2 (1+ pos2))
        (forward-char))
      
      (setq pos1 pos)
      (goto-char pos1)
      (while (and (not (bolp))
                  (not (is-white-char (char-before))))
        (setq pos1 (1- pos1))
        (backward-char))
      ;;(setq pos1 (1+ pos1))
      (setq xstr (buffer-substring-no-properties pos1 pos2))
      (print (format "POS (%d,%d) - %S" pos1 pos2 xstr))
      (list pos1 pos2 xstr))))

(defun ama-command-abbrev ()
  (interactive)
  (let (alst pos1 pos2 xstr)
    (setq alst (ama-get-abbrev-keyword))
    (setq pos1 (car alst))
    (setq pos2 (nth 1 alst))
    (setq xstr (nth 2 alst))
    (setq ystr (abbrev-expansion xstr))
    (when ystr
      (goto-char pos1)
      (delete-region pos1 pos2)
      (insert ystr)
      ;;(print (format "%s ==> %s" xstr ystr))
      )))
(global-set-key (kbd "C-c t") 'ama-command-abbrev)
