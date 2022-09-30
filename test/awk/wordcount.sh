cat >words1 <<EOF
fqef word4
wfww word3
EOF


cat > words2 <<EOF
word4 aaa
word2 fwww
word1 fwwww
EOF

awk '{a[$n]++}END{for(b in a)print b,a[b]}' n=2 words1 n=1 words2

rm words1 words2
