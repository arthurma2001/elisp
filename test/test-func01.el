(fset 'self-insert-command
      (lambda () "Print message instead of entering characters."
        (interactive)
        (message "HALLO?")))

(eval '456)
(fset 'foo (symbol-function 'car))
(foo '(3 2 1))
(funcall (lambda (x) (foo x)) '(3 2 1))
(indirect-function (lambda (x) (foo x)) '(3 2 1))

(defmacro ama-cadr (x)
  (list 'car (list 'cdr x)))
(ama-cadr '(3 4 5))

(defun ama-test-catch ()
  (catch 'foo
    (throw 'foo 32)))
;;(ama-test-catch)

(defun ama-test-cond (x)
  (cond ((> x 2)
         (message "AAAA"))
        (t nil)))
;;(ama-test-cond 1)
  
(defconst aaa1 12 "AAAA1")
;;(defconst aaa1 102 "AAAA1")
;;aaa1

(defvar aaa2 103 "AAAA2")
;;(defvar aaa2 22103 "AAAA2")
;;aaa2

;;(function 'xxx)
`(a list of (+ 2 3) elem)

(progn 1 2 3)
(prog1 1 2 3)
(prog2 1 2 3)

(let (xxx)
  ;;(setq xxx 'code)
  (setq xxx 'success)
  (pcase xxx
    (`success       (message "Done!"))
    (`would-block   (message "Sorry, can't do it now"))
    (`read-only     (message "The shmliblick is read-only"))
    (`access-denied (message "You do not have the needed rights"))
    (code           (message "Unknown return code %S" code)))
)

(defun evaluate (exp env)
  (pcase exp
    (`(add ,x ,y)       (+ (evaluate x env) (evaluate y env)))
    (`(call ,fun ,arg)  (funcall (evaluate fun env) (evaluate arg env)))
    (`(fn ,arg ,body)   (lambda (val)
                          (evaluate body (cons (cons arg val) env))))
    ((pred numberp)     exp)
    ((pred symbolp)     (cdr (assq exp env)))
    (_                  (error "Unknown expression %S" exp))))

(defun pcase-test ()
  (evaluate '(add 1 2) nil)                 ;=> 3
  (evaluate '(add x y) '((x . 1) (y . 2)))  ;=> 3
  ;;(evaluate '(call (fn x (add 1 x)) 2) nil) ;=> 3
  ;;(evaluate '(sub 1 2) nil)                 ;=> error
  )
(pcase-test)

(let (xxx)
  (setq xxx nil)
  (unless xxx
    (message "DDDD")))

;;(error "XXXX")
(define-error 'ama-error-signal "SDDDDD")
(signal 'ama-error-signal '(x y))
(user-error "%d %s" 100 "XLIST")
;;(error-message-string "%S" 103) ---> ?????



;;command-error-function

(let (xxx fname)
  (setq fname "Not_EXIST.txt")
  (condition-case nil
      (delete-file fname)
    ;;((debug error) nil)))
    (error "DDDD")))
;;condition-case-unless-debug

(let (xx) 
  (defalias 'xx 'car)
  (xx (list 3 4 5)))

(defsubst func1 (a b c)
  (message (format "%S %S %S" a b c)))
(func1 12 13 14)

(setq f 'list)
(funcall f 3 4 5)

(apply '+ (list 3 4))

(defalias 'x1+ (apply-partially '+ 1)
  "Increment argument by one.")
(x1+ 10)

(identity 12)
(ignore 3 4 5)

(mapcar 'identity '((a b) (c d)))
(mapcar 'car '((a b) (c d)))
(mapconcat (function (lambda (x) (format "%c" (1+ x))))
           "HAL-8000"
           "")

(lambda (x) (* x x))
(function (lambda (x) (* x x)))
#'(lambda (x) (* x x))

(defun bar (n) (+ n 2))
(symbol-function 'bar)
(fset 'baz 'bar)
(symbol-function 'baz)
(baz 12)
(let (xxx)
  (when (fboundp 'baz)
    (fmakunbound 'baz)))

(fset 'baz #'(lambda (x) (+ x 101)))
(baz 12)

(defun my-tracing-function (proc string)
  (message "Proc %S received %S" proc string))

(defun test-function-filter ()
  (add-function :before (process-filter PROC) #'my-tracing-function)
  (remove-function (process-filter PROC) #'my-tracing-function)
  )

(defsubst f1(a b)
  (format "%d %d" a b))
(f1 3 4)

(defun fact (n)
  (if (zerop n) 1
    (* n (fact (1- n)))))
(debug-on-entry 'fact)
(fact 3)

(cancel-debug-on-entry 'fact)

(let (xxx)
  (setq xxx
        (with-output-to-string
          (princ "The buffer is ")
          (princ (buffer-name))))
  (message "XXX = %S" xxx))

(pp "DDDD")

(let (xxx)
  ;;(setq xxx (read-from-minibuffer "Input DL Number:"))
  ;;(setq xxx (read-string "Input DL:"))
  ;;(setq xxx (read-regexp "REGX:"))
  ;;(setq xxx (read-no-blanks-input "NoBlank:"))
  ;;(setq xxx (read-minibuffer "XXX:"))
  (setq xxx (eval-minibuffer "EVAL:"))
  (message "DL Number = %s" xxx)
    
  (edit-and-eval-command "Please edit: " '(forward-word 1))
  )
