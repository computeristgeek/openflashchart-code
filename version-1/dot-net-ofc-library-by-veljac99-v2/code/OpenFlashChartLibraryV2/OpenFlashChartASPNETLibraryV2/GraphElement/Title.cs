using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class Title : OptionalGraphElementBase
{
    // Fields
    private string _css;
    private string _titleText;
    internal const string TAG_NAME = "title";

    // Methods
    public void Set(string titleText, [Optional, DefaultParameterValue(null)] string cssFormat)
    {
        if (string.IsNullOrEmpty(titleText))
        {
            this.TitleText = string.Empty;
        }
        else
        {
            this.TitleText = titleText.Trim();
        }
        this.CssFormat = cssFormat;
        this.IsEnabled = !string.IsNullOrEmpty(titleText);
    }

    public override string StringValue()
    {
        StringBuilder sb = new StringBuilder();
        if (!this.IsEnabled)
        {
            sb.Append("").Append(",");
        }
        else
        {
            sb.Append(this.TitleText).Append(",");
            sb.Append(this.CssFormat);
        }
        return ChartUtil.EncodeNameValue("title", sb.ToString());
    }

    public override  string ToString()
    {
        return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("titleText={0}{1}", this.TitleText, lineSeparator);
        sb.AppendFormat("css={0}{1}", this.CssFormat, lineSeparator);
        return sb.ToString();
    }

    // Properties
    public string CssFormat
    {
        get
        {
            return this._css;
        }
        set
        {
            this._css = value;
            this.Enable();
        }
    }

    public string TitleText
    {
        get
        {
            return this._titleText;
        }
        set
        {
            this._titleText = value;
            this.Enable();
        }
    }
}
}
