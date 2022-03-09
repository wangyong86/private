#command: tsar --mem --tcp --traffic --io --sda --pcsw --tcpx

#!/bin/bash
cpu_begin=
cpu_end=
mem_begin=2
mem_cols=6
tcp_begin=8
tcp_cols=8
traffic_begin=16
traffic_cols=6
io_begin=22
io_cols=272
sda_begin=294
sda_cols=17
pcsw_begin=311
pcsw_cols=2
tcpx_begin=313
tcpx_cols=15

input=$1
filterrange(){
	begin=$1
	end=`expr $2 + $1 - 1`
	echo "filter "$3
	awk -v b=$begin -v e=$end '{printf $1" "; for(i=b; i<=e; i++) {printf $i"\t"}; printf "\n" }' $input >$3.out 
}

filterio(){
	begin=$io_begin
	interval=34
	devnr=8
	rsecs=7
	wsecs=8
	util=17
	echo "filterrio"
	awk -v b=$begin -v n=$devnr -v t=$interval -v r=$rsecs -v w=$wsecs -v u=$util                             \
				'{ printf $1"\t"; for(i=0;i<n;i++) {printf $(b+i*t+r-1)"\t"$(b+i*t+w-1)"\t"$(b+i*t+u-1)"\t"}; printf "\n"}' $input \
				| grep -v "^\t"|awk '{ if (!/Time/ || NR<2) print $0}' >$1.out
}

filterrange $mem_begin $mem_cols mem
filterrange $tcp_begin $tcp_cols tcp
filterrange $traffic_begin $traffic_cols traffic
filterrange $io_begin $io_cols io
filterrange $sda_begin $sda_cols sda
filterrange $pcsw_begin $pcsw_cols pcsw
filterrange $tcpx_begin $tcpx_cols tcpx
filterio sio
