;; charsets#.scm - Srfi-14 char-set library
;;
;; Copyright (c) 2010 by Marco Benelli <mbenelli@yahoo.com>
;; All Rights Reserved.


(namespace
 ("charsets#"
                                        ; predicates & comparison
  char-set?
  char-set=
  char-set<=
  char-set-hash
                                        ; iterating over character sets
  char-set-cursor
  char-set-ref
  char-set-cursor-next
  end-of-char-set?
  char-set-fold
  char-set-unfold
  char-set-unfold!
  char-set-for-each
  char-set-map
                                        ; creating character sets
  char-set-copy  
  char-set
  list->char-set
  list->char-set!
  string->char-set
  string->char-set!
  char-set-filter
  char-set-filter!
  ucs-range->char-set
  ucs-range->char-set!
                                        ; querying character sets
  char-set->list
  char-set->string
  char-set-size
  char-set-count
  char-set-contains?
  char-set-every
  char-set-any
                                        ; character-set algebra
  char-set-adjoin
  char-set-adjoin!
  char-set-delete
  char-set-delete!
  char-set-complement
  char-set-complement!
  char-set-union!
  char-set-union
  char-set-intersection
  char-set-intersection!
  char-set-difference
  char-set-difference!
  char-set-xor
  char-set-xor!
  char-set-diff+intersection
  char-set-diff+intersection!
                                        ; standard character sets
  char-set:empty
  char-set:full
  char-set:lower-case
  char-set:upper-case
  char-set:title-case
  char-set:letter
  char-set:digit
  char-set:hex-digit
  char-set:letter+digit
  char-set:punctuation
  char-set:symbol
  char-set:graphic
  char-set:whitespace
  char-set:printing
  char-set:blank
  char-set:iso-control
  char-set:ascii
  ))
