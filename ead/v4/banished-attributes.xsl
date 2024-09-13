<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    exclude-result-prefixes="xs math"
    version="3.0">

    <!-- still need to handle @base, which will be prepanded to valueURI when feasible -->
   
    <xsl:template match="@actuate | @altrender | @encodinganalog | @relatedencoding | @render | @show">
        <xsl:attribute name="{'migration:' || local-name()}" namespace="{$ead4-xlmns-migration}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    
    <!-- this is repurposed elsewhere, so removing from recordId entirely with this statement -->
    <xsl:template match="@instanceurl"/>

    
    <!-- these will all be moved to localType declaration references -->
    <xsl:template match="@label"/>
    
</xsl:stylesheet>