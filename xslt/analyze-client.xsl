<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">
    <xsl:param name="filename" as="xs:string"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/*">
        <client-analysis>
            <xsl:attribute name="source-file" select="$filename"/>
            <xsl:attribute name="analyzed-at" select="current-dateTime()"/>
            
            <!-- Extract client-related elements -->
            <xsl:apply-templates select="descendant-or-self::backup-virtual-router"/>
            <xsl:apply-templates select="descendant-or-self::internal-virtual-router"/>
        </client-analysis>
    </xsl:template>
    
    <xsl:template match="backup-virtual-router|internal-virtual-router">
        <router type="{local-name()}" clients="{count(client)}">
            <xsl:apply-templates/>
        </router>
    </xsl:template>

    <xsl:template match="client">
        <client-info>
            <xsl:apply-templates/>
        </client-info>
    </xsl:template>

    <xsl:template match="stats"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
