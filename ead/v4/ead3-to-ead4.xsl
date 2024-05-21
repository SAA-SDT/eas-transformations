<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all"
    version="3.0">
    
    <!-- XSLT3 conversion process to transform EAC-CPF 1.0 documents to EAC-CPF 2.0 -->
    
    <!-- to do:
        1) review if outline/level to list/list is output as expected;
        2) add a separate XSLT file to handle the sorting of elements, which would cut down on the file size of this one considerably?;
        2) add more options?;
    -->

    <xsl:output method="xml" encoding="UTF-8" indent="true"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    
    <!-- Global Parameters --> 
    <xsl:param name="ead4-xmlns" select="'https://archivists.org/ns/ead/v4'" as="xs:string"/>  
    <xsl:param name="ead4-xlmns-migration" select="'https://archivists.org/ns/ead4/migration'" as="xs:string"/>

    <xsl:param name="default-empty-element-text" select="'***** WARNING: content is now required when this element is utilized in this way. Nothing to add, aside from this warning message, so please fix manually *****'" as="xs:string"/>
    <xsl:param name="default-empty-message" select="'This empty element would be invalid in the new EAD4 data model. Because of that, the transformation is adding some extra structure to the output. Please review.'"/>

    <!-- note, if changed (since we don't have an internationalization file), then the *message / *text / *name parameters should also be updated -->
    <xsl:param name="default-xml-lang" select="'eng'" as="xs:string"/>
    <xsl:param name="default-migration-event-type" select="'updated'" as="xs:string"/>
    <xsl:param name="default-migration-agent-name" select="'EAD 3 to EAD 4 Migration Style Sheet (ead3-to-ead4.xsl)'" as="xs:string"/>
    <xsl:param name="default-migration-text" select="'EAD3 instance migrated to EAD 4 (https://archivists.org/ns/ead/v4)'" as="xs:string"/>
    <xsl:param name="include-migration-maintenanceEvent" select="true()" as="xs:boolean"/>


    
    <!-- by default, the output will be associated with the NVDL schema. You can switch to 'xsd', or pass 'xsd' to the transformation process, to associate your output files with the XSD schema instead of the RNG schema -->
        <!-- NOTE:  need to also append '-dev' in that case -->
    <xsl:param name="schema-output-version" select="'nvdl'" as="xs:string"/>

    <!-- replace with LoC URL paths once the files have been migrated -->
    <!-- https://raw.githubusercontent.com/SAA-SDT/eas-schemas/development/xml-schemas/ead/ead.nvdl -->
    <xsl:param name="schema-path" select="'https://raw.githubusercontent.com/SAA-SDT/eas-schemas/development/xml-schemas/ead/'" as="xs:string"/>
    <xsl:param name="schema-name" select="'ead' || '.' || $schema-output-version" as="xs:string"/>
    <!-- NOTE:  can go away, once we get the NVDL embed to work -->
    <xsl:param name="schematron-file" select="'https://raw.githubusercontent.com/SAA-SDT/eas-schematrons/ead4/schematron/ead.sch'" as="xs:string"/>
    


    <!-- Global Variables (NOTE: add 'em all!) -->
    <xsl:variable name="changed-element-names" select="map{
        'abbreviation': 'shortCode',
        'citation': 'reference',
        'placeEntry': 'placeName',
        'resourceRelation': 'relation',
        'script': 'writingSystem',
        'sourceEntry': 'reference'}
        "/>

   
    <!-- start to add templates, or split into modules ? -->

    
    <!-- HTML / FORMATTING EXTENSION SECTION -->
    


    
    <!-- BANISHED ELEMENTS -->

    
</xsl:stylesheet>
