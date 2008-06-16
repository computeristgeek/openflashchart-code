using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;
using System.Collections;

namespace OpenFlashChartASPNETLibraryV2.ChartDataValues
{
  /// <summary>
  /// Data values for "single-value" charts
  /// </summary>
  public class SingleValueChartData : ChartDataBase<float>
  {
    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public SingleValueChartData(int maxDecimals)
      : base(maxDecimals)
    {
    }

    /// <summary>
    /// Add newt data value
    /// </summary>
    /// <param name="value">decimal value</param>
    public void Add(decimal value)
    {
      this.Add(Convert.ToSingle(value));
    }

    /// <summary>
    /// Add newt data value
    /// </summary>
    /// <param name="value">double value</param>
    public void Add(double value)
    {
      this.Add((float)value);
    }

    /// <summary>
    /// Add newt data value
    /// </summary>
    /// <param name="value">long value</param>
    public void Add(long value)
    {
      this.Add((float)value);
    }

    /// <summary>
    /// Add newt data value
    /// </summary>
    /// <param name="value">float value</param>
    public void Add(float value)
    {
      _values.Add ( (float)Math.Round(value, _maxDecimals));
      //base._sb.Append(value.ToString(formatStr, CultureInfo.InvariantCulture));
      base._minValue = Math.Min(base._minValue, value);
      base._maxValue = Math.Max(base._maxValue, value);
    }



    public override IEnumerable GetValues()
    {
      //return (IEnumerable<object>)_values; //
      return _values; //
    }


    public override string ValuesAsString
    {
      get
      {
        StringBuilder sb = new StringBuilder();
        string formatStr = GetFormatString();


        bool isFirst = true;
        foreach (var item in _values)
        {
          if (isFirst)
          {
            isFirst = false;
          }
          else
          {
            sb.Append(",");
          }

          sb.Append(item.ToString(formatStr, CultureInfo.InvariantCulture));
        }
        return sb.ToString();
      }
    }



  }

}
