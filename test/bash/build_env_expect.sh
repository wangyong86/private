#!/bin/env bash
# expect is a tcl program
# spawn is a comand of expect
# expet {} enclose a series of pattern, except last, use exp_continue;
# interact and execpect eof is necessary
# pass command block to expect is a safe method. Instead, #!/bin/expect -f should be ok
changepasswd(){
for ip in `cat iplist`
do
/bin/expect  << EOF
spawn ssh $ip sudo passwd wy
expect {
	"New password:" { send "!@#$%^\n";exp_continue }
	"new password:" { send "!@#$%^\n"}
}
interact
expect eof 
EOF
done
}

genkey(){
for ip in `cat iplist`
do
/bin/expect  << EOF
spawn ssh wy@$ip ssh-keygen
expect {
	"password:" { send "!@#$%^\n";exp_continue }
	"id_rsa):" { send "\n";exp_continue }
	"passphrase):" { send "\n";exp_continue}
	"again:" { send "\n"}
}
interact
expect eof 
EOF
done
}

copyid(){
for ip in `cat iplist`
do
/bin/expect  << EOF
spawn ssh-copy-id wy@$ip
expect {
	"(yes/no)?" {send "yes\n";exp_continue}
	"password:" { send "!@#$%^\n"}
}
interact
expect eof 
EOF
done
}

#changepasswd
#genkey
copyid
