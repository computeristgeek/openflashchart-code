using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class NumberFormat : OptionalGraphElementBase
{
    // Fields
    private bool _isDecimalSeparatorComma = false;
    private bool _isFixedNumDecimalsForced = false;
    private bool _isThousandSeparatorDisabled = false;
    private int _numberOfDecimalPlaces = 2;

    // Methods
    public NumberFormat()
    {
        this.IsEnabled = false;
    }

    public void Set(int numberOfDecimalPlaces, bool isFixedNumDecimalsForced, bool isDecimalSeparatorComma, bool isThousandSeparatorDisabled)
    {
        this.NumberOfDecimalPlaces = numberOfDecimalPlaces;
        this.IsFixedNumberOfDecimalPlacesForced = isFixedNumDecimalsForced;
        this.IsDecimalSeparatorComma = isDecimalSeparatorComma;
        this.IsThousandSeparatorDisabled = isThousandSeparatorDisabled;
    }

    public override string StringValue()
    {
        return this.StringValue(false);
    }

    public string StringValue(bool isRight)
    {
        if (!this.IsEnabled)
        {
            return "";
        }
        string sufix = "";
        if (isRight)
        {
            sufix = "_y2";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(ChartUtil.EncodeNameValue("num_decimals" + sufix, this.NumberOfDecimalPlaces.ToString()));
        sb.Append(ChartUtil.EncodeNameValue("is_fixed_num_decimals_forced" + sufix, this.IsFixedNumberOfDecimalPlacesForced.ToString()));
        sb.Append(ChartUtil.EncodeNameValue("is_decimal_separator_comma" + sufix, this.IsDecimalSeparatorComma.ToString()));
        sb.Append(ChartUtil.EncodeNameValue("is_thousand_separator_disabled" + sufix, this.IsThousandSeparatorDisabled.ToString()));
        return sb.ToString();
    }

    public override string ToString()
    {
        return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("numberOfDecimalPlaces={0}{1}", this.NumberOfDecimalPlaces.ToString(), lineSeparator);
        sb.AppendFormat("isFixedNumDecimalsForced={0}{1}", this.IsFixedNumberOfDecimalPlacesForced.ToString(), lineSeparator);
        sb.AppendFormat("isDecimalSeparatorComma={0}{1}", this.IsDecimalSeparatorComma.ToString(), lineSeparator);
        sb.AppendFormat("isThousandSeparatorDisabled={0}{1}", this.IsThousandSeparatorDisabled.ToString(), lineSeparator);
        return sb.ToString();
    }

    // Properties
    public bool IsDecimalSeparatorComma
    {
        get
        {
            return this._isDecimalSeparatorComma;
        }
        set
        {
            this._isDecimalSeparatorComma = value;
            this.Enable();
        }
    }

    public bool IsFixedNumberOfDecimalPlacesForced
    {
        get
        {
            return this._isFixedNumDecimalsForced;
        }
        set
        {
            this._isFixedNumDecimalsForced = value;
            this.Enable();
        }
    }

    public bool IsThousandSeparatorDisabled
    {
        get
        {
            return this._isThousandSeparatorDisabled;
        }
        set
        {
            this._isThousandSeparatorDisabled = value;
            this.Enable();
        }
    }

    public int NumberOfDecimalPlaces
    {
        get
        {
            return this._numberOfDecimalPlaces;
        }
        set
        {
            this._numberOfDecimalPlaces = value;
            this.Enable();
        }
    }
}


}
