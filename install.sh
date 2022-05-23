#!/usr/bin/expect

set timeout -1
spawn ./bulk.sh

expect "Password:"
send -- "adminpass\r"
expect "Password (again):"
send -- "adminpass\r"
expect eof