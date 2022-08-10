#!/bin/env bash

if [ $# -gt 1 ]; then
    storeengine=$1
else
    storeengine=mars3
fi

function random_range() {
    local beg=$1
    local end=$2
    local rdm=`od -An -N2 -i /dev/urandom`
    echo $((${rdm} % ($end - $beg) + $beg))
}

vins=("H000AX81OATY67963" "H000GJXVUAVP83590" "H000OAYJZWF803735" "H001FJSRGIZD43447" "H001ICJRLOLA53439" "H001ILOGV8R112297" "H001XCBPBBL726520" "H001ZMZPAJPU41389" "H002MQDATUM777647" "H003BK0H8DB933726" "H003LOJVI5NS66214" "H003LPTZ9JYO39737" "H003MYUQVFIJ34196" "H003UINDIZDP74493" "H004IKTMFULT98649" "H004JB265BAH42163" "H004PQEP5W1S12131" "H005HFGO4FNG20041" "H006DNI3G3JP67465" "H006KPYIBLQ389735")

sn=`random_range 0 20`;
vin="'"${vins[${sn}]}"'"
output=query.out

echo "Random:"$sn
echo "Vin:"$vin
echo "Outputfile:"$output
echo "Storeninge"$storeengine

psql beili1 <<-EOF
\timing
\o $output
select * from vehicle_basic_data_$storeengine where vin=$vin;
select count(*) from vehicle_basic_data_$storeengine where vin=$vin;
select * from vehicle_basic_data_$storeengine where vin=$vin and ts<'2022-05-13 23:59:50' and ts>'2022-05-1 00:06:23' order by ts desc;
select count(*)  from vehicle_basic_data_$storeengine where vin=$vin and ts<'2022-05-13 23:59:50' and ts>'2022-05-1 00:06:23';
\timing
EOF
