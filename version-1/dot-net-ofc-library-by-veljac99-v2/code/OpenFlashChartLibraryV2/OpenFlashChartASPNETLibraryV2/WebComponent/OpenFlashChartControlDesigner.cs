using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI.Design;

namespace OpenFlashChartASPNETLibraryV2.WebComponent
{
  /// <summary>
  /// ControlDesigner for OpenFlashChartControl web control
  /// </summary>
public class OpenFlashChartControlDesigner : ControlDesigner
{
    // Methods
    public override string GetDesignTimeHtml()
    {
        StringBuilder sb = new StringBuilder();
        try
        {
            OpenFlashChartControl openFlashChartControl = (OpenFlashChartControl) base.Component;
            string template = "<br>{0} : {1}";
            sb.AppendFormat("<div style='width:{0}px;height:{1}px;'>", openFlashChartControl.WidthPx, openFlashChartControl.HeightPx);
            sb.Append("open-flash-chart Control");
            sb.AppendFormat(template, "isDataSourceExternal", openFlashChartControl.IsDataSourceExternal);
            sb.AppendFormat(template, "isSwfObjectEnabled", openFlashChartControl.IsSwfObjectEnabled);
            sb.AppendFormat(template, "widthPx", openFlashChartControl.WidthPx);
            sb.AppendFormat(template, "heightPx", openFlashChartControl.HeightPx);
            openFlashChartControl = null;
            sb.Append("</div>");
            return  this.CreatePlaceHolderDesignTimeHtml(sb.ToString());
        }
        catch (Exception ex)
        {
          return this.GetErrorDesignTimeHtml(ex);
        }
    }

    protected override string GetErrorDesignTimeHtml(Exception e)
    {
        string text = string.Format("{0}{1}{2}{3}", 
            "There was an error and the control can't be displayed.", "<br />", "Exception: ", e.Message 
            );
        return this.CreatePlaceHolderDesignTimeHtml(text);
    }
}
}
