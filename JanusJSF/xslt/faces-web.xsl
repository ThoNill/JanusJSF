<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" />

	<xsl:template match="filelist">

<web-app xmlns="http://java.sun.com/xml/ns/javaee"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://java.sun.com/xml/ns/javaee 
      http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
      version="3.0">

    <context-param>
        <description>Development or Production</description>
        <param-name>javax.faces.PROJECT_STAGE</param-name>
        <param-value>Development</param-value> 
    </context-param>
    
    <context-param>
    <param-name>javax.faces.CONFIG_FILES</param-name>
  	  <param-value>/WEB-INF/faces-config.xml</param-value>
  	</context-param>

    <servlet>
        <servlet-name>Faces Servlet</servlet-name>
        <servlet-class>javax.faces.webapp.FacesServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>Faces Servlet</servlet-name>
        <url-pattern>*.jsf</url-pattern>
    </servlet-mapping>
</web-app>
	</xsl:template>
	

</xsl:stylesheet>