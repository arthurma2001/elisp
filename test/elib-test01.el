;; double-link (dll)

;; binary tree
;;(fset 'foo '<)
;;(foo 4 3)
(setq bb (bintree-create '<))
(bintree-p bb)
(bintree-compare-function bb)
(bintree-empty bb)
(bintree-enter bb 12)
(bintree-enter bb 38)
(bintree-enter bb -3)
(bintree-enter bb -12)
(bintree-delete bb -3)
(bintree-member bb -12)
(bintree-map #'(lambda (x) (+ x 5)) bb)
(bintree-first bb)
(bintree-last bb)
(setq bb1 (bintree-copy bb))
(bintree-flatten bb1)
(bintree-size bb1)
(bintree-clear bb1)

;; elib-node
(setq root (elib-node-create nil nil 333))
(elib-node-left root)
(elib-node-right root)
(elib-node-data root)
(elib-node-set-left root (elib-node-create nil nil 418))
(elib-node-set-right root (elib-node-create nil nil 888))
(elib-node-set-data root 918)
(elib-node-branch root 2)
(elib-node-set-branch root 0 812)

;; elib-string
(string-split ";" "a;b;c;d")
(string-replace-match ".aa" "This is 3aa, " "BB")

;;elib-read
(read-number "Input a number" 500)
(read-num-range 50 100 "Input a range" t)
(read-silent "Password:" ?*)

;; elib-stack-f/stack-m
(setq xx (stack-create))
(stack-p xx)
(stack-push xx 12)
(stack-push xx 13)
(stack-push xx 14)
(stack-pop xx)
(stack-empty xx)
(stack-top xx)
(stack-nth xx 1)
(stack-all xx)
(setq yy (stack-copy xx))
(stack-length yy)
(stack-clear xx)

;; elib's queue-f
(setq xx (queue-create))
(queue-p xx)
(queue-enqueue xx 12)
(queue-enqueue xx 13)
(queue-enqueue xx 14)
(queue-dequeue xx)
(queue-empty xx)
(queue-first xx)
(queue-nth xx 1)
(queue-last xx)
(queue-all xx)
(setq yy (queue-copy xx))
(queue-length yy)
(queue-clear xx)
