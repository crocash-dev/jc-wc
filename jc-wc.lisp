(defpackage #:jc-wc
  (:use #:common-lisp
	#:iterate)
  (:export #:main))

(in-package #:jc-wc)

;; Input file for testing
;;(defvar *input-file* "test.txt")
;;(defparameter *test-list* '("test.txt" "compare.txt" "test.txt"))


;; Word delimters for sum-words
(defparameter *word-delimeters* '(#\Space #\Tab #\Newline #\Vt #\Page #\Return))

;; Acceptable CLI arguments for use with the application
(defparameter *acceptable-args* '("-c" "-l" "-m" "-w"))


(defun main ()
  ;; SBCL has execuatable name first, discard it with REST
  (let* ((args (rest sb-ext:*posix-argv*)))
    ;; If there's no file (second args) process the piped input
    (cond
      ;; Only filename specified, so run-calculation has nil 1st arg
      ((not (member (first args) *acceptable-args* :test #'string=))
       (run-calculation 'nil (first args)))
      ;; only acceptable arg given, read from STDIN
      ((and (member (first args) *acceptable-args* :test #'string=)
	    (not (second args))) 
	   (run-calculation-stdin (first args) *standard-input*))    
      ;; Otherwise process the file with correct arg applied
      (t (loop-calculations (first args) (rest args))))))


;; Runs the calculation and prints results
(defun run-calculation (arg input-file)
  ;; If arg nil, there are no CLI arguments and thus standard output
  (cond	((not (uiop:file-exists-p input-file))
	 (format t "~&File not found. ~&"))
	 ((not arg)
	 (format t "~A ~A ~A ~A~&"
		 (sum-bytes input-file)
		 (sum-lines input-file)
		 (sum-words input-file)
		 input-file))
	;; Otherwise CLI args are processed
	((equal arg "-c")
	 (format t "~A ~A~&" (sum-bytes input-file) input-file))
	((equal arg "-l")
	 (format t "~A ~A~&" (sum-lines input-file) input-file))
	((equal arg "-m")
	 (format t "~A ~A~&" (sum-char input-file) input-file))
	((equal arg "-w")
	 (format t "~A ~A~&" (sum-words input-file) input-file))))

(defun loop-calculations (arg input-file-list)
  (iter (for file in input-file-list)
    (run-calculation arg file)))

(defun run-calculation-stdin (arg input-stream)
  ;; If arg nil, there are no CLI arguments and thus standard output
  (cond	((not arg)
	 (format t "~A ~A ~A ~&"
		 (sum-bytes-stdin input-stream)
		 (sum-lines-stdin input-stream)
		 (sum-words-stdin input-stream)))
	;; Otherwise CLI args are processed
	((equal arg "-c")
	 (format t "~A ~&" (sum-bytes-stdin input-stream)))
	((equal arg "-l")
	 (format t "~A ~&" (sum-lines-stdin input-stream)))
	((equal arg "-m")
	 (format t "~A ~&" (sum-char-stdin input-stream)))
	((equal arg "-w")
	 (format t "~A ~&" (sum-words-stdin input-stream)))))


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

(defun sum-words-stdin (input-stream)
  (let ((sum 0) (previous-char #\A))
    (iter (for char in-stream input-stream using #'read-char)
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

(defun sum-lines-stdin (input-stream)
  (let ((sum 0))
    (iter (for line in-stream input-stream using #'read-line)
      (incf sum))
    sum))

;; Character count
(defun sum-char (input-file)
  (let ((sum 0))
    (iter (for char in-file input-file using #'read-char)
	  (incf sum))
    sum))

(defun sum-char-stdin (input-stream)
  (let ((sum 0))
    (iter (for char in-stream input-stream using #'read-char)
	  (incf sum))
    sum))

;; Byte count
(defun sum-bytes (input-file)
  (let ((sum 0) (file (open input-file :element-type '(unsigned-byte 8))))
    (iter (for byte in-stream file using #'read-byte)
      (incf sum))
    (close file)
    sum))


(defun sum-bytes-stdin (input-stream)
  (let ((sum 0))
    (iter (for byte in-stream input-stream using #'read-byte)
      (incf sum))
    sum))
