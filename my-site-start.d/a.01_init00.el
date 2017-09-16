;;(global-set-key (kbd "M-SPC") 'set-mark-command)
;;(set-default-font "-adobe-courier-bold-r-normal--34-240-100-100-m-200-iso8859-1")
(set-default-font "-sony-*-*-*-*-*-24-*-*-*-*-*-*-*")
;;(set-face-attribute 'default nil :font "Adobe Courier 34")
;;(font-family-list)

(setq-default tab-width 4) 
(setq-default indent-tabs-mode nil)
(line-number-mode 1)
(column-number-mode 1)
(setq standard-indent 2)
(set-foreground-color "#dbdbdb")
(set-background-color "#000000")
(set-cursor-color "#ff0000")
(setq transient-mark-mode t)

;;(global-font-lock-mode 1)
(setq visible-bell t)

;; macro
;;(load-file "~/.emacs.d/emacs.macs")
(put 'narrow-to-region 'disabled nil)
