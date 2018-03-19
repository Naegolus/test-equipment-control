#!/bin/sh

funcGenDir="../pyFY3200S"
osciDir="../eevt002"

exeCmd()
{
	#echo "Executing: '$1'"
	${osciDir}/cmd.py  "$1"
}

echo "Initializing function generator"
${funcGenDir}/setWaveform.py 0 0
${funcGenDir}/setAmplitude.py 0 4
${funcGenDir}/setOffset.py 0 2.5
#${funcGenDir}/setFrequency.py 0 2000000

echo "Initializing oscilloscope"
echo "ID:      $(${osciDir}/cmd.py "*idn?")"
echo "Version: $(${osciDir}/cmd.py ":syst:vers?")"
echo "Date:    $(${osciDir}/cmd.py ":syst:date?")"

echo "Reseting"
exeCmd "*rst"
sleep 1.0
exeCmd ":tim:scal 2.5e-8"
exeCmd ":trig:edg:lev 2.5"

echo "Channel 2"
cid="2"
exeCmd ":chan${cid}:disp off"
exeCmd ":chan${cid}:prob 10"

echo "Channel 1"
cid="1"
exeCmd ":chan${cid}:prob 10"
exeCmd ":chan${cid}:scal 1"
exeCmd ":chan${cid}:offs -4.0"

counterPostfix="000000"
for i in `seq 0 4${counterPostfix} 20${counterPostfix}`
do
	echo "Setting frequency: $i"
	${funcGenDir}/setFrequency.py 0 $i
	sleep 0.2
	echo "Vpp = $(${osciDir}/cmd.py ":meas:vpp? chan1") [V]"
done
