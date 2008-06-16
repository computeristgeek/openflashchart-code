using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Chart.Base;
using OpenFlashChartASPNETLibraryV2.ChartDataValues;
using Newtonsoft.Json;
using OpenFlashChartASPNETLibraryV2.GraphElement;
using System.Collections;

namespace OpenFlashChartASPNETLibraryV2.Chart
{
  /// <summary>
  /// Scatter chart with circles (with parametrized radius)
  /// </summary>
  public class ScatterCircleChart : ChartBase
  {
    private int _maxDecimals = 2;
    // Fields
    private string _color = "#80FF80";
    private string _legend;
    private int _legendFontSize;
    private int _lineWidth = 80;
    private ScatterCircleChartData _values;

    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public ScatterCircleChart(int maxDecimals)
    {
      this._values = new ScatterCircleChartData(maxDecimals);
    }

    public override string StringValue()
    {
      StringBuilder sb = new StringBuilder();
      sb.Append(this.LineWidth).Append(",");
      sb.Append(this.Color).Append(",");
      sb.Append(this.Legend).Append(",");
      sb.Append(this.LegendFontSize);
      return sb.ToString();
    }

    public string ToString(string lineSeparator)
    {
      StringBuilder sb = new StringBuilder();
      sb.AppendFormat("lineWidth={0}{1}", this.LineWidth.ToString(), lineSeparator);
      sb.AppendFormat("color={0}{1}", this.Color, lineSeparator);
      sb.AppendFormat("legend={0}{1}", this.Legend, lineSeparator);
      sb.AppendFormat("legendFontSize={0}{1}", this.LegendFontSize.ToString(), lineSeparator);
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
        return ChartBase.ChartType.scatter.ToString();
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
    /// Legend text
    /// </summary>
    public string Legend
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
    /// Legend text font size
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

    /// <summary>
    /// Circle line width
    /// </summary>
    public int LineWidth
    {
      get
      {
        return this._lineWidth;
      }
      set
      {
        this._lineWidth = value;
      }
    }

    [JsonIgnore]
    public ScatterCircleChartData Data
    {
      get { return _values == null ? new ScatterCircleChartData(_maxDecimals) : _values; }
      set { _values = value; }
    }

    public override MinMax GetXMinMax()
    {
      MinMax rng = new MinMax(MinMax.MinMaxType.X);
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
