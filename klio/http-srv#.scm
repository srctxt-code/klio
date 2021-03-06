;==============================================================================

; File: "http#.scm", Time-stamp: <2007-04-04 14:42:52 feeley>

; Copyright (c) 2005-2007 by Marc Feeley, All Rights Reserved.

;==============================================================================

(##namespace ("http-srv#"

; procedures

make-http-server
http-server-start!
reply-unbuffered
reply
reply-chunked

current-request

see-other

not-found
unauthorized

internal-error
not-implemented
service-unavaible

make-request
request?
request-attributes
request-attributes-set!
request-connection
request-connection-set!
request-method
request-method-set!
request-query
request-query-set!
request-server
request-server-set!
request-uri
request-uri-set!
request-version
request-version-set!

make-server
server?
server-method-table
server-method-table-set!
server-port-number
server-port-number-set!
server-threaded?
server-threaded?-set!
server-timeout
server-timeout-set!

read-content

))

;==============================================================================
