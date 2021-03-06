;;; fwtest.scm - Test for fetch-write protocol.
;;;
;;; Copyright (c) 2011 by Marco Benelli <mbenelli@yahoo.com>
;;; All Right Reserved.
;;;
;;; Author: Marco Benelli <mbenelli@yahoo.com>
;;;

(##include "../klio/ctypes#.scm")
(##include "../klio/binary-io#.scm")
(##include "../klio/fetchwrite#.scm")

(define address (make-parameter "localhost"))

(define (test-fetch-db)
  (let* ((fp (open-tcp-client
               `(server-address: ,(address) port-number: 2000)))
         (res (fetch-db 62 0 250 fp)))
    (pp res)
    (close-port fp)))

; TODO: clean up, test alternatives and move all the endianess-aware code
; to ctypes.

(define native-endianess (make-parameter 'little))

(define (read-f32vector n port endianess)
  (let* ((res (make-f32vector n))
	 (float-buffer (make-u8vector 4))
	 (push-value
	   (if (eq? endianess (native-endianess))
	       (lambda (i)
		 (vector-set! res i (read-f32 port)))
	       (lambda (i)
		 (u8vector-set! float-buffer 3 (read-u8 port))
		 (u8vector-set! float-buffer 2 (read-u8 port))
		 (u8vector-set! float-buffer 1 (read-u8 port))
		 (u8vector-set! float-buffer 0 (read-u8 port))
		 (f32vector-set! res i (with-input-from-u8vector
					 float-buffer
					 read-f32))))))
    (do ((i 0 (+ i 1)))
      ((= i n) res)
      (push-value i))))


;; From http://okmij.org/ftp/Scheme/binary-io.html
;; Slighty modified.

(define (combine . bytes)
  (let loop ((bytes bytes) (accum 0))
    (if (null? bytes) accum
        (loop (cdr bytes)
              (+ (* 256 accum) (car bytes))))))

(define (read-float port)
  (let* ((b1 (read-u8 port))
         (b2 (read-u8 port))
         (b3 (read-u8 port))
         (b4 (read-u8 port)))
    (cond
      ((and (zero? b1) (zero? b2) (zero? b3) (zero? b4)) 0.0)
      (else
         (let* ((sign-neg
                (and (> b1 127) (begin (set! b1 (- b1 128)) #t)))
                (full-exp (+ (* 2 b1)
                             (if (> b2 127)
                                 (begin (set! b2 (- b2 128)) 1) 0)))
                (num
                 (if (= 255 full-exp)
                     #f         ; won't handle NaN and +Inf, -Inf
		     ; For Bigloo, change (expt 2 full-exp)
		     ; to read: (expt 2 full-exp)
                     (* (expt 2.0 full-exp)
                        (combine
                         (if (zero? full-exp) b2 (+ b2 128))
                         b3 b4)
                        (if (zero? full-exp) 1.401298464324817e-45
                            7.006492321624085e-46)))))
           (if sign-neg (and num (- num)) num))))))


(define (read-floats-vector n port)
  (let ((res (make-f32vector n)))
    (do ((i 0 (+ i 1)))
      ((= n i) res)
      (f32vector-set! res i (read-float port)))))

(define (read-ieee-f32vector n port)
  (let ((res (make-f32vector n)))
    (do ((i 0 (+ i 1)))
      ((= i n) res)
      (f32vector-set! res i (read-ieee-float32 port 'big-endian)))))

(define (test-reading-floats v n)
  (println "=====     read-f32vector")
  (time
    (do ((i 0 (+ i 1)))
      ((= i n) 'done)
      (call-with-input-u8vector v
	(lambda (port)
	  (read-f32vector 32 port 'big)))))
  (println "=====     read-floats-vector")
  (time
    (do ((i 0 (+ i 1)))
      ((= i n) 'done)
      (call-with-input-u8vector v
	(lambda (port)
	  (read-floats-vector 32 port)))))
  (println "=====     read-ieee-float32")
  (time
    (do ((i 0 (+ i 1)))
      ((= i n) 'done)
      (call-with-input-u8vector v
	(lambda (port)
	  (read-ieee-f32vector 32 port))))))

(define-type
  query0

  measures
  alarms
  enablings
  prms)


(define (read-db p)
  (let ((measures #f)
	(alarms (make-u8vector 10))
	(enablings (make-u8vector 16))
	(prms #f))
    (set! measures (read-ieee-f32vector 32 p))
    (read-subu8vector alarms 0 10 p)
    (read-subu8vector enablings 0 16 p)
    (set! prms (read-ieee-f32vector 24 p))
    (make-query0 measures alarms enablings prms)))


(define (test-fetch/apply)
  (let ((p (open-tcp-client
	     `(server-address: ,(address) port-number: 2000))))
    (fetch/apply 62 0 250 read-db p)))

;(define q0 (call-with-input-u8vector r read-db))

;; Sample output.

(define r
  '#u8(
                                        ; measure 0
       66
       242
       4
       108
                                        ; 1
       67
       159
       74
       131
                                        ; 2
       0
       0
       0
       0
                                        ; 3
       0
       0
       0
       0
                                        ; 4
       0
       0
       0
       0
                                        ; 5
       0
       0
       0
       0
                                        ; 6
       64
       224
       0
       0
                                        ; 7
       65
       166
       149
       142
                                        ; 8
       0
       0
       0
       0
                                        ; 9
       0
       0
       0
       0
                                        ; 10
       0
       0
       0
       0
                                        ; 11
       0
       0
       0
       0
                                        ; 12
       0
       0
       0
       0
                                        ; 13
       0
       0
       0
       0
                                        ; 14
       65
       1
       213
       9
                                        ; 15
       0
       0
       0
       0
                                        ; 16
       66
       242
       4
       108
                                        ; 17
       0
       0
       0
       0
                                        ; 18
       0
       0
       0
       0
                                        ; 19
       0
       0
       0
       0
                                        ; 20
       0
       0
       0
       0
                                        ; 21
       0
       0
       0
       0
                                        ; 22
       0
       0
       0
       0
                                        ; 23
       0
       0
       0
       0
                                        ; 24
       0
       0
       0
       0
                                        ; 25
       0
       0
       0
       0
                                        ; 26
       66
       242
       4
       119
                                        ; 27
       0
       0
       0
       0
                                        ; 28
       0
       0
       0
       0
                                        ; 29
       65
       152
       0
       0
                                        ; 30
       0
       0
       0
       0
                                        ; 31
       0
       0
       0
       0
                                        ; 
       0
       0
       0
       0
                                        ; Alarms
       0
       0
       0
       0
       0
       0
       9
       0
       0
       141
                                        ; misc
       0
       0
       
       11
       232
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       67
       22
       
       0
       0
       0
       0
       
       0
       0
       64
       64
       
       0
       0
       66
       72
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0
       0
       0
       
       0
       0))

