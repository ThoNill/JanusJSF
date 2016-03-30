<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes" />


	<xsl:template match="filelist">
		<DIALOG url="TestServlet" xmlns:xi="http://www.w3.org/2001/XInclude"
			page="seiten" title="Tabelle">

			<NAMESPACE prefix="toni.data.tags.Data">

	<BEANSET>
			<BEAN name="sucheBean" class="toni.worker.VerteilerCall">
				<xsl:apply-templates select="child::node()"
					mode="definiton" />

			</BEAN>
		</BEANSET>

			</NAMESPACE>
			<GUI>
				<VBOX>

					<xsl:apply-templates select="child::node()"
						mode="gui" />


				</VBOX>
			</GUI>
		</DIALOG>

	</xsl:template>

	<xsl:template match="file" mode="definiton">

			<CALL  command="go" >
					<xsl:attribute name="name">call<xsl:value-of select="@name" /></xsl:attribute>
			    	<SET var="name" >
			 			<xsl:attribute name="constant"><xsl:value-of select="@name" />.xhtml</xsl:attribute>   	
			    	</SET>
				</CALL>

				<CALL  command="show" >
					<xsl:attribute name="name">callXML<xsl:value-of select="@name" /></xsl:attribute>
			    	<SET var="name" >
			 			<xsl:attribute name="constant">xml_<xsl:value-of select="@name" />.xhtml</xsl:attribute>   	
			    	</SET>
				</CALL>
				
				<CALL  command="show" >
					<xsl:attribute name="name">callXhtml<xsl:value-of select="@name" /></xsl:attribute>
			    	<SET var="name" >
			 			<xsl:attribute name="constant">xhtml_<xsl:value-of select="@name" />.xhtml</xsl:attribute>   	
			    	</SET>
				</CALL>				

	</xsl:template>
	
	<xsl:template match="file" mode="gui">
  <HBOX>
<LINK  size="33" >
<xsl:attribute name="value"><xsl:value-of select="@name" />.jsf</xsl:attribute>
<xsl:attribute name="text">zur Demo <xsl:value-of select="@name" /></xsl:attribute>
</LINK>
<LINK   size="33" >
<xsl:attribute name="value">xml_<xsl:value-of select="@name" />.html</xsl:attribute>
<xsl:attribute name="text">Anzeige XML  <xsl:value-of select="@name" /></xsl:attribute>
</LINK>
<LINK   size="33" >
<xsl:attribute name="value">xhtml_<xsl:value-of select="@name" />.html</xsl:attribute>
<xsl:attribute name="text">Anzeige JSF XHTML  <xsl:value-of select="@name" /></xsl:attribute>
</LINK>
  </HBOX>
	
	</xsl:template>

</xsl:stylesheet>