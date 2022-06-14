#!/bin/bash
# Script: status.sh
# Purpose: Display CPU temperature and throttle status of Raspberry Pi 
# Author: OZ5RIX
# -------------------------------------------------------

#Read CPU temperatur
thermal_zone0=$(</sys/class/thermal/thermal_zone0/temp)
cpu=$((thermal_zone0/1000))

#Read GPU temperatur
#echo "GPU => $(/opt/vc/bin/vcgencmd measure_temp)"

#Flag Bits
UNDERVOLTED=0x1
CAPPED=0x2
THROTTLED=0x4
SOFT_TEMPLIMIT=0x8
HAS_UNDERVOLTED=0x10000
HAS_CAPPED=0x20000
HAS_THROTTLED=0x40000
HAS_SOFT_TEMPLIMIT=0x80000

#Text Colors
GREEN=`tput setaf 2`
RED=`tput setaf 1`
NC=`tput sgr0`

#Output Strings
GOOD="${GREEN}NO${NC}"
BAD="${RED}YES${NC}"

#Get Status, extract hex
STATUS=$(vcgencmd get_throttled)
STATUS=${STATUS#*=}

echo ""
echo "$(date) @ $(hostname)"
echo -n "Uptime: "
echo "$(uptime -p | cut -d " " -f2-)"
echo "-------------------------------------------"
echo -n "CPU  Temp: "
(($cpu>=75)) && echo "${RED}${cpu}'C${NC}"  || echo "${GREEN}${cpu}'C${NC}" 


echo ""
echo "Thottled status"
echo "---------------"
echo -n "Status: "
(($STATUS!=0)) && echo "${RED}${STATUS}${NC}" || echo "${GREEN}${STATUS}${NC}"

echo "Undervolted:"
echo -n "   Now: "
((($STATUS&UNDERVOLTED)!=0)) && echo "${BAD}" || echo "${GOOD}"
echo -n "   Run: "
((($STATUS&HAS_UNDERVOLTED)!=0)) && echo "${BAD}" || echo "${GOOD}"

echo "Throttled:"
echo -n "   Now: "
((($STATUS&THROTTLED)!=0)) && echo "${BAD}" || echo "${GOOD}"
echo -n "   Run: "
((($STATUS&HAS_THROTTLED)!=0)) && echo "${BAD}" || echo "${GOOD}"
echo "Frequency Capped:"
echo -n "   Now: "
((($STATUS&CAPPED)!=0)) && echo "${BAD}" || echo "${GOOD}"
echo -n "   Run: "
((($STATUS&HAS_CAPPED)!=0)) && echo "${BAD}" || echo "${GOOD}"

echo "Softlimit:"
echo -n "   Now: "
((($STATUS&SOFT_TEMPLIMIT)!=0)) && echo "${BAD}" || echo "${GOOD}"
echo -n "   Run: "
((($STATUS&HAS_SOFT_TEMPLIMIT)!=0)) && echo "${BAD}" || echo "${GOOD}"
echo  ""
