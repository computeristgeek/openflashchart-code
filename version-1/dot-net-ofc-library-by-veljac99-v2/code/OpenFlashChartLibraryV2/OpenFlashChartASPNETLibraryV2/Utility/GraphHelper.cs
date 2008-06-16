using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.Utility
{
  public class GraphHelper
  {
    // Methods
    public static string AddSoVariables(string graphDefinition)
    {
      if (string.IsNullOrEmpty(graphDefinition))
      {
        return "";
      }
      StringBuilder sb = new StringBuilder();
      string template = "so.addVariable(\"{0}\",\"{1}\");\r\n";
      sb.AppendFormat(template, "variables", "true");
      foreach (string _line in graphDefinition.Split("\r\n".ToCharArray(), StringSplitOptions.RemoveEmptyEntries))
      {
        if (!string.IsNullOrEmpty(_line))
        {
          string line = _line.Trim();
          if (((line.Length > 3) && line.StartsWith("&")) && line.EndsWith("&"))
          {
            string[] values = line.Substring(1, line.Length - 2).Split("=".ToCharArray(), 2);
            if (values.Length == 2)
            {
              sb.AppendFormat(template, values[0], values[1]);
            }
          }
        }
      }
      return sb.ToString();
    }
  }

 

}
