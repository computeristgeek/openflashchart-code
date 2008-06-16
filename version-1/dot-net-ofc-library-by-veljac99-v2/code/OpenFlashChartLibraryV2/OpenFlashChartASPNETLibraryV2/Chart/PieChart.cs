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
  /// Pie chart - must be used only with PieGraph.
  /// Cannot be mixed with other chart types.
  /// </summary>
  public class PieChart : ChartBase
  {
    // Fields
    private int _alpha = 80;
    private int _borderWidth = 1;
    private string _color = "#80FF80";
    private bool _isGradientFillEnabled = true;
    private string _textColor = "#000000";
    private SingleValueChartData _values;
    private int _maxDecimals = 2;


    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public PieChart(int maxDecimals)
    {
      _maxDecimals = maxDecimals;
      this._values = new SingleValueChartData(maxDecimals);
    }

    public override string StringValue()
    {
      StringBuilder sb = new StringBuilder();
      sb.Append(this.Alpha).Append(",");
      sb.Append(this.Color).Append(",");
      sb.Append(this.TextColor).Append(",");
      sb.Append(this.IsGradientFillEnabled.ToString().ToLower(CultureInfo.InstalledUICulture)).Append(",");
      sb.Append(this.BorderWidth);
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
    /// border width
    /// </summary>
    public int BorderWidth
    {
      get
      {
        return this._borderWidth;
      }
      set
      {
        this._borderWidth = value;
      }
    }

    /// <summary>
    /// Chart id used by ofc control
    /// </summary>
    public override string ChartId
    {
      get
      {
        return ChartBase.ChartType.pie.ToString();
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
    /// Set to false to disable gradient fill of pie slice
    /// </summary>
    public bool IsGradientFillEnabled
    {
      get
      {
        return this._isGradientFillEnabled;
      }
      set
      {
        this._isGradientFillEnabled = value;
      }
    }

    /// <summary>
    /// Color for text
    /// </summary>
    public string TextColor
    {
      get
      {
        return this._textColor;
      }
      set
      {
        this._textColor = value;
      }
    }


    [JsonIgnore]
    public SingleValueChartData Data
    {
      get { return _values == null ? new SingleValueChartData(_maxDecimals) : _values; }
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
