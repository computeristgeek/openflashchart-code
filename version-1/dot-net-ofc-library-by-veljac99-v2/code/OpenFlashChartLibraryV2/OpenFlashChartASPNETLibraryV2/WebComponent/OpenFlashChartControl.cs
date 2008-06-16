using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.ComponentModel;
using System.Web;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.WebComponent
{
  /// <summary>
  /// OFC web control
  /// </summary>
  [
    Designer(typeof(OpenFlashChartControlDesigner))
    , Description("Chart control V2 for open flash chart V1")
    , DefaultProperty("Text")
    , ToolboxData("<{0}:OpenFlashChartControl runat=server visible=true isDataSourceExternal =\"true\" isSwfObjectEnabled =\"true\" dataSource=\"GraphData.aspx\"></{0}:OpenFlashChartControl>")
  ]
  public class OpenFlashChartControl : Control
  {

    #region Properties

    /// <summary>
    /// If data source is external (isDataSourceExternal) swf dynamically loads 
    /// chart definition from dataSource url. 
    /// If not, dataSource must contain chart definition.
    /// </summary>
    [Localizable(true)
    , Category("Data")
    , Bindable(true)
    , Description("If data source is external (isDataSourceExternal) swf dynamically loads chart definition from dataSource url. If not, dataSource must contain chart definition.")
    , DefaultValue("")]
    public string DataSource
    {
      get
      {
        string s = this.ViewState["dataSource"] as string;

        if (string.IsNullOrEmpty(s))
        {
          return string.Empty;
        }
        return s;
      }
      set
      {
        this.ViewState["dataSource"] = value;
      }
    }


    /// <summary>
    /// If enabled javascript will be used to create swf object. If not swf HTML tags will be created without using javascript.
    /// </summary>
    [Category("Appearance")
    , Bindable(true)
    , Localizable(true)
    , DefaultValue(true)
    , Description("If enabled javascript will be used to create swf object. If not swf HTML tags will be created without using javascript.")]
    public bool IsSwfObjectEnabled
    {
      get
      {
        bool value = true;
        if (this.ViewState["isSwfObjectEnabled"] != null)
        {
          value = (bool)(this.ViewState["isSwfObjectEnabled"]);
        }
        return value;
      }
      set
      {
        this.ViewState["isSwfObjectEnabled"] = value;
      }
    }


    /// <summary>
    /// If data source is external (default) swf dynamically loads chart definition from dataSource url. If not, dataSource must contain chart definition.
    /// </summary>
    [Localizable(true)
    , Bindable(true)
    , Description("If data source is external (default) swf dynamically loads chart definition from dataSource url. If not, dataSource must contain chart definition.")
    , DefaultValue(false)
    , Category("Appearance")]
    public bool IsDataSourceExternal
    {
      get
      {
        bool value = false;
        if (this.ViewState["isDataSourceExternal"] != null)
        {
          value = (bool)(this.ViewState["isDataSourceExternal"]);
        }
        return value;
      }
      set
      {
        this.ViewState["isDataSourceExternal"] = value;
      }
    }


    /// <summary>
    /// Chart width in pixels
    /// </summary>
    [Bindable(true)
    , Description("Chart width in pixels")
    , Localizable(true)
    , DefaultValue(400)
    , Category("Appearance")]
    public int WidthPx
    {
      get
      {
        int value = 400;
        if (this.ViewState["widthPx"] != null)
        {
          value = (int)(this.ViewState["widthPx"]);
        }
        return value;
      }
      set
      {
        this.ViewState["widthPx"] = value;
      }
    }

    /// <summary>
    /// Chart height in pixels
    /// </summary>
    [Category("Appearance")
    , Bindable(true)
    , DefaultValue(250)
    , Description("Chart height in pixels")
    , Localizable(true)]
    public int HeightPx
    {
      get
      {
        int value = 250;
        if (this.ViewState["heightPx"] != null)
        {
          value = (int)(this.ViewState["heightPx"]);
        }
        return value;
      }
      set
      {
        this.ViewState["heightPx"] = value;
      }
    }

    #endregion


    #region Rendering

    /// <summary>
    /// Renders control
    /// </summary>
    /// <param name="writer"></param>
    public override void RenderControl(HtmlTextWriter writer)
    {
      if (this.Visible)
      {
        if (this.IsSwfObjectEnabled)
        {
          this.RenderContentsWithSoObject(ref writer);
        }
        else
        {
          this.RenderContentsWithoutSoObject(ref writer);
        }
      }
    }

    /// <summary>
    /// Render using so object
    /// </summary>
    /// <param name="writer"></param>
    private void RenderContentsWithSoObject(ref HtmlTextWriter writer)
    {
      string spanId = this.ChartId + "_span";
      StringBuilder sb = new StringBuilder();
      sb.AppendFormat(" <span id='{0}'></span>", spanId);
      sb.Append(" <script type='text/javascript'>");
      sb.AppendFormat(" var so = new SWFObject('{0}', '{1}', '{2}', '{3}', '9', '#FFFFFF');", new object[] { this.SwfPath, this.ChartId, this.WidthPx, this.HeightPx });
      sb.AppendFormat(" so.addVariable('width', '{0}');", this.WidthPx);
      sb.AppendFormat(" so.addVariable('height', '{0}');", this.HeightPx);
      if (this.IsDataSourceExternal)
      {
        sb.AppendFormat(" so.addVariable('data', '{0}');", HttpUtility.UrlEncode  (  this.DataSource));
      }
      else
      {
        sb.Append(GraphHelper.AddSoVariables(this.DataSource));
      }
      sb.Append(" so.addParam('allowScriptAccess', 'sameDomain');");
      sb.AppendFormat(" so.write('{0}');", spanId);
      sb.Append(" </script>");

      writer.Write(sb.ToString());
    }


    /// <summary>
    /// render pure HTML object tag
    /// </summary>
    /// <param name="writer"></param>
    private void RenderContentsWithoutSoObject(ref HtmlTextWriter writer)
    {
      StringBuilder sb = new StringBuilder();
      sb.Append(" <object");
      sb.Append(" classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\"");
      sb.Append(" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0\"");
      sb.AppendFormat(" width=\"{0}\" height=\"{1}\"", this.WidthPx, this.HeightPx);
      sb.AppendFormat(" id=\"{0}\"", this.ChartId);
      sb.Append(" align=\"middle\">");
      sb.Append(" <param name=\"allowScriptAccess\" value=\"sameDomain\" />");
      if (this.IsDataSourceExternal)
      {
        sb.AppendFormat(" <param name=\"movie\" value=\"{0}?width={1}&height={2}&data={3}\" />", new object[] { this.SwfPath, this.WidthPx, this.HeightPx, this.DataSource });
      }
      else
      {
        sb.AppendFormat(" <param name=\"movie\" value=\"{0}?width={1}&height={2}\" />", this.SwfPath, this.WidthPx, this.HeightPx);
      }
      sb.Append(" <param name=\"quality\" value=\"high\" />");
      sb.Append(" <param name=\"bgcolor\" value=\"#FFFFFF\" />");
      if (this.IsDataSourceExternal)
      {
        sb.AppendFormat(" <embed src=\"{0}?width={1}&height={2}&data={3}\"", new object[] { this.SwfPath, this.WidthPx, this.HeightPx, this.DataSource });
      }
      else
      {
        sb.AppendFormat(" <embed src=\"{0}?width={1}&height={2}\"", this.SwfPath, this.WidthPx, this.HeightPx);
      }
      sb.Append(" quality=\"high\" bgcolor=\"#FFFFFF\"");
      sb.AppendFormat(" width=\"{0}\" height=\"{1}\"", this.WidthPx, this.HeightPx);
      sb.Append(" name=\"open-flash-chart\"");
      sb.Append(" align=\"middle\" allowScriptAccess=\"sameDomain\"");
      sb.Append(" type=\"application/x-shockwave-flash\"");
      sb.Append(" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" /> </object>");
      if (HttpContext.Current.Request.IsSecureConnection)
      {
        writer.Write(sb.ToString().Replace("http://", "https://"));
      }
      writer.Write(sb.ToString());
    }
    #endregion


    #region Private properties and helpers
    
    // Methods
    private void _RegisterClientScript()
    {
      //string scriptPath = this.ControlFolder + "/js/";
      string scriptName1 = "swfobject.js";
      if (!this.Page.ClientScript.IsClientScriptBlockRegistered(scriptName1))
      {
        this.Page.ClientScript.RegisterClientScriptBlock(
           this.Page.GetType()
           , scriptName1
           , "<script src=\"" 
              + this.Page.ClientScript.GetWebResourceUrl(
                this.GetType(), "OpenFlashChartASPNETLibraryV2.swfobject.js"
                ) 
              + "\"></script>");
      }
    }

    private string GetApplicationPath()
    {
      string ap = HttpContext.Current.Request.ApplicationPath;
      if (ap == "/")
      {
        return "";
      }
      return ap;
    }

    protected override void OnInit(EventArgs e)
    {
      this._RegisterClientScript();
      base.OnInit(e);
    }

    
    // Properties
    private string ChartId
    {
      get
      {
        return this.ClientID;
      }
    }

    private string ControlFolder
    {
      get
      {
        return (this.GetApplicationPath() + HttpRuntime.AspClientScriptVirtualPath + "/OpenFlashChart");
      }
    }


    [Bindable(true)
    , Description("Location of open-flash-chart.swf flash file")
    , Localizable(true)
    , Category("Appearance")
    , DefaultValue("")]
    private string SwfPath
    {
      get
      {
        return this.Page.ClientScript.GetWebResourceUrl(this.GetType(), "OpenFlashChartASPNETLibraryV2.open-flash-chart.swf");
      }
      set
      {
        this.ViewState["swfPath"] = value;
      }
    }
    #endregion
  }
}
