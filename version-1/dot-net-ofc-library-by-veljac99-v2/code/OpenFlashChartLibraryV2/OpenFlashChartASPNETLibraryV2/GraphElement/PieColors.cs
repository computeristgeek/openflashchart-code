using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class PieColors
  {
    // Fields
    protected bool _isFirstColor = true;
    protected StringBuilder _sbColors = new StringBuilder();

    // Methods
    public void AddColor(string value)
    {
      if (string.IsNullOrEmpty(value))
      {
        value = string.Empty;
      }
      if (this._isFirstColor)
      {
        this._isFirstColor = false;
      }
      else
      {
        this._sbColors.Append(",");
      }
      this._sbColors.Append(value);
    }

    public string StringValue()
    {
      return this._sbColors.ToString();
    }
  }

 

}
