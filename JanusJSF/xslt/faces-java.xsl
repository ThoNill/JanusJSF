<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://java.sun.com/jsf/html"
	xmlns:xalan="org.apache.xalan.xslt.extensions.Redirect"
	xmlns:f="http://java.sun.com/jsf/core"

	xmlns:java="http://xml.apache.org/xalan/java"
	extension-element-prefixes="xalan">


	<xsl:output method="text" indent="yes" />

<xsl:template name="guiactions" >
	<xsl:value-of select="java:X.IdMap.clear()"/>

	<xsl:for-each select="descendant::GUI">
		<xsl:for-each select="descendant::node()[@name]">
			<xsl:value-of
				select="java:X.IdMap.put(@name,concat('number',count(preceding::node())))" />
		</xsl:for-each>
		<xsl:for-each select="descendant::node()[@call]">
			<xsl:value-of
				select="java:X.IdMap.put(@call,concat('number',count(preceding::node())))" />
		</xsl:for-each>
	</xsl:for-each>
	
	
	<xsl:for-each select="child::GUI/ACTION">
	// GuiAction <xsl:value-of select="concat(name(),' name: ', @name,' foreach: ', @foreach) "/>
	
	private GuiActionImpl action<xsl:value-of select="concat(@name,' ')"/> = null;
	
	public void <xsl:value-of select="@name"/>() {
	if (action<xsl:value-of select="@name"/> == null) {
			action<xsl:value-of select="concat(@name,' ')"/> = new <xsl:value-of select="@class"/>();
			action<xsl:value-of select="@name"/>.setParam("<xsl:value-of select="@param"/>");
			<xsl:value-of select="java:X.IdMap.createAll(concat('action',@name),@foreach)"/>};
			action<xsl:value-of select="@name"/>.perform(this,"NN","<xsl:value-of select="@param"/>");
	}
	</xsl:for-each>
</xsl:template>	

<xsl:template match="DIALOG">
	<xsl:variable name="beanname" ><xsl:value-of select="@page" />Basis</xsl:variable>
	<xsl:variable name="javaname" ><xsl:value-of select="$beanname" />.java</xsl:variable>


<xalan:open select="$javaname" />
<xalan:write select="$javaname">
	package pages;

	import javax.swing.table.DefaultTableModel;
	import toni.tablemodels.RandomModel;
	import toni.tablemodels.DataModelMaptable;
	import toni.tablemodels.TableModelList;
	import toni.transformation.Transformation;
	import javax.faces.model.DataModel;
	import toni.basis.ActionWithPriority;
	import toni.jsf.basis.AllBasis;
	import toni.basis.ClassFabrik;
	import java.util.HashMap;
	import org.xml.sax.Attributes;
	import org.xml.sax.helpers.AttributesImpl;
	import toni.action.Action;
	import toni.beans.Callable;
	import toni.action.AllBasisHandler;
	import toni.beans.Call;
	import toni.batch.Batch;
	import toni.basis.IfSnippet;
	import toni.helpers.Change;
	import toni.jsf.basis.GuiActionImpl;
	import java.util.Date;
	import toni.tablemodels.DataMaptable;
	
	public class <xsl:value-of select="$beanname" /> extends AllBasis {
	
			public <xsl:value-of select="$beanname" /> () {
			}
			
			public String pageName() {
				return "<xsl:value-of select="@page" />";
			}
			
			<xsl:if test="@page!='model'">
				public modelBean getGlobalBean() {
	              return (modelBean) findBean	("modelBean");
				}
			</xsl:if>
			
			<xsl:apply-templates select="node()">
				<xsl:with-param name="beanname" select="$beanname" />
			</xsl:apply-templates>
				
			<xsl:call-template name="guiactions" />
				
	}
	</xalan:write>
	<xalan:close select="$javaname" />
</xsl:template>

<xsl:template match="DESC" />

<xsl:template match="text()"/>

	
	
<xsl:template name="ifsnippet">
	<xsl:for-each select="self::node()[@if]" >
	   IfSnippet if<xsl:value-of select="@if"/> = new IfSnippet("<xsl:value-of select="@if"/>");
	</xsl:for-each>
</xsl:template>
	
<xsl:template name="ifsnippetCall">
	<xsl:for-each select="self::node()[@if]" >
	   if( if<xsl:value-of select="@if"/>.isOk(<xsl:value-of select="java:X.Helper.expandTextMitVariablenOderReferenz(@at)"/>))
	</xsl:for-each>
