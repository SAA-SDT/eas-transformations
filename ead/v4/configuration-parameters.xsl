<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    
    <!-- for now, just keeping this in XML, but will try out other options to make customizations easier later on -->
    <!-- 
        
    Perhaps a simple spreadsheet (not Excel, though)?, e.g.:
    
    Name                       | Value
    __________________________________________
    
    output-schema              |  xsd
    add-migration-event        |  True
    default-empty-source-note  |  All sources should have at least one reference element, which should at a minimum referencing the title of the source
    -->
    
    
    
    <!-- Global Parameters (likely no need for configuration options) --> 
    <xsl:param name="ead4-xmlns" select="'https://archivists.org/ns/ead/v4'" as="xs:string"/>  
    <!-- will be used with elementated attributes, like encodinganalog.  e.g. @migration:encodinganalog -->
    <xsl:param name="ead4-xlmns-migration" select="'https://archivists.org/ns/ead4/migration'" as="xs:string"/>
    <xsl:param name="xhtml-namespace" select="'http://www.w3.org/1999/xhtml'" as="xs:string"/>
    
    <!-- Global Parameters (that should be easy to change) -->
    <xsl:param name="default-empty-element-text" select="'***** WARNING: content is now required when this element is utilized in this way. Nothing to add, aside from this warning message, so please fix manually *****'" as="xs:string"/>
    <xsl:param name="default-empty-message" select="'This empty element would be invalid in the new EAD4 data model. Because of that, the transformation is adding some extra structure to the output. Please review.'"/>
    <xsl:param name="default-text-value" select="'UNKNOWN'"/>
    <xsl:param name="default-empty-source-note" select="'All sources should have at least one reference element, which should at a minimum referencing the title of the source'"/>
    
    <!-- note, if changed (since we don't have an internationalization file), then the *message / *text / *name parameters should also be updated -->
    <xsl:param name="default-xml-lang" select="'eng'" as="xs:string"/>
    <xsl:param name="default-migration-event-type" select="'updated'" as="xs:string"/>
    <xsl:param name="default-migration-agent-type" select="'machine'" as="xs:string"/>
    <xsl:param name="default-migration-agent-name" select="'TS-EAS EAD to EAD 4 Migration Style Sheet (ead-to-ead4.xsl)'" as="xs:string"/>
    <xsl:param name="default-migration-text" select="'EAD instance migrated to EAD 4 (https://archivists.org/ns/ead/v4)'" as="xs:string"/>
    <xsl:param name="add-migration-event" select="true()" as="xs:boolean"/>
    
    <xsl:param name="instance-url-link-role" select="'EAD Source'"/>
    
    <!-- You can switch the schema output using the following values: 'nvdl', 'rng', or 'xsd' -->
    <xsl:param name="schema-output-version" select="'xsd'" as="xs:string"/>
    
    <!-- replace with LoC URL paths once the files have been migrated -->
    <!-- https://raw.githubusercontent.com/SAA-SDT/eas-schemas/development/xml-schemas/ead/ead.nvdl -->
    <xsl:param name="schema-path" select="'https://raw.githubusercontent.com/SAA-SDT/eas-schemas/development/xml-schemas/ead/'" as="xs:string"/>
    <!-- remove the 'else' bit here once the default ead filename / EAD2002 issue with oXygen is addressed -->
    <xsl:param name="schema-name" select="if ($schema-output-version eq 'nvdl') then 'ead.' || $schema-output-version else 'ead-4-dev.' || $schema-output-version " as="xs:string"/>
    <!-- NOTE:  can go away, once we get the NVDL embed to work -->
    <xsl:param name="schematron-file" select="'https://raw.githubusercontent.com/SAA-SDT/eas-schematrons/ead4/schematron/ead.sch'" as="xs:string"/>
    
    <xsl:param name="remove-existing-schematron-declarations" select="true()" as="xs:boolean"/>
    <xsl:param name="remove-existing-stylesheet-declarations" select="true()" as="xs:boolean"/>

    <xsl:param name="add-migration-comments" select="false()" as="xs:boolean"/>
    <xsl:param name="add-migration-messages" select="false()" as="xs:boolean"/>
    
    <!-- add more language-based configuration options, for messages, text node values (e.g. Person), etc. -->
    
</xsl:stylesheet>