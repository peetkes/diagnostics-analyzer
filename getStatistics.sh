#!/bin/bash

if [ "$#" -ne 5 ]; then
	echo 'Execute command by passing username, password and management IP, e.g.: ./getStatistics.sh http appliance-ip 80 admin <password>'
	exit 1
fi
XMLLINT_INSTALLED=true
command -v xmllint >/dev/null || XMLLINT_INSTALLED=false

if ! $XMLLINT_INSTALLED; then
	echo Install xmllint before running this script!
	echo -e "Ubuntu/Debian\t\tsudo apt install libxml2-utils"
	echo -e "RHEL/CentOS\t\tsudo apt install libxml2-utils"
	echo -e "Fedorea\t\t\tsudo apt install libxml2-utils"
	echo -e "Alpine\t\t\tsudo apt install libxml2-utils"
	echo -e "MacOS\t\t\tsudo apt install libxml2-utils"
	exit 1
fi

PROTOCOL=$1
MIP=$2
PORT=$3
USERNAME=$4
PASS=$5

DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
OUTPUT_DIR=stats/$DATE_WITH_TIME

URL="$PROTOCOL://$MIP:$PORT/SEMP"

if [[ "$PROTOCOL" == "https" ]]; 
then
	OPTIONS="-k -s"
else
	OPTIONS="-s"
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

CLIENT_STATS="<rpc><show><client><name>*</name><vpn-name>*</vpn-name><stats/></client></show></rpc>"
MESSAGE_VPN_STATS="<rpc><show><message-vpn><vpn-name>*</vpn-name><stats/></message-vpn></show></rpc>"
QUEUE_STATS="<rpc><show><queue><name>*</name><vpn-name>*</vpn-name><stats/></queue></show></rpc>"
MESSAGE_SPOOL_STATS="<rpc><show><message-spool><stats/></message-spool></show></rpc>"

curl $OPTION -d $CLIENT_STATS -u $USERNAME:$PASS $URL >> "${OUTPUT_DIR}/ClientStats.xml"
curl $OPTION -d $MESSAGE_VPN_STATS -u $USERNAME:$PASS $URL >> "${OUTPUT_DIR}/MessageVPNStats.xml"
curl $OPTION -d $QUEUE_STATS -u $USERNAME:$PASS $URL >> "${OUTPUT_DIR}/QueueStats.xml"
curl $OPTION -d $MESSAGE_SPOOL_STATS -u $USERNAME:$PASS $URL >> "${OUTPUT_DIR}/MessageSpoolStats.xml"

# get array of vpn names
INPUT_FILE="${OUTPUT_DIR}/MessageVPNStats.xml"
VPN_NAMES=()
counter=1
while true; do
    vpn_name=$(xmllint --xpath "//vpn[$counter][enabled='true']/name/text()" "$INPUT_FILE" 2>/dev/null)
    if [[ -z "$vpn_name" ]]; then
        break
    fi
    VPN_NAMES+=("$vpn_name")
    ((counter++))
done
for vpn_name in "${VPN_NAMES[@]}"; do
	MESSAGE_SPOOL_STATS="<rpc><show><message-spool><vpn-name>${vpn_name}</vpn-name><stats/></message-spool></show></rpc>"
	curl $OPTION -d $MESSAGE_SPOOL_STATS -u $USERNAME:$PASS $URL >> "${OUTPUT_DIR}/MessageSpoolStats_${vpn_name}.xml"
done
