(let (a b)
  (setq a "abcdefg")
  (message (format "sequencep=%S" (sequencep a)))
  (message (format "elt 3=%c" (elt a 3)))
  (message (format "length(a) = %d" (length a)))
  (setq b (copy-sequence a))
  (message (format "copy-sequence(a) = %S" b))
  )