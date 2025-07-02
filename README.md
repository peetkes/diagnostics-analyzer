# diagnostics-analyzer

This project is created to generate an overview of message-vpns queues and clients for a given broker

**TODO**

Make sure the statistics files are generated with SEMP v1 calls to the brokers. Filenames should contain:
- 'MessageVPN' for message vpn stats
- "MessageSpool' for messagespool stats
- 'Queue' for queue stats
- 'Client' for client stats

```
xmlcalabash generate-excel-overview.xpl input-dir=[location of your stats files]
```