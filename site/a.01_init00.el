;;(global-set-key (kbd "M-SPC") 'set-mark-command)
;;(set-default-font "-adobe-courier-bold-r-normal--34-240-100-100-m-200-iso8859-1")
;;(set-face-attribute 'default nil :font "Adobe Courier 34")
;;(font-family-list)
;;(set-face-attribute 'default nil :background "black" :foreground "white"
;;		    :font "Courier" :height 240)
;;(set-default-font "-adobe-utopia-regular-r-normal--33-240-100-100-p-180-iso8859-1")
;;(set-default-font "-b&h-lucidatypewriter-medium-r-normal-sans-34-240-100-100-m-200-iso8859-1")

;;(set-default-font "-adobe-new century schoolbook-medium-r-normal--34-240-100-100-p-181-iso8859-1")
(set-default-font "-adobe-new century schoolbook-medium-r-normal--34-240-100-100-p-181-iso10646-1")

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
