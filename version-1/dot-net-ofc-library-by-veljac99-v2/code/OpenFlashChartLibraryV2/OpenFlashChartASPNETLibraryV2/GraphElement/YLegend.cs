using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class YLegend : XLegend
{
    // Fields
    internal new const string TAG_NAME = "y_legend";

    // Methods
    public override string StringValue()
    {
        return this.StringValue("y_legend");
    }

    internal new string StringValue(string tagName)
    {
        if (!this.IsEnabled)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(this.Title).Append(",");
        sb.Append(this.Size).Append(",");
        sb.Append(this.Color);
        return ChartUtil.EncodeNameValue(tagName, sb.ToString());
    }
}


}
