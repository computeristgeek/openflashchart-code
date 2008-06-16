using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class YAxis : OptionalGraphElementBase
{
    // Fields
    private string _axisColor = "#784016";
    private string _gridColor = "#F5E1AA";
    public const string TAG_NAME_axisColor = "y_axis_colour";
    public const string TAG_NAME_gridColor = "y_grid_colour";

    // Methods
    public void Set(string gridColor, string axisColor)
    {
        this.GridColor = gridColor;
        this.AxisColor = axisColor;
    }

    public override string StringValue()
    {
        return this.StringValue("y_grid_colour", "y_axis_colour");
    }

    public string StringValue(string tagNameGridColor, string tagNameAxisColor)
    {
        if (!this.IsEnabled)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(ChartUtil.EncodeNameValue(tagNameGridColor, this.GridColor));
        sb.Append(ChartUtil.EncodeNameValue(tagNameAxisColor, this.AxisColor));
        return sb.ToString();
    }

    public override  string ToString()
    {
        return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("gridColor={0}{1}", this.GridColor, lineSeparator);
        sb.AppendFormat("axisColor={0}{1}", this.AxisColor, lineSeparator);
        return sb.ToString();
    }

    // Properties
    public string AxisColor
    {
        get
        {
            return this._axisColor;
        }
        set
        {
            this.Enable();
            this._axisColor = value;
        }
    }

    public string GridColor
    {
        get
        {
            return this._gridColor;
        }
        set
        {
            this.Enable();
            this._gridColor = value;
        }
    }
}


}
