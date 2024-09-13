<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    

    <xsl:template name="formsAvailable">
        <xsl:element name="formsAvailable" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="ead3:altformavail | ead3:originalsloc | ead3:did/ead3:dao | ead3:did/ead3:daoset"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:daoset">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="ead3:dao"/>
            <xsl:apply-templates select="ead3:descriptiveNote"/>
    </xsl:template>
    

    <xsl:template match="ead3:dao">
        <xsl:element name="formAvailable" namespace="{$ead4-xmlns}">
            <!--
            <xsl:apply-templates select="@*"/>
            -->
            <xsl:apply-templates select="ead3:descriptiveNote"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>