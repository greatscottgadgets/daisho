#!/bin/sh

echo "This will clobber PBGA-289.mod, enter to continue, ctrl-c to abort"
read x

#PADSQ=0.5
PADR=0.35

echo "PCBNEW-LibModule-V1  `date +"%a %d %b %Y %r %Z"`" > PBGA-289.mod
cat << EOF >> PBGA-289.mod
# encoding utf-8
Units mm
\$INDEX
PBGA-289
\$EndINDEX
\$MODULE PBGA-289
Po 0 0 0 15 514C9BF2 00000000 ~~
Li PBGA-289
Sc 0
AR 
Op 0 0 0
T0 -7.35 -8.9 0.5 0.5 0 0.125 N V 21 N "PBGA-289"
T1 8.1 -8.9 0.5 0.5 0 0.125 N V 21 N "VAL**"
EOF

echo 'DS -9.6 -9.6 -9.6 9.6 0.15 21' >> PBGA-289.mod
echo 'DS 9.6 -9.6 9.6 9.6 0.15 21' >> PBGA-289.mod
echo 'DS -9.6 -9.6 9.6 -9.6 0.15 21' >> PBGA-289.mod
echo 'DS -9.6 9.6 9.6 9.6 0.15 21' >> PBGA-289.mod

echo 'DS -9.6 -9.0 -9.0 -9.6 0.15 21' >> PBGA-289.mod

rpos=-8
for r in A B C D E F G H J K L M N P R T U; do
	cpos=-8
	for c in `seq 1 17`; do
		cat << EOF >> PBGA-289.mod
\$PAD
Sh "$r$c" C $PADR $PADR 0 0 0
Dr 0 0 0
At SMD N 00888000
Ne 0 ""
Po $cpos $rpos
\$EndPAD
EOF
		cpos=$((cpos+1))
	done
	rpos=$((rpos+1))
done

# $PAD
# Sh "1" R 0.65 0.65 0 0 0
# Dr 0 0 0
# At SMD N 00888000
# Ne 0 ""
# Po -1.4 -2.45
# $EndPAD

cat << EOF >> PBGA-289.mod
\$EndMODULE PBGA-289
\$EndLIBRARY
EOF

