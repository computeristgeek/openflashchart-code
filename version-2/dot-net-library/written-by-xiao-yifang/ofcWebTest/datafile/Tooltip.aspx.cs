﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using OpenFlashChart;
using ToolTip=OpenFlashChart.ToolTip;

public partial class Tooltip : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        OpenFlashChart.OpenFlashChart chart = new OpenFlashChart.OpenFlashChart();
        List<double> data1 = new List<double>();
        List<double> data2 = new List<double>();
        List<double> data3 = new List<double>();
        Random random = new Random(DateTime.Now.Millisecond);
        for (double i = 0; i < 6.2; i += 0.2)
        {
            data1.Add(Math.Sin(i) * 1.9 + 7);
            data2.Add(Math.Sin(i) * 1.9 + 10);
            data3.Add(random.Next(-10,12));
        }

        OpenFlashChart.LineHollow line1 = new LineHollow();
        line1.Values = data1;
        line1.HaloSize = 3;
        line1.Width = 2;
        line1.DotSize = 5;
        line1.Fontsize = 12;
        line1.Colour = "#456f3";

        OpenFlashChart.LineHollow line2 = new LineHollow();
        line2.Values = data2;
        line2.HaloSize = 1;
        line2.Width = 1;
        line2.DotSize = 4;
        line2.Fontsize = 12;

        OpenFlashChart.LineHollow line3 = new LineHollow();
        line3.Values = data3;
        line3.HaloSize = 2;
        line3.Width = 6;
        line3.DotSize = 4;
        line3.Fontsize = 12;

        line1.Text = "line1";
        line2.Text = "line2";
        line3.Text = "line3";


        chart.AddElement(line1);
        chart.AddElement(line2);
        chart.AddElement(line3);
        chart.Title = new Title("multi line");
        chart.Y_Axis.SetRange(-10, 15, 5);

        chart.Tooltip = new ToolTip("my tip #val#");

        Response.Clear();
        Response.CacheControl = "no-cache";
        Response.Write(chart.ToPrettyString());
        Response.End();
    }
}
