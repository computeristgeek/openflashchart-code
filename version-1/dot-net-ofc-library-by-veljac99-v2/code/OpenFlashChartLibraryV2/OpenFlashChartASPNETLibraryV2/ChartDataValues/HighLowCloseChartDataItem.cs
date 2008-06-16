using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.ChartDataValues
{
  /// <summary>
  /// Single data value for HLC chart (open, high, low, close)
  /// </summary>
  public class HighLowCloseChartDataItem
  {
    public float High { get; set; }
    public float Low { get; set; }
    public float Close { get; set; }
  }
}
