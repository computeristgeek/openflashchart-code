using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class YAxisRight : YAxis
  {
    // Fields
    public new const string TAG_NAME_axisColor = "y2_axis_colour";
    public new const string TAG_NAME_gridColor = "y2_grid_colour";

    // Methods
    public override string StringValue()
    {
      return this.StringValue("y2_grid_colour", "y2_axis_colour");
    }
  }


}
