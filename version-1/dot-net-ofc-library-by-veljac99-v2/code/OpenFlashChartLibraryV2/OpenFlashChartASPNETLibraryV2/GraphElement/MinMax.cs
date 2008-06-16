using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;
using System.Globalization;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class MinMax : OptionalGraphElementBase
{
    // Fields
    private float _maxvalue = float.MaxValue;
    private MinMaxType _minmaxtype;
    private float _minvalue = float.MinValue;

    // Methods
    internal MinMax(MinMaxType minmaxtype)
    {
        this._minmaxtype = minmaxtype;
        switch (minmaxtype)
        {
            case MinMaxType.X:
            case MinMaxType.Y2:
                this.IsEnabled = false ;
                break;

            case MinMaxType.Y:
                this.IsEnabled = false;
                break;
        }
    }

    public void Set(float minValue, float maxValue)
    {
        this.MinValue = minValue;
        this.MaxValue = maxValue;
    }

    public override string StringValue()
    {
        if (!this.IsEnabled)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        if (this.MinValue > float.MinValue)
        {
          sb.Append(ChartUtil.EncodeNameValue(this._minmaxtype.ToString().ToLower() + "_min", ToValidNumString(this.MinValue)));
        }
        if (this.MaxValue  < float.MaxValue)
        {
          sb.Append(ChartUtil.EncodeNameValue(this._minmaxtype.ToString().ToLower() + "_max", ToValidNumString(this.MaxValue)));
        }
        return sb.ToString();
    }


    private string ToValidNumString(float value) {
      string v = value.ToString("#", CultureInfo.InvariantCulture);
      if (string.IsNullOrEmpty(v))
        return "0";
      else
        return v;
    }

    public override  string ToString()
    {
        return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("minvalue={0}{1}", this.MinValue.ToString("################0.##############"), lineSeparator);
        sb.AppendFormat("maxvalue={0}{1}", this.MaxValue.ToString("################0.##############"), lineSeparator);
        return sb.ToString();
    }

    // Properties
    public float MaxValue
    {
        get
        {
            return this._maxvalue;
        }
        set
        {
            this._maxvalue = value;
            this.Enable();
        }
    }

    public float MinValue
    {
        get
        {
            return this._minvalue;
        }
        set
        {
            this._minvalue = value;
            this.Enable();
        }
    }

    // Nested Types
    public enum MinMaxType
    {
        X,
        Y,
        Y2
    }
}


}
