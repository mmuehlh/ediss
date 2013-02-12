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
			<xsl:when test=". = 'simple' and contains(//dri:metadata[@qualifier='URI'], 'browse')">
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

						<xsl:variable name="paging">
							<xsl:choose>
								<xsl:when test="parent::node()/@previousPage or parent::node()/@nextPage">
									<xsl:text>1</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:if test="$paging != '0'">
						
                                                       
                      
						<!--<xsl:variable name="rpp">
							 <xsl:choose>
                                                                <xsl:when test="parent::node()/@previousPage">
									<xsl:variable name="temp"><xsl:value-of select="substring-before(parent::node()/@previousPage, '&amp;sort_by=')"/></xsl:variable>		
												
                                                                        <xsl:value-of select="substring-after($temp, 'rpp=')"/>
                                                                </xsl:when>
                                                                <xsl:when test="parent::node()/@nextPage">
									<xsl:variable name="temp"><xsl:value-of select="substring-before(parent::node()/@nextPage, '&amp;sort_by=')"/></xsl:variable>

                                                                        <xsl:value-of select="substring-after($temp, 'rpp=')"/>
                                                                </xsl:when>
                                                        </xsl:choose>

							</xsl:variable> -->
						<xsl:variable name="rpp"> <xsl:value-of select="//dri:field[@n='rpp']/dri:value"/></xsl:variable>
						<xsl:variable name="sort_by"> <xsl:value-of select="//dri:field[@n='sort_by']/dri:value"/></xsl:variable>	
						<xsl:variable name="type"> <xsl:value-of select="//dri:field[@n='type']/dri:value"/></xsl:variable>
						<xsl:variable name="order"> <xsl:value-of select="//dri:field[@n='order']/dri:value"/></xsl:variable>
						<xsl:variable name="etal"> <xsl:value-of select="//dri:field[@n='etal']/dri:value"/></xsl:variable>
						<xsl:variable name="currentPage">
							<xsl:choose>
								<xsl:when test="((parent::node()/@firstItemIndex -1)  mod $rpp) = 0">
									<xsl:value-of select='(format-number((parent::node()/@firstItemIndex -1)  div $rpp, "#")) '/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select='(format-number((parent::node()/@firstItemIndex -1)  div $rpp, "#")) + 21'/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="pagesTotal">
							<xsl:choose>
								<xsl:when test="parent::node()/@itemsTotal mod $rpp = 0">
									<xsl:value-of select='(parent::node()/@itemsTotal div $rpp) '/>
								</xsl:when>	
								<xsl:otherwise>
									<xsl:value-of select='format-number(parent::node()/@itemsTotal  div $rpp, "#") + 1'/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="linkPrefix"><xsl:value-of select="concat(//dri:metadata[@qualifier='URI'], '?sort_by=', $sort_by, '&amp;type=', $type, '&amp;etal=', $etal, '&amp;order=', $order, '&amp;rpp=', $rpp, '&amp;offset=')"/></xsl:variable>
						<!-- it does not work with search-filter and epeaple -->
                       
						<xsl:if test="$paging != '0'" >
						<ul class="pagination-links">
							pTotal: <xsl:value-of select="$pagesTotal"/>
							current: <xsl:value-of select="$currentPage"/>
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
							<xsl:if test="($currentPage - 4)  &gt; 0">
                                                        <li class="page-link">
                                                             <a>
                                                                <xsl:attribute name="href">
												
                                                                       <xsl:value-of select="concat($linkPrefix, '0')"/>
                                                                </xsl:attribute>
                                                                1
                                                             </a>
                                                        </li>
                                                        <li class="page-link">
									...
								</li>
							</xsl:if>
							 <xsl:if test="($currentPage - 3)  &gt;= 0">
								<li class="page-link">
                                 <a>
								<xsl:choose>
										<xsl:when test="(parent::node()/@itemsTotal - (3 * $rpp)) &lt;= 0">
											<xsl:attribute name="href">
												
                                                                       <xsl:value-of select="concat($linkPrefix, '0')"/>
                                                                </xsl:attribute>
                                                               	
										</xsl:when>
										<xsl:otherwise>
                                                        
                                                                <xsl:attribute name="href">
                                                                        <xsl:value-of select="concat($linkPrefix, (parent::node()/@firstItemIndex -1 ) - $rpp) "/>
                                                                </xsl:attribute>
                                                              
                                                                
										</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="$currentPage - 3"/>
								</a>
                             </li>
							</xsl:if>
							<xsl:if test="($currentPage - 2)  &gt;= 0">
								<li class="page-link">
                                 <a>
								<xsl:choose>
										<xsl:when test="(parent::node()/@itemsTotal - (2 * $rpp)) &lt;= 0">
											<xsl:attribute name="href">
												
                                                                       <xsl:value-of select="concat($linkPrefix, '0')"/>
                                                                </xsl:attribute>
                                                               	
										</xsl:when>
										<xsl:otherwise>
                                                        
                                                                <xsl:attribute name="href">
                                                                        <xsl:value-of select="concat($linkPrefix, (parent::node()/@firstItemIndex -1 ) - (2 * $rpp)) "/>
                                                                </xsl:attribute>
                                                              
                                                                
										</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="$currentPage - 2"/>
								</a>
                             </li>
							</xsl:if>
							<xsl:if test="($currentPage - 1)  &gt;= 0">
								<li class="page-link">
                                 <a>
								<xsl:choose>
										<xsl:when test="(parent::node()/@itemsTotal - ($rpp)) &lt;= 0">
											<xsl:attribute name="href">
												
                                                                       <xsl:value-of select="concat($linkPrefix, '0')"/>
                                                                </xsl:attribute>
                                                               	
										</xsl:when>
										<xsl:otherwise>
                                                        
                                                                <xsl:attribute name="href">
                                                                        <xsl:value-of select="parent::node()/@previousPage"/>
                                                                </xsl:attribute>
                                                              
                                                                
										</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="$currentPage - 1"/>
								</a>
                             </li>
							</xsl:if>
							
							<li class="current-page-link">
								<a>
								<xsl:attribute name="href">
									<xsl:value-of select="concat('browse?', //dri:metadata[@qualifier='queryString:w
									'])"/>
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
							<xsl:if test="($currentPage + 2)  &lt;= $pagesTotal">
								<li class="page-link">
                                 <a>
								<xsl:choose>
										<xsl:when test="(parent::node()/@itemsTotal - (2 * $rpp)) &gt; 0">
											<xsl:attribute name="href">
												
                                                                       <xsl:value-of select="concat($linkPrefix, parent::node()/@itemsTotal - (2 * $rpp))"/>
                                                                </xsl:attribute>
                                                               	
										</xsl:when>
										<xsl:otherwise>
                                                        
                                                                <xsl:attribute name="href">
                                                                        <xsl:value-of select="concat($linkPrefix, parent::node()/@itemsTotal - (parent::node()/@itemsTotal mod $rpp)) "/>
                                                                </xsl:attribute>
                                                              
                                                                
										</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="$currentPage + 2"/>
								</a>
                             </li>
							</xsl:if>
							<xsl:if test="($currentPage + 3)  &lt;= $pagesTotal">
								<li class="page-link">
                                 <a>
								<xsl:choose>
										<xsl:when test="(parent::node()/@itemsTotal - (3 * $rpp)) &gt; 0">
											<xsl:attribute name="href">
												
                                                                       <xsl:value-of select="concat($linkPrefix, parent::node()/@itemsTotal - (3 * $rpp))"/>
                                                                </xsl:attribute>
                                                               	
										</xsl:when>
										<xsl:otherwise>
                                                        
                                                                <xsl:attribute name="href">
                                                                        <xsl:value-of select="concat($linkPrefix, parent::node()/@itemsTotal - (parent::node()/@itemsTotal mod $rpp)) "/>
                                                                </xsl:attribute>
                                                              
                                                                
										</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="$currentPage + 3"/>
								</a>
                             </li>
							</xsl:if>				
							<xsl:if test="($currentPage + 4 ) &lt;  $pagesTotal">
								<!-- <li  class="page-link">
									...
								</li>
							</xsl:if>
							<xsl:if test="$currentPage != ( $pagesTotal - 1)"> -->
										<xsl:text>...</xsl:text>
                                                                <li class="page-link">
                                                                        <a>
                                                                        <xsl:attribute name="href">
                                                                               <!-- <xsl:value-of select="concat($linkPrefix, $rpp * ($pagesTotal - 1))"/> -->
                                                                               <xsl:value-of select="concat($linkPrefix, parent::node()/@itemsTotal - (parent::node()/@itemsTotal mod $rpp)) "/>
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
					<xsl:if test="parent::node()/@nextPage">
                                                <a class="next-page-link">
                                                        <xsl:attribute name="href">
                                                                <xsl:value-of select="parent::node()/@nextPage"/>
                                                        </xsl:attribute>
                                                        <i18n:text>xmlui.dri2xhtml.structural.pagination-next</i18n:text>
                                                        </a>

                   </xsl:if>

				</div>
			</xsl:when>
		<xsl:when test=". = 'simple' and not(contains(//dri:metadata[@qualifier='URI'], 'browse'))">
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
                        <!--
                        <xsl:text>Now showing items </xsl:text>
                        <xsl:value-of select="parent::node()/@firstItemIndex"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="parent::node()/@lastItemIndex"/>
                        <xsl:text> of </xsl:text>
                        <xsl:value-of select="parent::node()/@itemsTotal"/>
                            -->
                    </p>
                    <ul class="pagination-links">
                        <li>
                            <xsl:if test="parent::node()/@previousPage">
                                <a class="previous-page-link">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="parent::node()/@previousPage"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.pagination-previous</i18n:text>
                                </a>
                            </xsl:if>
                        </li>
                        <li>
                            <xsl:if test="parent::node()/@nextPage">
                                <a class="next-page-link">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="parent::node()/@nextPage"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.pagination-next</i18n:text>
                                </a>
                            </xsl:if>
                        </li>
                    </ul>
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