</xsl:template>
	
	
<xsl:template name="configuration">
	<xsl:variable name="objid" select="count(preceding::node())" />
	   		 private Attributes configurationOf<xsl:value-of select="@name" />() {
	   		 AttributesImpl h = new AttributesImpl();
	<xsl:for-each select="@*">
			h.addAttribute("","","<xsl:value-of select="name()" />", "CDATA","<xsl:value-of select="." />");
	</xsl:for-each>
	
	<xsl:for-each select="CLASSATTRIBUTE">
			h.addAttribute("","","<xsl:value-of select="@name" />", "CDATA","<xsl:value-of select="@value" />");
	</xsl:for-each>
	   		return h;
	   	}
</xsl:template>
	
	

<xsl:template match="STRING">
	
	<xsl:variable name="objid" select="count(preceding::node())" />
	<xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

	    public static final  ActionWithPriority awp<xsl:value-of select="$objid" /> = new ActionWithPriority(<xsl:value-of select="$objid" />,1);

        String <xsl:value-of select="@name" /> = "<xsl:value-of select="@default" />";
     
        public AllBasisHandler getHandler<xsl:value-of select="@name" />() {
        	return new AllBasisHandler(<xsl:value-of select="$objid" />,this);
        }

		public void set<xsl:value-of select="$uname" />(String value) {
				this.<xsl:value-of select="@name" /> = value;
				setChanged(<xsl:value-of select="$objid" />,"changed");
		}
		
		public String get<xsl:value-of select="$uname" />() {
				return this.<xsl:value-of select="@name" />;
		}

		public void set<xsl:value-of select="$uname" />AsObject(Object value) {
				set<xsl:value-of select="$uname" />((String)Change.to("String",value));
		}
	
		public Object get<xsl:value-of select="$uname" />AsObject() {
				return this.<xsl:value-of select="@name" />;
		}
	
		public void set<xsl:value-of select="$uname" />AsDate(Date value) {
				set<xsl:value-of select="$uname" />(date2string(value));
		}
	
		public Date get<xsl:value-of select="$uname" />AsDate() {
				return string2date(this.<xsl:value-of select="@name" />);
		}
	
		public void set<xsl:value-of select="$uname" />AsInt(int value) {
				set<xsl:value-of select="$uname" />(""+value);
		}
	
		public int get<xsl:value-of select="$uname" />AsInt() {
				return Integer.parseInt(this.<xsl:value-of select="@name" />);
		}
		 		
		void init<xsl:value-of select="$uname" />(String value) {
				set<xsl:value-of select="$uname" />("<xsl:value-of select="@default" />");
		}

	
</xsl:template>

<xsl:template match="GLOBAL">
	<xsl:variable name="objid" select="count(preceding::node())" />
	<xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />
  
		String <xsl:value-of select="@name" /> = "<xsl:value-of select="@default" />";

        public AllBasisHandler getHandlermodel_<xsl:value-of select="@name" />() {
        	return new AllBasisHandler(<xsl:value-of select="$objid" />,this);
        }

		public void setModel_<xsl:value-of select="@name" />(String value) {
				getGlobalBean().set<xsl:value-of select="$uname" />(value);
		}
		
		public void set<xsl:value-of select="@name" />(String value) {
				getGlobalBean().set<xsl:value-of select="$uname" />(value);
		}
		
		public void set<xsl:value-of select="$uname" />(Object value) {
				set<xsl:value-of select="@name" />((String)Change.to("String",value));
		}
		
		public void setModel_<xsl:value-of select="$uname" />(Object value) {
				set<xsl:value-of select="@name" />((String)Change.to("String",value));
		}
		
		public String getModel_<xsl:value-of select="@name" />() {
				return getGlobalBean().get<xsl:value-of select="$uname" />();
		}
		
		public String get<xsl:value-of select="@name" />() {
				return getGlobalBean().get<xsl:value-of select="$uname" />();
		}

		void initModel_<xsl:value-of select="$uname" />(String value) {
				setModel_<xsl:value-of select="$uname" />("<xsl:value-of select="@defalt" />");
		}
</xsl:template>
	
