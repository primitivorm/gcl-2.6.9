;; Copyright (C) 1994 M. Hagiya, W. Schelter, T. Yuasa

;; This file is part of GNU Common Lisp, herein referred to as GCL
;;
;; GCL is free software; you can redistribute it and/or modify it under
;;  the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;; 
;; GCL is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public 
;; License for more details.
;; 
;; You should have received a copy of the GNU Library General Public License 
;; along with GCL; see the file COPYING.  If not, write to the Free Software
;; Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.


;;;;	evalmacros.lsp


(in-package "LISP")

(export '(defvar defparameter defconstant))

(in-package "SYSTEM")


(eval-when (compile) (proclaim '(optimize (safety 2) (space 3))))
;(eval-when (eval compile) (defun si:clear-compiler-properties (symbol)))
(eval-when (eval compile) (setq si:*inhibit-macro-special* nil))

(defmacro sgen (&optional (pref "G"))
  `(load-time-value (gensym ,pref)))


(defmacro defvar (var &optional (form nil form-sp) doc-string)
  `(progn (si:*make-special ',var)
	  ,(if doc-string
	       `(si:putprop ',var ,doc-string 'variable-documentation))
	  ,(if form-sp
	       `(or (boundp ',var)
		    (setq ,var ,form)))
	  ',var)
	  )

(defmacro defparameter (var form &optional doc-string)
  (if doc-string
      `(progn (si:*make-special ',var)
              (si:putprop ',var ,doc-string 'variable-documentation)
              (setq ,var ,form)
              ',var)
      `(progn (si:*make-special ',var)
              (setq ,var ,form)
              ',var)))

(defmacro defconstant (var form &optional doc-string)
  (if doc-string
      `(progn (si:*make-constant ',var ,form)
              (si:putprop ',var ,doc-string 'variable-documentation)
              ',var)
      `(progn (si:*make-constant ',var ,form)
              ',var)))


;;; Each of the following macros is also defined as a special form.
;;; Thus their names need not be exported.

(defmacro and (&rest forms)
  (if (endp forms)
      t
      (let ((x (reverse forms)))
           (do ((forms (cdr x) (cdr forms))
                (form (car x) `(if ,(car forms) ,form)))
               ((endp forms) form))))
  )

(defmacro or (&rest forms)
  (if (endp forms)
      nil
      (let ((x (reverse forms)))
           (do ((forms (cdr x) (cdr forms))
                (form (car x)
                      (let ((temp (gensym)))
                           `(let ((,temp ,(car forms)))
                                 (if ,temp ,temp ,form)))))
               ((endp forms) form))))
  )
               
(defun parse-body-header (x &optional doc decl ctps &aux (a (car x)))
  (cond 
   ((unless (or doc ctps) (and (stringp a) (cdr x))) (parse-body-header (cdr x) a decl ctps))
   ((unless ctps (when (consp a) (eq (car a) 'declare)))  (parse-body-header (cdr x) doc (cons a decl) ctps))
   ((when (consp a) (eq (car a) 'check-type)) (parse-body-header (cdr x) doc decl (cons a ctps)))
   (t (values doc (nreverse decl) (nreverse ctps) x))))

(defmacro locally (&rest body)
  (multiple-value-bind
   (doc decls ctps body)
   (parse-body-header body)
   `(let (,@(mapcan (lambda (x &aux (z (pop x))(z (if (eq z 'type) (pop x) z)))
		      (case z
			    ((ftype inline notinline optimize) nil)
			    (otherwise (mapcar (lambda (x) (list x x)) x))))
		   (apply 'append (mapcar 'cdr decls))))
      ,@(when doc (list doc))
      ,@decls
      ,@ctps
      ,@body)))

(defmacro loop (&rest body &aux (tag (gensym)))
  `(block nil (tagbody ,tag (progn ,@body) (go ,tag))))

(import 'while 'user)
(defmacro while (test &rest forms)
 `(loop (unless ,test (return)) ,@forms) )

(defmacro defmacro (name vl &rest body)
  `(si:define-macro ',name (si:defmacro* ',name ',vl ',body)))

(defmacro defun (name lambda-list &rest body)
  (multiple-value-bind (doc decl body)
       (find-doc body nil)
    (if doc
        `(progn (setf (get ',name 'si:function-documentation) ,doc)
                (setf (symbol-function ',name)
                      #'(lambda ,lambda-list
                          ,@decl (block ,name ,@body)))
                ',name)
        `(progn (setf (symbol-function ',name)
                      #'(lambda ,lambda-list
                          ,@decl (block ,name ,@body)))
                ',name))))

; assignment

(defmacro psetq (&rest args)
   (do ((l args (cddr l))
        (forms nil)
        (bindings nil))
       ((endp l) (list* 'let* (nreverse bindings) (nreverse (cons nil forms))))
       (declare (object l))
       (let ((sym (gensym)))
            (push (list sym (cadr l)) bindings)
            (push (list 'setq (car l) sym) forms)))
   )

; conditionals

(defmacro cond (&rest clauses &aux (form nil))
  (let ((x (reverse clauses)))
    (dolist (l x form)
      (cond ((endp (cdr l))
	     (if (or (constantp (car l)) (eq l (car x)))
		 (setq form (car l))
	       (let ((sym (gensym)))
		 (setq form `(let ((,sym ,(car l))) (if ,sym ,sym ,form))))))
	    ((and (constantp (car l)) (car l))
	     (setq form (if (endp (cddr l)) (cadr l) `(progn ,@(cdr l)))))
	    ((setq form (if (endp (cddr l))
			    `(if ,(car l) ,(cadr l) ,form)
			  `(if ,(car l) (progn ,@(cdr l)) ,form))))))))


(defmacro when (pred &rest body)
  `(if ,pred (progn ,@body)))

(defmacro unless (pred &rest body)
  `(if (not ,pred) (progn ,@body)))

; program feature

(defmacro prog (vl &rest body &aux (decl nil))
  (do ()
      ((or (endp body)
           (not (consp (car body)))
           (not (eq (caar body) 'declare)))
       `(block nil (let ,vl ,@decl (tagbody ,@body)))
       )
      (push (car body) decl)
      (pop body))
  )

(defmacro prog* (vl &rest body &aux (decl nil))
  (do ()
      ((or (endp body)
           (not (consp (car body)))
           (not (eq (caar body) 'declare)))
       `(block nil (let* ,vl ,@decl (tagbody ,@body)))
       )
      (push (car body) decl)
      (pop body))
  )

; sequencing

(defmacro prog1 (first &rest body &aux (sym (gensym)))
  `(let ((,sym ,first)) ,@body ,sym))

(defmacro prog2 (first second &rest body &aux (sym (gensym)))
  `(progn ,first (let ((,sym ,second)) ,@body ,sym)))

; multiple values

(defmacro multiple-value-list (form)
  `(multiple-value-call 'list ,form))

(defmacro multiple-value-setq (vars form)
  (do ((vl vars (cdr vl))
       (sym (gensym))
       (forms nil)
       (n 0 (1+ n)))
      ((endp vl) `(let ((,sym (multiple-value-list ,form))) ,@forms))
      (declare (fixnum n) (object vl))
      (push `(setq ,(car vl) (nth ,n ,sym)) forms))
  )

(defmacro multiple-value-bind (vars form &rest body)
  (do ((vl vars (cdr vl))
       (sym (gensym))
       (bind nil)
       (n 0 (1+ n)))
      ((endp vl) `(let* ((,sym (multiple-value-list ,form)) ,@(nreverse bind))
                        ,@body))
      (declare (fixnum n) (object vl))
      (push `(,(car vl) (nth ,n ,sym)) bind))
  )

(defmacro do (control (test . result) &rest body
              &aux (decl nil) (label (gensym)) (vl nil) (step nil))
  (do ()
      ((or (endp body)
           (not (consp (car body)))
           (not (eq (caar body) 'declare))))
      (push (car body) decl)
      (pop body))
  (dolist (c control)
          (declare (object c))
    (if(symbolp  c) (setq c (list c)))
        (push (list (car c) (cadr c)) vl)
    (unless (endp (cddr c))
            (push (car c) step)
            (push (caddr c) step)))
  `(block nil
          (let ,(nreverse vl)
               ,@decl
               (tagbody
                ,label (if ,test (return (progn ,@result)))
                       (tagbody ,@body)
                       (psetq ,@(nreverse step))
                       (go ,label)))))

(defmacro do* (control (test . result) &rest body
               &aux (decl nil) (label (gensym)) (vl nil) (step nil))
  (do ()
      ((or (endp body)
           (not (consp (car body)))
           (not (eq (caar body) 'declare))))
      (push (car body) decl)
      (pop body))
  (dolist (c control)
          (declare (object c))
    (if(symbolp  c) (setq c (list c)))
        (push (list (car c) (cadr c)) vl)
    (unless (endp (cddr c))
            (push (car c) step)
            (push (caddr c) step)))
  `(block nil
          (let* ,(nreverse vl)
                ,@decl
                (tagbody
                 ,label (if ,test (return (progn ,@result)))
                        (tagbody ,@body)
                        (setq ,@(nreverse step))
                        (go ,label))))
  )

(defmacro case (keyform &rest clauses &aux (key (load-time-value (gensym "CASE"))) (c (reverse clauses)))
  (declare (optimize (safety 2)))
  (labels ((sw (x) `(eql ,key ',x))(dfp (x) (or (eq x t) (eq x 'otherwise)))
	   (v (x) (if (when (listp x) (not (cdr x))) (car x) x))
	   (m (x c &aux (v (v x))) (if (eq v x) (cons c v) v)))
	  `(let ((,key ,keyform))
	     (declare (ignorable ,key))
	     ,(let ((df (when (dfp (caar c)) (m (cdr (pop c)) 'progn))))
		(reduce (lambda (y c &aux (a (pop c))(v (v a)))
			  (when (dfp a) (error "default case must be last"))
			  `(if ,(if (when (eq a v) (listp v)) (m (mapcar #'sw v) 'or) (sw v)) ,(m c 'progn) ,y))
			c :initial-value df)))))

(defmacro ecase (keyform &rest clauses &aux (key (sgen "ECASE")))
  (declare (optimize (safety 2)))
  `(let ((,key ,keyform))
     (declare (ignorable ,key))
     (case ,key
	   ,@(mapcar (lambda (x) (if (member (car x) '(t otherwise)) (cons (list (car x)) (cdr x)) x)) clauses)
	   (otherwise
	    (error 'type-error :datum ,key
		   :expected-type '(member ,@(apply 'append (mapcar (lambda (x &aux (x (car x))) (if (listp x) x (list x))) clauses))))))))


(defmacro ccase (keyform &rest clauses &aux (key (sgen "CCASE")))
  (declare (optimize (safety 2)))
  `(let ((,key ,keyform))
     (declare (ignorable ,key))
     (do nil (nil)
      (case ,key
	    ,@(mapcar (lambda (x &aux (k (pop x)))
			`(,(if (member k '(t otherwise)) (list k) k) (return ,(if (cdr x) (cons 'progn x) (car x))))) clauses)
	    (otherwise 
	     (check-type ,key (member ,@(apply 'append (mapcar (lambda (x &aux (x (car x))) (if (listp x) x (list x))) clauses)))))))))

(defmacro return (&optional (val nil)) `(return-from nil ,val))

(defmacro dolist ((var form &optional (val nil)) &rest body
                                                 &aux (temp (gensym)))
  `(do* ((,temp ,form (cdr ,temp)) (,var (car ,temp) (car ,temp)))
	((endp ,temp) ,val)
	,@body))

;; In principle, a more complete job could be done here by trying to
;; capture fixnum type declarations from the surrounding context or
;; environment, or from within the compiler's internal structures at
;; compile time.  See gcl-devel archives for examples.  This
;; implementation relies on the fact that the gcc optimizer will
;; eliminate the bignum branch if the supplied form is a symbol
;; declared to be fixnum, as the comparison of a long integer variable
;; with most-positive-fixnum is then vacuous.  Care must be taken in
;; making comparisons with most-negative-fixnum, as the C environment
;; appears to treat this as positive or negative depending on the sign
;; of the other argument in the comparison, apparently to symmetrize
;; the long integer range.  20040403 CM.
(defmacro dotimes ((var form &optional (val nil)) &rest body)
  (cond
   ((symbolp form)
    (let ((temp (gensym)))
      `(cond ((< ,form 0)
	      (let ((,var 0))
		(declare (fixnum ,var) (ignorable ,var))
		,val))
	     ((<= ,form most-positive-fixnum)
                 (let ((,temp ,form))
                   (declare (fixnum ,temp))
                   (do* ((,var 0 (1+ ,var))) ((>= ,var ,temp) ,val)
                     (declare (fixnum ,var))
                     ,@body)))
                (t 
		 (let ((,temp ,form))
		   (do* ((,var 0 (1+ ,var))) ((>= ,var ,temp) ,val)
		     ,@body))))))
	((constantp form)
	 (cond ((< form 0)
		`(let ((,var 0))
		   (declare (fixnum ,var) (ignorable ,var))
		   ,val))
	       ((<= form most-positive-fixnum)
		`(do* ((,var 0 (1+ ,var))) ((>= ,var ,form) ,val)
		   (declare (fixnum ,var))
		   ,@body))
	       (t
		`(do* ((,var 0 (1+ ,var))) ((>= ,var ,form) ,val)
		   ,@body))))
	(t
	 (let ((temp (gensym)))
	 `(let ((,temp ,form))
	    (cond ((< ,temp 0)
		   (let ((,var 0))
		     (declare (fixnum ,var) (ignorable ,var))
		     ,val))
		  ((<= ,temp most-positive-fixnum)
		   (let ((,temp ,temp))
		     (declare (fixnum ,temp))
		     (do* ((,var 0 (1+ ,var))) ((>= ,var ,temp) ,val)
		       (declare (fixnum ,var))
		       ,@body)))
		  (t 
		   (do* ((,var 0 (1+ ,var))) ((>= ,var ,temp) ,val)
		     ,@body))))))))


(defmacro declaim (&rest l)
 `(eval-when (compile eval load)
	     ,@(mapcar #'(lambda (x) `(proclaim ',x)) l)))

(defmacro lambda ( &rest l) `(function (lambda ,@l)))

(defun compiler-macro-function (name)
  (get name 'compiler-macro-prop))
