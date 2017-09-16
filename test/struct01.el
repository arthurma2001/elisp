(require 'cl-lib)
1) default constructor
  (cl-defstruct circle
    x y radius)
  (let ((r (make-circle :x 100 :y 320 :radius 34)))
    (message "r.x = %d" (circle-x r))
    (message "r.y = %d" (circle-y r))
    (message "r.radius = %d" (circle-radius r)))

2). user's constructor
  (cl-defstruct (circle (:constructor circle-create))
    x y radius)
  (defun circle-create (x y radius)
    (let ((r (circle-create :x x :y y :radius radius)))
      (if (< radius 0)
          (error "must have non-negative radius")
        r)))
  (let ((r (circle-create 100 320 34)))
    (message "r.x = %d" (circle-x r))
    (message "r.y = %d" (circle-y r))
    (message "r.radius = %d" (circle-radius r)))

3). elisp's structure
(defstruct xrect
  x y w h)
(make-xrect :x 320 :y 444 :w 44 :h 32)

4). elisp structure slot
(defstruct (rectx
            ;; (:type list)
	    :named
	    (:constructor nil) ; no default construct
	    (:constructor new-rectx (x y w h)) ;; make-name
	    (:copier nil))   ;; default copy-name
  x y w h)
(let ( (q (new-rectx 320 444 44 32)))
  (message "rectx.w=%d" (rectx-w q)))



