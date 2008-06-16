<%@ WebHandler Language="C#" Class="GraphData" %>

using System;
using System.Web;

public class GraphData : IHttpHandler
{

  public void ProcessRequest(HttpContext context)
  {
    string[] graphIds = context.Request.QueryString.GetValues("graphId");
    string graphId = (graphIds == null || graphIds.Length < 1) ? "-001" : graphIds[0];



    context.Response.ContentType = "text/plain";
    context.Response.Write(GetGraphData(graphId));
  }

  private string GetGraphData(string graphId)
  {
    switch (graphId )
    {
      case "001":
        return ChartGraph001.GetChartGraph().StringValue();
      case "002":
        return ChartGraph002.GetChartGraph().StringValue();
      case "003":
        return ChartGraph003.GetChartGraph().StringValue();
      case "004":
        return ChartGraph004.GetChartGraph().StringValue();
      case "005":
        return ChartGraph005.GetChartGraph().StringValue();
      case "006":
        return ChartGraph006.GetChartGraph().StringValue();
      case "007":
        return ChartGraph007.GetChartGraph().StringValue();
      case "008":
        return ChartGraph008.GetChartGraph().StringValue();
      case "009":
        return ChartGraph009.GetChartGraph().StringValue();
      case "010":
        return ChartGraph010.GetChartGraph().StringValue();
      default:

        break;
    }

    return "graphId:" + graphId + " not implemented";
  }

  public bool IsReusable
  {
    get
    {
      return false;
    }
  }

}