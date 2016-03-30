<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="DIALOG">

		&lt;file name="<xsl:value-of select="@page"/>" /&gt; 
		
	</xsl:template>



</xsl:stylesheet>