using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class XLabelStyle : OptionalGraphElementBase
  {
    // Fields
    private string _altAxisColor;
    private string _color;
    private RotationType _rotation;
    private float _size=12;
    private int _step;
    internal const string TAG_NAME = "x_label_style";

    // Methods
    public void Set([Optional, DefaultParameterValue(10f)] float size, [Optional, DefaultParameterValue("#000000")] string color, [Optional, DefaultParameterValue(RotationType.Horizontal)] RotationType rotation, [Optional, DefaultParameterValue(1)] int _step, [Optional, DefaultParameterValue("#000000")] string altAxisColor)
    {
      this.Size = size;
      this.Color = color;
      this.Rotation = rotation;
      this.Step = _step;
      this.AltAxisColor = altAxisColor;
    }

    public override string StringValue()
    {
      return this.StringValue("x_label_style");
    }

    internal string StringValue(string tagName)
    {
      if (!this.IsEnabled)
      {
        return "";
      }
      StringBuilder sb = new StringBuilder();
      sb.Append(this.Size).Append(",");
      sb.Append(this.Color).Append(",");
      sb.Append((int)this.Rotation).Append(",");
      sb.Append(this.Step).Append(",");
      sb.Append(this.AltAxisColor);
      return ChartUtil.EncodeNameValue(tagName, sb.ToString());
    }

    public override string ToString()
    {
      return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
      StringBuilder sb = new StringBuilder();
      sb.AppendFormat("size={0}{1}", this.Size.ToString(), lineSeparator);
      sb.AppendFormat("color={0}{1}", this.Color, lineSeparator);
      sb.AppendFormat("rotation={0}{1}", this.Rotation.ToString(), lineSeparator);
      sb.AppendFormat("step={0}{1}", this.Step.ToString(), lineSeparator);
      return sb.ToString();
    }

    // Properties
    public string AltAxisColor
    {
      get
      {
        return this._altAxisColor;
      }
      set
      {
        this._altAxisColor = value;
        this.Enable();
      }
    }

    /// <summary>
    /// Text color, example: "#808080"
    /// </summary>
    public string Color
    {
      get
      {
        return this._color;
      }
      set
      {
        this._color = value;
        this.Enable();
      }
    }

    public RotationType Rotation
    {
      get
      {
        return this._rotation;
      }
      set
      {
        this._rotation = value;
        this.Enable();
      }
    }

    /// <summary>
    /// Text size (points)
    /// </summary>
    public float Size
    {
      get
      {
        return this._size;
      }
      set
      {
        this._size = value;
        this.Enable();
      }
    }

    public int Step
    {
      get
      {
        return this._step;
      }
      set
      {
        this._step = value;
        this.Enable();
      }
    }

    // Nested Types
    /// <summary>
    /// XLabel text rotation
    /// </summary>
    public enum RotationType
    {
      Horizontal,
      Vertical,
      Diagonal_45_Degrees
    }
  }



}
