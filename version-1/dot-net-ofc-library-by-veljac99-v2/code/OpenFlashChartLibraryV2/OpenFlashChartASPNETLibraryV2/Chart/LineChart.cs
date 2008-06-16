using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.ChartDataValues;
using OpenFlashChartASPNETLibraryV2.Chart.Base;
using Newtonsoft.Json;
using System.Collections;
using OpenFlashChartASPNETLibraryV2.GraphElement;
using System.Globalization;

namespace OpenFlashChartASPNETLibraryV2.Chart
{
  /// <summary>
  /// Simple line chart
  /// </summary>
  public class LineChart : Base.ChartBase
  {
    private SingleValueChartData _values;
    private int _maxDecimals = 2;


    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public LineChart(int maxDecimals)
    {
      _maxDecimals = maxDecimals;
      Color = "#80FF80";
      LineWidth = 2;
      this._values = new SingleValueChartData(maxDecimals);
    }

    // Methods


    public override string StringValue()
    {
      StringBuilder sb = new StringBuilder();
      sb.Append(this.LineWidth).Append(",");
      sb.Append(this.Color).Append(",");
      sb.Append(this.Legend).Append(",");
      sb.Append(this.LegendFontSize).Append(",");
      sb.Append(this.CircleSize);
      return sb.ToString();
    }

    public string ToString(string lineSeparator)
    {
      StringBuilder sb = new StringBuilder();
      sb.AppendFormat("lineWidth={0}{1}", this.LineWidth.ToString(CultureInfo.InstalledUICulture), lineSeparator);
      sb.AppendFormat("color={0}{1}", this.Color, lineSeparator);
      sb.AppendFormat("legend={0}{1}", this.Legend, lineSeparator);
      sb.AppendFormat("legendFontSize={0}{1}", this.LegendFontSize.ToString(CultureInfo.InstalledUICulture), lineSeparator);
      sb.AppendFormat("circleSize={0}{1}", this.CircleSize.ToString(CultureInfo.InstalledUICulture), lineSeparator);
      return sb.ToString();
    }

    // Properties
    /// <summary>
    /// Chart id used by ofc control
    /// </summary>
    [JsonProperty("type")]
    public override string ChartId
    {
      get
      {
        return ChartBase.ChartType.line.ToString();
      }
    }

    /// <summary>
    /// Size of circle marker
    /// </summary>
    [JsonProperty("circleSize")]
    public int CircleSize { get; set; }

    /// <summary>
    /// Color, example: "#808080"
    /// </summary>
    [JsonProperty("colour")]
    public string Color { get; set; }

    /// <summary>
    /// Legend text
    /// </summary>
    [JsonProperty("legend")]
    public string Legend { get; set; }

    /// <summary>
    /// Legend font size
    /// </summary>
    [JsonProperty("legendFontSize")]
    public int LegendFontSize { get; set; }

    /// <summary>
    /// Line width
    /// </summary>
    [JsonProperty("width")]
    public int LineWidth { get; set; }

    [JsonIgnore]
    public SingleValueChartData Data
    {
      get { return _values == null ? new SingleValueChartData(_maxDecimals) : _values; }
      set { _values = value; }
    }

    public override  MinMax GetXMinMax() {
       MinMax rng =  new MinMax(MinMax.MinMaxType.X );
       rng.MinValue = _values.MinValue;
       rng.MaxValue = _values.MaxValue;
       return rng;
    }

    [JsonProperty("values")]
    public override IEnumerable Values
    {
      get
      {
        return this._values.GetValues();
      }
    }

    [JsonIgnore]
    public override string ValuesAsString
    {
      get
      {
        return _values.ValuesAsString;
      }

    }


  }
}
