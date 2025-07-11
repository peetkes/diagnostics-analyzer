<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:param name="filename" as="xs:string"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/*">
        <messagespool-info-analysis>
            <xsl:attribute name="source-file" select="$filename"/>
            <xsl:attribute name="analyzed-at" select="current-dateTime()"/>
            
            <!-- Extract message-spool-related elements -->
            <xsl:apply-templates select="descendant-or-self::message-spool"/>
        </messagespool-info-analysis>
    </xsl:template>
    
    <xsl:template match="message-spool">
        <messagespool-vpn-info>
            <xsl:attribute name="vpn-name" select="message-vpn/vpn/name"/>
            <xsl:apply-templates select="descendant-or-self::vpn"/>
        </messagespool-vpn-info>
    </xsl:template>

    <xsl:template match="vpn">
        <xsl:apply-templates select="*" mode="check-value"/>
    </xsl:template>   
    
    <xsl:template match="*" mode="check-value">
        <xsl:variable name="hasChildren" select="exists(*)"/>
        <xsl:variable name="isValue" select="number(.) = ."/>
        <xsl:choose>
            <xsl:when test="exists(*)">
                <xsl:variable name="content">
                    <xsl:apply-templates select="*" mode="check-value"/>
                </xsl:variable>
                <xsl:if test="count($content/node()) gt 0">
                    <xsl:copy>
                        <xsl:copy-of select="$content"/>
                    </xsl:copy>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$isValue">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>