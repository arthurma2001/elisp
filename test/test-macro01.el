(defmacro inc (var)
  `(setq ,var (1+ ,var)))

(defmacro for (var from init to final do &rest body)
  "Execute a simple \"for\" loop.
     For example, (for i from 1 to 10 do (print i))."
  `(let ((,var ,init))
     (while (<= ,var ,final)
       ,@body
       (inc ,var))))

(for i from 1 to 3 do
     (setq square (* i i))
     (princ (format "\n%d %d" i square)))

(defmacro inc (var)
  (list 'setq var (list '1+ var)))

(defmacro inc2 (var)
  `(setq ,var (1+ ,var)))

(defmacro inc3 (var1 var2)
  (list 'progn (list 'inc var1) (list 'inc var2)))

(let (x)
  (setq x 1)
  (inc2 x)
  (message "%d" x))

(macroexpand '(inc2 r))
(macroexpand-all '(inc3 r s))
;;(progn (setq r (1+ r)) (setq s (1+ s)))


(defmacro my-set-buffer-multibyte (arg)
  (let ((tempvar (make-symbol "xxx")))
    `(let ((,tempvar 20))
       (setq ,arg ,tempvar))))

(let (a)
  (my-set-buffer-multibyte a)
  (message "a = %d" a))
