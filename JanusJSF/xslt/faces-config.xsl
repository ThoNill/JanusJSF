<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes" />


	<xsl:template match="filelist">
		<faces-config xmlns:n="http://java.sun.com/xml/ns/javaee"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="http://java.sun.com/xml/ns/javaee 
    http://java.sun.com/xml/ns/javaee/web-facesconfig_2_0.xsd"
			version="2.0">

			<xsl:apply-templates select="child::node()"/>

		</faces-config>

	</xsl:template>

	<xsl:template match="file">

		<managed-bean>
			<managed-bean-name><xsl:value-of select="@name" />Bean</managed-bean-name>
			<managed-bean-class>pages.<xsl:value-of select="@name" />Bean</managed-bean-class>
			<managed-bean-scope>session</managed-bean-scope>
		</managed-bean>

	</xsl:template>

</xsl:stylesheet>