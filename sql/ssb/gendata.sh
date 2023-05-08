#!/usr/bin/env bash
srcdir=`pwd`
scale=100
datadir=/data1/wy/ssb/data

rm -rf $datadir
mkdir -p $datadir

ln -nfs $datadir data
cd data

ln -nfs $srcdir/dists.dss .

$srcdir/dbgen -s $scale -T c
$srcdir/dbgen -s $scale -T l
$srcdir/dbgen -s $scale -T p
$srcdir/dbgen -s $scale -T s
$srcdir/dbgen -s $scale -T d
