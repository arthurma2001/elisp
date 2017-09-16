 (defun ama-zap-to-char (arg char)
       "Kill up to and including ARG'th occurrence of CHAR.
     Case is ignored if `case-fold-search' is non-nil in the current buffer.
     Goes backward if ARG is negative; error if CHAR not found."
       (interactive "p\ncZap to char: ")
       (if (char-table-p translation-table-for-input)
           (setq char (or (aref translation-table-for-input char) char)))
       (kill-region (point) (progn
                              (search-forward (char-to-string char)
                                              nil nil arg)
                              (point))))
;;(global-set-key (kbd "C-c C-x") 'ama-zap-to-char)
;; This is T a test

(defun ama-test-append-to-buffer (buffer start end)
  "DOCUMENTATION…"
  (interactive
   (list (read-buffer "Append to buffer: " (other-buffer
                                            (current-buffer) t))
         (region-beginning) (region-end)))
  (let ((oldbuf (current-buffer)))
    (save-excursion
      (let* ((append-to (get-buffer-create buffer))
             (windows (get-buffer-window-list append-to t t))
             point)
        (set-buffer append-to)
        (setq point (point))
        (barf-if-buffer-read-only)
        (insert-buffer-substring oldbuf start end)
        (dolist (window windows)
          (when (= (window-point window) point)
            (set-window-point window (point))))))))

;;(global-set-key (kbd "C-c C-x") 'ama-test-append-to-buffer)
;;(read-buffer "Append to buffer: " (other-buffer  (current-buffer) t))
