using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class PieLabels : XAxisLabels
  {
    internal new const string TAG_NAME = "pie_labels";

    public override string StringValue()
    {
      return this.StringValue(TAG_NAME);
    }
  }


}
