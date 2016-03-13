#!/bin/bash
###############################################################################################################################
## Source: https://gist.githubusercontent.com/ecampidoglio/5009512/raw/2efdb8535b30c2f8f9a391f055216c2a7f37e28b/cpustatus.sh ##
###############################################################################################################################
# cpustatus
#
# Prints the current state of the CPU like temperature, voltage and speed.
# The temperature is reported in degrees Celsius (C) while
# the CPU speed is calculated in megahertz (MHz).

### TODO
# show cpu uage:
#echo CPU: `top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`

function convert_to_MHz {
    let value=$1/1000
    echo "$value"
}

function calculate_overvolts {
    # We can safely ignore the integer
    # part of the decimal argument
    # since it's not realistic to run the Pi
    # at voltages higher than 1.99 V
    let overvolts=${1#*.}-20
    echo "$overvolts"
}

temp=$(cat /sys/class/thermal/thermal_zone0/temp)
temp=${temp/1000}
let newtemp=$temp/1000
echo "$newtemp"

#volts=$(vcgencmd measure_volts)
#volts=${volts:5:4}

if [ $volts != "1.20" ]; then
    overvolts=$(calculate_overvolts $volts)
fi

minFreq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq)
minFreq=$(convert_to_MHz $minFreq)

maxFreq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)
maxFreq=$(convert_to_MHz $maxFreq)

freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
freq=$(convert_to_MHz $freq)

governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

echo "Temperature:   $newtemp C"
#echo -n "Voltage:       $volts V"
#[ $overvolts ] && echo " (+0.$overvolts overvolt)" || echo -e "\r"
echo "Min speed:     $minFreq MHz"
echo "Max speed:     $maxFreq MHz"
echo "Current speed: $freq MHz"
echo "Governor:      $governor"

exit 0
