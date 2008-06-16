using OpenFlashChartASPNETLibraryV2.Graph;
using OpenFlashChartASPNETLibraryV2.Chart;

public class ChartGraph001
{
  public static ChartGraph GetChartGraph()
  {
    ChartGraph g = new ChartGraph();

    LineChart chart = g.AddLineChart(2);

    for (int i = 0; i < 15; i++)
    {
      chart.Data.Add(i);
    }
    g.CalcXMinMax();


    return g;
  }
}
