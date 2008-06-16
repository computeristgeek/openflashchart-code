using OpenFlashChartASPNETLibraryV2.Graph;
using OpenFlashChartASPNETLibraryV2.Chart;
using System;

public class ChartGraph008
{
  public static ChartGraph GetChartGraph()
  {
    ChartGraph g = new ChartGraph();
    
    //add line chart to graph
    HighLowCloseChart chart = g.AddHighLowCloseChart(2);
    chart.LineWidth = 2;
    chart.Color = "#ff3030";
    chart.Alpha = 80;

    //chart data
    System.Random rnd = new System.Random(System.DateTime.Now.Millisecond); //Randomize
    for (int i = 0; i < 20; i++)
    {
      float highValue = (float)(rnd.Next(90000000) / 1000.00f);
      float lowValue = highValue * rnd.Next(70, 95) / 100.00f;
      float closeValue = lowValue + (highValue - lowValue) * rnd.Next(5, 95) / 100.00f;

      chart.Data.Add(
        highValue
        , lowValue
        , closeValue
        );
      //associated x label
      g.XLabels.Add(DateTime.Now.AddDays (i).ToShortDateString ());
    }

    g.XLabels.Add("");

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
