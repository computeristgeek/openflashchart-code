using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.GraphElement;
using OpenFlashChartASPNETLibraryV2.Chart;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.Graph
{
  /// <summary>
  /// Pie graph, which contains only one pie chart and cannot be mixed with other charts
  /// </summary>
  public class PieGraph : Graph
  {
    // Fields
    public Background Background = new Background();
    public PieLabels Labels = new PieLabels();
    public Links Links = new Links();
    public PieChart PieChart;
    public PieColors PieColors = new PieColors();
    public Title Title = new Title();
    public Tooltip ToolTip = new Tooltip();

    // Methods
    /// <summary>
    /// constuctor
    /// </summary>
    /// <param name="maxDecimals">Maximum number of decimal places</param>
    public PieGraph(int maxDecimals)
    {
      this.PieChart = new PieChart(maxDecimals);
    }

    public override string StringValue()
    {
      StringBuilder sb = new StringBuilder();
      if (this.Title != null)
      {
        sb.Append(this.Title.StringValue());
      }
      if (this.Background != null)
      {
        sb.Append(this.Background.StringValue());
      }
      if (this.ToolTip != null)
      {
        sb.Append(this.ToolTip.StringValue());
      }
      sb.AppendLine();
      if (this.PieChart != null)
      {
        sb.Append(ChartUtil.EncodeNameValue(this.PieChart.ChartId, this.PieChart.StringValue(), 1));
        if (this.PieChart.Values != null)
        {
          sb.Append(ChartUtil.EncodeNameValue("values", this.PieChart.ValuesAsString, 1));
        }
      }
      if (this.Labels != null)
      {
        sb.Append(this.Labels.StringValue());
      }
      if (this.Links != null)
      {
        sb.Append(ChartUtil.EncodeNameValue("links", this.Links.StringValue(), 1));
      }
      if (this.PieColors != null)
      {
        sb.Append(ChartUtil.EncodeNameValue("colours", this.PieColors.StringValue(), 1));
      }
      //sb.Append(this.customGraphElementItemsToString());
      return sb.ToString();
    }
  }


}
