using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Chart.Base;

namespace OpenFlashChartASPNETLibraryV2.Chart
{
  /// <summary>
  /// Line chart with dots at each point
  /// </summary>
  public class LineDotChart : LineChart
  {
    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public LineDotChart(int maxDecimals)
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
        return ChartBase.ChartType.line_dot.ToString();
      }
    }
  }

 

}
