(defpackage #:jc-wc
  (:use #:common-lisp
	#:iterate)
  (:export #:main))

(in-package #:jc-wc)

;; Input file
(defvar *input-file* "test.txt")

(defparameter *word-delimeters* '(#\Space #\Tab #\Newline #\Vt #\Page #\Return))

(defparameter *acceptable-args* '("-c" "-l" "-m" "-w"))

(defun main ()
  ;; SBCL has execuatable name first, discard it with REST
  (let* ((args (rest sb-ext:*posix-argv*)))
    ;; If there's no file (second args) process the piped input
    (cond
      ;; Only filename specified, so run-calculation has nil 1st arg
      ((not (member (first args) *acceptable-args*))
       (run-calculation 'nil (first args)))
      ;; Only cli arg given, read from STDIN
      ((and (member (first args) *acceptable-args*) (not (second args)))
       (run-calculation (first args) *standard-input*))    
      ;; Otherwise process the file with correct arg applied
      (t (run-calculation (first args) (second args))))))

;; Runs the calculation and prints results
(defun run-calculation (arg input-stream)
  (cond	((not arg)
	 (format t "~A ~A ~A ~A"
		 (sum-bytes input-stream)
		 (sum-lines input-stream)
		 (sum-words input-stream)
		 input-stream))
	((equal arg "-c")
	 (format t "~A ~A" (sum-bytes input-stream) input-stream))
	((equal arg "-l")
	 (format t "~A ~A" (sum-lines input-stream) input-stream))
	((equal arg "-m")
	 (format t "~A ~A" (sum-char input-stream) input-stream))
	((equal arg "-w")
	 (format t "~A ~A" (sum-words input-stream) input-stream))))
   

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


