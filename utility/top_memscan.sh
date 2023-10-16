for host in `cat oiplist`
do
echo -n "$host:"
ssh $host "top -b -c -n 1 -o '%CPU' |grep -A 1 PID|grep -v PID|head -1"
done
