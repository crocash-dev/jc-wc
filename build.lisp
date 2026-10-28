(require :asdf)

(load (merge-pathnames "quicklisp/setup.lisp"
                       (user-homedir-pathname)))

(asdf:load-asd (truename "jc-wc.asd"))
(asdf:load-system "jc-wc")

(sb-ext:save-lisp-and-die
 "jc-wc"
 :executable t
 :toplevel #'jc-wc:main)
