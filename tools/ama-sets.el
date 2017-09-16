(require 'cl)

(defun ama-set-difference(A B)
  (cl-set-difference A B)
  )
;;(ama-set-difference '(1 2 3) '(2 3 4))

(defun ama-set-intersection (A B)
  (cl-intersection A B)
  )
;;(ama-set-intersection '(1 2 3) '(2 3 4))

(defun ama-set-union (A B)
  (cl-union A B)
  )
;;(ama-set-union '(1 2 3) '(2 3 4))

(defun ama-set-exclusive (A B)
  (cl-set-exclusive-or A B))
;;(ama-set-exclusive '(1 2 3) '(2 3 4))

(defun ama-set-subsetp (A B)
  (cl-subsetp A B))
;;(ama-set-subsetp '(1 2 3) '(1 2 3 4))

(defun ama-set-member (x A)
  (cl-member x A))
;;(ama-set-member 2 '(3 4 5))