<xsl:template match="TRANSFORMATION">
	   <xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

	   <xsl:call-template name="configuration" />

	   protected Transformation  <xsl:value-of select="@name" /> = (Transformation)ClassFabrik.getObjectOfClass("<xsl:value-of select="@class" />",configurationOf<xsl:value-of select="@name" />(),Transformation.class);

	   protected String str<xsl:value-of select="@name" /> = "";

	   public String get<xsl:value-of select="$uname" />() {
				return str<xsl:value-of select="@name" />;
	   }		
</xsl:template>
	
<xsl:template name="splitActions">
  <xsl:param name="pText" />
  <xsl:param name="pName" />
  <xsl:param name="pParam" />
  
  <xsl:if test="string-length($pText)">
  
   <xsl:value-of select="$pName"/>.perform(this,getHandler<xsl:value-of select="substring-before(concat($pText,','),',')"/>(),"<xsl:value-of select="$pParam"/>");

	perform();

	<xsl:call-template name="splitActions">
		<xsl:with-param name="pText" select="substring-after($pText, ',')" />
		<xsl:with-param name="pName" select="$pName" />
		<xsl:with-param name="pParam" select="$pParam" />
	</xsl:call-template>
  </xsl:if>
</xsl:template>	
	
	
	
<xsl:template match="DIALOG/ACTION">
	   <xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

       public AllBasisHandler getHandler<xsl:value-of select="@name" />() {
        	return new AllBasisHandler(<xsl:value-of select="$objid" />,this);
       }


	   <xsl:call-template name="ifsnippet" />
	    

	   protected Action  <xsl:value-of select="@name" /> = (Action)ClassFabrik.getObjectOfClass("<xsl:value-of select="@class" />",configurationOf<xsl:value-of select="@name" />(),Action.class);

	   <xsl:call-template name="configuration" />

	   public void <xsl:value-of select="@name" />() {
	   
	   <xsl:call-template name="ifsnippetCall" /> {
	   
	   <xsl:value-of select="@name" />.actionName("<xsl:value-of select="@name" />");
	     if (<xsl:value-of select="@name" />	!= null) {
	<xsl:call-template name="splitActions">
		<xsl:with-param name="pText" select="@foreach" />
		<xsl:with-param name="pName" select="@name" />
		<xsl:with-param name="pParam" select="@param" />
	</xsl:call-template>
	     }
	    }
	   }		
</xsl:template>	

<xsl:template match="BEAN"><xsl:param name="beanname"/>
	   <xsl:variable name="objid" select="count(preceding::node())" />
       <xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />
	   <xsl:call-template name="configuration" />

	   protected <xsl:value-of select="@class" /><xsl:value-of select="' '" /><xsl:value-of select="@name" /> = (<xsl:value-of select="@class" />)ClassFabrik.getObjectOfClass("<xsl:value-of select="@class" />",configurationOf<xsl:value-of select="@name" />(),Callable.class);

	   public <xsl:value-of select="@class" /> get<xsl:value-of select="$uname" />() {
				return <xsl:value-of select="@name" />;
	   }

	<xsl:apply-templates select="child::*">
		<xsl:with-param name="beanname" select="$beanname" />
	</xsl:apply-templates>
		
</xsl:template>		
	
<xsl:template name="splitActionsInCall">
	<xsl:param name="pText" />

	<xsl:if test="string-length($pText)">

		<xsl:value-of select="substring-before(concat($pText,','),',')" />();

		<xsl:call-template name="splitActionsInCall">
			<xsl:with-param name="pText" select="substring-after($pText, ',')" />
		</xsl:call-template>
	</xsl:if>
 </xsl:template>		
	
	
<xsl:template match="CALL"><xsl:param name="beanname"/>
	<xsl:variable name="objid" select="count(preceding::node())" />
    public AllBasisHandler getHandler<xsl:value-of select="@name" />() {
        	return new AllBasisHandler(<xsl:value-of select="$objid" />,this);
    }

	<xsl:call-template name="ifsnippet" />


   	<xsl:call-template name="configuration" />

    private HashMap&lt;String,Object&gt; getParameterFor<xsl:value-of select="$objid" />() {
        HashtMap&lt;String,Object&gt; h = new HashMap&lt;String,Object&gt;();
        
		<xsl:apply-templates select="child::*">
			<xsl:with-param name="beanname" select="$beanname" />
		</xsl:apply-templates>
		
		return h;
	}

    protected Call call<xsl:value-of select="@name" /> = new Call("<xsl:value-of select="@name" />",<xsl:value-of select="../@name" />,"<xsl:value-of select="@command" />",configurationOf<xsl:value-of select="@name" />());

	public String <xsl:value-of select="@name" />() {
				String result = "";

	   <xsl:call-template name="ifsnippetCall" /> {
				<xsl:call-template name="splitActionsInCall">
  					  <xsl:with-param name="pText" select="@pre"/>
  				</xsl:call-template>
  				
				result = call<xsl:value-of select="@name" />.call(getParameterFor<xsl:value-of select="$objid" />());

		 		<xsl:call-template name="splitActionsInCall">
  					  <xsl:with-param name="pText" select="@post"/>
       			</xsl:call-template>
  				}
				return result;
		}
