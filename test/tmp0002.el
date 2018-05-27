;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

defun test001 ()
  (setq max-specpdl-size 5)
  (setq debug-on-error t)    ; now you should get a backtrace
  ;; C-h a ; in speedbar
  (message (format "max-specpdl-size=%d" max-specpdl-size))
  )

;;(file-name-directory "lewis/foo")
;;(file-name-directory "lewis/foo")

(defun test001()
  (interactive)
  ;;(replace-regexp-in-string " " "_" "this is a test")
  (let (word)
    (setq word
          (if (use-region-p)
              (buffer-substring-no-properties (region-beginning) (region-end))
            (current-word)))
    (message (format "word=%s" word))))
(global-set-key (kbd "C-c a") 'test001)

(defun x-make-word-red (begin end)
  "make current region colored red, using text properties"
  (interactive "r")
  (put-text-property begin end 'font-lock-face '(:foreground "red")))

(defun x-open-me ()
  "open a file, using current line as file name/path"
  (interactive)
  (find-file
   (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
;;/home/ama/tmp.txt

(defvar x-keymap nil "sample keymap")
(setq x-keymap (make-sparse-keymap))
(define-key x-keymap (kbd "RET") 'x-open-me)

(defun x-add-prop (begin end)
  "add text properties to a region."
  (interactive "r")
    (put-text-property begin end 'font-lock-face '(:foreground "blue"))
    (put-text-property begin end 'keymap x-keymap))

(font-lock-string-face
;; M-x list-faces-display
/home/ama/tmp.txt
;(browse-url "www.google.com");
;(eww "www.wenxuecity.com")
;(eww "www.dictionary.com")
;(w3 "www.google.com")
;;(emacs-wget
