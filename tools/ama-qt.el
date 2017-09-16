(defun ama-qt5-port ()
  (interactive)
  (goto-char (line-beginning-position))
  (kill-line)
  (insert "#include <QtGlobal>" "\n")
  (insert "#if QT_VERSION > QT_VERSION_CHECK(5, 0, 0)" "\n")
  (insert "  #include <QtWidgets>" "\n")
  (insert "#else" "\n")
  (insert "  #include <QtGui>" "\n")
  (insert "#endif" "\n")
  )
(global-set-key (kbd "<f12>") 'ama-qt5-port)