</xsl:template>

<xsl:template match="CALL/SET[@constant]">
	h.put("<xsl:value-of select="@var" />","<xsl:value-of select="@constant" />");
</xsl:template>
	
<xsl:template match="CALL/SET[@to]">
	h.put("<xsl:value-of select="@var" />",<xsl:value-of select="java:X.Helper.expandTextMitVariablenOderReferenz(@to)" />);
</xsl:template>
	
	
<xsl:template match="MAPTABLE">
	<xsl:variable name="objid" select="count(preceding::node())" />
	<xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />

	DataModelMaptable <xsl:value-of select="@name" /> = null;

   
    public AllBasisHandler getHandler<xsl:value-of select="@name" />() {
        	return new AllBasisHandler(<xsl:value-of select="$objid" />,this);
    }
   
	public DataModelMaptable get<xsl:value-of select="$uname" />() {
				if (<xsl:value-of select="@name" /> == null) {
				DefaultTableModel tm = new DefaultTableModel(new String[]{"value","text"},0);
				      int r = 0;
				<xsl:apply-templates select="child::*">
						<xsl:with-param name="tablename" select="@name" />
				</xsl:apply-templates>
				    
				<xsl:value-of select="@name" /> = new DataModelMaptable(tm);
				};
				return this.<xsl:value-of select="@name" />;
	}
/*
		public void setSelected<xsl:value-of select="$uname" />(DataMaptable o) {
					get<xsl:value-of select="$uname" />().setSelectedItem(o);
		}
		
		public DataMaptable getSelected<xsl:value-of select="$uname" />() {
					return get<xsl:value-of select="$uname" />().getSelectedItem();
		}
*/
		
		public void set<xsl:value-of select="$uname" />(Object o) {
					get<xsl:value-of select="$uname" />().find(0,o);
		}

	
</xsl:template>

<xsl:template match="ENTRY">
		<xsl:param name="tablename" />
		tm.setRowCount(r+1);
		tm.setValueAt("<xsl:value-of select="@value" />",r,0);
		tm.setValueAt("<xsl:value-of select="@text" />",r,1);
		r++;

</xsl:template>


<xsl:template match="MUTABLE">
	<xsl:param name="beanname" />

	<xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />
 	<xsl:variable name="modelname" >DataModel<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /></xsl:variable>	
	<xsl:value-of select="$modelname" /><xsl:value-of select="' '"/> <xsl:value-of select="@name" /> = null;
		
		
	public <xsl:value-of select="$modelname" /> get<xsl:value-of select="$uname" />() {
				if (<xsl:value-of select="@name" /> == null) {
				<xsl:value-of select="@name" /> = new <xsl:value-of select="$modelname" />(
						new RandomModel(new String[] {"_rowid"
			
				<xsl:apply-templates select="child::*">
						<xsl:with-param name="tablename" select="@name" />
				</xsl:apply-templates>
				    }));
				};
				return this.<xsl:value-of select="@name" />;
	}
		
	public <xsl:value-of select="$modelname" /> getHandler<xsl:value-of select="@name" />() {
       	return get<xsl:value-of select="$uname" />();
    }



	<xsl:variable name="javamodelname" >DataModel<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />.java</xsl:variable>
	<xalan:open select="$javamodelname" />
	<xalan:write select="$javamodelname">
package pages;

import javax.swing.table.TableModel;
import toni.tablemodels.TableModelList;
import toni.tablemodels.DataBasis;

