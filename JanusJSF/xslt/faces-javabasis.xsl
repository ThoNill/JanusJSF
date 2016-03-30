<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://java.sun.com/jsf/html"
	xmlns:xalan="org.apache.xalan.xslt.extensions.Redirect"
	xmlns:f="http://java.sun.com/jsf/core"
	xmlns:java="http://xml.apache.org/xalan/java"
	extension-element-prefixes="xalan">


	<xsl:output method="text" indent="yes" />

  <xsl:key use="'basis'" name="wurzel" match="/DIALOG" />

	<xsl:template match="DIALOG">
	
	<xsl:variable name="basisname" ><xsl:value-of select="@page" />Basis</xsl:variable>
	<xsl:variable name="beanname" ><xsl:value-of select="@page" />Bean</xsl:variable>
	<xsl:variable name="javaname" ><xsl:value-of select="$beanname" />.java</xsl:variable>
	<xsl:variable name="dummy" select="java:X.Helper.clearReferences()" />

<xalan:open select="$javaname" />
<xalan:write select="$javaname">
	
	
	package pages;
	
	import javax.swing.table.DefaultTableModel;
	import toni.tablemodels.RandomModel;
	import toni.tablemodels.DataModelMaptable;
	import toni.tablemodels.TableModelList;
	import javax.faces.model.DataModel;
	import toni.basis.ActionWithPriority;
	import toni.jsf.basis.AllBasis;
	import toni.jsf.navigation.Navigator;
	import toni.beans.Call;
	import toni.tablemodels.DataMaptable;
	
	public class <xsl:value-of select="$beanname" />  extends <xsl:value-of select="$basisname" />{
	
			public <xsl:value-of select="$beanname" /> () {
				init();
			}
			
protected String navigate(Call call,String result) {
		Navigator n = AppNavigator.getNavigator();
		return n.goToPage(this,call,result);
	}
 			
				<xsl:apply-templates mode="analyse" select="node()" />
				
				<xsl:apply-templates mode="definition" select="node()" />

				public void init() {
					<xsl:apply-templates mode="init" select="node()"/>
					perform();
				}
				
				public void perform(int a,int quelle) {
					switch(a) {
					
				<xsl:apply-templates mode="perform" select="node()"/>
					
					};
				}
				
				public void setValue(int a,Object value) {
					switch(a) {
					
				<xsl:apply-templates mode="setValue" select="node()" />
					};
				}
					
				public String getValue(int a) {
					switch(a) {
					
				<xsl:apply-templates  mode="getValue" select="node()" />
							
					
					};
				return "";
	            }
			
	}
	</xalan:write>
	<xalan:close select="$javaname" />
</xsl:template>



<xsl:template name="caseperform">
	   		 <xsl:variable name="objid" select="count(preceding::node())" />
	   		 case <xsl:value-of select="$objid" /> :
	   		 	    do<xsl:value-of select="$objid" />(quelle);
	   		 		break;
</xsl:template>
	   
<xsl:template mode="definition" match="DESC" />	   
<xsl:template mode="perform" match="DESC" />
<xsl:template mode="init" match="DESC" />
<xsl:template mode="analyse" match="DESC" />
<xsl:template mode="setValue" match="DESC" />
<xsl:template mode="getValue" match="DESC" />

<xsl:template match="text()"/>	   
	   
<xsl:template mode="perform" match="STRING">
	   <xsl:call-template name="caseperform" />
</xsl:template>

<xsl:template mode="init" match="STRING|MAPTABLE[@default]">
			 <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />	  
			 <xsl:if test="@default" >
			set<xsl:value-of select="$uname" />("<xsl:value-of select="@default" />");
			</xsl:if>
</xsl:template>

<xsl:template mode="analyse" match="STRING">
		<xsl:if test="@source != ''">
			<xsl:variable name="dummy"
				select="java:X.Helper.analysiereSource(@name,@source,1,'STRING')" />
		</xsl:if>
</xsl:template>
	   	
<xsl:template mode="getValue" match="STRING">       	   	
		
	   <xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />
	   		 case <xsl:value-of select="$objid" /> :
	   		 	    return get<xsl:value-of select="$uname" />();
</xsl:template>		 		

<xsl:template mode="setValue" match="STRING">  
		
	   <xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />	   	
	   		 case <xsl:value-of select="$objid" /> :
	   		 	    set<xsl:value-of select="$uname" />AsObject(value);
	   		 		break;

</xsl:template>		 		

