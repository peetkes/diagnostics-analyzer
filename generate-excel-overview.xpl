<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="3.0"
                name="main">
    
    <p:option name="input-dir" select="'stats_ops/'" as="xs:string"/>
    <p:option name="output-dir" select="'output/ops'" as="xs:string"/>
    <p:option name="file-pattern" select="'.*\.xml$'" as="xs:string"/>
    <p:option name="broker" select="'OPS'"  as="xs:string"/>

    <p:output port="result"/>
    
    <!-- Create output directory if it doesn't exist -->
    <p:file-mkdir href="{$output-dir}"/>

    <p:variable name="input-fld" select="if ($input-dir and ends-with($input-dir,'/')) then $input-dir else concat($input-dir,'/')"/>
    
    <!-- 1. List XML files in folder -->
    <p:directory-list name="list-files" path="{$input-fld}" include-filter="{$file-pattern}"/>
       
    <!-- 2. Load all XML files -->
    <p:for-each name="load-each">
        <p:with-input select="//c:file" pipe="result@list-files"/>
        <p:variable name="filename" select="replace(/*/@name,'#','%23')" as="xs:string"/>
        <p:variable name="input-path" select="concat($input-fld, $filename)" as="xs:string"/>
        
        <!-- 3.1. Load XML files -->
        <p:load href="{$input-path}"/>
        <!-- 3.2 Process XML file -->
        <p:choose>
            <p:when test="matches($filename,'MessageVPNStats')">
                <p:xslt name="analyze_message_vpn">
                    <p:with-input port="stylesheet">
                        <p:document href="xslt/analyze-message-vpn.xsl"/>
                    </p:with-input>
                    <p:with-option name="parameters" select="map{'filename': $filename}"/>
                </p:xslt>
            </p:when>
            <p:when test="matches($filename,'MessageSpoolStats')">
                <p:xslt name="analyze_message_spool_stats">
                    <p:with-input port="stylesheet">
                        <p:document href="xslt/analyze-message-spool_stats.xsl"/>
                    </p:with-input>
                    <p:with-option name="parameters" select="map{'filename': $filename}"/>
                </p:xslt>
            </p:when>
            <p:when test="matches($filename,'MessageSpoolInfo')">
                <p:xslt name="analyze_message_spool_info">
                    <p:with-input port="stylesheet">
                        <p:document href="xslt/analyze-message-spool_info.xsl"/>
                    </p:with-input>
                    <p:with-option name="parameters" select="map{'filename': $filename}"/>
                </p:xslt>
            </p:when>
            <p:when test="matches($filename,'QueueStats')">
                <p:xslt name="analyze_queue">
                    <p:with-input port="stylesheet">
                        <p:document href="xslt/analyze-queue.xsl"/>
                    </p:with-input>
                    <p:with-option name="parameters" select="map{'filename': $filename}"/>
                </p:xslt>
            </p:when>
            <p:when test="matches($filename,'ClientStats')">
                <p:xslt name="analyze_client">
                    <p:with-input port="stylesheet">
                        <p:document href="xslt/analyze-client.xsl"/>
                    </p:with-input>
                    <p:with-option name="parameters" select="map{'filename': $filename}"/>
                </p:xslt>
            </p:when>
            <p:otherwise>
                <p:identity>
                    <p:with-input port="source">
                        <p:inline>
                            <non-existing/>
                        </p:inline>
                    </p:with-input>
                </p:identity>
            </p:otherwise>
        </p:choose>
    </p:for-each>
    
    <!-- 4. Wrap results in overview element -->
    <p:wrap-sequence wrapper="overview"/>
    
    <!-- Optional: Store to file -->
    <p:store href="{$output-dir}/overview-{$broker}.xml"/>
    
    <p:xslt name="convert-to-excel">
        <p:with-option name="parameters" select="map{'broker': $broker}"/>
        <p:with-input port="stylesheet">
            <p:document href="xslt/generate-excel-format.xsl"/>
        </p:with-input>
    </p:xslt>
    <!-- Optional: Store to file -->
    <p:store href="{$output-dir}/overview-excel-{$broker}.xml"/>
    
</p:declare-step>
