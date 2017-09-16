(defun ama-run-cmd-region-sample01 (startPos endPos)
  (interactive "r")
  (let (cmdStr)
    (setq cmdStr "/home/ama/work/elisp/tools/dump.py") ; full path to your script
    (shell-command-on-region startPos endPos cmdStr nil t nil t)))

(defun ama-run-cmd-region-sample02 ()
  "example of calling a external command.
passing text of region to its stdin.
and passing current file name to the script as arg.
replace region by its stdout."
  (interactive)
  (let ((cmdStr
         (format
          "/usr/bin/python /home/jane/pythonscriptxyz %s"
          (buffer-file-name))))
    (shell-command-on-region (region-beginning) (region-end) cmdStr nil "REPLACE" nil t)))

