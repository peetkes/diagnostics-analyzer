<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all">
    
    <!-- Parameters -->
    <xsl:param name="filename" select="'unknown'"/>
    
    <!-- Identity transform template -->
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!-- Add metadata to root element -->
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:attribute name="source-file" select="$filename"/>
            <xsl:attribute name="processed-timestamp" select="current-dateTime()"/>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>