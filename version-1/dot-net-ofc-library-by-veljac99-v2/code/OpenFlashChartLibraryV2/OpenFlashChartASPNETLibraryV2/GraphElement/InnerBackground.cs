using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class InnerBackground : OptionalGraphElementBase
{
    // Fields
    private int _angle;
    private string _color;
    private string _color2;

    // Methods
    public void Set(string color, string color2, int angle)
    {
        this.Color = color;
        this.Color2 = color2;
        this.Angle = angle;
        this.Enable();
    }

    public override string StringValue()
    {
        if (!this.IsEnabled)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(this.Color).Append(",");
        sb.Append(this.Color2).Append(",");
        sb.Append(this.Angle);
        return ChartUtil.EncodeNameValue("inner_background", sb.ToString());
    }

    public override  string ToString()
    {
        return this.ToString("\r\n");
    }

    public  string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("color={0}{1}", this.Color, lineSeparator);
        sb.AppendFormat("color2={0}{1}", this.Color2, lineSeparator);
        sb.AppendFormat("angle={0}{1}", this.Angle.ToString(), lineSeparator);
        return sb.ToString();
    }

    // Properties
    public int Angle
    {
        get
        {
            return this._angle;
        }
        set
        {
            this._angle = value;
            this.Enable();
        }
    }

    /// <summary>
    /// Inner background color, example: "#808080"
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
            this.Enable();
        }
    }

    public string Color2
    {
        get
        {
            return this._color2;
        }
        set
        {
            this._color2 = value;
            this.Enable();
        }
    }
}


}
