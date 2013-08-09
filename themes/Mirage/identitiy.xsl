<?xml version="1.0"?>
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

	<xsl:output indent="yes" encoding="UTF-8" method="xml" />   

	<xsl:template match="@*|node()">
		<xsl:choose>
			<xsl:when test="( ( not(*) and ( . = '&#160;' or . = '' ) ) and ( name() = 'div' or name() = 'p' or name() = 'h2' or name() = 'span' or name() = 'ul' or name() = 'head' or name() = 'label' ) )">
				<xsl:text> </xsl:text><!-- Cannot be emtpy -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
