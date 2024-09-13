<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all"
    version="3.0">
    
    <!-- attributes to elements
        
        otherdaotype - relationType
        
        -->
    
    <xsl:variable name="changed-attribute-names" as="map(xs:string, xs:string)" select="map{
        'containerid': 'containerId',
        'coordinatesystem': 'coordinateSystem',
        'countrycode': 'countryCode',
        'countryencoding': 'countryEncoding',
        'datechar': 'dateChar',
        'dateencoding': 'dateEncoding',
        'dsctype': 'descriptionOfComponentsType',
        'identifier': 'valueURI',
        (: will need to handle another way...
        'instanceurl': 'href',
        :)
        'lang': 'languageOfElement',
        'langcode': 'languageCode',
        'langencoding': 'languageEncoding',
        'linkrole': 'linkRole',
        'linktitle': 'linkTitle',
        'localtype': 'localType',
        'normal': 'standardDate',
        'notafter': 'notAfter',
        'notbefore': 'notBefore',
        'physdescstructuredtype': 'physDescStructuredType',
        'repositorycode': 'repositoryCode',
        'repositoryencoding': 'repositoryEncoding',
        'script': 'scriptOfElement',
        'scriptcode': 'scriptCode',
        'scriptencoding': 'scriptEncoding',
        'source': 'vocabularySource',
        'standarddate': 'standardDate',
        'standarddatetime': 'standardDateTime',
        'unitdatetype': 'unitDateType'}
    "/>
    
    <xsl:template match="@*">
        <xsl:variable name="current-node-name" select="local-name()"/>
        <xsl:attribute name="{if (map:contains($changed-attribute-names, $current-node-name)) then map:get($changed-attribute-names, $current-node-name) else $current-node-name}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@langencoding" priority="2">
        <xsl:attribute name="{map:get($changed-attribute-names, local-name())}">
            <!-- also add a comment, in case the 2b vs. 2t distinction might ever matter to someone ? -->
            <xsl:value-of select="if (contains(., '-2b')) then replace(., 'b', '') else ."/>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="ead3:addressline/@localtype">
        <xsl:attribute name="addressLineType">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    
</xsl:stylesheet>