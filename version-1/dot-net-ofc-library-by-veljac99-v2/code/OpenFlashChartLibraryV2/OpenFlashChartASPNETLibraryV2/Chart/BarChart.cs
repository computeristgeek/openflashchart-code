using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Chart.Base;
using OpenFlashChartASPNETLibraryV2.ChartDataValues;
using Newtonsoft.Json;
using System.Collections;
using OpenFlashChartASPNETLibraryV2.GraphElement;
using System.Globalization;

namespace OpenFlashChartASPNETLibraryV2.Chart
{
  /// <summary>
  /// Simple bar chart
  /// </summary>
  public class BarChart : ChartBase
  {
    // Fields
    private SingleValueChartData _values;

    private int _alpha = 80;
    private string _color = "#80FF80";
    private string _legend;
    private int _legendFontSize;
    private int _maxDecimals = 2;

    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public BarChart(int maxDecimals)
    {
      _maxDecimals = maxDecimals;
      this._values = new SingleValueChartData(maxDecimals);
    }

    public override string StringValue()
    {
      StringBuilder sb = new StringBuilder();
      sb.Append(this.Alpha).Append(",");
      sb.Append(this.Color).Append(",");
      sb.Append(this.LegendText).Append(",");
      sb.Append(this.LegendFontSize);
      return sb.ToString();
    }

    public string ToString(string lineSeparator)
    {
      StringBuilder sb = new StringBuilder();
      sb.AppendFormat("alpha={0}{1}", this.Alpha.ToString(CultureInfo.InstalledUICulture), lineSeparator);
      sb.AppendFormat("color={0}{1}", this.Color, lineSeparator);
      sb.AppendFormat("legend={0}{1}", this.LegendText, lineSeparator);
      sb.AppendFormat("legendFontSize={0}{1}", this.LegendFontSize.ToString(CultureInfo.InstalledUICulture), lineSeparator);
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
        return ChartBase.ChartType.bar.ToString();
      }
    }

    /// <summary>
    /// Color, example: "#808080"
    /// </summary>
    public string Color
    {
      get
      {
        return this._color;
      }
      set
      {
        this._color = value;
      }
    }

    /// <summary>
    /// Chart data values
    /// </summary>
    [JsonIgnore]
    public SingleValueChartData Data
    {
      get { return _values == null ? new SingleValueChartData(_maxDecimals) : _values; }
      set { _values = value; }
    }

    /// <summary>
    /// Legend text
    /// </summary>
    public string LegendText
    {
      get
      {
        return this._legend;
      }
      set
      {
        this._legend = value;
      }
    }

    /// <summary>
    /// font site (points) for legend
    /// </summary>
    public int LegendFontSize
    {
      get
      {
        return this._legendFontSize;
      }
      set
      {
        this._legendFontSize = value;
      }
    }


    public override MinMax GetXMinMax()
    {
      MinMax rng = new MinMax(MinMax.MinMaxType.X);
      rng.MinValue = _values.MinValue;
      rng.MaxValue = _values.MaxValue;
      return rng;
    }

    /// <summary>
    /// IEnumerable date Values
    /// </summary>
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
