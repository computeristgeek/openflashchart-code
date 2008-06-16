using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.GraphElement;
using System.Collections;

namespace OpenFlashChartASPNETLibraryV2.ChartDataValues
{
  /// <summary>
  /// Base (abstract) class for all charts
  /// </summary>
  /// <typeparam name="T"></typeparam>
  public abstract class ChartDataBase <T> //: GraphElementBase
  {
    // Fields
    protected List <T> _values;
    protected int _maxDecimals = 2;
    protected float _maxValue = float.MinValue;
    protected float _minValue = float.MaxValue;

    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public ChartDataBase(int maxDecimals)
    {
      if (maxDecimals < 0)
      {
        throw new ArgumentOutOfRangeException("maxDecimals", "must be >=0");
      }
      this._maxDecimals = maxDecimals;
      _values = new List<T>();
    }

    /// <summary>
    /// reset all values
    /// </summary>
    public void Reset()
    {
      this._maxDecimals = 2;
      _values = new List<T> ();
    }

    //public override string StringValue()
    //{
    //  return "";// this._sb.ToString();
    //}

    // Properties
    /// <summary>
    /// Maximum value to be displayed
    /// </summary>
    public float MaxValue
    {
      get
      {
        if (this._maxValue < this._minValue)
        {
          return float.MaxValue;
        }
        return this._maxValue;
      }
    }

    /// <summary>
    /// Minimum value to be displayed
    /// </summary>
    public float MinValue
    {
      get
      {
        if (this._minValue > this._maxValue)
        {
          return float.MinValue;
        }
        return this._minValue;
      }
    }

    public abstract IEnumerable GetValues ();
    public abstract string ValuesAsString { get; }

    /// <summary>
    /// Used to format numbers for generated output
    /// </summary>
    /// <returns></returns>
    protected  string GetFormatString()
    {
      string formatStr = "0";
      if (_maxDecimals > 0)
      {
        formatStr = formatStr + "." + new string('#',_maxDecimals);
      }
      return formatStr;
    }

  }

}
