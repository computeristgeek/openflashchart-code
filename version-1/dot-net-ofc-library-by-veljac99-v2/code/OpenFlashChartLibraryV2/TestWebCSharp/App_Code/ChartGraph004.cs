using OpenFlashChartASPNETLibraryV2.Graph;
using OpenFlashChartASPNETLibraryV2.Chart;

public class ChartGraph004
{
  public static Graph GetChartGraph()
  {
    PieGraph g = new PieGraph(2);

    //set title with css formatting
    g.Title.TitleText = "Sales by region";
    g.Title.CssFormat = "{color: #7E97A6; font-size: 20; margin: 3px 0px; text-align: left}";


    //get chart instance
    PieChart chart = g.PieChart;

    //chart data
    System.Random rnd = new System.Random(System.DateTime.Now.Millisecond); //Randomize
    for (int i = 0; i < 10; i++)
    {
      chart.Data.Add(rnd.Next(100000000) / 1000.00);
      //associated x label
      g.Labels.Add("Region " + i);

    }

    //graph colors
    g.Background.Color = "#ffffff";

    //colors for slices
    g.PieColors.AddColor("#ff0000");
    g.PieColors.AddColor("#00ff00");
    g.PieColors.AddColor("#0000ff");

    //g.Links ...
    //g.ToolTip ...


    return g;
  }
}
