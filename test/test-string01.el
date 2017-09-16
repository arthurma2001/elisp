(let (xxx)
  (setq xxx "void")
  (string= "void" xxx)
  (string-equal "void" xxx))

(substring "abcdefg" -3)
(substring "abcdefg" 0 3)
(substring "abcdefg" -3 -1)

(with-temp-buffer
  (insert "abcdefg")
  (buffer-substring 2 4))