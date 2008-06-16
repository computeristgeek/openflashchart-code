using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.Utility
{
  public class ChartUtil
{
    // Methods
    public static string EncodeNameValue(string name, string value)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("&");
        sb.Append(name);
        sb.Append("=");
        sb.Append(value);
        sb.Append("&");
        sb.AppendLine();
        return sb.ToString();
    }

    public static string EncodeNameValue(string name, string value, int chartId)
    {
        if (chartId > 1)
        {
            name = name + "_" + chartId.ToString();
        }
        return EncodeNameValue(name, value);
    }
}


}
