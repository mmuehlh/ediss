<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    Rendering specific to the navigation (options)

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
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

    <xsl:output indent="yes"/>

    <!--
        The template to handle dri:options. Since it contains only dri:list tags (which carry the actual
        information), the only things than need to be done is creating the ds-options div and applying
        the templates inside it.

        In fact, the only bit of real work this template does is add the search box, which has to be
        handled specially in that it is not actually included in the options div, and is instead built
        from metadata available under pageMeta.
    -->
    <!-- TODO: figure out why i18n tags break the go button -->
    <xsl:template match="dri:options">
        <div id="sidebar">

			<div class="publish">
				<xsl:choose>
					<xsl:when test="contains(//dri:metadata[@element='request'][@qualifier='URI'], 'submit')">
						<a href="#">
							<i18n:text>xmlui.general.publish_now</i18n:text>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<!--<xsl:variable name="container">
							<xsl:choose>
								<xsl:when test="//dri:metadata[@qualifier='container'] and not(//dri:metadata[@qualifier='object'])">
									<xsl:value-of select="concat('/handle/', substring-after(//dri:metadata[@qualifier='container'], 'hdl:'), '/')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>/</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable> -->
						<a href="{$context-path}/submit">
	                                                        <i18n:text>xmlui.general.publish_now</i18n:text>
						</a>				
					</xsl:otherwise>
				</xsl:choose>
					
			</div>
			<!-- <h1 class="ds-option-set-head"><i18n:text>xmlui.navigation.help.header</i18n:text></h1>	
			<div class="ds-option-set">
				<ul class="ds-simple-list">
					<li><a href="{$context-path}/help/fullpublication"><i18n:text>xmlui.navigation.help.publication_process</i18n:text></a></li>
					<li><a href="{$context-path}/help/pdf-howto"><i18n:text>xmlui.navigation.help.pdf_howto</i18n:text></a></li>
					<li><a href="{$context-path}/help/deposit-license"><i18n:text>xmlui.deposit.license.title</i18n:text></a></li>
					<li><a href="{$context-path}/help/good-to-know"><i18n:text>xmlui.navigation.help.general</i18n:text></a></li>
				</ul>
			</div> -->
			<!-- Once the search box is built, the other parts of the options are added -->
			<xsl:apply-templates/>
			<h1 class="ds-option-set-head"><i18n:text>xmlui.navigation.help.header</i18n:text></h1>
                        <div id="static.help" class="ds-option-set">
                                <ul class="ds-simple-list">
                                        <li><a href="{$context-path}/help/fullpublication"><i18n:text>xmlui.navigation.help.publication_process</i18n:text></a></li>
                                        <li><a href="{$context-path}/help/pdf-howto"><i18n:text>xmlui.navigation.help.pdf_howto</i18n:text></a></li>
                                        <!--<li><a href="{$context-path}/help/cumulative-diss"><i18n:text>xmlui.navigation.help.cumulative_dissertation</i18n:text></a></li> -->
                                        <li><a href="{$context-path}/help/deposit-license"><i18n:text>xmlui.deposit.license.title</i18n:text></a></li>
                                        <li><a href="{$context-path}/help/good-to-know"><i18n:text>xmlui.navigation.help.general</i18n:text></a></li>
                                </ul>
                        </div>

			<!-- DS-984 Add RSS Links to Options Box -->
			<!-- <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']) != 0">
				<h1 id="ds-feed-option-head" class="ds-option-set-head">
					<i18n:text>xmlui.feed.header</i18n:text>
				</h1>
				<div id="ds-feed-option" class="ds-option-set">
					<ul>
						<xsl:call-template name="addRSSLinks"/>
					</ul>
				</div>
			</xsl:if> -->

        </div>
    </xsl:template>

    <!-- Add each RSS feed from meta to a list -->
   <!-- <xsl:template name="addRSSLinks">
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
            <li>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>

                    <xsl:attribute name="style">
                        <xsl:text>background: url(</xsl:text>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/static/icons/feed.png) no-repeat</xsl:text>
                    </xsl:attribute>

                    <xsl:choose>
                        <xsl:when test="contains(., 'rss_1.0')">
                            <xsl:text>RSS 1.0</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(., 'rss_2.0')">
                            <xsl:text>RSS 2.0</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(., 'atom_1.0')">
                            <xsl:text>Atom</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@qualifier"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </li>
        </xsl:for-each>
    </xsl:template> -->

    <!--give nested navigation list the class sublist-->
    <xsl:template match="dri:options/dri:list/dri:list" priority="3" mode="nested">
        <li>
            <xsl:apply-templates select="dri:head" mode="nested"/>
            <ul class="ds-simple-list sublist">
                <xsl:apply-templates select="dri:item" mode="nested"/>
            </ul>
        </li>
    </xsl:template>

    <!-- Quick patch to remove empty lists from options -->
    <xsl:template match="dri:options//dri:list[count(child::*)=0]" priority="5" mode="nested">
    </xsl:template>
    <xsl:template match="dri:options//dri:list[count(child::*)=0]" priority="5">
    </xsl:template>

</xsl:stylesheet>
