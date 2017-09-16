(defun Ldivide (a b)
  (let (q r)
    (setq q (/ a b))
    (setq r (- a (* q b)))
    (list q r)))

(Ldivide 12 5)

(setq a '(("username" . "beazley")
          ("home" . "/home/beazley")
          ("uid" . 900)))
(print a)

(lsh 5 1)
(lsh 5 -1)
(lsh 5 1)
(lsh 5 -1)
(ash 5 1)
(logand 13 12)
(logior 13 12)
(logxor 13 12)
(lognot 13)
