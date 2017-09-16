;;Global key-bindings (Hot-keys)
;; global key bindings
(global-set-key [C-delete]    'kill-word)
(global-set-key [C-backspace] 'backward-kill-word)
(global-set-key [home]        'beginning-of-line)
(global-set-key [end]         'end-of-line)
(global-set-key [C-home]      'beginning-of-buffer)
(global-set-key [C-end]       'end-of-buffer)
(global-set-key [f1]          'find-file)
(global-set-key [f2]          '(lambda () (interactive) (progn (fill-paragraph 1) (save-buffer))))
(global-set-key [f3]          'manual-entry)
(global-set-key [f4]          'shell)
(global-set-key [f5]          '(lambda () (interactive) (kill-buffer (current-buffer))))
(global-set-key [S-f7]        'compile)
(global-set-key [f7]          'next-error)
(global-set-key [C-f7]        'kill-compilation)
(global-set-key [f8]          'other-window)
(global-set-key [S-right]     'other-window)
(global-set-key [S-left]      'other-window)
;;(global-set-key [f9]          'save-buffer)
;;(global-set-key [f10]         '(lambda () (interactive) (my-key-swap    my-key-pairs)))
;;(global-set-key [S-f10]       '(lambda () (interactive) (my-key-restore my-key-pairs)))
(global-set-key [f12]         'dabbrev-expand)
(define-key esc-map [f12]     'dabbrev-completion)
;; book mark
(define-key global-map [f9] 'bookmark-jump)
(define-key global-map [f10] 'bookmark-set)
(setq bookmark-save-flag 1)		; How many mods between saves

; for my pc @ home
(global-set-key [M-backspace] 'dabbrev-expand)
;; (global-set-key [S-f12]       'my-vm-without-new-frame)
(global-set-key [C-f12]       'save-buffers-kill-emacs)
;; some machines have SunF37 instead of f12
(global-set-key [SunF37]      'dabbrev-expand)
(define-key esc-map [SunF37]  'dabbrev-completion)
;; (global-set-key [S-SunF37]    'my-vm-without-new-frame)
(global-set-key [C-SunF37]    'save-buffers-kill-emacs)
;;(global-set-key "\C-x\C-b"    'electric-buffer-list)
; Make Emacs use "newline-and-indent" when you hit the Enter key so
; that you don't need to keep using TAB to align yourself when coding.
(global-set-key "\C-m"        'newline-and-indent)
; capitalize current word (for example, C constants)
(global-set-key "\M-u"        '(lambda () (interactive) (backward-word 1) (upcase-word 1)))

;; pager.el stuff
;;(require 'pager)
;;(global-set-key "\C-v"     'pager-page-down)
;;(global-set-key [next]     'pager-page-down)
;;(global-set-key "\ev"      'pager-page-up)
;;(global-set-key [prior]    'pager-page-up)
;;(global-set-key '[M-up]    'pager-row-up)
;;(global-set-key '[M-kp-8]  'pager-row-up)
;;(global-set-key '[M-down]  'pager-row-down)
;;(global-set-key '[M-kp-2]  'pager-row-down)

;; 10 express rules
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(message "bind-keys.el loaded")