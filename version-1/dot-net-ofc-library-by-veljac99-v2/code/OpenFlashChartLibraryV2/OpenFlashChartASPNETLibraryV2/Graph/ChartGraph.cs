using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Chart.Base;
using OpenFlashChartASPNETLibraryV2.Utility;
using OpenFlashChartASPNETLibraryV2.Chart;
using OpenFlashChartASPNETLibraryV2.GraphElement;
using Newtonsoft.Json;

namespace OpenFlashChartASPNETLibraryV2.Graph
{
  /// <summary>
  /// Chart graph for all basic charts (except Pie! - see PieGraph)
  /// </summary>
  public class ChartGraph : Graph
  {
    #region Fields

    /// <summary>
    /// Graph Background settings
    /// </summary>
    public Background Background = new Background();

    /// <summary>
    /// List of added charts
    /// </summary>
    public List<ChartBase> Charts = new List<ChartBase>();

    /// <summary>
    /// Graph inner background settings
    /// </summary>
    public InnerBackground InnerBackground = new InnerBackground();

    /// <summary>
    /// Set this value to true only for grapht with separate scale for Y axis (left AND RIGHT)
    /// </summary>
    public bool IsYRightVisible = false;

    /// <summary>
    /// Graph title settings
    /// </summary>
    public Title Title = new Title();

    /// <summary>
    /// Graph tooltip setings
    /// </summary>
    public Tooltip ToolTip = new Tooltip();

    /// <summary>
    /// Graph XAxis setings (gridColor,  axisColor,  axis_3D_depthPx,  axisSteps)
    /// </summary>
    public XAxis XAxis = new XAxis();

    /// <summary>
    /// Graph XLabels setings
    /// </summary>
    public XAxisLabels XLabels = new XAxisLabels();

    /// <summary>
    /// Graph XLabelStyle setings
    /// </summary>
    public XLabelStyle XLabelStyle = new XLabelStyle();

    /// <summary>
    /// Graph XLegend setings
    /// </summary>
    public XLegend XLegend = new XLegend();

    /// <summary>
    /// Graph x range - XMinMax setings
    /// </summary>
    public MinMax XMinMax = new MinMax(MinMax.MinMaxType.X);

    /// <summary>
    /// Graph XTicks setings
    /// </summary>
    public XTicks XTicks = new XTicks();

    /// <summary>
    /// Graph YAxis setings
    /// </summary>
    public YAxis YAxis = new YAxis();

    /// <summary>
    /// Graph YAxisRight (if IsYRightVisible is true) setings
    /// </summary>
    public YAxisRight YAxisRight = new YAxisRight();

    /// <summary>
    /// Graph YLabelStyle setings
    /// </summary>
    public YLabelStyle YLabelStyle = new YLabelStyle();

    /// <summary>
    /// Graph YLabelStyleRight setings  (if IsYRightVisible is true)
    /// </summary>
    public YLabelStyleRight YLabelStyleRight = new YLabelStyleRight();

    /// <summary>
    /// Graph YLegend setings
    /// </summary>
    public YLegend YLegend = new YLegend();

    /// <summary>
    /// Graph YLegendRight setings (if IsYRightVisible is true)
    /// </summary>
    public YLegendRight YLegendRight = new YLegendRight();

    /// <summary>
    /// Graph Y range setings
    /// </summary>
    public MinMax YMinMax = new MinMax(MinMax.MinMaxType.Y);

    /// <summary>
    /// Graph Y range setings (for Y2 - if IsYRightVisible is true)
    /// </summary>
    public MinMax YMinMaxRight = new MinMax(MinMax.MinMaxType.Y2);

    /// <summary>
    /// Graph number format setings (decimal and thousand separator, number of decimal places)
    /// </summary>
    public NumberFormat YNumberFormat = new NumberFormat();

    /// <summary>
    /// Graph number format setings (decimal and thousand separator, number of decimal places)
    /// </summary>
    public NumberFormatRight YNumberFormatRight = new NumberFormatRight();

    /// <summary>
    /// Graph YTicks setings
    /// </summary>
    public YTicks YTicks = new YTicks();
    #endregion
    // Methods
    #region Add Chart Methods

    /// <summary>
    /// Add a new chart
    /// </summary>
    /// <param name="chart"></param>
    private void AddChart(ChartBase chart)
    {
      if (chart != null)
      {
        this.Charts.Add(chart);
      }
    }

