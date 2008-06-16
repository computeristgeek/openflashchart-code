using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Chart.Base;

namespace OpenFlashChartASPNETLibraryV2.Chart
{
  /// <summary>
  /// Bar chart - arrow type
  /// </summary>
  public class BarArrowChart : BarChart
  {
    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public BarArrowChart(int maxDecimals)
      : base(maxDecimals)
    {
    }

    // Properties
    /// <summary>
    /// Chart id used by ofc control
    /// </summary>
    public override string ChartId
    {
      get
      {
        return ChartBase.ChartType.bar_arrow.ToString();
      }
    }
  }

 

}