public class DataModel<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> extends
		TableModelList {

	public DataModel<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />(TableModel tm) {
		super(tm);
	}

	public Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> getRowData() {
		return new Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />(getTm(),	getRowIndex());
	}

	public Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> getSelectedItem() {
		return new Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />(getTm(),	getSelectedRow());
	}
	
	public void setSelectedItem(Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> item) {
		super.setSelectedItem(item);
	}
	
	<xsl:for-each select="COLUMN">
	   	<xsl:variable name="cname" select="java:X.SL.firstUpper(@name)" />

	public String get<xsl:value-of select="$cname" />() {
		return convertToString(getInternalData(<xsl:value-of select="position()" />));
	
	}
	</xsl:for-each>

}
	</xalan:write>
	<xalan:close select="$javamodelname" />		
	

	<xsl:variable name="javaname" >Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />.java</xsl:variable>
	<xalan:open select="$javaname" />
	<xalan:write select="$javaname">
package pages;

import javax.swing.table.TableModel;
import toni.tablemodels.DataBasis;

public class Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> extends DataBasis {

	TableModel tm;
	int row;

	public Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />(TableModel tm, int row) {
		super(tm,row);
	}


	<xsl:for-each select="COLUMN">
       <xsl:variable name="cname" select="java:X.SL.firstUpper(@name)" />

	public String get<xsl:value-of select="$cname" />() {
	 
		return convertToString(getInternalData(<xsl:value-of select="position()" />));
	
	}
	</xsl:for-each>
}
	

</xalan:write>
<xalan:close select="$javaname" />
	
</xsl:template>
	
<xsl:template match="SQL/COLUMN">
       	,"<xsl:value-of select="@name" />"	 
</xsl:template>
	
<xsl:template match="SQL">
	<xsl:param name="beanname" />

	<xsl:variable name="uname" select="java:X.SL.firstUpper(@name)" />
 	<xsl:variable name="modelname" >DataModel<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /></xsl:variable>	
	<xsl:value-of select="$modelname" /><xsl:value-of select="' '"/> <xsl:value-of select="@name" /> = null;
		
		
	public <xsl:value-of select="$modelname" /> get<xsl:value-of select="$uname" />() {
			if (<xsl:value-of select="@name" /> == null) {
				<xsl:value-of select="@name" /> = new <xsl:value-of select="$modelname" />(
						new RandomModel(new String[] {"_rowid"
			
				<xsl:apply-templates select="child::*">
						<xsl:with-param name="tablename" select="@name" />
				</xsl:apply-templates>
				    }));
				};
				return this.<xsl:value-of select="@name" />;
		}
		
	public <xsl:value-of select="$modelname" /> getHandler<xsl:value-of select="@name" />() {
        	return get<xsl:value-of select="$uname" />();
    }


	public void set<xsl:value-of select="$uname" />(Object o) {
		get<xsl:value-of select="$uname" />().find(0,o);
	}

	<xsl:variable name="javamodelname" >DataModel<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />.java</xsl:variable>
	<xalan:open select="$javamodelname" />
	<xalan:write select="$javamodelname">
package pages;

import javax.swing.table.TableModel;
import toni.tablemodels.TableModelList;
import toni.tablemodels.DataBasis;

public class DataModel<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> extends
		TableModelList {

	public DataModel<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />(TableModel tm) {
		super(tm);
	}

	public Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> getRowData() {
		return new Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />(getTm(),	getRowIndex());
	}

	public Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> getSelectedItem() {
		return new Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />(getTm(),	getSelectedRow());
	}
	
	public void setSelectedItem(Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> item) {
		super.setSelectedItem(item);
	}
	
	<xsl:for-each select="COLUMN">
       <xsl:variable name="cname" select="java:X.SL.firstUpper(@name)" />

	public String get<xsl:value-of select="$cname" />() {
	 
		return convertToString(getInternalData(<xsl:value-of select="position()" />));
	
	}
	</xsl:for-each>

}
		
	</xalan:write>
	<xalan:close select="$javamodelname" />		
	

	<xsl:variable name="javaname" >Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />.java</xsl:variable>
	<xalan:open select="$javaname" />
	<xalan:write select="$javaname">
package pages;

import javax.swing.table.TableModel;
import toni.tablemodels.DataBasis;

