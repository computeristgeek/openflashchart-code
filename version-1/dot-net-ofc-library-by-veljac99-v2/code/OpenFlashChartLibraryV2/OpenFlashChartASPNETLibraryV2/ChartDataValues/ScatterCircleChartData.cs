using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Globalization;

namespace OpenFlashChartASPNETLibraryV2.ChartDataValues
{
  /// <summary>
  /// Data values for scatter chart 
  /// </summary>
  public class ScatterCircleChartData : ChartDataBase <ScatterCircleChartDataItem >
  {
    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public ScatterCircleChartData(int maxDecimals)
      : base(maxDecimals)
    {
    }

    /// <summary>
    /// Add next data value
    /// </summary>
    /// <param name="valueX">circle cener X value</param>
    /// <param name="valueY">circle cener Y value</param>
    /// <param name="valueRadius">circle radius value</param>
    public void Add(float valueX, float valueY, float valueRadius)
    {
      ScatterCircleChartDataItem item = new ScatterCircleChartDataItem();
      item.ValueX = (float)Math.Round(valueX, _maxDecimals);
      item.ValueY = (float)Math.Round(valueY, _maxDecimals);
      item.Radius = (float)Math.Round(valueRadius, _maxDecimals);

      _values.Add(item);

      base._minValue = Math.Min(base._minValue, valueX);
      base._minValue = Math.Min(base._minValue, valueY);
      base._maxValue = Math.Max(base._maxValue, valueX);
      base._maxValue = Math.Max(base._maxValue, valueY);
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


          sb.Append("[");
          sb.Append(item.ValueX.ToString(formatStr, CultureInfo.InvariantCulture));
          sb.Append(",");
          sb.Append(item.ValueY.ToString(formatStr, CultureInfo.InvariantCulture));
          sb.Append(",");
          sb.Append(item.Radius.ToString(formatStr, CultureInfo.InvariantCulture));
          sb.Append("]");
          //sb.Append(item.ToString(formatStr, CultureInfo.InvariantCulture));
        }
        return sb.ToString();
      }
    }
  
  }

 

}
