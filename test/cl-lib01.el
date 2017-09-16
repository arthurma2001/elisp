(require 'cl-lib)
(let ((a 1) (b 2) (c 3))
  (cl-rotatef a b c)
  (format "a=%S b=%S c=%S" a b c)
  )

(cl-defsubst fun1 (a b)
  (format "fun1() a=%S b=%S" a b)
  )
;;(fun1 3 4)

(setq foo1 101)
(fset 'foo1 (symbol-function 'fun1))
(foo1 3 4)
;;(cl-callf2 'foo1 3 5)

(cl-copy-list (list 3 4 5))
(cl-oddp 3)
(cl-minusp -1)
(cl-rest (list 3 4 5))
(cl-list* 3 4 5) ;(3 4 . 5)

(setq ival1 12)
(cl-decf ival1)
(cl-incf ival1)

