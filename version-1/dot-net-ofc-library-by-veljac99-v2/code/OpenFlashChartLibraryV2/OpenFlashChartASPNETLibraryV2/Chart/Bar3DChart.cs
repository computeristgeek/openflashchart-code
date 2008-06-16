using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Chart.Base;

namespace OpenFlashChartASPNETLibraryV2.Chart
{
  /// <summary>
  /// Bar chart with 3D bars
  /// </summary>
  public class Bar3DChart : BarChart
  {
    // Methods
    /// <summary>
    /// constructor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public Bar3DChart(int maxDecimals)
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
        return ChartBase.ChartType.bar_3d.ToString();
      }
    }
  }

 

}
