<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://java.sun.com/jsf/html"
	xmlns:f="http://java.sun.com/jsf/core"
	xmlns:java="http://xml.apache.org/xalan/java"
	xmlns:p="http://primefaces.org/ui"
	>

	<xsl:output method="xml" indent="yes" />

    <xsl:key use="'basis'" name="wurzel" match="/DIALOG/@page" />


<xsl:template name="addId">
	<xsl:attribute name="id"><xsl:value-of select="concat('number',count(preceding::node()))" /></xsl:attribute>
	<xsl:if test="@size">
		<xsl:attribute name="style">width:<xsl:value-of select="@size" />em</xsl:attribute>
	</xsl:if>
</xsl:template>

<xsl:template match="DIALOG">
	<html xmlns="http://www.w3.org/1999/xhtml" xmlns:h="http://java.sun.com/jsf/html" xmlns:f="http://java.sun.com/jsf/core">
		<h:head>
			<title>
				<xsl:value-of select="@title" />
			</title>
		</h:head>
		<h:body>
			<xsl:for-each select="child::MENU">
				<h:form>
					<p:menubar>
						<xsl:apply-templates/>
					</p:menubar>
				</h:form>
			</xsl:for-each>
			<xsl:apply-templates select="descendant::GUI" />
		</h:body>
	</html>
</xsl:template>

<xsl:template match="GUI">
	<xsl:variable name="beanname"><xsl:value-of select="key('wurzel','basis')" />Bean</xsl:variable>
	<f:event type="preRenderView">
		<xsl:attribute name="listener">#{<xsl:value-of select="$beanname"></xsl:value-of>.jfsChange}</xsl:attribute>
	</f:event>
	<xsl:apply-templates select="child::*" />
</xsl:template>

<xsl:template match="VBOX">
		<h:panelGrid columns="1">
			<xsl:apply-templates select="child::*" />
		</h:panelGrid>
</xsl:template>

<xsl:template match="HBOX">
		<h:panelGrid columns="{count(child::*)}">
			<xsl:apply-templates select="child::*" />
		</h:panelGrid>
</xsl:template>

<xsl:template match="GLUE">
			<xsl:apply-templates select="child::*" />
</xsl:template>

<xsl:template match="LABEL">
	<p:outputLabel value="{@text}">
		<xsl:call-template name="addId" />
	</p:outputLabel>
</xsl:template>

<xsl:template match="TEXTFIELD">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>

	<h:form id="form{java:X.SL.uid()}">
		<p:inputText label="{@title}" value="{java:X.SL.fbeanprop($beanname,@name)}">
			<xsl:call-template name="addId" />
			<xsl:if test="@tooltip">
			<p:tooltip for="{concat('number',count(preceding::node()))}"
				value="{@tooltip}" showEffect="slide" hideEffect="slide" />
			</xsl:if>
		</p:inputText>
	</h:form>

</xsl:template>
	
	
<xsl:template match="TEXTAREA">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>

	<h:form id="form{java:X.SL.uid()}">
		<p:inputTextarea label="{@title}"
			value="{java:X.SL.fbeanprop($beanname,@name)}" rows="{@size}" cols="{@vsize}">
			<xsl:call-template name="addId" />
		</p:inputTextarea>
	</h:form>
</xsl:template>
   
  

<xsl:template match="INTFIELD">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>

	<h:form id="form{java:X.SL.uid()}">
		<p:inputText label="{@title}" size="20"
			value="{java:X.SL.fbeanprop($beanname,concat(@name,'AsInt'))}">
			<xsl:call-template name="addId" />
			<f:convertNumber />
		</p:inputText>
	</h:form>
</xsl:template>
	
	
<xsl:template match="DATEFIELD">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>

	<h:form id="form{java:X.SL.uid()}">
		<p:calendar conversionFailed="true"
			value="{java:X.SL.fbeanprop($beanname,concat(@name,'AsDate'))}"
			pattern="dd.MM.yyyy" showOn="button" navigator="true">
			<xsl:call-template name="addId" />
			<f:convertDateTime pattern="dd.MM.yyyy" timeZone="GMT+1" />
		</p:calendar>
	</h:form>
</xsl:template>
	

<xsl:template match="BUTTON">
		<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>
