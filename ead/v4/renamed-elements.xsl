<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead3="http://ead3.archivists.org/schema/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all"
    version="3.0">
    
    <!-- for now, just keeping this in XML, but will try out other options to make customizations easier later on -->
    
    <!-- 
    elements to attributes:
    
    eventtype  - maintenanceEventType
    
    maintenancestatus - maintenanceStatus
    
    publicationstatus - publicationStatus
    
    -->
    
    <xsl:variable name="changed-element-names" as="map(xs:string, item()*)" select="map{
        'abbr': ('shortCode', 'referringString'),
        'abbreviation': 'shortCode',
        'accessrestrict': 'accessConditions',
        'acqinfo': 'sourceOfAcquisition',
        'addressline': 'addressLine',
        'agencycode': 'agencyCode',
        'agencyname': 'agencyName',
        'agenttype': 'agentType',
        'altformavail': 'formAvailable',
        
        (: only needed for EAD2002, not 3, but still adding it here :)
        'arc': 'reference',
      
        'archdesc': 'archDesc',
        'archref': 'reference',
        'author': 'agent',
        'bibliography': 'publicationNote',
        'bibref': 'reference',
        
        (: only needed for EAD2002, not 3, but still adding it here :)
        'bibseries': 'reference',
        
        'bioghist': 'biogHist',
        
        (: only needed for EAD2002, not 3, but still adding it here :)
        'change': 'maintenanceEvent',
        
        'citation': 'reference',  
        'controlaccess': 'subjectHeadings',
        'conventiondeclaration': 'conventionDeclaration',
        'corpname': ('agent', 'referringString'),
        
        (: only needed for EAD2002, not 3, but still adding it here :)
        'creation': 'maintenanceEvent',
        
        'custodhist': 'custodHist',
        
        'dao': 'formAvailable',
        
        (: only needed for EAD2002, not 3, but still adding it here :)
        'daogrp': 'formsAvailable',
        
        'daoset': 'formsAvailable',       
        'date': ('date', 'referringString'),        
        'daterange': 'dateRange',
        'dateset': 'dateSet',
        
        (: review this closely :)
        'datesingle': 'date',
        
        'descriptivenote': 'descriptiveNote',
        'did': 'identificationData',
        'didnote': 'identificationDataNote',
        'dsc': 'descriptionOfComponents',
        
        (: only needed for EAD2002, not 3, but still adding it here :)
        'eadheader': 'control',
        'eadid': 'recordId',
        
        'emph': 'span',
        'eventdatetime': 'eventDateTime',
        'eventdescription': 'eventDescription',
        'expan': 'referrringString',
        
        (: only needed for EAD2002, not 3, but still adding it here :)
        'extent': 'quantity',
        'extptr': 'reference',
        'extptrloc': 'reference',
        'extref': 'reference',
        'extrefloc': 'reference',
        
        'famname': ('agent', 'referringString'),
        'filedesc': 'findAidDesc',
        
        'fileplan': 'filePlan',
        'footnote': 'referringString',
        'foreign': 'span',
        'fromdate': 'fromDate',
        'function': ('function', 'referringString'),
        'genreform': ('subject', 'referringString'),
        'geogname': ('place', 'referringString'),    
        'geographiccoordinates': 'geographicCoordinates',
        
        
        (: only needed for EAD2002, not 3, but still adding it here :)
        'imprint': 'reference',
        

        (: index 
        
        will be integrated with subjectHeadings, like controlAccess,
        but mapping might be complex :)
        
        'langmaterial': 'languageOfMaterial',
        'languagedeclaration': 'languageDeclaration',
        'languageset': 'languageSet',
        
        (: only needed for EAD2002, not 3, but still adding it here :)
        'langusage': 'languageDeclaration',
        
        'legalstatus': 'legalStatus',
        'localtypedeclaration': 'localTypeDeclaration',
        'maintenanceagency': 'maintenanceAgency',
        'maintenanceevent': 'maintenanceEvent',
        'maintenancehistory': 'maintenanceHistory',
        'materialspec': 'materialSpec',
        'name': ('agent', 'referringString'),
        'num': 'referringString',
        'objectxmlwrap': 'objectXMLWrap',
        'occupation': ('subject', 'referringString'),
        'odd': 'otherDescriptiveInfo',
        
        (: will also need to move around, so this will likely be handled with extra templates :)
        'originalsloc': 'formAvailable',
        
        'otheragencycode': 'otherAgencyCode',
        'otherfindaid': 'otherFindAid',
        'otherrecordid': 'otherRecordId',
        
        (: any hope to map 'part' here ? :)
        
        'persname': ('agent', 'referringString'),
        'physdesc': 'physDesc',
        'physdescset': 'physDescSet',
        'physdescstructured': 'physDescStructured',
        'physfacet': 'physFacet',
        'physloc': 'physLoc',
        'phystech': 'physicalOrTechnicalRequirements',
        'prefercite': 'preferCite',
        'processinfo': 'processInfo',
        
        (: review ptrgrp ptrloc :)
        'ptr': 'reference',
        'publisher': 'agent',
        
        'quote': 'span',
        
        'recordid': 'recordId',
        'ref': 'reference',
        'refloc': 'reference',
        'relatedmaterial': 'relatedMaterial',
        
        'representation': 'findAidDesc',


        
        (:  only in EAD2002 right now:
            
            resource, 
            revisiondesc, 
            runner
            subarea
        :)
        
        'rightsdeclaration': 'rightsDeclaration',
        'scopecontent': 'scopeContent',
        'script': 'writingSystem',
        'separatedmaterial': 'separatedMaterial',
        'sourceentry': 'reference', 
        'sponsor': 'agent',
        'subject': ('subject', 'referringString'),
        'subtitle': 'part',
        'title': ('publicationNote', 'referringString'),
        'titleproper': 'title',
        'todate': 'toDate',
        'unitdate': 'unitDate',
        'unitdatestructured': 'unitDateStructured',
        'unitid': 'unitId',
        'unittitle': 'unitTitle',
        'unittype': 'unitType',
        'userestrict': 'useConditions'}
    "/>
    
    <xsl:variable name="elements-to-attributes" as="map(xs:string, xs:string)" select="map{
        'eventtype': 'maintenanceEventType',
        'language': 'languageCode',
        'maintenancestatus': 'maintenanceStatus',
        'script': 'scriptCode'}
        "/>
    
    <xsl:template match="*">
        <xsl:variable name="current-node-name" select="local-name()"/>
        <xsl:element name="{if (map:contains($changed-element-names, $current-node-name)) then map:get($changed-element-names, $current-node-name)[1] else $current-node-name}" namespace="{$ead4-xmlns}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- find a good home for this, or maybe just add one file per element that needs special treatment? -->
    <xsl:template match="ead3:objectxmlwrap" priority="2">
        <xsl:element name="{map:get($changed-element-names, local-name())}" namespace="{$ead4-xmlns}">
            <xsl:copy-of select="*"/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="ead3:*" mode="element-to-attribute">
        <xsl:attribute name="{map:get($elements-to-attributes, local-name())}">
            <!-- if more than one, add the other values to a comment ?? -->
            <xsl:value-of select="(@value, @*[ends-with(local-name(), 'code')], .[normalize-space()])[1]"/>
        </xsl:attribute>
    </xsl:template>
    

    
</xsl:stylesheet>