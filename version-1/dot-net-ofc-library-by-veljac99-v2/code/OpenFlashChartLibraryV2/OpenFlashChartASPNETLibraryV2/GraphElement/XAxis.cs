using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class XAxis : OptionalGraphElementBase
{
    // Fields
    private int _axis_3d = 0;
    private string _axisColor = "#000000";
    private int _axisSteps = 10;
    private string _gridColor = "#000000";
    internal const string TAG_NAME_axis_3d = "x_axis_3d";
    internal const string TAG_NAME_axis_steps = "x_axis_steps";
    internal const string TAG_NAME_axisColor = "x_axis_colour";
    internal const string TAG_NAME_gridColor = "x_grid_colour";

    // Methods
    public void Set(string gridColor, string axisColor, int axis_3D_depthPx, int axisSteps)
    {
        this.GridColor = gridColor;
        this.AxisColor = axisColor;
        this.Axis3D_DepthPx = axis_3D_depthPx;
        this.AxisSteps = axisSteps;
    }

    public override string StringValue()
    {
        return this.StringValue("x_grid_colour", "x_axis_colour", "x_axis_3d", "x_axis_steps");
    }

    public string StringValue(string tagNameGridColor, string tagNameAxisColor, string tagAxis3d, string tagAxis_steps)
    {
        if (!this.IsEnabled)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(ChartUtil.EncodeNameValue(tagNameGridColor, this.GridColor));
        sb.Append(ChartUtil.EncodeNameValue(tagNameAxisColor, this.AxisColor));
        if (this.Axis3D_DepthPx > 0)
        {
            sb.Append(ChartUtil.EncodeNameValue(tagAxis3d, this.Axis3D_DepthPx.ToString()));
        }
        if (this.AxisSteps > 0)
        {
            sb.Append(ChartUtil.EncodeNameValue(tagAxis_steps, this.AxisSteps.ToString()));
        }
        return sb.ToString();
    }

    public override  string ToString()
    {
        return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("gridColor={0}{1}", this.GridColor, lineSeparator);
        sb.AppendFormat("axisColor={0}{1}", this.AxisColor, lineSeparator);
        sb.AppendFormat("axis_3d={0}{1}", this.Axis3D_DepthPx.ToString(), lineSeparator);
        return sb.ToString();
    }

    // Properties
    public int Axis3D_DepthPx
    {
        get
        {
            return this._axis_3d;
        }
        set
        {
            this._axis_3d = value;
            this.Enable();
        }
    }

    public string AxisColor
    {
        get
        {
            return this._axisColor;
        }
        set
        {
            this._axisColor = value;
            this.Enable();
        }
    }

    public int AxisSteps
    {
        get
        {
            return this._axisSteps;
        }
        set
        {
            this._axisSteps = value;
            this.Enable();
        }
    }

    public string GridColor
    {
        get
        {
            return this._gridColor;
        }
        set
        {
            this._gridColor = value;
            this.Enable();
        }
    }
}


}
