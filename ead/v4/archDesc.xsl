<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    
    <!-- 
    AGENTS:


Agent, attribute:
"Move repository/localtype to agent@localType; 
    create a localTypeDeclaration with @id in control and add the default content ""List of local types for agents"" to its sub-element reference; then add @localTypeDeclarationReference to agent pointing to the @id of said localTypeDeclaration; if a localTypeDeclaration with this content in its sub-element reference already exists, point to this instead of creating another one
    
Remove @encodinganalog and include a comment about the removal; 
    if any parent element in EAD3 indicates a relatedencoding according to MARC21, add the MARC21 namespace and use the attribute @marc21:tag in agent to include the value of @encodinganalog (xmlns:marc21=""http://www.loc.gov/MARC21/slim"" marc21:tag=""..."")
    
Remove @label and include comment about the removal; an option could be to suggest adding the XHTML namespace and using the attribute @title in abstract to include the value of @label (xmlns:xhtml=""http://www.w3.org/1999/xhtml"" xhtml:title=""..."")"

-->
    
    <!-- update for both ead2002 and ead3 -->
    <xsl:template match="ead3:archdesc | ead3:c | ead3:*[matches(local-name(), '^c0|^c1')]" priority="2">
        <xsl:variable name="current-node-name" select="local-name()"/>
        <xsl:element name="{if (map:contains($changed-element-names, $current-node-name)) then map:get($changed-element-names, $current-node-name)[1] else $current-node-name}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="ead3:did"/>
            <xsl:if test="ead3:did/ead3:repository, ead3:did/ead3:origination">
                <xsl:call-template name="agents"/>
            </xsl:if>
            <xsl:if test="ead3:altformavail, ead3:originalsloc, ead3:did/ead3:dao, ead3:did/ead3:daoset">
                <xsl:call-template name="formsAvailable"/>
            </xsl:if>
            <xsl:apply-templates select="* except (ead3:did, ead3:altformavail, ead3:originalsloc)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:did">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <!-- TO DO: add everything else here that is getting promoted out of did -->
            <xsl:apply-templates select="* except (ead3:repository, ead3:origination, ead3:dao, ead3:daoset)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:didnote">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@*"/>
            <xsl:element name="p" namespace="{$ead4-xmlns}">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="agents">
        <xsl:element name="agents" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="ead3:did/ead3:repository/*[contains(local-name(), 'name')] | ead3:did/ead3:origination/*" mode="structured-agents"/>
        </xsl:element>
    </xsl:template>
    
    <!-- what attribute data do we need to inherit from repository and origination?
        and what to do if it conflicts ? -->
    <!-- break this up, once the logic is worked out regarding all the attributes, etc. -->
    <xsl:template match="ead3:corpname | ead3:famname | ead3:name | ead3:persname" mode="structured-agents">
        <xsl:element name="{map:get($changed-element-names, local-name())[1]}" namespace="{$ead4-xmlns}">
            
            <xsl:if test="ead3:part[2]">
                <xsl:comment select="'Multiple part elements have been combined into a single agentName'"/>
                <!-- add the before elements as an inline comment -->
            </xsl:if>
            <xsl:element name="agentName" namespace="{$ead4-xmlns}">
                <xsl:sequence select="string-join(ead3:part, ', ')"/>
            </xsl:element>
            
            <!-- these values should be paramertized for language choice, right???? -->
            <!-- and this section should be moved, once refined -->
            <xsl:if test="parent::ead3:repository or parent::ead3:origination/*[not(local-name() eq 'name')]">
                <xsl:element name="agentRole" namespace="{$ead4-xmlns}">
                    <xsl:value-of select="if (parent::ead3:repository) then 'Repository'
                        else if (self::ead3:corpname) then 'Corporate Body' 
                        else if (self::ead3:famname) then 'Family'
                        else 'Person'"/>
                </xsl:element>   
             </xsl:if>
            
            <!-- 
            Move the content of each repository/address/addressline into a separate agent/placeName; 
    if addressline was used with a @localtype, move the value of this attribute to placeName@localType in this context
    
        A single address is a single placeName, though. 
        Shouldn't this instead be:
            repository/address
            ==>
            agent/place/address
            
            if the schema allowed place rather than just placeName 
            
            the more exceptions, the more confusing the whole thing gets.
            ?
            
            -->
            <xsl:apply-templates select="parent::ead3:repository/ead3:address/ead3:addressline" mode="addressline-to-placeName"/>
            
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead3:addressline" mode="addressline-to-placeName">
        <xsl:element name="placeName" namespace="{$ead4-xmlns}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>