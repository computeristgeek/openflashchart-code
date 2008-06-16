using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Globalization;

namespace OpenFlashChartASPNETLibraryV2.ChartDataValues
{
  /// <summary>
  /// Data values for HLC chart (high, low, close)
  /// </summary>
  public class HighLowCloseChartData : ChartDataBase<HighLowCloseChartDataItem>
{
    // Methods
  /// <summary>
  /// constuctor
  /// </summary>
  /// <param name="maxDecimals">Maximum number of decimal places</param>
    public HighLowCloseChartData(int maxDecimals)
      : base(maxDecimals)
    {
    }

    /// <summary>
    /// Add next data value
    /// </summary>
    /// <param name="valueHigh">high / max value</param>
    /// <param name="valueLow">low / min value</param>
    /// <param name="valueClose">close / last value</param>
    public void Add(float valueHigh, float valueLow, float valueClose)
    {
      HighLowCloseChartDataItem item = new HighLowCloseChartDataItem();
      item.High = (float)Math.Round(valueHigh, _maxDecimals);
      item.Low = (float)Math.Round(valueLow, _maxDecimals);
      item.Close = (float)Math.Round(valueClose, _maxDecimals);

      _values.Add(item);

      base._minValue = Math.Min(base._minValue, valueHigh);
      base._minValue = Math.Min(base._minValue, valueLow);
      base._maxValue = Math.Max(base._maxValue, valueHigh);
      base._maxValue = Math.Max(base._maxValue, valueLow);
    }


    public override IEnumerable GetValues()
    {
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

          
          sb.Append("[");
          sb.Append(item.High.ToString(formatStr, CultureInfo.InvariantCulture));
          sb.Append(",");
          sb.Append(item.Low.ToString(formatStr, CultureInfo.InvariantCulture));
          sb.Append(",");
          sb.Append(item.Close.ToString(formatStr, CultureInfo.InvariantCulture));
          sb.Append("]");
        }
        return sb.ToString();
      }
    }
  
  }

 

}
