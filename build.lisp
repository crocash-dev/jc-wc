(require :asdf)

(asdf:load-system "jc-wc")

(sb-ext:save-lisp-and-die
 "jc-wc"
 :executable t
 :toplevel #'jc-wc:main)
