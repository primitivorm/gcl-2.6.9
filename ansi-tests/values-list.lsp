;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Mon Jan 13 16:53:39 2003
;;;; Contains: Tests for VALUES-LIST

(in-package :cl-test)

(deftest values-list.error.1
  (classify-error (values-list))
  program-error)

(deftest values-list.error.2
  (classify-error (values-list nil nil))
  program-error)

(deftest values-list.1
  (values-list nil))

(deftest values-list.2
  (values-list '(1))
  1)

(deftest values-list.3
  (values-list '(1 2))
  1 2)

(deftest values-list.4
  (values-list '(a b c d e f g h i j))
  a b c d e f g h i j)

(deftest values-list.5
  (let ((x (loop for i from 1 to (min 1000
				      (1- call-arguments-limit)
				      (1- multiple-values-limit))
		 collect i)))
    (equalt x
	    (multiple-value-list (values-list x))))
  t)

  
