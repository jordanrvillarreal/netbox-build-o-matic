#!/usr/bin/expect

set timeout -1
spawn ./step2.sh

expect "Password:"
send -- "adminpass\r"
expect "Password (again):"
send -- "adminpass\r"
expect eof
