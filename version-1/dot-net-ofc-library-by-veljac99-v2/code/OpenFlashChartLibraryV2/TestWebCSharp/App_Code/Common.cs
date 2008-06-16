using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

/// <summary>
/// Summary description for Common
/// </summary>
public class Common
{
  // Methods
  public static string GetApplicationPath()
  {
    string ap = HttpContext.Current.Request.ApplicationPath;
    if (ap == "/")
    {
      return "";
    }
    return ap;
  }

  public static string GetFullApplicationPath()
  {
    string t = HttpContext.Current.Request.Url.AbsoluteUri;
    int i = t.IndexOf(HttpContext.Current.Request.Url.AbsolutePath);
    if (i > 1)
    {
      return (t.Substring(0, i) + GetApplicationPath());
    }
    return (HttpContext.Current.Request.Url.AbsoluteUri.Replace(HttpContext.Current.Request.Url.AbsolutePath, "") + GetApplicationPath());
  }

  public static string GetFullApplicationPath(string Pagename)
  {
    if (!Pagename.StartsWith("/"))
    {
      Pagename = "/" + Pagename;
    }
    return (GetFullApplicationPath() + Pagename);
  }

  public static string GetPath(string PageName)
  {
    if (!PageName.StartsWith("/"))
    {
      PageName = "/" + PageName;
    }
    return (GetApplicationPath() + PageName);
  }
}


