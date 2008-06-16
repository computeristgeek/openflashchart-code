using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class XAxisLabels : OptionalGraphElementBase
  {
    // Fields
    private int _count;
    private bool _isFirst = true;
    private StringBuilder _sb = new StringBuilder();
    internal const string TAG_NAME = "x_labels";

    // Methods
    public void Add(string value)
    {
      if (this._isFirst)
      {
        this._isFirst = false;
      }
      else
      {
        this._sb.Append(",");
      }
      this._sb.Append(value.Replace(",", " "));
      this._count++;
      this.IsEnabled = true;
    }

    public void Reset()
    {
      this._count = 0;
      this._sb = new StringBuilder();
      this._isFirst = true;
      this.IsEnabled = false;
    }

    public override string StringValue()
    {
      return this.StringValue("x_labels");
    }

    public string StringValue(string tagName)
    {
      if (!this.IsEnabled)
      {
        return "";
      }
      return ChartUtil.EncodeNameValue(tagName, this._sb.ToString());
    }
  }


}
