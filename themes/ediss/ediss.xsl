<?xml version="1.0" encoding="UTF-8"?>
<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    TODO: Describe this XSL file    
    Author: Alexey Maslov
    
-->    

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:dri="http://di.tamu.edu/DRI/1.0/"
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/TR/xlink/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">
    
    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:output indent="yes"/>
    
    
    <!-- An example of an existing template copied from structural.xsl and overridden -->  
    <xsl:template name="buildFooter">
        <div id="ds-footer">
            This footer has had its text and links changed. This change should override the existing template.
            <div id="ds-footer-links">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/contact</xsl:text>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                </a>
                <xsl:text> | </xsl:text>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/feedback</xsl:text>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.feedback-link</i18n:text>
                </a>
            </div>
        </div>
    </xsl:template>

    <!-- render each field on a row, alternating phase between odd and even -->
    <!-- recursion needed since not every row appears for each Item. -->
    <xsl:template name="itemSummaryView-DIM-fields">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>

            <!--  artifact?
            <tr class="ds-table-row odd">
                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-preview</i18n:text>:</span></td>
                <td>
                    <xsl:choose>
                        <xsl:when test="mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                            <a class="image-link">
                                <xsl:attribute name="href"><xsl:value-of select="@OBJID"/></xsl:attribute>
                                <img alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                            mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-preview</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>-->
            
          <!-- Title row -->
          <xsl:when test="$clause = 1 and (dim:field[@element='title' and @qualifier='tranlsated'])">
            <tr class="ds-table-row {$phase}">
                <td><span class="bold"><i18n:text>Übersetzter Titel</i18n:text>: </span></td>
                <td>
			<xsl:value-of select="dim:field[@element='title' and @qualifier='tranlsated']" disable-output-escaping="yes"/>
                </td>
            </tr>
            <xsl:call-template name="itemSummaryView-DIM-fields">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title alternative -->
          <xsl:when test="$clause = 2 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <tr class="ds-table-row {$phase}">
                        <td><span class="bold"><i18n:text>Untertitel</i18n:text>:</span></td>
                        <td>
                                        <xsl:value-of select="dim:field[@element='title' and @qualifier='alternative']" />

                        </td>
                    </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- title alternative translated -->
          <xsl:when test="$clause = 3 and (dim:field[@element='title' and @qualifier='alternativeTranslated'])">
                    <tr class="ds-table-row {$phase}">
                        <td><span class="bold"><i18n:text>Untertitel übersetzt</i18n:text>:</span></td>
                        <td>
                                        <xsl:value-of select="dim:field[@element='title' and @qualifier='alternativeTranslated']" />

                        </td>
                    </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- Author(s) row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] or dim:field[@element='contributor'])">
                    <tr class="ds-table-row {$phase}">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>:</span></td>
	                <td>
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='contributor']">
	                            <xsl:for-each select="dim:field[@element='contributor']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	                </td>
	            </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- Abstract row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='description' and @qualifier='abstractger'])">
                    <tr class="ds-table-row {$phase}">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</span></td>
	                <td>
	                <!-- <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<hr class="metadata-seperator"/>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
	                    	<hr class="metadata-seperator"/>
	                    </xsl:if>
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<hr class="metadata-seperator"/>
	                </xsl:if> -->
			<xsl:value-of select="dim:field[@element='description' and @qualifier='abstractger']"/>
	                </td>
	            </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- Description row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='description' and @qualifier='abstracteng'])">
                    <tr class="ds-table-row {$phase}">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span></td>
	                <td>
	                <!-- <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
	                	<hr class="metadata-seperator"/>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
	                    	<hr class="metadata-seperator"/>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
	                	<hr class="metadata-seperator"/>
	                </xsl:if> -->
			<xsl:value-of select="dim:field[@element='description' and @qualifier='abstracteng']"/>
	                </td>
	            </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- identifier.uri row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <tr class="ds-table-row {$phase}">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span></td>
	                <td>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </td>
	            </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- date.issued row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='date' and @qualifier='issued'])">
                    <tr class="ds-table-row {$phase}">
	                <td><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></td>
	                <td>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </td>
	            </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- identifier.purl row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='identifier' and @qualifier='purl'])">
                    <tr class="ds-table-row {$phase}">
                        <td><span class="bold"><i18n:text>PURL</i18n:text>:</span></td>
                        <td>
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="dim:field[@element='identifier' and @qualifier='purl']"/></xsl:attribute>
					<xsl:value-of select="dim:field[@element='identifier' and @qualifier='purl']"/>
				</a>
	
                        </td>
                    </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
	
          <!-- date examination row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='date' and @qualifier='examination'])">
                    <tr class="ds-table-row {$phase}">
                        <td><span class="bold"><i18n:text>Prüfung</i18n:text>:</span></td>
                        <td>
                                        <xsl:value-of select="dim:field[@element='date' and @qualifier='examination']"/>

                        </td>
                    </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- affiliation address row -->
          <xsl:when test="$clause = 11 and (dim:field[@element='affiliation' and @qualifier='address'])">
                    <tr class="ds-table-row {$phase}">
                        <td><span class="bold"><i18n:text>E-Mail</i18n:text>:</span></td>
                        <td>
                                        <xsl:value-of select="dim:field[@element='affiliation' and @qualifier='address']"/>

                        </td>
                    </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- affiliation birth day row -->
          <xsl:when test="$clause = 12 and (dim:field[@element='affiliation' and @qualifier='dateOfBirth'])">
                    <tr class="ds-table-row {$phase}">
                        <td><span class="bold"><i18n:text>Geburtstag</i18n:text>:</span></td>
                        <td>
                                        <xsl:value-of select="dim:field[@element='affiliation' and @qualifier='dateOfBirth']"/>

                        </td>
                    </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- faculty row -->
          <xsl:when test="$clause = 13 and (dim:field[@element='affiliation' and @qualifier='institut'])">
                    <tr class="ds-table-row {$phase}">
                        <td><span class="bold"><i18n:text>Fakultät</i18n:text>:</span></td>
                        <td>
                                        <xsl:value-of select="dim:field[@element='affiliation' and @qualifier='institut']"/>

                        </td>
                    </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

	 <!-- urn row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='identifier' and @qualifier='urn'])">
                    <tr class="ds-table-row {$phase}">
                        <td><span class="bold"><i18n:text>URN</i18n:text>:</span></td>
                        <td>
                                        <xsl:value-of select="dim:field[@element='identifier' and @qualifier='urn']"/>

                        </td>
                    </tr>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>


          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 15">
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    
    <!-- The summaryView of communities and collections is undefined. -->
    <xsl:template name="collectionSummaryView-DIM">
        <i18n:text>xmlui.dri2xhtml.METS-1.0.collection-not-implemented</i18n:text>
    </xsl:template>
    
    <xsl:template name="communitySummaryView-DIM">
        <i18n:text>xmlui.dri2xhtml.METS-1.0.community-not-implemented</i18n:text>
    </xsl:template>


    
</xsl:stylesheet>
