using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Chart.Base;

namespace OpenFlashChartASPNETLibraryV2.Chart
{
  /// <summary>
  /// Bar chart with filled bars with border
  /// </summary>
 public class BarFilledChart : BarChart
{
    // Fields
    private string _colorBorder;

    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public BarFilledChart(int maxDecimals) : base(maxDecimals)
    {
        //this._colorBorder = null;
    }

    public override string StringValue()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(this.Alpha).Append(",");
        sb.Append(this.Color).Append(",");
        sb.Append(this.ColorBorder).Append(",");
        sb.Append(this.LegendText).Append(",");
        sb.Append(this.LegendFontSize);
        return sb.ToString();
    }

    // Properties
    /// <summary>
    /// Chart id used by ofc control
    /// </summary>
    public override string ChartId
    {
        get
        {
            return ChartBase.ChartType.filled_bar.ToString();
        }
    }

   /// <summary>
   /// Border color, example: "#808080"
   /// </summary>
    public string ColorBorder
    {
        get
        {
            return this._colorBorder;
        }
        set
        {
            this._colorBorder = value;
        }
    }
}
}
