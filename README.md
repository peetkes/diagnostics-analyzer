# diagnostics-analyzer

This project is created to generate an overview of message-vpns, message-spools, queues and clients for a given broker
These statistics can be pulled from the broker via the getStatistics.sh script.
This script pulls statuistics via the SEMP v1 API.

## Prerequisites
- xmllint: used for getting the message-vpn names from the MESSAGE_VPN_STATS
	Ubuntu/Debian   sudo apt install libxml2-utils
	RHEL/CentOS     sudo apt install libxml2-utils
	Fedorea         sudo apt install libxml2-utils
	Alpine          sudo apt install libxml2-utils
	MacOS           sudo apt install libxml2-utils
- xmlcalabash: used for the pipeline to prepare the excel sheets.
    Check out https://docs.xmlcalabash.com/userguide/current/index.html for the installation guide


 ## Get Statistics

The script getStatistics.sh extracts a set of statistics files from a given broker by executing a set of curl POST commands with a SEMP v1 payload.
The resulting statistics files will be stored in the subfolder stats. Files are suffixed with a timestamp.

It will get the following statistics:
* CLIENT_STATS			=> stats_$BROKER/yyyymmdd-HHmmss/ClientStats.xml
* MESSAGE_VPN_STATS		=> stats_$BROKER/yyyymmdd-HHmmss/MessageVPNStats.xml
* QUEUE_STATS			=> stats_$BROKER/yyyymmdd-HHmmss/QueueStats.xml
* MESSAGE_SPOOL_STATS	=> stats_$BROKER/yyyymmdd-HHmmss/MessageSpoolStats(-[message-vpn])?.xml
* MESSAGE_SPOOL_INFO	=> stats_$BROKER/yyyymmdd-HHmmss/MessageSpoolInfo(-[message-vpn])?.xml

It will create a MessageSpoolStats and MessageSpoolInfo file per active message-vpn and an overall MessageSpoolStats file

The script takes 6 parameters:
- protocol: http or https
- ip-address: appliance or software broker
- port: 80/443 for appliance, 8080/1943 for software broker
- user: admin username broker
- password: admin password broker
- brokername: a name identifying the broker

```
./getStatistics.sh http appliance-ip 80 admin <password> <brokername>
```

## Create Excel Overview  

Make sure the statistics files are generated with SEMP v1 calls to the brokers. Filenames should contain:
- 'MessageVPN' for message vpn stats
- "MessageSpoolStats' for messagespool stats
- "MessageSpoolInfo' for messagespool information
- 'Queue' for queue stats
- 'Client' for client stats

```
xmlcalabash generate-excel-overview.xpl input-dir=[location of your stats files] output-dir=[location for the results] broker=[broker-name]
```