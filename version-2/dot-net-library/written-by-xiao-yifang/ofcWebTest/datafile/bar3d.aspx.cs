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

public partial class bar3d : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        OpenFlashChart.OpenFlashChart chart = new OpenFlashChart.OpenFlashChart();
        chart.Title = new Title("AreaHollow");

        Bar3D bar = new OpenFlashChart.Bar3D();
        Random random = new Random();
        bar.Colour = "#345";

        bar.Fillalpha = 0.4;
        bar.Text = "Test";

        bar.Fontsize = 10;
        List<double> values = new List<double>();
        List<string> labels = new List<string>();
        for (int i = 0; i < 12; i++)
        {values.Add(random.Next(i, i * 2));
labels.Add(i.ToString());
        }
        bar.Values = values;
        chart.AddElement(bar);
        chart.X_Axis.Steps = 4;
        chart.X_Axis.Labels.Steps = 4;
        chart.X_Axis.Labels.Values = labels;
        chart.X_Axis.Labels.Vertical = true;
        
        string s = chart.ToString();
        Response.Clear();
        Response.CacheControl = "no-cache";
        Response.Write(s);
        Response.End();
    }
}