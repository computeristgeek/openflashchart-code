﻿using OpenFlashChartASPNETLibraryV2.Graph;
using OpenFlashChartASPNETLibraryV2.Chart;
using System;

public class ChartGraph006
{
  public static ChartGraph GetChartGraph()
  {
    ChartGraph g = new ChartGraph();

    //set title with css formatting
    g.Title.TitleText = "Sales by region";
    g.Title.CssFormat = "{color: #7E97A6; font-size: 20; margin: 3px 0px; text-align: left}";

    //add line chart to graph
    BarGlassChart chart1 = g.AddBarGlassChart(2);
    chart1.Alpha = 80;
    chart1.Color = "#ff3030";


    //add another line chart to graph
    BarGlassChart chart2 = g.AddBarGlassChart(2);
    chart2.Alpha = 80;
    chart2.Color = "#308030";

    //add another line chart to graph
    BarGlassChart chart3 = g.AddBarGlassChart(2);
    chart3.Alpha = 80;
    chart3.Color = "#3030ff";


    //chart data
    System.Random rnd = new System.Random(System.DateTime.Now.Millisecond); //Randomize
    for (int i = 0; i < 10; i++)
    {
      chart1.Data.Add(rnd.Next(30000, 100000000) / 1000.00);
      chart2.Data.Add(rnd.Next(30000, 100000000) / 1000.00);
      chart3.Data.Add(rnd.Next(30000, 100000000) / 1000.00);
      //associated x label
      g.XLabels.Add("Region " + i);
    }

    //set range
    g.CalcXMinMax();

    g.YMinMax.MaxValue = 0;

    //calc Y range
    float maxValue = Math.Max(
                           chart1.GetXMinMax().MaxValue,
                           chart2.GetXMinMax().MaxValue
                           );
    maxValue = Math.Max(maxValue,
                           chart3.GetXMinMax().MaxValue
                           );
    maxValue = (float)Math.Ceiling(maxValue);

    //g.YMinMax.MaxValue =  maxValue;
    g.YMinMax.MaxValue = 100000;


    

    //X labels - style
    g.XLabelStyle.Size = 12;
    g.XLabelStyle.Rotation = OpenFlashChartASPNETLibraryV2.GraphElement.XLabelStyle.RotationType.Diagonal_45_Degrees;

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
