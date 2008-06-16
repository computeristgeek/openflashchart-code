using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class NumberFormatRight : NumberFormat
  {
    // Methods
    public override string StringValue()
    {
      return this.StringValue(true);
    }
  }

 

}
