using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class YTicks : OptionalGraphElementBase
{
    // Fields
    private int _major = 5;
    private int _minor = 2;
    private int _steps = 2;
    internal const string TAG_NAME = "y_ticks";

    // Methods
    public YTicks()
    {
        this.IsEnabled = true;
    }

    public void Set(int major, int minor, int steps)
    {
        this.Major = major;
        this.Minor = minor;
        this.Steps = steps;
    }

    public override string StringValue()
    {
        return this.StringValue("y_ticks");
    }

    internal string StringValue(string tagName)
    {
        if (!this.IsEnabled)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(this.Minor).Append(",");
        sb.Append(this.Major).Append(",");
        sb.Append(this.Steps);
        return ChartUtil.EncodeNameValue(tagName, sb.ToString());
    }

    public override  string ToString()
    {
        return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("major={0}{1}", this.Major.ToString(), lineSeparator);
        sb.AppendFormat("minor={0}{1}", this.Minor.ToString(), lineSeparator);
        sb.AppendFormat("steps={0}{1}", this.Steps.ToString(), lineSeparator);
        return sb.ToString();
    }

    // Properties
    public int Major
    {
        get
        {
            return this._major;
        }
        set
        {
            this._major = value;
        }
    }

    public int Minor
    {
        get
        {
            return this._minor;
        }
        set
        {
            this._minor = value;
        }
    }

    public int Steps
    {
        get
        {
            return this._steps;
        }
        set
        {
            this._steps = value;
        }
    }
}
}
