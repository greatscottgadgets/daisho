#!/bin/sh

if test $# -lt 4; then
	echo "Expected $0 <odd first pin> <last pin> <hoffst> <voffst>"
	exit 1
fi

startpin=$1
endpin=$2
startofft=$3
vofft=$4

# odd pins first, negative voffset
offt=${startofft}
for pin in `seq $startpin 2 $endpin`; do

cat << EOF
\$PAD
Sh "${pin}" R 0.3 1.05 0 0 0
Dr 0 0 0
At SMD N 00888000
Ne 0 ""
Po ${offt} -${vofft} 
\$EndPAD
EOF

offt=`echo "scale=4; $offt+0.5" | bc ;exit`

done

# Even pins, positive offset
offt=${startofft}
for pin in `seq $(($startpin+1)) 2 $endpin`; do

cat << EOF 
\$PAD
Sh "${pin}" R 0.3 1.05 0 0 0
Dr 0 0 0
At SMD N 00888000
Ne 0 ""
Po ${offt} ${vofft} 
\$EndPAD
EOF

offt=`echo "scale=4; $offt+0.5" | bc ;exit`

done


