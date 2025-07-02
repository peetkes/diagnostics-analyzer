<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">
    <xsl:param name="filename" as="xs:string"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/*">
        <queue-analysis>
            <xsl:attribute name="source-file" select="$filename"/>
            <xsl:attribute name="analyzed-at" select="current-dateTime()"/>
            
            <!-- Extract queue-related elements -->
            <xsl:apply-templates select="descendant-or-self::queues"/>
        </queue-analysis>
    </xsl:template>

    <xsl:template match="queues">
        <!--queues-info count="{count(queue)}">
            <xsl:apply-templates/>
        </queues-info-->
        <xsl:variable name="queues" select="queue"/>
        <xsl:for-each select="descendant::message-vpn[not(. = preceding::message-vpn)]">
            <vpn>
                <xsl:attribute name="name" select="."/>
                <queues count="{count($queues[info/message-vpn = current()])}">
                    <!-- For each queue-info that matches this message-vpn -->
                    <xsl:for-each select="$queues[info/message-vpn = current()]">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </queues>
            </vpn>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="queue">
        <queue>
            <xsl:attribute name="name" select="name"/>
            <xsl:apply-templates select="descendant-or-self::message-spool-stats"/>
        </queue>
    </xsl:template>
    
    <xsl:template match="message-spool-stats">
        <stats>
            <xsl:apply-templates select="*" mode="check-value"/>
        </stats>
    </xsl:template>   
    
    <xsl:template match="*" mode="check-value">
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
                <xsl:if test="$isValue and number(.) gt 0">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="info"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>