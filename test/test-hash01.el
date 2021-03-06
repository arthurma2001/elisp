(require 'subr-x)

(defun ama-hash-to-list (xhash)
  (let (result)
    (maphash (lambda (k v)
               (push (list k v) result))
             xhash)
    result))

(let (xxx xxx2 alst)
  (setq xxx (make-hash-table :test 'equal))
  (puthash "xx3" 130 xxx)
  (puthash "xx1" 128 xxx)
  (puthash "xx2" 129 xxx)
  (gethash "xx1" xxx 888)
  (hash-table-p xxx)
  (hash-table-count xxx)
  (hash-table-keys xxx)
  (remhash "xx1" xxx)
  (setq alst (ama-hash-to-list xxx))
  (sort alst (lambda (a b) (string< (car a) (car b))))
  (setq xxx2 (copy-hash-table xxx))
  (clrhash xxx2)
  )

