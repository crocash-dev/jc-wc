(defpackage :jc-wc
  (:use :common-lisp
   :iterate))

(in-package :jc-wc)

;; Input file
(defparameter *input-file* "test.txt")

(defparameter *word-delimeters* '(#\Space #\Tab #\Newline #\Vt #\Page #\Return))

;; Wordcount
(defun sum-words (input-file)
  (let ((sum 0) (previous-char #\A))
    (iter (for char in-file input-file using #'read-char)
      (cond  ((and (not (member previous-char *word-delimeters*))
		  (member char *word-delimeters*))
	      (incf sum)
	      (setf previous-char char))
	     (t (setf previous-char char))))
    sum))

;; Line count
(defun sum-lines (input-file)
  (let ((sum 0))
    (iter (for line in-file input-file using #'read-line)
      (incf sum))
    sum))

;; Character count
(defun sum-char (input-file)
  (let ((sum 0))
    (iter (for char in-file input-file using #'read-char)
	  (incf sum))
    sum))

;; Byte count
(defun sum-bytes (input-file)
  (let ((sum 0) (file (open input-file :element-type '(unsigned-byte 8))))
    (iter (for byte in-stream file using #'read-byte)
      (incf sum))
    (close file)
    sum))
