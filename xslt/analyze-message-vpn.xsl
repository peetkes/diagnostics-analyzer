<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">
    <xsl:param name="filename" as="xs:string"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
   
    <xsl:template match="/*">
        <vpn-analysis>
            <xsl:attribute name="source-file" select="$filename"/>
            <xsl:attribute name="analyzed-at" select="current-dateTime()"/>
            
            <!-- Extract message-vpn-related elements -->
            <xsl:apply-templates select="descendant-or-self::message-vpn"/>
        </vpn-analysis>
    </xsl:template>

    <xsl:template match="message-vpn">
        <message-vpn-info vpns="{count(vpn)}" enabled="{count(vpn[enabled = 'true']) - count(vpn[not(starts-with(name, '#'))])}">
            <xsl:apply-templates/>
        </message-vpn-info>
    </xsl:template>

    <xsl:template match="vpn[starts-with(name, '#')]" priority="1"/>
    <!--xsl:template match="vpn[enabled != 'true']"/-->
    <xsl:template match="vpn[enabled]">
        <vpn-info>
            <xsl:apply-templates mode="filtered"/>
        </vpn-info>
    </xsl:template>
    
    <xsl:template match="name|enabled|connections|max-connections|connections-service-smf|connections-service-web|connections-service-rest-incoming|connections-service-mqtt|onnections-service-amqp|connections-service-rest-outgoing|total-unique-subscriptions|max-subscriptions" mode="filtered">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="filtered"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*" mode="filtered"/>
        
    <xsl:template match="authentication">
        <xsl:copy>
            <xsl:apply-templates select="@*,*[enabled eq 'true']"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="stats"/>

    <!-- Remove empty elements -->
    <xsl:template match="*[not(node()) and not(@*)]"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
