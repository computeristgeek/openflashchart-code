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
using System.Net;
using System.IO;

/// <summary>
/// Summary description for GraphHelper
/// </summary>
public class GraphHelper
{
  public  const string GRAPH_FILE_SAMPLE_FOLDER = "App_Code";
  public  const string GRAPH_FILE_PREFIX = "ChartGraph";
  public  const string GRAPH_FILE_SUFIX =".cs";
  public GraphHelper()
  {

  }

  public static string GetSourceFileName(string graphId)
  { 
    if (string.IsNullOrEmpty (graphId ))
      throw new ArgumentException ("graphID");

    string filename = GRAPH_FILE_PREFIX + graphId  + GRAPH_FILE_SUFIX ;
    filename  = System.IO.Path.Combine (
      HttpContext.Current.Server.MapPath ("~/" + GRAPH_FILE_SAMPLE_FOLDER)
      , filename );

    if (!System.IO.File.Exists (filename ))
      throw new System.IO.FileNotFoundException (filename );

    return filename ;
  }

  public static string GetSourceCode(string graphId) {
    string filename = GetSourceFileName(graphId);
    using (var fs = new System.IO.StreamReader(filename)) //new System.IO.FileStream(filename, System.IO.FileAccess.Read)))
    {
      var sr = new System.IO.StreamReader(filename);
      return sr.ReadToEnd();
    }

  }

  public static string GetUrlContent(string url)
  {
    HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(url);
    myRequest.Method = "GET";
    WebResponse myResponse = myRequest.GetResponse();
    StreamReader sr = new StreamReader(myResponse.GetResponseStream(), System.Text.Encoding.UTF8);
    string result = sr.ReadToEnd();
    sr.Close();
    myResponse.Close();
    return result;
  }
}
