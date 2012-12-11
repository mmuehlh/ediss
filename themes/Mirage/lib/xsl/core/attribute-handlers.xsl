<!--

	The contents of this file are subject to the license and copyright
	detailed in the LICENSE and NOTICE files at the root of the source
	tree and available online at

	http://www.dspace.org/license/

-->
<!--
	Templates to cover the attribute calls.

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

	<xsl:template match="@pagination">
		<xsl:param name="position"/>
		<xsl:choose>
			<xsl:when test=". = 'simple'">
				<div class="pagination clearfix {$position}">
				
					
					<p class="pagination-info">
						<i18n:translate>
							<xsl:choose>
								<xsl:when test="parent::node()/@itemsTotal = -1">
									<i18n:text>xmlui.dri2xhtml.structural.pagination-info.nototal</i18n:text>
								</xsl:when>
								<xsl:otherwise>
									<i18n:text>xmlui.dri2xhtml.structural.pagination-info</i18n:text>
								</xsl:otherwise>
							</xsl:choose>
							<i18n:param><xsl:value-of select="parent::node()/@firstItemIndex"/></i18n:param>
							<i18n:param><xsl:value-of select="parent::node()/@lastItemIndex"/></i18n:param>
							<i18n:param><xsl:value-of select="parent::node()/@itemsTotal"/></i18n:param>
						</i18n:translate>
					</p>
						<xsl:if test="parent::node()/@previousPage and contains(//dri:metadata[@qualifier='URI'], 'search-filter')">
                                                        <a class="previous-page-link">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:value-of select="parent::node()/@previousPage"/>
                                                                        </xsl:attribute>
                                                                        <i18n:text>xmlui.dri2xhtml.structural.pagination-previous</i18n:text>
                                                                </a>

                                                </xsl:if>

						<xsl:variable name="linkPrefix">
							<xsl:choose>
								<xsl:when test="parent::node()/@previousPage">
									<xsl:value-of select="substring-before(parent::node()/@previousPage, 'offset=')"/>
								</xsl:when>
								<xsl:when test="parent::node()/@nextPage">
									<xsl:value-of select="substring-before(parent::node()/@nextPage, 'offset=')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>nopaging</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:if test="$linkPrefix != 'nopaging'">
						<xsl:variable name="linkPostfix">
                                                        <xsl:choose>
                                                                <xsl:when test="parent::node()/@previousPage">
                                                                        <xsl:value-of select="substring-after(parent::node()/@previousPage, 'sort_by=')"/>
                                                                </xsl:when>
                                                                <xsl:when test="parent::node()/@nextPage">
                                                                        <xsl:value-of select="substring-after(parent::node()/@nextPage, 'sort_by=')"/>
                                                                </xsl:when>
                                                        </xsl:choose>
                                                </xsl:variable>
						<xsl:variable name="rpp">
							 <xsl:choose>
                                                                <xsl:when test="parent::node()/@previousPage">
									<xsl:variable name="temp"><xsl:value-of select="substring-before(parent::node()/@previousPage, '&amp;offset=')"/></xsl:variable>		
												
                                                                        <xsl:value-of select="substring-after($temp, 'rpp=')"/>
                                                                </xsl:when>
                                                                <xsl:when test="parent::node()/@nextPage">
									<xsl:variable name="temp"><xsl:value-of select="substring-before(parent::node()/@nextPage, '&amp;offset=')"/></xsl:variable>

                                                                        <xsl:value-of select="substring-after($temp, 'rpp=')"/>
                                                                </xsl:when>
                                                        </xsl:choose>

							</xsl:variable>
						<xsl:variable name="currentPage">
							<xsl:choose>
								<xsl:when test="((parent::node()/@firstItemIndex -1)  mod $rpp) = 0">
									<xsl:value-of select='(format-number((parent::node()/@firstItemIndex -1)  div $rpp, "#")) + 1'/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select='(format-number((parent::node()/@firstItemIndex -1)  div $rpp, "#")) + 2 '/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="pagesTotal">
							<xsl:choose>
								<xsl:when test="parent::node()/@itemsTotal mod $rpp = 0">
									<xsl:value-of select='parent::node()/@itemsTotal div $rpp'/>
								</xsl:when>	
								<xsl:otherwise>
									<xsl:value-of select='format-number((parent::node()/@itemsTotal + 1 ) div $rpp, "#")'/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<!-- it does not work with searh-filter -->
                                                <xsl:if test="not(contains(//dri:metadata[@qualifier='URI'], 'search-filter'))">	
						<ul class="pagination-links">

							<xsl:if test="parent::node()/@previousPage">
							    
		                                                <li>
								<a class="previous-page-link">
                		                                        <xsl:attribute name="href">
                                		                                <xsl:value-of select="parent::node()/@previousPage"/>
                                                		        </xsl:attribute>
	                	                                        <i18n:text>xmlui.dri2xhtml.structural.pagination-previous</i18n:text>
        		                                        </a>
								</li>
                                		        </xsl:if>

							<!-- firstPage -->
							<xsl:if test="(parent::node()/@firstItemIndex -1 - $rpp)  &gt; 0">
                                                        <li class="page-link">
                                                             <a>
                                                                <xsl:attribute name="href">
												
                                                                       <xsl:value-of select="concat($linkPrefix, 'offset=0&amp;sort_by=', $linkPostfix)"/>
                                                                </xsl:attribute>
                                                                1
                                                             </a>
                                                        </li>
							</xsl:if>
							<xsl:if test="(parent::node()/@firstItemIndex -1 - ($rpp * 4))  &gt; 0">
								<li class="page-link">
									...
								</li>
							</xsl:if>
							 <xsl:if test="(parent::node()/@firstItemIndex -1 - ($rpp * 3))  &gt; 0">
                                                        <li class="page-link">
                                                                <a>
                                                                <xsl:attribute name="href">
                                                                        <xsl:value-of select="concat($linkPrefix, 'offset=',  (parent::node()/@firstItemIndex -1 ) - ( $rpp * 3), '&amp;sort_by=', $linkPostfix)"/>
                                                                </xsl:attribute>
                                                                <xsl:value-of select="$currentPage - 3"/>
                                                                </a>
                                                        </li>
							</xsl:if>
							<xsl:if test="(parent::node()/@firstItemIndex -1 - ($rpp * 2))  &gt; 0">
                                                        <li class="page-link">
                                                                <a>
                                                                <xsl:attribute name="href">
                                                                        <xsl:value-of select="concat($linkPrefix, 'offset=', (parent::node()/@firstItemIndex -1 ) - ( $rpp * 2), '&amp;sort_by=', $linkPostfix)"/>
                                                                </xsl:attribute>
                                                                <xsl:value-of select="$currentPage - 2"/>
                                                                </a>
                                                        </li>
                                                        </xsl:if>

							 <xsl:if test="parent::node()/@previousPage">
							<li class="page-link">
                                                                <a>
                                                                <xsl:attribute name="href">
                                                                        <xsl:value-of select="parent::node()/@previousPage"/>
                                                                </xsl:attribute>
                                                                <xsl:value-of select="$currentPage - 1"/>
                                                                </a>
                                                        </li>
	
							</xsl:if>
						
							<li class="current-page-link">
								<a>
								<xsl:attribute name="href">
									<xsl:value-of select="concat($linkPrefix, 'offset=', (parent::node()/@firstItemIndex -1 ), '&amp;sort_by=', $linkPostfix)"/>
								</xsl:attribute>
                                                                <xsl:value-of select="$currentPage"/>
								</a>

							</li>
							<xsl:if test="parent::node()/@nextPage">
								<li class="page-link">
									<a>
									<xsl:attribute name="href">
										<xsl:value-of select="parent::node()/@nextPage"/>
									</xsl:attribute>
									<xsl:value-of select="$currentPage + 1"/>
									</a>
								</li>
							</xsl:if>
			
							<xsl:if test="($currentPage + 2) &lt; $pagesTotal">
                                                                <li class="page-link">
                                                                        <a>
                                                                        <xsl:attribute name="href">
                                                                                <xsl:value-of select="concat($linkPrefix, 'offset=', parent::node()/@lastItemIndex  + $rpp, '&amp;sort_by=', $linkPostfix)"/>
                                                                        </xsl:attribute>
                                                                        <xsl:value-of select="$currentPage + 2"/>
                                                                        </a>
                                                                </li>
                                                        </xsl:if>
		
							<xsl:if test="($currentPage + 3) &lt; $pagesTotal">
                                                                <li class="page-link">
                                                                        <a>
                                                                        <xsl:attribute name="href">
                                                                                <xsl:value-of select="concat($linkPrefix, 'offset=', parent::node()/@lastItemIndex + ($rpp * 2), '&amp;sort_by=', $linkPostfix)"/>
                                                                        </xsl:attribute>
                                                                        <xsl:value-of select="$currentPage + 3"/>
                                                                        </a>
                                                                </li>
                                                        </xsl:if>						
							<xsl:if test="($currentPage + 4) &lt; $pagesTotal">
								<li  class="page-link">
									...
								</li>
							</xsl:if>
							<xsl:if test="$currentPage != $pagesTotal">
                                                                <li class="page-link">
                                                                        <a>
                                                                        <xsl:attribute name="href">
                                                                                <xsl:value-of select="concat($linkPrefix, 'offset=', $rpp * ($pagesTotal - 1), '&amp;sort_by=', $linkPostfix)"/>
                                                                        </xsl:attribute>
                                                                        <xsl:value-of select="$pagesTotal"/>
                                                                        </a>
                                                                </li>
							</xsl:if>
						<!--
						<xsl:text>Now showing items </xsl:text>
						<xsl:value-of select="parent::node()/@firstItemIndex"/>
						<xsl:text>-</xsl:text>
						<xsl:value-of select="parent::node()/@lastItemIndex"/>
						<xsl:text> of </xsl:text>
						<xsl:value-of select="parent::node()/@itemsTotal"/>
							-->
					<xsl:if test="parent::node()/@nextPage">
						<li>
							<a class="next-page-link">
							<xsl:attribute name="href">
								<xsl:value-of select="parent::node()/@nextPage"/>
							</xsl:attribute>
							<i18n:text>xmlui.dri2xhtml.structural.pagination-next</i18n:text>
							</a>
						</li>
					</xsl:if>
					
					</ul>
					</xsl:if>
				    </xsl:if>
					<xsl:if test="parent::node()/@nextPage and contains(//dri:metadata[@qualifier='URI'], 'search-filter')">
                                                <a class="next-page-link">
                                                        <xsl:attribute name="href">
                                                                <xsl:value-of select="parent::node()/@nextPage"/>
                                                        </xsl:attribute>
                                                        <i18n:text>xmlui.dri2xhtml.structural.pagination-next</i18n:text>
                                                        </a>

                                        </xsl:if>

				</div>
			</xsl:when>
			<xsl:when test=". = 'masked'">
				<div class="pagination-masked clearfix {$position}">
					<p class="pagination-info">
						<i18n:translate>
							<xsl:choose>
								<xsl:when test="parent::node()/@itemsTotal = -1">
									<i18n:text>xmlui.dri2xhtml.structural.pagination-info.nototal</i18n:text>
								</xsl:when>
								<xsl:otherwise>
									<i18n:text>xmlui.dri2xhtml.structural.pagination-info</i18n:text>
								</xsl:otherwise>
							</xsl:choose>
							<i18n:param><xsl:value-of select="parent::node()/@firstItemIndex"/></i18n:param>
							<i18n:param><xsl:value-of select="parent::node()/@lastItemIndex"/></i18n:param>
							<i18n:param><xsl:value-of select="parent::node()/@itemsTotal"/></i18n:param>
						</i18n:translate>
					</p>
					<ul class="pagination-links">
						
						<xsl:if test="not(parent::node()/@firstItemIndex = 0 or parent::node()/@firstItemIndex = 1)">
							<li>
								<a class="previous-page-link">
									<xsl:attribute name="href">
										<xsl:value-of
												select="substring-before(parent::node()/@pageURLMask,'{pageNum}')"/>
										<xsl:value-of select="parent::node()/@currentPage - 1"/>
										<xsl:value-of
												select="substring-after(parent::node()/@pageURLMask,'{pageNum}')"/>
									</xsl:attribute>
									<i18n:text>xmlui.dri2xhtml.structural.pagination-previous</i18n:text>
								</a>
							</li>
						</xsl:if>
						<xsl:if test="(parent::node()/@currentPage - 4) &gt; 0">
							<li class="first-page-link">
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="substring-before(parent::node()/@pageURLMask,'{pageNum}')"/>
										<xsl:text>1</xsl:text>
										<xsl:value-of select="substring-after(parent::node()/@pageURLMask,'{pageNum}')"/>
									</xsl:attribute>
									<xsl:text>1</xsl:text>
								</a>
								<xsl:text> . . . </xsl:text>
							</li>
						</xsl:if>
						<xsl:call-template name="offset-link">
							<xsl:with-param name="pageOffset">-3</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="offset-link">
							<xsl:with-param name="pageOffset">-2</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="offset-link">
							<xsl:with-param name="pageOffset">-1</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="offset-link">
							<xsl:with-param name="pageOffset">0</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="offset-link">
							<xsl:with-param name="pageOffset">1</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="offset-link">
							<xsl:with-param name="pageOffset">2</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="offset-link">
							<xsl:with-param name="pageOffset">3</xsl:with-param>
						</xsl:call-template>
						<xsl:if test="(parent::node()/@currentPage + 4) &lt;= (parent::node()/@pagesTotal)">
							<li>
								<xsl:text>. . .</xsl:text>
							</li>
							<li class="last-page-link">
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="substring-before(parent::node()/@pageURLMask,'{pageNum}')"/>
										<xsl:value-of select="parent::node()/@pagesTotal"/>
										<xsl:value-of select="substring-after(parent::node()/@pageURLMask,'{pageNum}')"/>
									</xsl:attribute>
									<xsl:value-of select="parent::node()/@pagesTotal"/>
								</a>
							</li>
						</xsl:if>
						<xsl:if test="not(parent::node()/@lastItemIndex = parent::node()/@itemsTotal)">
							<li>
								<a class="next-page-link">
									<xsl:attribute name="href">
										<xsl:value-of
												select="substring-before(parent::node()/@pageURLMask,'{pageNum}')"/>
										<xsl:value-of select="parent::node()/@currentPage + 1"/>
										<xsl:value-of
												select="substring-after(parent::node()/@pageURLMask,'{pageNum}')"/>
									</xsl:attribute>
									<i18n:text>xmlui.dri2xhtml.structural.pagination-next</i18n:text>
								</a>
							</li>
						</xsl:if>

					</ul>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