public class Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" /> extends DataBasis {

	TableModel tm;
	int row;

	public Data<xsl:value-of select="$beanname" />_<xsl:value-of select="$uname" />(TableModel tm, int row) {
		super(tm,row);
	}

	<xsl:for-each select="COLUMN">
       <xsl:variable name="cname" select="java:X.SL.firstUpper(@name)" />

	public String get<xsl:value-of select="$cname" />() {
	 
		return convertToString(getInternalData(<xsl:value-of select="position()" />));
	
	}

	</xsl:for-each>
	}
	</xalan:write>
	<xalan:close select="$javaname" />
	
</xsl:template>
	
<xsl:template match="MUTABLE/COLUMN">
       	,"<xsl:value-of select="@name" />"	 
</xsl:template>
	
<xsl:template name="addbatchcommand" >
	<xsl:param name="batchname" />
 	<xsl:param name="bean" />
	<xsl:param name="bean1" />
	<xsl:param name="modus" />
	
	<xsl:if test="$bean != ''" >
	<xsl:variable name="class" select="java:X.Map.get(concat($batchname ,' ' ,$modus ,'class' ))"/>
	<xsl:variable name="command" select="java:X.Map.get(concat($batchname ,' ' , $modus ,'command' ))"/>
	<xsl:variable name="call"  select="java:X.Map.get(concat($batchname ,' ' , $modus ,'call'))"/>
	
 			<xsl:if test="$bean != $bean1" >
	    Callable  bean<xsl:value-of select="$bean" /> = (Callable)ClassFabrik.getObjectOfClass("<xsl:value-of select="$class" />",configurationOf<xsl:value-of select="$bean" />(),Callable.class);
			</xsl:if>
	    Call call<xsl:value-of select="$modus" /> = new Call("<xsl:value-of select="$call" />",bean<xsl:value-of select="$bean" />,"<xsl:value-of select="$command" />",configurationOf<xsl:value-of select="$call" />());
	
	  batch.add("<xsl:value-of select="$modus" />",call<xsl:value-of select="$modus" />);
	  batch.addHash("<xsl:value-of select="$modus" />",hash<xsl:value-of select="$batchname" />_<xsl:value-of select="$modus" />());
   </xsl:if>
</xsl:template>
	
<xsl:template match="BATCH"><xsl:param name="beanname"/>
   <xsl:variable name="objid" select="count(preceding::node())" />
   public AllBasisHandler getHandler<xsl:value-of select="@name" />() {
        	return new AllBasisHandler(<xsl:value-of select="$objid" />,this);
        }

   <xsl:apply-templates select="child::*" />

   <xsl:call-template name="configuration" />

    protected Batch batch<xsl:value-of select="@name" /> = new Batch<xsl:value-of select="$beanname" />_<xsl:value-of select="@name" />("<xsl:value-of select="@name" />",configurationOf<xsl:value-of select="@name" />(),get<xsl:value-of select="java:X.SL.firstUpper(@foreach)" />());

	public String <xsl:value-of select="@name" />() {
	init<xsl:value-of select="@name" />(batch<xsl:value-of select="@name" />);
	
				String result = "";
				 <xsl:call-template name="splitActionsInCall">
  					  <xsl:with-param name="pText" select="@pre"/>
  					   
     				 </xsl:call-template>
  				
				result = batch<xsl:value-of select="@name" />.call();

		 <xsl:call-template name="splitActionsInCall">
  					  <xsl:with-param name="pText" select="@post"/>
  					    
     				 </xsl:call-template>
  		
				return result;
		}
		
			
			<xsl:variable name="beanrun" select="java:X.Map.get(concat(@name , ' ' , 'run' , 'bean'))" />
			<xsl:variable name="beanstart" select="java:X.Map.get(concat(@name , ' ' , 'start' , 'bean'))" />
			<xsl:variable name="beanstop" select="java:X.Map.get(concat(@name , ' ' , 'stop' , 'bean'))" />
	
	private void init<xsl:value-of select="@name" />(Batch batch) {
		
		<xsl:call-template name="addbatchcommand">
		<xsl:with-param name="batchname" select="@name"/>
	<xsl:with-param name="bean" select="$beanrun"/>
	<xsl:with-param name="bean1" select="''" />
	<xsl:with-param name="modus" select="'run'" />
	
		</xsl:call-template>
		
			<xsl:call-template name="addbatchcommand">
			<xsl:with-param name="batchname" select="@name"/>
	<xsl:with-param name="bean" select="$beanstart" />
	<xsl:with-param name="bean1" select="$beanrun" />
	<xsl:with-param name="modus" select="'start'" />
		
		</xsl:call-template>
		
				<xsl:call-template name="addbatchcommand">
				<xsl:with-param name="batchname" select="@name"/>
	<xsl:with-param name="bean" select="$beanstop" />
	<xsl:with-param name="bean1" select="$beanrun" />
	<xsl:with-param name="modus" select="'stop'" />
		
		</xsl:call-template>
		}
