<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all"
    version="3.0">
    
    <!-- ead3 -->
    <xsl:template match="ead3:control">
        <xsl:element name="{local-name()}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="ead3:maintenancestatus" mode="element-to-attribute"/>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead3:recordid, ead3:maintenanceagency, ead3:maintenancehistory, ead3:sources, 
            (ead3:conventiondeclaration | ead3:languagedeclaration | ead3:localtypedeclaration, ead3:otherrecordid, ead3:rightsdeclaration)"/>
        </xsl:element>
        <!-- for the new findAidDesc elements -->
        <xsl:apply-templates select="ead3:filedesc"/>
        <xsl:apply-templates select="ead3:representation"/>
    </xsl:template>
    
    <xsl:template match="ead3:maintenancehistory">
        <xsl:variable name="current-dateTime" select="current-dateTime()"/>
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <!-- add sorting feature, or just assume that everything is in latest-to-oldest order? -->
            <xsl:if test="$add-migration-event">
                <xsl:element name="maintenanceEvent" namespace="{$ead4-xmlns}">
                    <xsl:attribute name="maintenanceEventType" select="$default-migration-event-type"/>
                    <xsl:element name="agent" namespace="{$ead4-xmlns}">
                        <xsl:element name="agentName" namespace="{$ead4-xmlns}">
                            <xsl:value-of select="$default-migration-agent-name"/>
                        </xsl:element>
                        <xsl:element name="agentType" namespace="{$ead4-xmlns}">
                            <xsl:value-of select="$default-migration-agent-type"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="eventDateTime" namespace="{$ead4-xmlns}">
                        <xsl:attribute name="standardDateTime" select="$current-dateTime"/>
                        <xsl:value-of select="format-date(xs:date($current-dateTime), '[Y0001] [MNn] [D1o]')"/>
                    </xsl:element>
                    <xsl:element name="eventDescription" namespace="{$ead4-xmlns}">
                        <xsl:value-of select="$default-migration-text"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:maintenanceevent">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="ead3:eventtype" mode="element-to-attribute"/>
            <xsl:apply-templates select="@*"/>
            <!-- note:  agenttype is not processed here, since it has been demoted to a child of agent -->
            <xsl:apply-templates select="ead3:agent, ead3:eventdatetime, ead3:eventdescription"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:agent">
        <xsl:element name="{local-name()}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <xsl:element name="agentName" namespace="{$ead4-xmlns}">
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:apply-templates select="../ead3:agenttype"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:agenttype">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@* except @value"/>
            <xsl:value-of select="(@value, .)[1] => normalize-space()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:conventiondeclaration | ead3:localtypedeclaration | ead3:rightsdeclaration">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="ead3:citation"/>
            <xsl:apply-templates select="ead3:abbr" mode="control-specific"/>
            <xsl:apply-templates select="ead3:descriptivenote"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:languagedeclaration">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:variable name="paras">
                <xsl:apply-templates select="ead3:language[normalize-space()], ead3:script[normalize-space()]" mode="element-to-paragraph"/>
            </xsl:variable>
            <!-- capitalize script code, or just ignore if invalid ? -->
            <xsl:apply-templates select="ead3:language, ead3:script" mode="element-to-attribute"/>
            <xsl:call-template name="descriptiveNote">
                <xsl:with-param name="paragraph-nodes" as="element(wrapper)" tunnel="1">
                    <wrapper>
                        <xsl:sequence select="$paras"/>
                    </wrapper>
                </xsl:with-param>
                <xsl:with-param name="element-exists" as="xs:boolean" select="exists(ead3:descriptivenote)"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*" mode="element-to-paragraph">
        <xsl:element name="p" namespace="{$ead4-xmlns}">
            <xsl:value-of select="upper-case(substring(local-name(.),1,1)) || substring(local-name(.), 2) || ': '"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- move this -->
    <xsl:template name="descriptiveNote">
        <xsl:param name="paragraph-nodes" tunnel="1"/>
        <xsl:param name="element-exists"/>
        <xsl:choose>
            <xsl:when test="$element-exists">
                <xsl:apply-templates select="ead3:descriptivenote">
                    <xsl:with-param name="paragraph-nodes" select="$paragraph-nodes"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="descriptiveNote" namespace="{$ead4-xmlns}">
                    <xsl:copy-of select="$paragraph-nodes/*"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ead3:descriptivenote">
        <xsl:param name="paragraph-nodes" tunnel="1"/>
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <!-- TO DO:  must still deal with mixed content here.  what to do? -->
            <xsl:apply-templates/>
            <xsl:if test="$paragraph-nodes">
                <xsl:copy-of select="$paragraph-nodes/*"/>   
            </xsl:if>
        </xsl:element>
    </xsl:template>
    
    <!-- if the source recordid is empty, we need to add a message -->
    <xsl:template match="ead3:recordid[not(normalize-space())]">
        <xsl:comment>
                <xsl:value-of select="$newline || $default-empty-element-text"/>
        </xsl:comment>
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <xsl:value-of select="$default-text-value"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:source[not(ead3:sourceentry)]">
        <xsl:element name="{local-name()}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <xsl:element name="reference" namespace="{$ead4-xmlns}">
                <xsl:comment select="$default-empty-source-note"/>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

    
    
    <xsl:template match="ead3:abbr" mode="control-specific">
        <xsl:element name="{map:get($changed-element-names, local-name())[1]}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    
    
    
    <!-- ead2002 (or create separate file) -->
    
    
</xsl:stylesheet>