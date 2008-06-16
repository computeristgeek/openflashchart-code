using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.Graph
{
  public abstract class Graph
  {
    // Fields
    //internal NameValueCollection CustomGraphElementItems { get; set; }

    // Methods
    //public void AddCustomGraphElement(string name, string value)
    //{
    //  if (string.IsNullOrEmpty(name))
    //  {
    //    throw new ArgumentNullException("name");
    //  }
    //  this.AssertValidItems();
    //  this.CustomGraphElementItems.Add(name, value);
    //}

    //internal void AssertValidItems()
    //{
    //  if (this.CustomGraphElementItems == null)
    //  {
    //    this.CustomGraphElementItems = new NameValueCollection();
    //  }
    //}

    //internal string CustomGraphElementItemsToString()
    //{
    //  if (
    //      (this.CustomGraphElementItems == null)
    //      ||
    //      (this.CustomGraphElementItems.Count == 0)
    //    )
    //  {
    //    return "";
    //  }

    //  StringBuilder sb = new StringBuilder();

    //  foreach (string key in CustomGraphElementItems)
    //  {
    //    string value = CustomGraphElementItems[key];
    //    sb.Append(ChartUtil.EncodeNameValue(key, value, 1));
    //  }

    //  return sb.ToString();
    //}

    //internal string CustomGraphElementItemsToJson()
    //{
    //  if (
    //      (this.CustomGraphElementItems == null)
    //      ||
    //      (this.CustomGraphElementItems.Count == 0)
    //    )
    //  {
    //    return "";
    //  }

    //  StringBuilder sb = new StringBuilder();

    //  foreach (string key in CustomGraphElementItems)
    //  {
    //    string value = CustomGraphElementItems[key];
    //    sb.Append(ChartUtil.EncodeNameValue(key, value, 1));
    //  }

    //  return sb.ToString();
    //}


    public abstract string StringValue();


  }



}
