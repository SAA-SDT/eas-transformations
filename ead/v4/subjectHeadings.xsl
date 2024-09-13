<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- 
When genreform is used as sub-element of controlaccess, indexentry, or namegrp, 
transform it to subject within subjectHeadings (with integrates controlaccess and index)

Move the content of the part sub-element(s) of genreform into subject/term; 
if genreform includes several part elements, concatenate these into the same term element and include a comment about this concatenation
    

Create a targetType element parallel to subject/term and add the default content "genre or form"
Create a targetRole element parallel to subject/term and add the value of the attribute @relator (if that was used with genreform); otherwise include a comment about targetRole being available for further definition
    
    -->
    
<!-- 
 When subject is used as sub-element of controlaccess, indexentry, or namegrp, 
 transform it to subject within subjectHeadings

Move the content of the part sub-element(s) of subject into term; 
if subject includes several part elements, concatenate these into the same term element and include a comment about this concatenation

    (this just does not work for how subject headings have been encoded at LoC and elsewhere...)

Create a targetRole sub-element and add the value of the attribute @relator (if that was used with subject); otherwise include a comment about targetRole being available for further definition

When subject is used as a mixed content element in ref, archref, bibref, abstract, unittitle, physfacet, or p, transform it to referringString in reference, abstract, unitTitle, physFacet and p respectively
Move the content of the part sub-element(s) of subject into referringString; if subject includes several part elements, concatenate these into the same referringString element and include a comment about this concatenation

When subject is used as a mixed content element in event, item, or entry, find appropriate XHTML encoding to capture its information, e.g. the XHTML element <span> within the XHTML elements <li>, <td>, or <dt> together with the XHTML @title attribute including the default value "Name of a subject"   
    
 -->
    
    <!-- TO DO:  address nested controlaccess sections.. these will need to be de-nested, with formatting moved 
        to some sort of XHTML content? -->
    
    <xsl:template match="ead3:controlaccess[ead3:controlaccess]">
        <xsl:comment select="'TO DO: still need to address nested controlaccess options'"/>
        <xsl:apply-templates select="ead3:controlaccess"/>
    </xsl:template>
    
    <xsl:template match="ead3:controlaccess/(ead3:persname | ead3:corpname | ead3:famname | ead3:geogname | ead3:name | ead3:occupation | ead3:subject | ead3:genreform | ead3:function | ead3:title)">
        <xsl:element name="subject" namespace="{$ead4-xmlns}">
            <xsl:attribute name="localType" select="local-name()"/>
            <xsl:apply-templates select="ead3:part" mode="subject-headings"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:part" mode="subject-headings">
        <xsl:element name="term" namespace="{$ead4-xmlns}">
            <xsl:if test="@localtype">
                <xsl:attribute name="{'migration:localTermType'}" namespace="{$ead4-xlmns-migration}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@* except @localtype|node()"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>