    public AreaHollowChart AddAreaHollowChart(int maxDecimals)
    {
      AreaHollowChart chart = new AreaHollowChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public BarChart AddBarChart(int maxDecimals)
    {
      BarChart chart = new BarChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public Bar3DChart AddBar3DChart(int maxDecimals)
    {
      Bar3DChart chart = new Bar3DChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public BarArrowChart AddBarArrowChart(int maxDecimals)
    {
      BarArrowChart chart = new BarArrowChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public BarFadeChart AddBarFadeChart(int maxDecimals)
    {
      BarFadeChart chart = new BarFadeChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public BarFilledChart AddBarFilledChart(int maxDecimals)
    {
      BarFilledChart chart = new BarFilledChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public BarGlassChart AddBarGlassChart(int maxDecimals)
    {
      BarGlassChart chart = new BarGlassChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public BarZebraChart AddBarZebraChart(int maxDecimals)
    {
      BarZebraChart chart = new BarZebraChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public CandleChart AddCandleChart(int maxDecimals)
    {
      CandleChart chart = new CandleChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public HighLowCloseChart AddHighLowCloseChart(int maxDecimals)
    {
      HighLowCloseChart chart = new HighLowCloseChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public LineChart AddLineChart(int maxDecimals)
    {
      LineChart chart = new LineChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public LineDotChart AddLineDotChart(int maxDecimals)
    {
      LineDotChart chart = new LineDotChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public LineHollowChart AddLineHollowChart(int maxDecimals)
    {
      LineHollowChart chart = new LineHollowChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }

    public ScatterCircleChart AddScatterCircleChart(int maxDecimals)
    {
      ScatterCircleChart chart = new ScatterCircleChart(maxDecimals);
      this.AddChart(chart);
      return chart;
    }
    #endregion

    public override string StringValue()
    {
      return StringValue(false);
    }

    private StringBuilder _sb;

    private void AppendJsonObject(OptionalGraphElementBase o, string objectName)
    {
      AppendJsonObject(o, o.IsEnabled, objectName);
      //if (o != null && !o.IsEnabled)
      //{
      //  return;
      //}
      //else
      //{
      //  AppendJsonObject(o, o.IsEnabled);
      //}

    }

    private void AppendJsonObject(object o, bool isEnebled, string objectName)
    {
      AppendJsonObject(o, isEnebled, true, objectName);
    }

    private void AppendJsonObject(object o, bool isEnebled, bool autoSeparator, string objectName)
    {

      if (o == null || !isEnebled)
      {
        return;
      }


      if (_sb == null)
      {
        _sb = new StringBuilder();
        _sb.Append("{");
      }
      else
      {
        if (autoSeparator) _sb.Append("\r\n,");
      }
      if (!String.IsNullOrEmpty(objectName)) _sb.Append("\"" + objectName + "\"").Append(":");
      _sb.Append(JavaScriptConvert.SerializeObject(o));
    }

    public void CalcXMinMax()
    {
      this.XMinMax = new MinMax(MinMax.MinMaxType.X);
      this.XMinMax.MinValue = float.MaxValue;
      this.XMinMax.MaxValue = float.MinValue;
      this.XMinMax.Disable();
      foreach (ChartBase chart in this.Charts)
      {
        this.XMinMax.Enable();
        MinMax rng = Charts[0].GetXMinMax();
        this.XMinMax.MinValue = Math.Min(rng.MinValue, this.XMinMax.MinValue);
        this.XMinMax.MaxValue = Math.Max(rng.MaxValue, this.XMinMax.MaxValue);
      }

    }


    public string JsonValue()
    {
      _sb = null; //!! must be null because of AppendJsonObject will handle it!!
      //_sb = new StringBuilder();

      AppendJsonObject(this.Title, "title");
      AppendJsonObject(this.Background, "background");
      AppendJsonObject(this.InnerBackground, "innerBackground");
      AppendJsonObject(this.ToolTip, "toolTip");
      AppendJsonObject(this.XMinMax, "xMinMax");
      AppendJsonObject(this.XLegend, "xLegend");
      AppendJsonObject(this.XLabelStyle, "xLabelStyle");
      AppendJsonObject(this.XLabels, "xLabels");
      AppendJsonObject(this.XAxis, "xAxis");
      AppendJsonObject(this.XTicks, "xTicks");
      AppendJsonObject(this.YMinMax, "yMinMax");
      AppendJsonObject(this.YLegend, "yLegend");
      AppendJsonObject(this.YLabelStyle, "yLabelStyle");
      AppendJsonObject(this.YAxis, "yAxis");
      AppendJsonObject(this.YTicks, "yTicks");
      AppendJsonObject(this.YNumberFormat, "yNumberFormat");

      if (this.IsYRightVisible)
      {
        ChartUtil.EncodeNameValue("show_y2", "true"); //TODO: fix

        AppendJsonObject(this.YMinMaxRight, "yMinMaxRight");
        AppendJsonObject(this.YLegendRight, "xxxx");
        AppendJsonObject(this.YLabelStyleRight, "xxxx");
        AppendJsonObject(this.YAxisRight, "xxxx");
        AppendJsonObject(this.YNumberFormatRight, "xxxx");

      }


      // AppendJsonObject(charts, true);

      int chartId = 0;

      _sb.Append("\r\n,\"elements\":[");

      foreach (ChartBase chart in this.Charts)
      {
        chartId++;
        if (chart != null)
        {
          AppendJsonObject(chart, true, false, "");
          //_sb.Append(ChartUtil.EncodeNameValue(chart.ChartId, chart.StringValue(), chartId));
          //if (chart.Values != null)
          //{
          //  _sb.Append(ChartUtil.EncodeNameValue("values", chart.Values.StringValue(), chartId));
          //}
        }
      }
      _sb.Append("]\r\n");
      //_sb.Append(this.CustomGraphElementItemsToJson());



      _sb.Append("}"); //json end


      return _sb.ToString();
    }

    /// <summary>
    /// Generate string based on current settings and data values for SWF OFC.
    /// Should be called after all changes.
    /// </summary>
    /// <param name="isJson"></param>
    /// <returns></returns>
    private string StringValue(bool isJson)
    {
      StringBuilder sb = new StringBuilder();
      if (this.Title != null)
      {
        sb.Append(this.Title.StringValue());
      }
      sb.AppendLine();
      if (this.Background != null)
      {
        sb.Append(this.Background.StringValue());
      }
      sb.AppendLine();
      if (this.InnerBackground != null)
      {
        sb.Append(this.InnerBackground.StringValue());
      }
      sb.AppendLine();
      if (this.ToolTip != null)
      {
        sb.Append(this.ToolTip.StringValue());
      }
      sb.AppendLine();
      if (this.XMinMax != null)
      {
        sb.Append(this.XMinMax.StringValue());
      }
      if (this.XLegend != null)
      {
        sb.Append(this.XLegend.StringValue());
      }
      if (this.XLabelStyle != null)
      {
        sb.Append(this.XLabelStyle.StringValue());
      }
      if (this.XLabels != null)
      {
        sb.Append(this.XLabels.StringValue());
      }
      if (this.XAxis != null)
      {
        sb.Append(this.XAxis.StringValue());
      }
      if (this.XTicks != null)
      {
        sb.Append(this.XTicks.StringValue());
      }
      sb.AppendLine();
      if (this.YMinMax != null)
      {
        sb.Append(this.YMinMax.StringValue());
      }
      if (this.YLegend != null)
      {
        sb.Append(this.YLegend.StringValue());
      }
      if (this.YLabelStyle != null)
      {
        sb.Append(this.YLabelStyle.StringValue());
      }
      if (this.YAxis != null)
      {
        sb.Append(this.YAxis.StringValue());
      }
      if (this.YTicks != null)
      {
        sb.Append(this.YTicks.StringValue());
      }
      if (this.YNumberFormat != null)
      {
        sb.Append(this.YNumberFormat.StringValue());
      }
      sb.AppendLine();
      if (this.IsYRightVisible)
      {
        ChartUtil.EncodeNameValue("show_y2", "true");
        if (this.YMinMaxRight != null)
        {
          sb.Append(this.YMinMaxRight.StringValue());
        }
        if (this.YLegendRight != null)
        {
          sb.Append(this.YLegendRight.StringValue());
        }
        if (this.YLabelStyleRight != null)
        {
          sb.Append(this.YLabelStyleRight.StringValue());
        }
        if (this.YAxisRight != null)
        {
          sb.Append(this.YAxisRight.StringValue());
        }
        if (this.YNumberFormatRight != null)
        {
          sb.Append(this.YNumberFormatRight.StringValue());
        }
        sb.AppendLine();
      }
      int chartId = 0;
      foreach (ChartBase chart in this.Charts)
      {
        chartId++;
        if (chart != null)
        {
          sb.Append(ChartUtil.EncodeNameValue(chart.ChartId, chart.StringValue(), chartId));
          if (chart.Values != null)
          {
            //foreach (var value in chart.Values)
            //{

            //}
            sb.Append(ChartUtil.EncodeNameValue("values", chart.ValuesAsString, chartId));
            //sb.Append(ChartUtil.EncodeNameValue("values", chart.Values.StringValue(), chartId)); 
            //TODO: fix
          }
        }
      }
      //sb.Append(this.CustomGraphElementItemsToString());
      return sb.ToString();
    }
  }
}
