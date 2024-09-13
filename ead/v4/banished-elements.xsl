<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!--
        
     archdescgrp
     daogrp
     descgrp
     eadgrp
     linkgrp
     namegrp
     
     note
     
        -->
    
    <xsl:template match="ead3:localcontrol"/>
    <xsl:template match="ead3:maintenancestatus"/>
    

    
    <!-- now, HTML only -->
    <!-- should add a configuration setting to make this the first paragraph of a note, if nothing else needs HTML in it.
            e.g. <p localtype:head>whatever</p>
    or
        <p>
            HEAD: 
            .... rest of note.
        </p>
    -->
    <xsl:template match="ead3:abstract"/>
    <xsl:template match="ead3:chronlist"/>
    <xsl:template match="ead3:head"/>
    <xsl:template match="ead3:head01"/>
    <xsl:template match="ead3:head02"/>
    <xsl:template match="ead3:head03"/>
    <xsl:template match="ead3:list"/>
    <xsl:template match="ead3:lb"/>
    <xsl:template match="ead3:table"/>
    <xsl:template match="ead3:thead"/>
    
</xsl:stylesheet>