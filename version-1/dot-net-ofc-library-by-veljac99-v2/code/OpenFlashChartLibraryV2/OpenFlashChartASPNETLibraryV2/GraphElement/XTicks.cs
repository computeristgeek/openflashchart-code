using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class XTicks : OptionalGraphElementBase
  {
    // Fields
    private int _ticks = 5;
    internal const string TAG_NAME = "x_ticks";

    // Methods
    public void Set(int ticks)
    {
      this.Ticks = ticks;
    }

    public override string StringValue()
    {
      return this.StringValue("x_ticks");
    }

    internal string StringValue(string tagName)
    {
      if (!this.IsEnabled)
      {
        return "";
      }
      return ChartUtil.EncodeNameValue(tagName, this.Ticks.ToString());
    }

    public override  string ToString()
    {
      return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
      StringBuilder sb = new StringBuilder();
      sb.AppendFormat("ticks={0}{1}", this.Ticks.ToString(), lineSeparator);
      return sb.ToString();
    }

    // Properties
    public int Ticks
    {
      get
      {
        return this._ticks;
      }
      set
      {
        this.IsEnabled = true;
        this._ticks = value;
      }
    }
  }


}
