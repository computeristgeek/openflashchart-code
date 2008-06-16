using OpenFlashChartASPNETLibraryV2.Graph;
using OpenFlashChartASPNETLibraryV2.Chart;

public class ChartGraph002
{
  public static ChartGraph GetChartGraph()
  {
    ChartGraph g = new ChartGraph();
    
    //add line chart to graph
    LineChart chart = g.AddLineChart(2);
    chart.LineWidth = 4;
    chart.Color = "#ff3030";
    chart.CircleSize = 6;
    //System.Drawing.Color.


    //chart data
    System.Random rnd = new System.Random(System.DateTime.Now.Millisecond); //Randomize
    for (int i = 0; i < 20; i++)
    {
      chart.Data.Add( rnd.Next (100000000)/ 1000.00);
      //associated x label
      g.XLabels.Add("Region " + i);
    }

    //set range
    g.CalcXMinMax();
    
    g.YMinMax.MaxValue = 0;
    g.YMinMax.MaxValue = chart.GetXMinMax().MaxValue +3;

    //X labels - style
    g.XLabelStyle.Size = 12;
    g.XLabelStyle.Rotation = OpenFlashChartASPNETLibraryV2.GraphElement.XLabelStyle.RotationType.Diagonal_45_Degrees ;
    
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
