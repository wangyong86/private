#set -x
Q()
{
    'psql' -d "$dbname" -P pager=off -Atq "$@"
}

querydir=queries
rstdir=rst
mkdir -p $rstdir 2>/dev/null 1>&2
for query in `ls $querydir/mxdb*.sql`
do
    for i in  `seq 1 1`
    do
        cat  <<$$
        \o ${rstdir}/${query}.analzye
        \i p;
        \i $query;
        \i $query;
        \i $query;
        \i $query;
$$
    done |Q|awk 'BEGIN{count=0;min=9999;max=0;time=0;}{count++; print "++"$2;if (count>s) {time+=$2}; if ($2<min) min=$2; if ($2>max) max=$2}END{print time/(count-s) " "min " "max}' s=1
done 