<xsl:choose>
	<xsl:when test="ancestor::TAB">
		<p:commandButton action="{java:X.SL.fbeancall($beanname,@call)}"
			value="{@text}" ajax="false">
			<xsl:call-template name="addId" />
		</p:commandButton>
	</xsl:when>
	<xsl:otherwise>
		<h:form id="form{java:X.SL.uid()}">
			<p:commandButton action="{java:X.SL.fbeancall($beanname,@call)}"
				value="{@text}" ajax="false">
				<xsl:call-template name="addId" />
			</p:commandButton>
		</h:form>
	</xsl:otherwise>
</xsl:choose>		
</xsl:template>


<xsl:template match="LINK">
	<h:outputLink value="{@value}">
		<h:outputText value="{@text}" />
	</h:outputLink>
</xsl:template>

<xsl:template match="DESC">
	<h:outputText value="{text()}" />
	<h:outputLink value="seiten.jsf">Zu den anderen Seiten</h:outputLink>
</xsl:template>

<xsl:template match="LIST">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>

	<h:form id="form{java:X.SL.uid()}">
		<h:selectOneListbox onchange="submit()">
			<xsl:call-template name="addId" />
			<xsl:attribute name="value">#{<xsl:value-of
				select="$beanname" />.selected<xsl:value-of
				select="java:X.SL.firstUpper(@name)" />}</xsl:attribute>

			<f:selectItems var="player">
				<xsl:attribute name="itemLabel">#{player.text}</xsl:attribute>
				<xsl:attribute name="itemValue">#{player.value}</xsl:attribute>
				<xsl:attribute name="value">#{<xsl:value-of
					select="$beanname" />.<xsl:value-of select="@name" />.maptable}</xsl:attribute>
			</f:selectItems>

		</h:selectOneListbox>
	</h:form>
</xsl:template>
	
	
<xsl:template match="RADIO">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>
	<xsl:variable name="vname" select="@name" />

	<h:form id="form{java:X.SL.uid()}">
		<h:selectOneRadio onchange="submit()">
			<xsl:call-template name="addId" />

			<xsl:attribute name="value">#{<xsl:value-of
				select="$beanname" />.selected<xsl:value-of
				select="java:X.SL.firstUpper(@name)" />}</xsl:attribute>

			<f:selectItems var="player">
				<xsl:attribute name="itemLabel">#{player.text}</xsl:attribute>
				<xsl:attribute name="itemValue">#{player.value}</xsl:attribute>
				<xsl:attribute name="value">#{<xsl:value-of
					select="$beanname" />.<xsl:value-of select="@name" />.maptable}</xsl:attribute>
			</f:selectItems>

		</h:selectOneRadio>
	</h:form>
</xsl:template>
	
	
<xsl:template match="COMBO">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>

	<xsl:variable name="vname" select="@name" />
	<h:form id="form{java:X.SL.uid()}">
		<h:selectOneMenu onchange="submit()">
			<xsl:call-template name="addId" />

			<xsl:attribute name="value">#{<xsl:value-of
				select="$beanname" />.selected<xsl:value-of
				select="java:X.SL.firstUpper(@name)" />}</xsl:attribute>

			<f:selectItems var="player">
				<xsl:attribute name="itemLabel">#{player.text}</xsl:attribute>
				<xsl:attribute name="itemValue">#{player.value}</xsl:attribute>
				<xsl:attribute name="value">#{<xsl:value-of
					select="$beanname" />.<xsl:value-of select="@name" />.maptable}</xsl:attribute>
			</f:selectItems>

		</h:selectOneMenu>
	</h:form>
</xsl:template>
	
<xsl:template match="MAPTABLE">
	<xsl:apply-templates />
</xsl:template>



<xsl:template match="ENTRY">
	<f:selectItem>
		<xsl:attribute name="itemValue"><xsl:value-of select="@value" /></xsl:attribute>
		<xsl:attribute name="itemLabel"><xsl:value-of select="@text" /></xsl:attribute>
	</f:selectItem>
</xsl:template>

