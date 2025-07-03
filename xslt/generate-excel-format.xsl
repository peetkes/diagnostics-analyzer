<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
    
    <xsl:param name="broker" as="xs:string"/>
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:variable name="columnWidth100" select="100"/>
    <xsl:variable name="columnWidth160" select="160"/>
    <xsl:variable name="columnWidth200" select="200"/>
    <xsl:variable name="columnWidth300" select="300"/>
    <xsl:variable name="columnWidth400" select="400"/>
    <xsl:variable name="columnWidth600" select="600"/>
    
    <xsl:template match="/">
        <ss:Workbook>
            <ss:DocumentProperties>
                <o:Title>XML Analysis Report</o:Title>
                <o:Author>XProc 3.0 XML Analyzer</o:Author>
                <o:Created><xsl:value-of select="current-dateTime()"/></o:Created>
            </ss:DocumentProperties>
            
            <ss:Styles>
                <ss:Style ss:ID="Header">
                    <ss:Font ss:Bold="1"/>
                    <ss:Alignment ss:WrapText="1"/>
                </ss:Style>
                <ss:Style ss:ID="Bold">
                    <ss:Font ss:Bold="1"/>
                </ss:Style>
            </ss:Styles>
            
            <!-- Summary Sheet -->
            <ss:Worksheet ss:Name="Environment Overview">
                <ss:Table>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <!--ss:Row>
                        <ss:Cell ss:MergeAcross="3">
                            <ss:Data ss:Type="string">Overview for environment <xsl:value-of select="$broker"/></ss:Data>
                        </ss:Cell>
                    </ss:Row-->
                    <ss:Row>
                         <ss:Cell ss:StyleID="Bold" ss:MergeAcross="3">
                            <ss:Data ss:Type="String">Overview for Broker <xsl:value-of select="$broker"/> generated on <xsl:value-of select="substring(string(current-date()), 1, 10)"/></ss:Data>
                        </ss:Cell>
                    </ss:Row>
                    <ss:Row/>
                    <ss:Row/>
                    <ss:Row>
                        <ss:Cell ss:StyleID="Header">
                            <ss:Data ss:Type="String">Total number of MessageVPNs</ss:Data>
                        </ss:Cell>
                        <ss:Cell ss:StyleID="Header">
                            <ss:Data ss:Type="String">Total number of enabled MessageVPNs</ss:Data>
                        </ss:Cell>
                        <ss:Cell ss:StyleID="Header">
                            <ss:Data ss:Type="String">Total Number of Queues</ss:Data>
                        </ss:Cell>
                        <ss:Cell ss:StyleID="Header">
                            <ss:Data ss:Type="String">Total Number of ClientNames</ss:Data>
                        </ss:Cell>
                    </ss:Row>
                    <ss:Row>
                        <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="count(//vpn-analysis//vpn-info)"/></ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="count(//vpn-analysis//vpn-info[enabled eq 'true'])"/></ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="count(//queue-analysis//queue)"/></ss:Data></ss:Cell>
                        <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="count(
                                        distinct-values(
                                            for $i in //client-analysis//client-info return concat($i/message-vpn, '|', $i/client-username)
                                        )
                                    )"/></ss:Data></ss:Cell>
                    </ss:Row>
                </ss:Table>
            </ss:Worksheet>
            <!-- MessageVpn Summary Sheet -->
            <ss:Worksheet ss:Name="MessageVPN">
                <ss:Table>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Row ss:Height="30">
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Message VPN</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Total queues</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Max Subscriptions</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Total Unique Subscriptions</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Total Connections</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Total Connections SMF</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Total Connections Web</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Total Connections Rest In</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Total Connections Rest Out</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Total Connections MQTT</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Total Connections AMQP</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Max Connections</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Ingress Messages</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Egress Messages</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Current Ingress Flows</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Max Ingress Flows</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Current Egress Flows</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Max Egress Flows</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Current Spool Usage(MB)</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Max Spool Usage(MB)</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Spool Usage(%)</ss:Data></ss:Cell>
                    </ss:Row>
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
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="connections-service-amqp"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="max-connections"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-analysis/messagespool-info[@element-name eq $vpn-name]/ingress-messages"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-analysis/messagespool-info[@element-name eq $vpn-name]/egress-messages"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-info-analysis/messagespool-vpn-info[@vpn-name eq $vpn-name]/current-ingress-flows"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-info-analysis/messagespool-vpn-info[@vpn-name eq $vpn-name]/maximum-ingress-flows"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-info-analysis/messagespool-vpn-info[@vpn-name eq $vpn-name]/current-egress-flows"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-info-analysis/messagespool-vpn-info[@vpn-name eq $vpn-name]/maximum-egress-flows"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-info-analysis/messagespool-vpn-info[@vpn-name eq $vpn-name]/current-spool-usage-mb"/></ss:Data></ss:Cell>
                            <ss:Cell><ss:Data ss:Type="Number"><xsl:value-of select="//messagespool-info-analysis/messagespool-vpn-info[@vpn-name eq $vpn-name]/maximum-spool-usage-mb"/></ss:Data></ss:Cell>
                            <xsl:variable name="numerator" select="xs:decimal(//messagespool-info-analysis/messagespool-vpn-info[@vpn-name eq $vpn-name]/current-spool-usage-mb)"/>
                            <xsl:variable name="denominator" select="xs:decimal(//messagespool-info-analysis/messagespool-vpn-info[@vpn-name eq $vpn-name]/maximum-spool-usage-mb)"/>
                            <ss:Cell>
                                <xsl:choose>
                                    <xsl:when test="$denominator != 0">
                                        <ss:Data ss:Type="String"><xsl:value-of select="format-number(($numerator div $denominator) * 100, '0.00')"/><xsl:text>%</xsl:text></ss:Data>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <ss:Data ss:Type="String">NaN</ss:Data>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ss:Cell>
                        </ss:Row>
                    </xsl:for-each>
                    <ss:Row>
                        <xsl:variable name="count" select="count(//vpn-analysis//vpn-info[enabled eq 'true'])"/>
                        <xsl:variable name="col-count" select = "11"/>
                        <ss:Cell ss:StyleID="Bold"><ss:Data ss:Type="String">Total</ss:Data></ss:Cell>
                        <xsl:for-each select="2 to $col-count" >
                            <ss:Cell ss:StyleID="Bold" ss:Formula="{concat('=SUM(R2C',.,':R',$count+1,'C',.,')')}"><ss:Data ss:Type="Number">0</ss:Data></ss:Cell>
                        </xsl:for-each>
                    </ss:Row>
                </ss:Table>
            </ss:Worksheet>
            
            <!-- Queues Overview Sheet -->
            <ss:Worksheet ss:Name="Queues">
                <ss:Table>
                    <ss:Column ss:Width="{$columnWidth400}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Row>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Queue Name</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">VPN Name</ss:Data></ss:Cell>
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
                    <ss:Column ss:Width="{$columnWidth160}"/>
                    <ss:Column ss:Width="{$columnWidth600}"/>
                    <ss:Column ss:Width="{$columnWidth160}"/>
                    <ss:Column ss:Width="{$columnWidth160}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Column ss:Width="{$columnWidth100}"/>
                    <ss:Row>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Router Type</ss:Data></ss:Cell>                        
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Client Name</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Client Address</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Client Username</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">VPN Name</ss:Data></ss:Cell>
                        <ss:Cell ss:StyleID="Header"><ss:Data ss:Type="String">Nr of Subscriptions</ss:Data></ss:Cell>
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