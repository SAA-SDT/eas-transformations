<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all"
    version="3.0">
    
    <!-- XSLT3 conversion process to transform EAD2002 + EAD3 documents to EAD4 -->

    <!-- DONE, as of 2024-08-11
        - Repository set up (including EAD3 subrepository for original EAD2002 to 3 transformations)
        - General framework set up
        - Validity-first approach implemented
        - renamed elements + attributes
        - control (minus localTypeDeclaration references)
        - findAidDesc
        - archdesc (including former dsc)
        - referringString
        - formsAvailable
        - subjectHeadings (controlaccess)
    -->
    
    <!-- TO DO, from 2024-08-12 - ???
       - subjectHeadings (index)
       - move fancy mixed-content to XHTML / formattingExtension
       - ensure all NESTED elements that are not converted to HTML are flattened (e.g. originalsloc/originalsloc/originalsloc)
       - review attributes
       - re-review element list
       - localTypeDeclaration 
       - EAD 2002
       - Break out more specific grouping lists, e.g. for agents / roles
    -->

    <xsl:output method="xml" encoding="UTF-8" indent="true"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:include href="archDesc.xsl"/>
    <xsl:include href="banished-attributes.xsl"/>
    <xsl:include href="banished-elements.xsl"/>
    <xsl:include href="configuration-parameters.xsl"/>
    <xsl:include href="control.xsl"/>
    <xsl:include href="findAidDesc.xsl"/>
    <!-- import instead of include, for now. to finalize strategy later -->
    <xsl:import href="formattingExtension-xhtml.xsl"/>
    <xsl:include href="formsAvailable.xsl"/>
    <xsl:include href="referringString.xsl"/>
    <xsl:include href="renamed-attributes.xsl"/>
    <xsl:include href="renamed-elements.xsl"/>
    <xsl:include href="subjectHeadings.xsl"/>


    <xsl:variable name="newline">
        <xsl:text>&#10;</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="ead-input-version">
        <!-- also look into ead1 vs 2002 differentiators -->
        <!-- not yet used, but will be used for switching between ead2002 and ead3 transformations -->
        <xsl:value-of select="if (*:ead/*:control) then 'ead3' else if (*:ead/*:eadheader) then 'ead2002' else 'unknown'"/>
    </xsl:variable>
    
    <xsl:variable name="add-migration-namespace" select="exists((//@altrender, //@encodinganalog, //@relatedencoding))" as="xs:boolean"/>

    <!-- how best to test for this? 
    could be lots of things, including control/representation/text()
    -->
    <xsl:variable name="add-xhtml-namespace" select="true()"/>
    
    <xsl:template match="/">
        <xsl:message select="$ead-input-version"/>
        <xsl:choose>
            <xsl:when test="$schema-output-version eq 'nvdl'">
                <xsl:processing-instruction name="xml-model">
                    <xsl:text expand-text="true">href="{$schema-path}{$schema-name}" type="application/xml" schematypens="http://purl.oclc.org/dsdl/nvdl/ns/structure/1.0"</xsl:text>
                </xsl:processing-instruction>
                <!-- update, as necessary, to remove the release information here once we decide on the best deployment option -->
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="https://raw.githubusercontent.com/SAA-SDT/eas-schematrons/release_2024_03/schematron/ead.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:text>
                </xsl:processing-instruction>
            </xsl:when>
            <xsl:when test="$schema-output-version eq 'rng'">
                <xsl:processing-instruction name="xml-model">
                    <xsl:text expand-text="true">href="{$schema-path}{$schema-name}" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
                </xsl:processing-instruction>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="*:ead"/>
    </xsl:template>
    
    <xsl:template match="*:ead">
        <xsl:element name="{local-name()}" namespace="{$ead4-xmlns}">
            <xsl:if test="$schema-output-version eq 'xsd'">
                <xsl:attribute name="schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance">
                    <xsl:value-of select="$ead4-xmlns || ' ' || $schema-path || $schema-name"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$add-migration-namespace">
                <xsl:namespace name="migration" select="$ead4-xlmns-migration"/>
            </xsl:if>
            <xsl:if test="$add-xhtml-namespace">
                <xsl:namespace name="xhtml" select="$xhtml-namespace"/>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>        
    </xsl:template> 
    
    <!-- various cleanup, as part of the new schema association-->
    <xsl:template match="@xsi:schemaLocation"/>
    <xsl:template match="processing-instruction('xml-model')[$remove-existing-schematron-declarations]"/>
    <xsl:template match="processing-instruction('xml-stylesheet')[$remove-existing-stylesheet-declarations]"/>
    
    
    <!-- not yet used, but will implement later -->
    <xsl:template name="add-comment-and-message">
        <xsl:param name="comment"/>
        <xsl:if test="$add-migration-comments=true()">
            <xsl:comment><xsl:value-of select="$comment"/></xsl:comment>
        </xsl:if>
        <xsl:if test="$add-migration-messages=true()">
            <xsl:message>
                <xsl:value-of select="$comment"/>
            </xsl:message>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