<xsl:template match="SHOWTABLE/COLUMN">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>
	<xsl:variable name="tabname"><xsl:value-of  select="parent::node()/@name"/></xsl:variable>
	<xsl:variable name="uname" select="java:X.SL.firstUpper($tabname)" />
	<p:column >
	<!-- 	<xsl:attribute name="sortBy">#{o.<xsl:value-of
				select="java:X.SL.firstLower(@name)" />}</xsl:attribute>
	
		column header -->
		<f:facet name="header">
			<h:commandLink >
		<xsl:attribute name="action">#{<xsl:value-of
				select="java:X.SL.beanprop($beanname,concat('sort',$uname,'_',java:X.SL.firstUpper(@name)))" />}</xsl:attribute>
				<xsl:value-of select="@header" /></h:commandLink>
				
			<h:commandLink styleClass="ui-sortable-column-icon ui-icon ui-icon-carat-2-n-s" >
		<xsl:attribute  name="action">#{<xsl:value-of
				select="java:X.SL.beanprop($beanname,concat('sort',$uname,'_',java:X.SL.firstUpper(@name)))" />}</xsl:attribute>
				</h:commandLink>		
				
		</f:facet>
	
		<h:outputText>
			<xsl:attribute name="value">#{o.<xsl:value-of
				select="java:X.SL.firstLower(@name)" />}</xsl:attribute>

			<xsl:choose>
				<xsl:when test="@type='MONEY'">
					<xsl:attribute name="style">float:right</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type='INT'">
					<xsl:attribute name="style">float:right</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style">float:left</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</h:outputText>

	</p:column>
 
</xsl:template>


<xsl:template match="SHOWTABLE">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>
	<xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

	<h:form id="form{java:X.SL.uid()}">

		<p:dataTable var="o" paginator="true" rows="10"

			rowsPerPageTemplate="5,10,15" styleClass="order-table" headerClass="order-table-header"
			rowClasses="order-table-odd-row,order-table-even-row" selectionMode="single">
			<xsl:call-template name="addId" />

			<xsl:attribute name="value">#{<xsl:value-of
				select="java:X.SL.beanprop($beanname,@name)" />}</xsl:attribute>
			<xsl:attribute name="selection">#{<xsl:value-of
				select="java:X.SL.beanprop($beanname,@name)" />.selectedItem}</xsl:attribute>
			<xsl:attribute name="paginatorTemplate">{CurrentPageReport}  {FirstPageLink} {PreviousPageLink} {PageLinks} {NextPageLink} {LastPageLink} {RowsPerPageDropdown}</xsl:attribute>

			<f:facet name="header">
				<xsl:value-of select="@title" />
			</f:facet>
			<p:column headerText="Auswahl" style="width:4%">
				<p:commandButton action="{java:X.SL.fbeancall($beanname,@call)}"
					value="" ajax="false" icon="ui-icon-search">
					<xsl:attribute name="action">#{<xsl:value-of
						select="$beanname" />.setSelected<xsl:value-of
						select="$uname" />(o)}</xsl:attribute>
					<xsl:call-template name="addId" />
				</p:commandButton>
			</p:column>
			<xsl:apply-templates />
		</p:dataTable>
	</h:form>		
</xsl:template>

<xsl:template match="MENU">
	<p:submenu label="{@text}" icon="ui-icon-refresh">
			<xsl:apply-templates />
	</p:submenu>
</xsl:template>


<xsl:template match="MENUITEM">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>

	<p:menuitem value="{@text}" action="{java:X.SL.fbeancall($beanname,@call)}"
		ajax="false">
		<xsl:call-template name="addId" />
	</p:menuitem>
</xsl:template>

<xsl:template match="TABS">
	<xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')"/>Bean</xsl:variable>

	<h:form id="form{java:X.SL.uid()}">
		<p:tabView activeIndex="{java:X.SL.fbeancall($beanname,concat(@name,'AsInt'))}"
			update="grow1">
			<xsl:call-template name="addId" />
			<p:ajax event="tabChange">
				<xsl:attribute name="listener">#{<xsl:value-of
					select="$beanname" />.onTabChange}</xsl:attribute>
			</p:ajax>
			<xsl:apply-templates />
		</p:tabView>
	</h:form>
</xsl:template>

<xsl:template match="TAB">
	<p:tab title="{@name}">
		<xsl:call-template name="addId" />
		<h:panelGrid columns="1" cellpadding="10">
			<xsl:apply-templates />
		</h:panelGrid>
	</p:tab>
</xsl:template>

</xsl:stylesheet>