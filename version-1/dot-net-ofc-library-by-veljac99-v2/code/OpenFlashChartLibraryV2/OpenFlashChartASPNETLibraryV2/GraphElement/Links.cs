using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class Links : OptionalGraphElementBase
  {
    // Fields
    protected bool _isFirstLink = true;
    protected StringBuilder _sbLinks = new StringBuilder();

    // Methods
    public void AddLink(string value)
    {
      if (this._isFirstLink)
      {
        this._isFirstLink = false;
      }
      else
      {
        this._sbLinks.Append(",");
      }
      this._sbLinks.Append(value);
    }

    public override string StringValue()
    {
      return this._sbLinks.ToString();
    }
  }


}