<xsl:template mode="definition" match="STRING" >  	   	
		
	   <xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

	   public static final  ActionWithPriority awp<xsl:value-of select="@name" /> = new ActionWithPriority(<xsl:value-of select="$objid" />,1);

	   String <xsl:value-of select="@name" /> = "<xsl:value-of select="@default" />";

     
     	// Object: «this.id»
		public void do<xsl:value-of select="$objid" />(int i) {
				set<xsl:value-of select="$uname" />("<xsl:value-of select="@default" />");
				
		}
		
		public void set<xsl:value-of select="$uname" />(String value) {
				super.set<xsl:value-of select="$uname" />(value);
					<xsl:variable name="addReferences" select="java:X.Helper.getAddReferences(@name)" />
						<xsl:value-of select="$addReferences" />
				setChanged(<xsl:value-of select="$objid" />,"changed");
		}
</xsl:template>
	

<xsl:template  mode="perform"  match="MAPTABLE">
	   <xsl:call-template name="caseperform" />
</xsl:template>
	

<xsl:template  mode="analyse"  match="MAPTABLE">
	   	<xsl:if test="@source != ''">
		   	<xsl:variable name="dummy" select="java:X.Helper.analysiereSource(@name,@source,1,'STRING')" />
	   	</xsl:if>
</xsl:template>
	

<xsl:template  mode="getValue"  match="MAPTABLE">
	   <xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

	 case <xsl:value-of select="$objid" /> :
	 	    return get<xsl:value-of select="$uname" />().getValue();

</xsl:template>
	

<xsl:template  mode="setValue"  match="MAPTABLE">
	   <xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

   		 case <xsl:value-of select="$objid" /> :
   		 	    set<xsl:value-of select="$uname" />(value);
	 		break;
</xsl:template>
	

<xsl:template  mode="definition"  match="MAPTABLE">
		<xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

	   public static final  ActionWithPriority awp<xsl:value-of select="@name" /> = new ActionWithPriority(<xsl:value-of select="$objid" />,1);

	   String <xsl:value-of select="@name" /> = "<xsl:value-of select="@default" />";

     
     	// Object: «this.id»
		public void do<xsl:value-of select="$objid" />(int i) {
				set<xsl:value-of select="$uname" />("<xsl:value-of select="@default" />");
				
		}
			
			
		public void set<xsl:value-of select="$uname" />(Object value) {
				super.set<xsl:value-of select="$uname" />(value);
					<xsl:variable name="addReferences" select="java:X.Helper.getAddReferences(@name)" />
						<xsl:value-of select="$addReferences" />
				setChanged(<xsl:value-of select="$objid" />,"changed");
		}			


		public void setSelected<xsl:value-of select="$uname" />(String value) {
				set<xsl:value-of select="$uname" />(value);
					<xsl:variable name="addReferences" select="java:X.Helper.getAddReferences(@name)" />
						<xsl:value-of select="$addReferences" />
				setChanged(<xsl:value-of select="$objid" />,"changed");
		}
		
		public String getSelected<xsl:value-of select="$uname" />() {
				return get<xsl:value-of select="$uname" />().getValue();
		}
</xsl:template>

<xsl:template   mode="perform"  match="GLOBAL">
	   <xsl:call-template name="caseperform" />
</xsl:template>

<xsl:template   mode="analyse"  match="GLOBAL">	
	   	<xsl:if test="@source != ''">
	   	<xsl:variable name="dummy" select="java:X.Helper.analysiereSource(@name,@source,1,'GLOBAL')" />
	   	</xsl:if>
</xsl:template>

<xsl:template   mode="definition"  match="GLOBAL">
	   <xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

	   public static final  ActionWithPriority awp<xsl:value-of select="@name" /> = new ActionWithPriority(<xsl:value-of select="$objid" />,1);

	   String <xsl:value-of select="@name" /> = "<xsl:value-of select="@default" />";

     	// Object: «this.id»
		public void do<xsl:value-of select="$objid" />(int i) {
				setModel_<xsl:value-of select="$uname" />("<xsl:value-of select="@default" />");
					<xsl:variable name="addReferences" select="java:X.Helper.getAddReferences(@name)" />
						<xsl:value-of select="$addReferences" />
		}
						

		public void setModel_<xsl:value-of select="$uname" />(Object value) {
				super.setModel_<xsl:value-of select="$uname" />(value);
				setChanged(<xsl:value-of select="$objid" />,"changed");
		}
		
</xsl:template>

<xsl:template   mode="perform"  match="TRANSFORMATION"> 
  <xsl:call-template name="caseperform" />
</xsl:template>

<xsl:template   mode="analyse"  match="TRANSFORMATION"> 
	   	<xsl:if test="@source != ''">
	   	<xsl:variable name="dummy" select="java:X.Helper.analysiereSource(@name,@source,0,'TRANSFORMATION')" />
	   	</xsl:if>
</xsl:template>

