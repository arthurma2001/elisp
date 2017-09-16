(require 'cl)
(set-difference '(1 2 3) '(3 4 5))
(cl-union '(1 2 3) '(3 4 5))
(cl-nunion '(1 2 3) '(3 4 5))
(cl-intersection '(1 2 3) '(3 4 5))
(cl-set-difference '(1 2 3) '(3 4 5))
(cl-set-exclusive-or '(1 2 3) '(3 4 5))
(cl-subsetp '(1) '(1 2 3))

;;http://www.gnu.org/software/emacs/manual/html_node/cl/Lists-as-Sets.html#Lists-as-Sets