</xsl:template>

<xsl:template match="BATCH/CALLREF">
<xsl:param name="table" select="../@foreach" />
    <xsl:variable name="batchname" select="../@name"/>
	<xsl:variable name="ref" select="@ref" /> 
	<xsl:variable name="on" select="@on" /> 
	
	 
	<xsl:for-each select="ancestor::node()[last()]" >
	
	<xsl:variable name="beanname" select="DIALOG/@page" /> 
	
	// Beanname <xsl:value-of select="$beanname" />
	
	<xsl:for-each select="descendant::*/BEAN/CALL[@name=$ref]">
	
	private HashMap&lt;String,Object&gt;  hash<xsl:value-of select="$batchname" />_<xsl:value-of select="$on" /> () {
	
	HashMap&lt;String,Object&gt; h = new HashMap&lt;String,Object&gt;();
	<xsl:for-each select="descendant::SET">
		
		<xsl:if test="@to">
			<xsl:if test="not(starts-with (@to,$table))">
	h.put("<xsl:value-of select="@var" />",<xsl:value-of select="java:X.Helper.expandTextMitVariablenOderReferenz(@to)" />);
 			</xsl:if>
		</xsl:if>

		<xsl:if test="self::node()[@constant]">
	h.put("<xsl:value-of select="@var" />","<xsl:value-of select="@constant" />");
		</xsl:if>
		
	</xsl:for-each>
	 return h;
	}
	
	
	<xsl:variable name="javaname" >Batch<xsl:value-of select="$beanname" />Basis_<xsl:value-of select="$batchname" />.java</xsl:variable>
	<xalan:open select="$javaname" />
	<xalan:write select="$javaname">
package pages;

import javax.swing.table.TableModel;
import toni.tablemodels.DataBasis;
import toni.batch.Batch;
import org.xml.sax.Attributes;
import java.util.HashMap;

public class Batch<xsl:value-of select="$beanname" />Basis_<xsl:value-of select="$batchname" /> extends Batch {
	
	private DataModel<xsl:value-of select="$beanname" />Basis_<xsl:value-of select="java:X.SL.firstUpper($table)" /> table;
	
	public  Batch<xsl:value-of select="$beanname" />Basis_<xsl:value-of select="$batchname" />(String name, Attributes configurationOfKorrektur,
	   DataModel<xsl:value-of select="$beanname" />Basis_<xsl:value-of select="java:X.SL.firstUpper($table)" /> table) {
	     super(name,configurationOfKorrektur,table);
	     this.table = table;
    }
	   
	public   DataModel<xsl:value-of select="$beanname" />Basis_<xsl:value-of select="java:X.SL.firstUpper($table)" /> get<xsl:value-of select="java:X.SL.firstUpper($table)" />() {
	return table;
	}
	 
	protected HashMap&lt;String, Object&gt;  hashFor_run (HashMap&lt;String, Object&gt; h) {
		
	<xsl:for-each select="descendant::SET">
		
		<xsl:if test="@to">
			<xsl:if test="starts-with (@to,$table)">
	h.put("<xsl:value-of select="@var" />",<xsl:value-of select="java:X.Helper.expandTextMitVariablenOderReferenz(@to)" />);
 			</xsl:if>
		</xsl:if>

	</xsl:for-each>
	 return h;
	}
}
	
	</xalan:write>
	<xalan:close select="$javaname" />

	<xsl:variable name="runbean" select="java:X.Map.put(concat($batchname ,' ' ,$on ,'bean'),../@name)" />
	<xsl:variable name="runclass" select="java:X.Map.put(concat($batchname ,' ' ,$on ,'class'),../@class)" />
	<xsl:variable name="runcommand" select="java:X.Map.put(concat($batchname ,' ' ,$on ,'command'),@command)" />
	<xsl:variable name="runcall" select="java:X.Map.put(concat($batchname ,' ' ,$on ,'call'),@name)" />
			    
	</xsl:for-each>
	</xsl:for-each>
</xsl:template>


	



</xsl:stylesheet>