<xsl:template  mode="definition"  match="TRANSFORMATION"> 	
	
	<xsl:variable name="objid" select="count(preceding::node())" />
	<xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

  public static final  ActionWithPriority awp<xsl:value-of select="@name" /> = new ActionWithPriority(<xsl:value-of select="$objid" />,1);
 
    					
     	// Object: «this.id»
		public void do<xsl:value-of select="$objid" />(int i) {
				if (<xsl:value-of select="@name" /> != null) {				
			<xsl:variable name="addParameter" select="java:X.Helper.expandGetReferenzes(@source)" />
		 str<xsl:value-of select="@name" /> = <xsl:value-of select="@name" />.transform(
				new String[]{<xsl:value-of select="$addParameter" /> });
				
					<xsl:variable name="addReferences" select="java:X.Helper.getAddReferences(@name)" />
					<xsl:value-of select="$addReferences" />
				setChanged(<xsl:value-of select="$objid" />,"changed");
			}
		}
</xsl:template>

<xsl:template mode="perform" match="SQL">
  <xsl:call-template name="caseperform" />
</xsl:template>

<xsl:template mode="analyse" match="SQL">
	     
    	<xsl:if test="@stmt != ''">
	   	<xsl:variable name="dummy" select="java:X.Helper.analyseQuestion(@name,@stmt,'SQL')" />
	   	</xsl:if>
	   	
	   	<xsl:if test="@source != ''">
	   	getAddReferences
	   	</xsl:if>
	   
</xsl:template>

<xsl:template mode="definition" match="SQL">
	    <xsl:variable name="objid" select="count(preceding::node())" />
		<xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />


   public static final  ActionWithPriority awp<xsl:value-of select="@name" /> = new ActionWithPriority(<xsl:value-of select="$objid" />,1);

	public void do<xsl:value-of select="$objid" />(int i) {
						get<xsl:value-of select="$uname" />().perform();
												
						<xsl:variable name="addRef" select="java:X.Helper.getAddReferences(@name)" />
						<xsl:value-of select="$addRef" />
						perform();
					}

  <xsl:variable name="beanname"><xsl:value-of  select="key('wurzel','basis')/@page"/></xsl:variable>
	public void setSelected<xsl:value-of select="$uname" />(pages.Data<xsl:value-of select="$beanname" />Basis_<xsl:value-of select="$uname" /> value) {
				get<xsl:value-of select="$uname" />().setSelectedItem(value);
					<xsl:variable name="addRef" select="java:X.Helper.getAddReferences(@name)" />
						<xsl:value-of select="$addRef" />
				setChanged(<xsl:value-of select="$objid" />,"changed");
		}

  public pages.Data<xsl:value-of select="$beanname" />Basis_<xsl:value-of select="$uname" /> getSelected<xsl:value-of select="$uname" />() {
				return get<xsl:value-of select="$uname" />().getSelectedItem();
  }
			
			
				<xsl:for-each select="COLUMN">
       <xsl:variable name="cname" select="java:X.SL.firstUpper(@name)" />

	public void sort<xsl:value-of select="$uname" />_<xsl:value-of select="$cname" />() {
	 
		get<xsl:value-of select="$uname" />().sort(<xsl:value-of select="count(preceding-sibling::COLUMN)"/>);
	
	}
	</xsl:for-each>
		
</xsl:template>

<xsl:template  mode="perform" match="CALL">
  <xsl:call-template name="caseperform"/>
</xsl:template>

<xsl:template  mode="analyse" match="CALL">	   	  	
    	<xsl:apply-templates select="child::*" />
</xsl:template>

<xsl:template  mode="definition" match="CALL">	   	
	<xsl:variable name="objid" select="count(preceding::node())" />
	<xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />
	

   public static final  ActionWithPriority awp<xsl:value-of select="@name" /> = new ActionWithPriority(<xsl:value-of select="$objid" />,1);



	public String do<xsl:value-of select="$objid" />(int i) {
	                    String result = "";
						if (call<xsl:value-of select="@name" />.autoupdate() || i == AllBasis.DIREKTAUFRUF) {
						result = super.<xsl:value-of select="@name" />();
												
						<xsl:value-of  select="java:X.Helper.getAddReferences(../@name)" />
						
						perform();
						};
						return result;
	}
	
	public String <xsl:value-of select="@name" />() {
				return navigate(call<xsl:value-of select="@name" />,do<xsl:value-of select="$objid" />(AllBasis.DIREKTAUFRUF));
	}

</xsl:template>
	
<xsl:template match="CALL/SET[@to]">
   	<xsl:variable name="dummy" select="java:X.Helper.analyseQuestionOderReferenz(../@name,@to,'SQL')" />
</xsl:template>

</xsl:stylesheet>