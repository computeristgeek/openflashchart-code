using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Chart.Base;
using System.Globalization;

namespace OpenFlashChartASPNETLibraryV2.Chart
{
  /// <summary>
  /// Line chart with filled area and hollow points
  /// </summary>
  public class AreaHollowChart : LineChart
  {
    // Fields
    private int _alpha;
    private string _fillColor;

    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public AreaHollowChart(int maxDecimals)
      : base(maxDecimals)
    {
    }

    /// <summary>
    /// Generate chart definition for values
    /// </summary>
    /// <returns></returns>
    public override string StringValue()
    {
      StringBuilder sb = new StringBuilder();
      sb.Append(this.LineWidth).Append(",");
      sb.Append(this.CircleSize).Append(",");
      sb.Append(this.Alpha).Append(",");
      sb.Append(this.Color).Append(",");
      sb.Append(this.Legend).Append(",");
      sb.Append(this.LegendFontSize).Append(",");
      sb.Append(this.FillColor);
      return sb.ToString();
    }

    public new string ToString(string lineSeparator)
    {
      StringBuilder sb = new StringBuilder();
      sb.AppendFormat("lineWidth={0}{1}", this.LineWidth.ToString(CultureInfo.InstalledUICulture), lineSeparator);
      sb.AppendFormat("circleSize={0}{1}", this.CircleSize.ToString(CultureInfo.InstalledUICulture), lineSeparator);
      sb.AppendFormat("alpha={0}{1}", this.Alpha, lineSeparator);
      sb.AppendFormat("color={0}{1}", this.Color, lineSeparator);
      sb.AppendFormat("legend={0}{1}", this.Legend, lineSeparator);
      sb.AppendFormat("legendFontSize={0}{1}", this.LegendFontSize.ToString(CultureInfo.InstalledUICulture), lineSeparator);
      sb.AppendFormat("fillColor={0}{1}", this.FillColor, lineSeparator);
      return sb.ToString();
    }

    // Properties
    /// <summary>
    /// alpha transparency (0 transparent - 100 )
    /// </summary>
    public int Alpha
    {
      get
      {
        return this._alpha;
      }
      set
      {
        this._alpha = value;
      }
    }

   /// <summary>
   /// Chart id used by ofc control
   /// </summary>
    public override string ChartId
    {
      get
      {
        return ChartBase.ChartType.area_hollow.ToString();
      }
    }

    /// <summary>
    /// Fill color, example: "#808080"
    /// </summary>
    public string FillColor
    {
      get
      {
        return this._fillColor;
      }
      set
      {
        this._fillColor = value;
      }
    }
  }


}
