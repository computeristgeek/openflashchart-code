using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.IO;

public partial class _Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
      if (!IsPostBack)
      {
        var d = new DirectoryInfo(Server.MapPath("~/App_Code"));

        cboGraph.DataSource = from file in d.GetFiles()
                              where file.Name.StartsWith ("ChartGraph")
                              select file.Name.Remove(0, "ChartGraph".Length).Replace(".cs", "")
                              
                     ;

        cboGraph.DataBind();
        cboGraph.AutoPostBack = true;
        try
        {
          cboGraph.SelectedIndex = 0;
          cboGraph_SelectedIndexChanged(sender, e);
        }
        catch (Exception)
        {
        }
      }
    }
    protected void cboGraph_SelectedIndexChanged(object sender, EventArgs e)
    {
      lblTitle.Text ="Selected graph: " + cboGraph.SelectedItem;
      string graphId = cboGraph.SelectedValue;
      txtSourceCode.Text  = (GraphHelper.GetSourceCode ( graphId));

      OpenFlashChartControl1.DataSource =  
        "SampleCharts/GraphData.ashx?v=" + DateTime.Now.ToString ("HHmmss") 
        + "&graphId=" + graphId
        ;

      //Response.Write("<" + OpenFlashChartControl1.DataSource);
      
      txtDataSource.Text =GraphHelper.GetUrlContent ( Common.GetFullApplicationPath ( OpenFlashChartControl1.DataSource));
    }

    protected void cmdRefresh_Click(object sender, EventArgs e)
    {
      cboGraph_SelectedIndexChanged(sender, e);
    }

}
