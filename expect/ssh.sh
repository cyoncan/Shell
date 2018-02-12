#!/usr/bin/expect
set timeout 1
set username [lindex $argv 0]
set password [lindex $argv 1]
set hostname [lindex $argv 2]

spawn ssh $username@$hostname
expect {
    "(yes/no)?"
    {
        send "yes\n"
        expect "assword:"{send "$password\n"}
    }
    "*assword:"
    {
        send "$password\n"
    }
}