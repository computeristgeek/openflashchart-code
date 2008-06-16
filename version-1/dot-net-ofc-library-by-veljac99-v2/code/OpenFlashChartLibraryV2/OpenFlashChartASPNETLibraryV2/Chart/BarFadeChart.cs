using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Chart.Base;

namespace OpenFlashChartASPNETLibraryV2.Chart
{
  /// <summary>
  /// Bar chart with fading bars 
  /// </summary>
  public class BarFadeChart : BarChart
  {
    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public BarFadeChart(int maxDecimals)
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
        return ChartBase.ChartType.bar_fade.ToString();
      }
    }
  }

 

}
