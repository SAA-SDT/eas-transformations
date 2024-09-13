<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="3.0">

    <!-- 
    author
    div (only EAD2002, though)
    edition
    editionstmt
    filedesc
    frontmatter
    publicationstmt
    publisher
    seriesstmt
    sponsor
    titlepage (only EAD2002, though)
    titlestmt
    
    representation
    @instanceurl
    -->
    
    <xsl:template match="ead3:filedesc">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <xsl:if test="../ead3:recordid/@instanceurl">
                <xsl:attribute name="href" select="../ead3:recordid/@instanceurl"/>
                <xsl:attribute name="linkRole" select="$instance-url-link-role"/>
            </xsl:if>
            <!--titles-->
            <xsl:apply-templates select="ead3:titlestmt/ead3:titleproper"/>
            <xsl:apply-templates select="ead3:seriesstmt/ead3:titleproper"/>
            <!--agents-->
            <xsl:apply-templates select="ead3:titlestmt/ead3:author"/>
            <xsl:apply-templates select="ead3:publicationstmt/ead3:publisher"/>
            <!--places-->
            <xsl:apply-templates select="ead3:publicationstmt/ead3:address"/>
            <!--dates-->
            <xsl:apply-templates select="ead3:publicationstmt/ead3:date"/>
            
            <!-- XHTML leftovers, e.g. 
                notestmt,
                publicationstmt/num, 
                etc. -->
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:representation">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="text()">
                    <xsl:element name="formattingExtension" namespace="{$ead4-xmlns}">
                        <xhtml:p><xsl:apply-templates/></xhtml:p>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="agent" namespace="{$ead4-xmlns}">
                        <xsl:element name="agentName" namespace="{$ead4-xmlns}">
                            <xsl:value-of select="$default-migration-agent-name"/>
                        </xsl:element>
                        <xsl:element name="agentType" namespace="{$ead4-xmlns}">
                            <xsl:value-of select="$default-migration-agent-type"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:titleproper">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <xsl:element name="part" namespace="{$ead4-xmlns}">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:author | ead3:publisher">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <xsl:element name="agentName" namespace="{$ead4-xmlns}">
                <!-- TO DO:  figure out how to handle links here, etc. -->
                <xsl:apply-templates select="text()"/>
            </xsl:element>
            <xsl:element name="agentRole" namespace="{$ead4-xmlns}">
                <xsl:value-of select="if (self::ead3:author) then 'Finding Aid Author(s)' else 'Publisher'"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:publicationstmt/ead3:address">
        <xsl:element name="place" namespace="{$ead4-xmlns}">
            <xsl:element name="address" namespace="{$ead4-xmlns}">
                <xsl:apply-templates select="@*|node()"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:addressline/ead3:ref">
        <!-- TO DO: add soemthing to copy any attributes to comments -->
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>