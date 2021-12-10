#!/bin/env bash

stringZ=abcABC123ABCabc

#length
echo ${#stringZ}
echo `expr length $stringZ`
echo `expr "$stringZ" : '.*'` # char number?

#substring
echo `expr match "$stringZ" 'abc[A-Z]*.2'`
echo `expr "$stringZ" : 'abc[A-Z]*.2'`
