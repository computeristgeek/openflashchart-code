using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class YLabelStyle : OptionalGraphElementBase
{
    // Fields
    private string _color;
    private float _size;
    internal const string TAG_NAME = "y_label_style";

    // Methods
    public YLabelStyle()
    {
        this.Set(10f, "#000000");
    }

    public void Set([Optional, DefaultParameterValue(10f)] float size, [Optional, DefaultParameterValue("#000000")] string color)
    {
        this.Size = size;
        this.Color = color;
        this.IsEnabled = true;
    }

    public override string StringValue()
    {
        return this.StringValue("y_label_style");
    }

    internal string StringValue(string tagName)
    {
        StringBuilder sb = new StringBuilder();
        if (!this.IsEnabled)
        {
            sb.Append("none");
        }
        else
        {
            sb.Append(this.Size).Append(",");
            sb.Append(this.Color);
        }
        return ChartUtil.EncodeNameValue(tagName, sb.ToString());
    }

    public override  string ToString()
    {
        return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("size={0}{1}", this.Size.ToString(), lineSeparator);
        sb.AppendFormat("color={0}{1}", this.Color, lineSeparator);
        return sb.ToString();
    }

    // Properties
    /// <summary>
    /// Text color, example: "#808080"
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
  /// Text size (points)
  /// </summary>
    public float Size
    {
        get
        {
            return this._size;
        }
        set
        {
            this._size = value;
        }
    }
}


}
