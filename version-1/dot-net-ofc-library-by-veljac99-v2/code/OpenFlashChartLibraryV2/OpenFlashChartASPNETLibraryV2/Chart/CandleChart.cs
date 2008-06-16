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
  /// Candle chart 
  /// </summary>
  public class CandleChart : ChartBase
  {
    // Fields
    private int _alpha;
    private string _color;
    private string _legend;
    private int _legendFontSize;
    private int _lineWidth;
    private CandleChartData _values;
    private int _maxDecimals = 2;

    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public CandleChart(int maxDecimals)
    {
      _maxDecimals = maxDecimals;
      this._values = new CandleChartData(maxDecimals);
    }

    public override string StringValue()
    {
      StringBuilder sb = new StringBuilder();
      sb.Append(this.Alpha).Append(",");
      sb.Append(this.LineWidth).Append(",");
      sb.Append(this.Color).Append(",");
      sb.Append(this.Legend).Append(",");
      sb.Append(this.LegendFontSize);
      return sb.ToString();
    }

    public override string ToString()
    {
      return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
      StringBuilder sb = new StringBuilder();
      sb.AppendFormat("alpha={0}{1}", this.Alpha.ToString(CultureInfo.InstalledUICulture), lineSeparator);
      sb.AppendFormat("lineWidth={0}{1}", this.LineWidth.ToString(CultureInfo.InstalledUICulture), lineSeparator);
      sb.AppendFormat("color={0}{1}", this.Color, lineSeparator);
      sb.AppendFormat("legend={0}{1}", this.Legend, lineSeparator);
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
        return ChartBase.ChartType.candle.ToString();
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
    /// Legend font size (points)
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
    /// line width in pixels
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
    public CandleChartData Data
    {
      get { return _values == null ? new CandleChartData(_maxDecimals) : _values; }
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
