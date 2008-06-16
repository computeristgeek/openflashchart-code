using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.ChartDataValues
{
  /// <summary>
  /// Single data value for candle chart (open, high, low, close)
  /// </summary>
  public class CandleChartDataItem
  {
    public float High { get; set; }
    public float Open { get; set; }
    public float Close { get; set; }
    public float Low { get; set; }
    
  }
}
