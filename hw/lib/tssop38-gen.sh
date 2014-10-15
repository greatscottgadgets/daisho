#!/bin/sh

hofft=3.625
skip=0.50

vofft=0
for pin in `seq 1 19`; do

cat << EOF
\$PAD
Sh "${pin}" R 1.43 0.28 0 0 0
Dr 0 0 0
At SMD N 00888000
Ne 0 ""
Po -${hofft} ${vofft} 
\$EndPAD
EOF

vofft=`echo "scale=4; $vofft+$skip" | bc ;exit`

done

vofft=0
for pin in `seq 20 38`; do

cat << EOF
\$PAD
Sh "${pin}" R 1.43 0.28 0 0 0
Dr 0 0 0
At SMD N 00888000
Ne 0 ""
Po ${hofft} ${vofft} 
\$EndPAD
EOF

vofft=`echo "scale=4; $vofft+$skip" | bc ;exit`

done

exit


