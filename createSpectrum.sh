#!/bin/sh

funcGenDir="../pyFY3200S"
osciDir="../eevt002"
outFile="./spec.csv"

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
sleep 2.0

echo "Channel 2"
cid="2"
exeCmd ":chan${cid}:prob 10"
exeCmd ":chan${cid}:scal 2"
exeCmd ":chan${cid}:offs -6.0"

echo "Channel 1"
cid="1"
#exeCmd ":chan${cid}:disp off"
exeCmd ":chan${cid}:prob 10"
exeCmd ":chan${cid}:scal 2"
exeCmd ":chan${cid}:offs 0.0"

echo "Misc."
exeCmd ":tim:scal 2.5e-8"
exeCmd ":trig:edg:lev 2.5"
echo

echo "Creating ${outFile}"
#echo "Setting frequency: 0"
${funcGenDir}/setFrequency.py 0 0
sleep 0.2
amp1=$(${osciDir}/cmd.py ":meas:vavg? chan1")
#echo "Vpp1 = ${amp1} [V]"
amp2=$(${osciDir}/cmd.py ":meas:vavg? chan2")
#echo "Vpp2 = ${amp2} [V]"

echo "0; ${amp1}; ${amp2}" > ${outFile}

counterPostfix="000000"
for i in $(seq 4${counterPostfix} 4${counterPostfix} 20${counterPostfix})
do
	#echo "Setting frequency: $i"
	${funcGenDir}/setFrequency.py 0 $i
	sleep 0.2
	amp1=$(${osciDir}/cmd.py ":meas:vpp? chan1")
	#echo "Vpp1 = ${amp1} [V]"
	amp2=$(${osciDir}/cmd.py ":meas:vpp? chan2")
	#echo "Vpp2 = ${amp2} [V]"

	echo "$i; ${amp1}; ${amp2}" >> ${outFile}
done

echo "Done"
