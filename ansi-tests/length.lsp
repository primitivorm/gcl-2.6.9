;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Tue Aug 20 23:25:29 2002
;;;; Contains: Test cases for LENGTH

(in-package :cl-test)

(deftest length-list.1
  (length nil)
  0)

(deftest length-list.2
  (length '(a b c d e))
  5)

(deftest length-list.3
    (length (make-list 200000))
  200000)

(defun length-list-4-body ()
  (let ((x ()))
    (loop
     for i from 0 to 999 do
     (progn
       (unless (eql (length x) i) (return nil))
       (push i x))
     finally (return t))))

(deftest length-list-4
  (length-list-4-body)
  t)

(deftest length-vector.1
  (length #())
  0)

(deftest length-vector.2
  (length #(a))
  1)

(deftest length-vector.3
  (length #(a b))
  2)

(deftest length-vector.4
  (length #(a b c))
  3)

(deftest length-nonsimple-vector.1
  (length (make-array 10 :fill-pointer t :adjustable t))
  10)

(deftest length-nonsimple-vector.2
  (let ((a (make-array 10 :fill-pointer t :adjustable t)))
    (setf (fill-pointer a) 5)
    (length a))
  5)

(deftest length-bitstring.1
  (length #*)
  0)

(deftest length-bitstring.2
  (length #*1)
  1)

(deftest length-bitstring.3
  (length #*0)
  1)

(deftest length-bitstring.4
  (length #*010101)
  6)

(deftest length-string.1
  (length "")
  0)

(deftest length-string.2
  (length "a")
  1)

(deftest length-string.3
  (length "abcdefghijklm")
  13)

(deftest length-string.4
  (length "\ ")
  1)

;;; Error cases

(deftest length.error.1
  (classify-error (length 'a))
  type-error)

(deftest length.error.2
  (classify-error (length 10))
  type-error)

(deftest length.error.3
  (classify-error (length 1.0))
  type-error)

(deftest length.error.4
  (classify-error (length #\a))
  type-error)

(deftest length.error.5
  (classify-error (length 10/3))
  type-error)

(deftest length.error.6
  (classify-error (length))
  program-error)

(deftest length.error.7
  (classify-error (length nil nil))
  program-error)

(deftest length.error.8
  (classify-error (locally (length 'a) t))
  type-error)

;;; Length on vectors created with make-array

(deftest array-length-1
  (length (make-array '(20)))
  20)

(deftest array-length-2
  (length (make-array '(100001)))
  100001)

(deftest array-length-3
  (length (make-array '(0)))
  0)

(deftest array-length-4
  (let ((x (make-array '(100) :fill-pointer 10)))
    (length x))
  10)

(deftest array-length-5
  (let ((x (make-array '(100) :fill-pointer 10)))
    (setf (fill-pointer x) 20)
    (length x))
  20)
