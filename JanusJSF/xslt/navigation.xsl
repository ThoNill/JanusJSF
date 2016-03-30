<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://java.sun.com/jsf/html"
	xmlns:xalan="org.apache.xalan.xslt.extensions.Redirect"
	xmlns:f="http://java.sun.com/jsf/core"
	xmlns:java="http://xml.apache.org/xalan/java"
	extension-element-prefixes="xalan">

<xsl:output method="text" indent="yes" />

	<xsl:template match="PAGEMAP">
	
	<xsl:variable name="beanname" >AppNavigator</xsl:variable>
	<xsl:variable name="javaname">AppNavigator.java</xsl:variable>


<xalan:open select="$javaname" />
<xalan:write select="$javaname">
	
	package pages;

	
	import toni.jsf.navigation.Navigator;
	import toni.jsf.navigation.NavigatorImpl;
	

	
	public class <xsl:value-of select="$beanname" /> extends NavigatorImpl {
			private static <xsl:value-of select="$beanname" /> navigator = null;
			
			private <xsl:value-of select="$beanname" /> () {
				fill();
			}
			
			public static Navigator getNavigator() {
				if (navigator == null) {
					navigator = new <xsl:value-of select="$beanname" /> (); 
				};
				return navigator;
			}
			
			public String pageName() {
				return "<xsl:value-of select="@page" />";
			}
			
			private void fill() {
				<xsl:apply-templates select="descendant::*">
					<xsl:with-param name="beanname" select="$beanname" />
				</xsl:apply-templates>
			}	
	}
	</xalan:write>
	<xalan:close select="$javaname" />
	</xsl:template>

<xsl:template match="PAGE">
		put("<xsl:value-of select="@name" />",null,null,null,"<xsl:value-of select="@goto" />");
</xsl:template>

<xsl:template match="COMMAND">
put("<xsl:value-of select="../@name" />",null,"<xsl:value-of select="@name" />",null,"<xsl:value-of select="@goto" />");
</xsl:template>

</xsl:stylesheet>