using OpenFlashChartASPNETLibraryV2.Graph;
using OpenFlashChartASPNETLibraryV2.Chart;

public class ChartGraph007
{
  public static ChartGraph GetChartGraph()
  {
    ChartGraph g = new ChartGraph();
    
    //add line chart to graph
    ScatterCircleChart chart = g.AddScatterCircleChart(2);
    chart.LineWidth = 4;
    chart.Color = "#ff3030";

    //chart data
    System.Random rnd = new System.Random(System.DateTime.Now.Millisecond); //Randomize
    for (int i = 0; i < 20; i++)
    {
      chart.Data.Add(
        (float)rnd.Next(2, 19)
        , (float)(rnd.Next (90000000)/ 1000.00f)
        , (float)rnd.Next(2, 19)
        );
      //associated x label
      g.XLabels.Add( i.ToString ());
    }

    //set range
    g.CalcXMinMax();
    
    g.YMinMax.MaxValue = 0;
    g.YMinMax.MaxValue = 100000;

    //X labels - style
    g.XLabelStyle.Size = 12;
    g.XLabelStyle.Rotation = OpenFlashChartASPNETLibraryV2.GraphElement.XLabelStyle.RotationType.Horizontal  ;
    
    //Number formating
    g.YNumberFormat.IsDecimalSeparatorComma = true;
    g.YNumberFormat.IsFixedNumberOfDecimalPlacesForced = true;
    g.YNumberFormat.IsThousandSeparatorDisabled = false;
    g.YNumberFormat.NumberOfDecimalPlaces = 2;

    //graph colors
    g.Background.Color = "#ffffff";
    g.InnerBackground.Color = "#f0f0f0";
    g.XAxis.GridColor = "#ffc0c0";


    g.XTicks.Ticks = 2;

    return g;
  }
}
