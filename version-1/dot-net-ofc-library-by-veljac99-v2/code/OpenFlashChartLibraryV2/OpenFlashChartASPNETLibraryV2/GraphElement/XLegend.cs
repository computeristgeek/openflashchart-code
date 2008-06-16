using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class XLegend : OptionalGraphElementBase
{
    // Fields
    private string _color;
    private float _size;
    private string _title;
    internal const string TAG_NAME = "x_legend";

    // Methods
    public void Set(string title, [Optional, DefaultParameterValue(10f)] float size, [Optional, DefaultParameterValue("#000000")] string color)
    {
        if (string.IsNullOrEmpty(title))
        {
            this.Title = string.Empty;
        }
        else
        {
            this.Title = title.Trim();
        }
        this.Size = size;
        this.Color = color;
        this.IsEnabled = !string.IsNullOrEmpty(title);
    }

    public override string StringValue()
    {
        return this.StringValue("x_legend");
    }

    internal string StringValue(string tagName)
    {
        if (!this.IsEnabled)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(this.Title).Append(",");
        sb.Append(this.Size).Append(",");
        sb.Append(this.Color);
        return ChartUtil.EncodeNameValue(tagName, sb.ToString());
    }

    public override  string ToString()
    {
        return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("title={0}{1}", this.Title, lineSeparator);
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
            this.Enable();
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
            this.Enable();
        }
    }

    public string Title
    {
        get
        {
            return this._title;
        }
        set
        {
            this._title = value;
            this.Enable();
        }
    }
}
}
