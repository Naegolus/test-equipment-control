#!/bin/sh

funcGenDir="../pyFY3200S"
osciDir="../eevt002"

echo "Initializing function generator"
#${funcGenDir}/setWaveform.py 0 0
#${funcGenDir}/setAmplitude.py 0 4
#${funcGenDir}/setOffset.py 0 2.5
#${funcGenDir}/setFrequency.py 0 2000000

echo "Initializing oscilloscope"

counterPostfix="000000"
for i in `seq 0 2${counterPostfix} 10${counterPostfix}`
do
	echo "Setting frequency: $i"
	${funcGenDir}/setFrequency.py 0 $i
done
