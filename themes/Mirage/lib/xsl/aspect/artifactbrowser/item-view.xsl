<!--

	The contents of this file are subject to the license and copyright
	detailed in the LICENSE and NOTICE files at the root of the source
	tree and available online at

	http://www.dspace.org/license/

-->
<!--
	Rendering specific to the item display page.

	Author: art.lowel at atmire.com
	Author: lieven.droogmans at atmire.com
	Author: ben at atmire.com
	Author: Alexey Maslov

-->

<xsl:stylesheet
		xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
		xmlns:dri="http://di.tamu.edu/DRI/1.0/"
		xmlns:mets="http://www.loc.gov/METS/"
		xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
		xmlns:xlink="http://www.w3.org/TR/xlink/"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:ore="http://www.openarchives.org/ore/terms/"
		xmlns:oreatom="http://www.openarchives.org/ore/atom/"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xalan="http://xml.apache.org/xalan"
		xmlns:encoder="xalan://java.net.URLEncoder"
		xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
		exclude-result-prefixes="i18n dri mets dim xlink xsl atom ore oreatom xalan encoder util">

	<xsl:output indent="yes"/>
	<xsl:decimal-format name="de" decimal-separator="," grouping-separator="." />

	<xsl:template name="itemSummaryView-DIM">

		<xsl:variable name="dim" select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"/>

		<!-- Generate the info about the item from the metadata section -->
		<xsl:apply-templates select="$dim" mode="itemTitle-DIM"/>

		<div class="metadata">

			<xsl:apply-templates select="$dim" mode="itemTitleTranslated-DIM"/>
			<xsl:apply-templates select="$dim" mode="itemAuthors-DIM"/>
			<xsl:call-template name="itemType"/>	
			<xsl:apply-templates select="$dim" mode="itemExamination-DIM"/>
			<!--<xsl:apply-templates select="$dim" mode="itemCitation-DIM"/>-->
			<xsl:apply-templates select="$dim" mode="itemDate-DIM"/>
			<!--<xsl:apply-templates select="$dim" mode="itemPublisher-DIM"/>-->
			<!-- <xsl:apply-templates select="$dim" mode="itemPURL-DIM"/> -->
			<!--<xsl:apply-templates select="$dim" mode="itemEmail-DIM"/>-->
			<!--<xsl:apply-templates select="$dim" mode="itemBirth-DIM"/>-->
			<!-- <xsl:apply-templates select="$dim" mode="itemInstitute-DIM"/> -->
			<!-- <xsl:apply-templates select="$dim" mode="itemURN-DIM"/> -->
			<xsl:apply-templates select="$dim" mode="itemAdvisor-DIM"/>
			<xsl:apply-templates select="$dim" mode="itemReferee-DIM"/>
			<xsl:apply-templates select="$dim" mode="itemCoreferee-DIM"/>
			<xsl:apply-templates select="$dim" mode="itemThirdreferee-DIM"/> 

			<xsl:apply-templates select="$dim" mode="itemURI-DIM"/>	
			<!--<xsl:apply-templates select="$dim" mode="itemType-DIM"/>-->
			<!--<xsl:apply-templates select="$dim" mode="itemLanguage-DIM"/>-->
			<!--<xsl:apply-templates select="$dim" mode="itemSeries-DIM"/>-->
			<xsl:if test="$ds_item_view_toggle_url != ''">
				<p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
					<a>
						<xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
						<!-- <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text> -->
						<xsl:text>&#160;</xsl:text>
					</a>
				</p>
			</xsl:if>
			<span class="spacer">&#160;</span>

		</div>

		<!-- Generate the bitstream information from the file section -->
		<xsl:choose>
			<xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
				<xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
					<xsl:with-param name="context" select="."/>
					<xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
				</xsl:apply-templates>
			</xsl:when>
			<!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
			<xsl:when test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
				<xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE']"/>
			</xsl:when>
			<xsl:otherwise>
				<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
				<table class="ds-table file-list">
					<tr class="ds-table-header-row">
						<th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
						<th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
						<th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
						<th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
					</tr>
					<tr>
						<td colspan="4">
							<p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
						</td>
					</tr>
				</table>
			</xsl:otherwise>
		</xsl:choose>

		<!-- show embargo date if existent -->
		<xsl:if test="//dim:field[@qualifier='embargoed']">
			<div class="embargo-info">
				<xsl:variable name="year"><xsl:value-of select="substring-before(//dim:field[@qualifier='embargoed'], '-')" /></xsl:variable>
				<xsl:variable name="monthday"><xsl:value-of select="substring-after(//dim:field[@qualifier='embargoed'], '-')" /></xsl:variable>

				<p>
					<i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoed1</i18n:text>
					<xsl:value-of select="substring-after($monthday, '-')" /><xsl:text>.</xsl:text><xsl:value-of select="substring-before($monthday, '-')" /><xsl:text>.</xsl:text><xsl:value-of select="$year" />
					<i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoed2</i18n:text>
				</p>
			</div>
		</xsl:if>
		<!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default)-->
		<xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
		<xsl:apply-templates select="$dim" mode="itemLicense-DIM" />
		<hr />
		<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></h2>
		<div class="metadata">
			<xsl:apply-templates select="$dim" mode="itemAbstractGer-DIM"/>
			<xsl:apply-templates select="$dim" mode="itemAbstractEng-DIM"/>
			<div class="spacer">&#160;</div>
		</div>

		<xsl:apply-templates select="$dim" mode="itemKeywords-DIM"/>

		<!--<xsl:apply-templates select="$dim" mode="itemSummaryView-DIM"/>-->

	</xsl:template>

	<xsl:template match="dim:dim" mode="itemSummaryView-DIM">

		<!-- <xsl:choose> -->

		<!-- Abstract row -->
		<!--<xsl:when test="(dim:field[@element='description' and @qualifier='abstract'] and string-length(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
				<div class="simple-item-view-description">
					<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></h2>
					<div>
						<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
							<div class="spacer">&#160;</div>
						</xsl:if>
						<xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
							<xsl:copy-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
								<div class="spacer">&#160;</div>
								
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
							<div class="spacer">&#160;</div>
						</xsl:if>
					</div>
				</div>
			</xsl:when> -->

		<!-- Description row -->
		<!-- <xsl:when test="dim:field[@element='description' and not(@qualifier)]">
				<div class="simple-item-view-description">
					<h3 class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</h3>
					<div>
						<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
							<div class="spacer">&#160;</div>
						</xsl:if>
						<xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
							<xsl:copy-of select="./node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
								<div class="spacer">&#160;</div>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
							<div class="spacer">&#160;</div>
						</xsl:if>
					</div>
				</div>
			</xsl:when> -->

		<!-- </xsl:choose> -->

	</xsl:template>

	<!-- Title row -->
	<xsl:template match="dim:dim" mode="itemTitle-DIM">
		<xsl:choose>
			<xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
				<!-- display first title as h1 -->
				<h1 class="title">
					<xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()" disable-output-escaping="yes"/>
				</h1>
				<xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
					<p class="subtitle"><xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" disable-output-escaping="yes"/></p>
				</xsl:if>
				<div class="simple-item-view-other">
					<span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
					<span>
						<xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
							<xsl:value-of select="./node()" disable-output-escaping="yes"/>
							<xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
								<xsl:text>; </xsl:text>
								<br/>
							</xsl:if>
						</xsl:for-each>
					</span>
				</div>
			</xsl:when>
			<xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
				<h1 class="title">
					<xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()" disable-output-escaping="yes"/>
				</h1>
				<xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
					<p class="subtitle"><xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" disable-output-escaping="yes"/></p>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<h1 class="title">
					<i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
				</h1>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="dim:dim" mode="itemAuthors-DIM">
		<!-- author(s) row -->
		<xsl:if test="dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] or dim:field[@element='contributor']">
			<div class="simple-item-view-authors">
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
					<!--	<xsl:when test="dim:field[@element='contributor']">
						<xsl:for-each select="dim:field[@element='contributor']">
							<xsl:copy-of select="node()"/>
							<xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:when> -->
					<xsl:otherwise>
						<i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemURI-DIM">
		<!-- identifier.uri row -->
		<xsl:if test="dim:field[@element='identifier' and @qualifier='uri']">
			<div class="simple-item-view-bookmark">
				<p>
					<i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:
					<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
						<a>
							<xsl:attribute name="class">
								<xsl:text>bookmark</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="href">
								<xsl:copy-of select="./node()"/>
							</xsl:attribute>
							<xsl:copy-of select="./node()"/>
						</a>
						<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
							<br/>
						</xsl:if>
					</xsl:for-each>
				</p>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemKeywords-DIM">
		<xsl:if test="dim:field[@element='subject' and @qualifier='gokverbal']">
			<div class="ds-item-categories"> 
				<strong><i18n:text>xmlui.dri2xhtml.METS-1.0.item-gok</i18n:text>:</strong>
				<xsl:for-each select="dim:field[@element='subject' and @qualifier='gokverbal']">
					<!--<xsl:copy-of select="."/>-->
					<a>
						<xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=subject&amp;value=', .)"/></xsl:attribute><xsl:value-of select="."/>
					</a>
					<xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='gokverbal']) != 0">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</div>
		</xsl:if>
		<xsl:if test="dim:field[@element='subject' and not(@qualifier)] ">
			<div class="ds-item-keywords">
				<strong><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject</i18n:text>:</strong>
				<!-- <xsl:for-each select="dim:field[@element='subject'][not(@qualifier)]"> 
					<xsl:call-template name="split-list">
						<xsl:with-param name="list">
							<xsl:value-of select="."/> 
						</xsl:with-param>
					</xsl:call-template> 
					<xsl:if test="count(following-sibling::dim:field[@element='subject'and not(@qualifier)]) != 0">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each> -->
				<xsl:value-of select="dim:field[@element='subject' and not(@qualifier)]"/>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemLicense-DIM">
		<xsl:if test="contains(dim:field[@element='rights'][@qualifier='uri'], 'creativecommons')">
			<div class="license-info">
				<p><i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text></p>
				<ul>
					<li><a href="{dim:field[@element='rights'][@qualifier='uri']}"><i18n:text>xmlui.dri2xhtml.structural.link_cc</i18n:text></a></li>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="split-list">
		<xsl:param name="list"/>
		<xsl:variable name="newlist" select="normalize-space($list)"/>
		<xsl:variable name="first">
			<xsl:choose>
				<xsl:when test="contains($newlist, ';')">
					<xsl:value-of select="substring-before($newlist, ';')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$newlist"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="remaining" select="substring-after($newlist, ';')"/>
		<a>
			<xsl:attribute name="href"><xsl:value-of select="concat($context-path, '/discover?query=')"/><xsl:value-of select="$first"/></xsl:attribute><xsl:value-of select="$first"/>
		</a>
		<xsl:choose>
			<xsl:when test="contains($remaining, ';')">
				<xsl:text>; </xsl:text>
				<xsl:call-template name="split-list">
					<xsl:with-param name="list" select="$remaining"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$remaining != ''">
					<a> 
						<xsl:attribute name="href"><xsl:value-of select="concat($context-path, '/advanced-search?field1=keyword&amp;query1=')"/><xsl:value-of select="$first"/></xsl:attribute><xsl:value-of select="$remaining"/>
					</a>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemPublisher-DIM">
		<xsl:if test="dim:field[@element='publisher']">
			<xsl:for-each select="dim:field[@element='publisher']">
				<xsl:copy-of select="./node()"/>
				<xsl:if test="count(following-sibling::dim:field[@element='publisher']) != 0">
					<hr class="metadata-seperator"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<!-- Hallo Marianna, an dieser Stelle sollte bei Sammelbaenden deren Titel auftrauchen; klappt aber nicht :( -->
	<xsl:template match="dim:dim" mode="itemSeries-DIM">
		<xsl:if test="dim:field[@element='relation' and @qualifier='ispartof']">
			<xsl:variable name="series">
				<xsl:choose>
					<xsl:when test="contains(dim:field[@element='relation' and @qualifier='ispartof'], ';')">
						<xsl:value-of select="substring-before(dim:field[@element='relation' and @qualifier='ispartof'],';')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartof']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<span class="series">
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($context-path, '/search?query=series:' , $series)"/></xsl:attribute><xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartof']"/>
				</a>
			</span>
		</xsl:if> 
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemCitation-DIM">
		<xsl:if test="dim:field[@element='identifier' and @qualifier='citation']">
			<xsl:value-of select="dim:field[@element='identifier' and @qualifier='citation']"/>
		</xsl:if>
	</xsl:template>


	<xsl:template match="dim:dim" mode="itemType-DIM">
		<xsl:if test="dim:field[@element='type']">
			<div class="simple-item-view-type">
				<xsl:for-each select="dim:field[@element='type']">
					<i18n:text><xsl:copy-of select="."/></i18n:text>
					<xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemLanguage-DIM">
		<xsl:if test="dim:field[@element='language']">
			<div class="simple-item-view-type">
				<i18n:text><xsl:value-of select="dim:field[@element='language']"/></i18n:text>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemDate-DIM">
		<!-- date.issued row -->
		<xsl:if test="dim:field[@element='date' and @qualifier='issued']">
			<div class="simple-item-view-other">
				<span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
				<span>
					<xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
						<xsl:copy-of select="substring(./node(),1,10)"/>
						<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
							<br/>
						</xsl:if>
					</xsl:for-each>
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemAbstractGer-DIM">
		<!-- Abstract german row -->
		<xsl:if test="dim:field[@element='description' and @qualifier='abstractger']">
			<div class="simple-item-view-abstract">
				<!--<span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span>-->
				<h3><i18n:text>xmlui.general.language.de</i18n:text></h3>
				<span>
					<xsl:value-of select="dim:field[@element='description' and @qualifier='abstractger']" disable-output-escaping="yes"/>
				</span>
			</div>
		</xsl:if>
	</xsl:template>


	<xsl:template match="dim:dim" mode="itemAbstractEng-DIM">
		<!-- Abstract english row -->
		<xsl:if test="dim:field[@element='description' and @qualifier='abstracteng']">
			<div class="simple-item-view-abstract">
				<!--<span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span>-->
				<h3><i18n:text>xmlui.general.language.en</i18n:text></h3>
				<span>
					<xsl:value-of select="dim:field[@element='description' and @qualifier='abstracteng']" disable-output-escaping="yes"/>
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemPURL-DIM">
		<xsl:if test="dim:field[@element='identifier' and @qualifier='purl']">
			<div class="simple-item-view-other">
				<span class="bold">PURL:</span>
				<span>
					<a href="{dim:field[@element='identifier' and @qualifier='purl']}" target="_blank">
						<xsl:value-of select="dim:field[@element='identifier' and @qualifier='purl']" />
					</a>
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemExamination-DIM">
		<xsl:if test="dim:field[@element='date' and @qualifier='examination']">
			<div class="simple-item-view-other">
				<span class="bold"><i18n:text>xmlui.item-view.examination</i18n:text>:</span>
				<span>
					<xsl:value-of select="dim:field[@element='date' and @qualifier='examination']" />
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemEmail-DIM">
		<xsl:if test="dim:field[@element='affiliation' and @qualifier='address']">
			<span class="bold">E-Mail:</span>
			<span>
				<xsl:value-of select="dim:field[@element='affiliation' and @qualifier='address']" />
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemBirth-DIM">
		<xsl:if test="dim:field[@element='affiliation' and @qualifier='dateOfBirth']">
			<div class="simple-item-view-other">
				<span class="bold">Geburtsdatum:</span>
				<span>
					<xsl:value-of select="dim:field[@element='affiliation' and @qualifier='dateOfBirth']" />
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemInstitute-DIM">
		<xsl:if test="dim:field[@element='affiliation' and @qualifier='institute']">
			<div class="simple-item-view-other">
				<span class="bold">Institut:</span>
				<span>
					<xsl:value-of select="dim:field[@element='affiliation' and @qualifier='institute']" />
				</span>
			</div>
		</xsl:if>
	</xsl:template>


	<xsl:template match="dim:dim" mode="itemURN-DIM">
		<xsl:if test="dim:field[@element='identifier' and @qualifier='urn']">
			<div class="simple-item-view-other">
				<span class="bold">URN:</span>
				<span>
					<xsl:value-of select="dim:field[@element='identifier' and @qualifier='urn']" />
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemAdvisor-DIM">
		<xsl:if test="dim:field[@element='contributor' and @qualifier='advisor']">
			<div class="simple-item-view-other">
				<span class="bold"><i18n:text>xmlui.item-view.advisor</i18n:text>:</span>
				<span>
					<xsl:value-of select="dim:field[@element='contributor' and @qualifier='advisor']" />
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemReferee-DIM">
		<xsl:if test="dim:field[@element='contributor' and @qualifier='referee']">
			<div class="simple-item-view-other">
				<span class="bold"><i18n:text>xmlui.item-view.referee</i18n:text>:</span>
				<span>
					<xsl:value-of select="dim:field[@element='contributor' and @qualifier='referee']" />
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemCoreferee-DIM">
		<xsl:if test="dim:field[@element='contributor' and @qualifier='coReferee']">
			<div class="simple-item-view-other">
				<span class="bold"><i18n:text>xmlui.item-view.referee</i18n:text>:</span>
				<span>
					<xsl:value-of select="dim:field[@element='contributor' and @qualifier='coReferee']" />
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dim:dim" mode="itemThirdreferee-DIM">
		<xsl:if test="dim:field[@element='contributor' and @qualifier='thirdReferee']">
			<div class="simple-item-view-other">
				<span class="bold"><i18n:text>xmlui.item-view.referee</i18n:text>:</span>
				<span>
					<xsl:value-of select="dim:field[@element='contributor' and @qualifier='thirdReferee']" />
				</span>
			</div>
		</xsl:if>
	</xsl:template>


	<xsl:template match="dim:dim" mode="itemTitleTranslated-DIM">
		<xsl:if test="dim:field[@element='title' and @qualifier='translated']">
			<p class="title translated">
				<xsl:value-of select="dim:field[@element='title' and @qualifier='translated']" disable-output-escaping="yes"/>
			</p>
			<xsl:if test="dim:field[@element='title'][@qualifier='alternativeTranslated']">
				<p class="subtitle translated"><xsl:value-of select="dim:field[@element='title'][@qualifier='alternativeTranslated']" disable-output-escaping="yes"/></p>
			</xsl:if>

		</xsl:if>
	</xsl:template>



	<xsl:template match="dim:dim" mode="itemDetailView-DIM">
		<span class="Z3988">
			<xsl:attribute name="title">
				<xsl:call-template name="renderCOinS"/>
			</xsl:attribute>
		</span>
		<table class="ds-includeSet-table detailtable">
			<xsl:apply-templates mode="itemDetailView-DIM"/>
		</table>
	</xsl:template>

	<xsl:template match="dim:field" mode="itemDetailView-DIM">
		<tr>
			<xsl:attribute name="class">
				<xsl:text>ds-table-row </xsl:text>
				<xsl:if test="(position() div 2 mod 2 = 0)">even </xsl:if>
				<xsl:if test="(position() div 2 mod 2 = 1)">odd </xsl:if>
			</xsl:attribute>
			<td class="label-cell">
				<xsl:value-of select="./@mdschema"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="./@element"/>
				<xsl:if test="./@qualifier">
					<xsl:text>.</xsl:text>
					<xsl:value-of select="./@qualifier"/>
				</xsl:if>
			</td>
			<td>
				<xsl:copy-of select="./node()"/>
				<xsl:if test="./@authority and ./@confidence">
					<xsl:call-template name="authorityConfidenceIcon">
						<xsl:with-param name="confidence" select="./@confidence"/>
					</xsl:call-template>
				</xsl:if>
			</td>
			<td><xsl:value-of select="./@language"/></td>
		</tr>
	</xsl:template>

	<xsl:template name="itemType">
		<span class="bold">
			Dissertation
		</span>
	</xsl:template>

	<!--dont render the item-view-toggle automatically in the summary view, only when it get's called-->
	<xsl:template match="dri:p[contains(@rend , 'item-view-toggle') and
		(preceding-sibling::dri:referenceSet[@type = 'summaryView'] or following-sibling::dri:referenceSet[@type = 'summaryView'])]">
	</xsl:template>

	<!-- dont render the head on the item view page -->
	<xsl:template match="dri:div[@n='item-view']/dri:head" priority="5">
	</xsl:template>

	<xsl:template match="mets:fileGrp[@USE='CONTENT']">
		<xsl:param name="context"/>
		<xsl:param name="primaryBitstream" select="-1"/>

		<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
		<div class="file-list">
			<xsl:choose>
				<!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
				<xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
					<xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</xsl:when>
				<!-- Otherwise, iterate over and display all of them -->
				<xsl:otherwise>
					<xsl:apply-templates select="mets:file">
						<xsl:sort data-type="number" select="boolean(./@ID=$primaryBitstream)" order="descending" />
						<xsl:sort select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="mets:file">
		<xsl:param name="context" select="."/>
		<div class="file-wrapper clearfix">
			<!--
			<div class="thumbnail-wrapper">
				<a class="image-link">
					<xsl:attribute name="href">
						<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]">
							<img alt="Thumbnail">
								<xsl:attribute name="src">
									<xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
								</xsl:attribute>
							</img>
						</xsl:when>
						<xsl:otherwise>
							<img alt="Icon" src="{concat($theme-path, '/images/mime.png')}" style="height: {$thumbnail.maxheight}px;"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</div>
			-->
			<div class="file-metadata"><!--style="height: {$thumbnail.maxheight}px;"-->
				<div>
					<span class="bold">
						<i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-name</i18n:text>
						<xsl:text>:</xsl:text>
					</span>
					<span>
						<xsl:attribute name="title"><xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/></xsl:attribute>
						<!-- TS: Why is the string shortened? Long strings don't break the layout -->
						<!--<xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:title, 17, 5)"/>-->
						<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
					</span>
				</div>
				<!-- File size always comes in bytes and thus needs conversion -->
				<div>
					<span class="bold">
						<i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text>
						<xsl:text>:</xsl:text>
					</span>
					<span>
						<xsl:choose>
							<xsl:when test="@SIZE &lt; 1024">
								<xsl:value-of select="format-number(@SIZE,'#,0 B','de')"/>
								<!--<i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>-->
							</xsl:when>
							<xsl:when test="@SIZE &lt; 1024 * 1024">
								<xsl:value-of select="format-number(substring(string(@SIZE div 1024),1,5),'#,0 KB','de')"/>
								<!--<i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>-->
							</xsl:when>
							<xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
								<xsl:value-of select="format-number(substring(string(@SIZE div (1024 * 1024)),1,5),'#,0 MB','de')"/>
								<!--<i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>-->
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number(substring(string(@SIZE div (1024 * 1024 * 1024)),1,5),'#,0 GB','de')"/>
								<!--<i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>-->
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</div>
				<!-- Lookup File Type description in local messages.xml based on MIME Type.
		 In the original DSpace, this would get resolved to an application via
		 the Bitstream Registry, but we are constrained by the capabilities of METS
		 and can't really pass that info through. -->
				<div>
					<span class="bold">
						<i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text>
						<xsl:text>:</xsl:text>
					</span>
					<span>
						<xsl:call-template name="getFileTypeDesc">
							<xsl:with-param name="mimetype">
								<xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
								<xsl:text>/</xsl:text>
								<xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
							</xsl:with-param>
						</xsl:call-template>
					</span>
				</div>
				<!---->
				<!-- Display the contents of 'Description' only if bitstream contains a description -->
				<xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
					<div>
						<span class="bold">
							<i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text>
							<xsl:text>:</xsl:text>
						</span>
						<span>
							<xsl:attribute name="title"><xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/></xsl:attribute>
							<!--<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>-->
							<xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:label, 17, 5)"/>
						</span>
					</div>
				</xsl:if>
			</div>
			<div class="file-link"><!-- style="max-height: {$thumbnail.maxheight}px;" -->
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
					</xsl:attribute>
					<i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
				</a>
			</div>
		</div>

	</xsl:template>

</xsl:stylesheet>
