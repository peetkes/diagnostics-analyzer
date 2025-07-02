<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <ss:Workbook>
            <ss:DocumentProperties>
                <o:Title>XML Analysis Report</o:Title>
                <o:Author>XProc 3.0 XML Analyzer</o:Author>
                <o:Created><xsl:value-of select="current-dateTime()"/></o:Created>
            </ss:DocumentProperties>
            
            <!-- File Summary Sheet -->
            <ss:Worksheet ss:Name="MessageVPN Summary">
                <ss:Table>
                    <ss:Row>
                        <ss:Cell><ss:Data ss:Type="String">Message VPN</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Total queues</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Max Subscriptions</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Total Unique Subscriptions</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Total Connections</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Total Connections SMF</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Total Connections Web</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Total Connections Rest In</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Total Connections Rest Out</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Total Connections MQTT</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Max Connections</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Ingress Flows</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Egress Flows</ss:Data></ss:Cell>
                    </ss:Row>
                    <xsl:variable name="enabled-vpns" select="//vpn-analysis//vpn-info[enabled eq 'true']"/>
                    <xsl:for-each select="//vpn-analysis//vpn-info[enabled eq 'true']">
                        <xsl:variable name="vpn-name" select="name/text()"/>
                        <ss:Row>
                            <ss:Cell><ss:Data ss:Type="String"><xsl:value-of select="$vpn-name"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//queue-analysis/vpn[@name eq $vpn-name]/queues/@count"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="max-subscriptions"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="total-unique-subscriptions"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="connections"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="connections-service-smf"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="connections-service-web"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="connections-service-rest-incoming"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="connections-service-rest-outgoing"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="connections-service-mqtt"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="max-connections"/></ss:Data></ss:Cell>
                            <xsl:choose>
                                <xsl:when test="exists(//messagespool-analysis/messagespool-info[@element-name eq $vpn-name]/ingress-messages)">
                                    <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-analysis/messagespool-info[@element-name eq $vpn-name]/ingress-messages"/></ss:Data></ss:Cell>
                                </xsl:when>
                                <xsl:otherwise>
                                    <ss:Cell><ss:Data ss:Type="Number">0</ss:Data></ss:Cell>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="exists(//messagespool-analysis/messagespool-info[@element-name eq $vpn-name]/egress-messages)">
                                    <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-analysis/messagespool-info[@element-name eq $vpn-name]/egress-messages"/></ss:Data></ss:Cell>
                                </xsl:when>
                                <xsl:otherwise>
                                    <ss:Cell><ss:Data ss:Type="Number">0</ss:Data></ss:Cell>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ss:Row>
                    </xsl:for-each>
                </ss:Table>
            </ss:Worksheet>
            
            <!-- Queues Overview Sheet -->
            <ss:Worksheet ss:Name="Queues">
                <ss:Table>
                    <ss:Row>
                        <ss:Cell><ss:Data ss:Type="String">Queue Name</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">VPN Name</ss:Data></ss:Cell>
                    </ss:Row>
                    
                    <xsl:for-each select="//queue-analysis/vpn/queues/queue">
                        <ss:Row>
                            <ss:Cell><ss:Data ss:Type="String"><xsl:value-of select="@name"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="String"><xsl:value-of select="ancestor::vpn/@name"/></ss:Data></ss:Cell>
                        </ss:Row>
                    </xsl:for-each>
                </ss:Table>
            </ss:Worksheet>
            
            <!-- Client Overview Sheet -->
            <ss:Worksheet ss:Name="Clients">
                <ss:Table>
                    <ss:Row>
                        <ss:Cell><ss:Data ss:Type="String">Router Type</ss:Data></ss:Cell>                        
                        <ss:Cell><ss:Data ss:Type="String">Client Name</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Client Address</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Client Username</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">VPN Name</ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="String">Nr of Subscriptions</ss:Data></ss:Cell>
                    </ss:Row>
                    
                    <xsl:for-each select="//client-analysis/router/client-info">
                        <ss:Row>
                            <ss:Cell><ss:Data ss:Type="String"><xsl:value-of select="ancestor-or-self::router/@type"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="String"><xsl:value-of select="name"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="String"><xsl:value-of select="client-address"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="String"><xsl:value-of select="client-username"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="String"><xsl:value-of select="message-vpn"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="num-subscriptions"/></ss:Data></ss:Cell>
                        </ss:Row>
                    </xsl:for-each>
                </ss:Table>
            </ss:Worksheet>
        </ss:Workbook>
    </xsl:template>
</xsl:stylesheet>