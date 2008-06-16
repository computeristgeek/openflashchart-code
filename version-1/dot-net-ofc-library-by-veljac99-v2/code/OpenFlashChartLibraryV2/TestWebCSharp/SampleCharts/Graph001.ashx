<%@ WebHandler Language="C#" Class="Graph001" %>

using System;
using System.Web;

public class Graph001 : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

      
      context.Response.Write(" &title=,&");
      context.Response.Write(" &bg_colour=#f8f8d8&");
      context.Response.Write(" &x_min=0&");
      context.Response.Write(" &x_max=9&");
      context.Response.Write(" &y_label_style=10,#000000&");
      context.Response.Write(" &y_ticks=2,5,2&");
      context.Response.Write(" &line=2,#80FF80,,0,0&");
      context.Response.Write(" &values=0,1,2,3,4,5,6,7,8,9&");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}