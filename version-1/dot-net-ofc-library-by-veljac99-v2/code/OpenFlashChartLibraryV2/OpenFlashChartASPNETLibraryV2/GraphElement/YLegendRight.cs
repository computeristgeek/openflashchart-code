using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class YLegendRight : YLegend
  {
    // Fields
    internal new const string TAG_NAME = "y2_legend";

    // Methods
    public override string StringValue()
    {
      return this.StringValue("y2_legend");
    }
  }

 

}
