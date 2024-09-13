<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- 
    ﻿May occur within
abstract (X), container, dimensions, eventDescription, head, materialSpec, p,
physDesc, physFacet, physLoc, reference, unitDate, unitId, unitTitle (X)
    -->
    
    <!-- first, we handle the elements that have multiple migration paths (i.e., not footnote, etc.) -->
    <!-- not a fan of this approach now, since abbr needs to be handled differently due to the control section. 
    for now, changing that to a different mode, but it would be ideal to come up with a standard approach -->
    <xsl:template match="ead3:abstract/(ead3:persname | ead3:corpname | ead3:famname | ead3:geogname | ead3:name | ead3:occupation | ead3:subject | ead3:genreform | ead3:function | ead3:title | ead3:date) |
                         ead3:unittitle/(ead3:persname | ead3:corpname | ead3:famname | ead3:geogname | ead3:name | ead3:occupation | ead3:subject | ead3:genreform | ead3:function | ead3:title | ead3:date) |
                         ead3:p/(ead3:persname | ead3:corpname | ead3:famname | ead3:geogname | ead3:name | ead3:occupation | ead3:subject | ead3:genreform | ead3:function | ead3:title | ead3:date) |
                         
                         (: still to review :)
                         ead3:ref/(ead3:corpname| ead3:famname| ead3:function| ead3:occupation| ead3:persname| ead3:name| ead3:title) | 
                         ead3:archref/(ead3:corpname| ead3:famname| ead3:function| ead3:occupation| ead3:persname| ead3:name| ead3:title) |
                         ead3:bibref/(ead3:corpname| ead3:famname| ead3:function| ead3:occupation| ead3:persname| ead3:name| ead3:title) |
                         ead3:abstract/(ead3:corpname| ead3:famname| ead3:function| ead3:occupation| ead3:persname| ead3:name| ead3:title) |
                         ead3:physfacet/(ead3:corpname| ead3:famname| ead3:function| ead3:occupation| ead3:persname| ead3:name| ead3:title) |

                         ead3:footnote | ead3:num | ead3:abbr | ead3:expan">
        
        <xsl:if test="ead3:part[2]">
            <xsl:comment select="'TO DO:  write this comment, and then add it to the configuration options! Something about more than one part element being combined... and make the separator configurable, too.'"/>
        </xsl:if>

        <xsl:element name="referringString" namespace="{$ead4-xmlns}">
            <xsl:attribute name="localType" select="local-name()"/>
            <!-- change to apply templates once we figure out how best to handle attributes for date, etc. -->
            <xsl:sequence select="if (ead3:part) then string-join(ead3:part, ', ') else text()"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>