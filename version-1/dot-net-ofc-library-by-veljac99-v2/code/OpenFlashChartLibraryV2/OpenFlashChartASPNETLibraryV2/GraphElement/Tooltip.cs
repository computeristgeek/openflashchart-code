using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public class Tooltip : OptionalGraphElementBase
  {
    // Fields
    private string _tooltip = null;
    internal const string TAG_NAME = "tool_tip";

    // Methods
    public Tooltip AddNewLine()
    {
      return this.AddText("<br>");
    }

    public Tooltip AddText(string value)
    {
      if (string.IsNullOrEmpty(this.TooltipValue))
      {
        this.TooltipValue = value;
      }
      else
      {
        this.TooltipValue = this.TooltipValue + value;
      }
      return this;
    }

    public Tooltip AddVariable(VariableType variableType)
    {
      if (string.IsNullOrEmpty(this.TooltipValue))
      {
        this.TooltipValue = this.GetVariableByType(variableType);
      }
      else
      {
        this.TooltipValue = this.TooltipValue + this.GetVariableByType(variableType);
      }
      return this;
    }

    internal string GetVariableByType(VariableType variable_Type)
    {
      switch (variable_Type)
      {
        case VariableType.YValue:
          return "#val#";

        case VariableType.YValueUsingNumberFormat:
          return "#val:number#";

        case VariableType.YValueUsingTimeFormat:
          return "#val:time#";

        case VariableType.XLegendValue:
          return "#x_legend#";

        case VariableType.XLabelValue:
          return "#x_label#";

        case VariableType.ChartLegend:
          return "#key#";

        case VariableType.YValueHigh:
          return "#high#";

        case VariableType.YValueLow:
          return "#low#";

        case VariableType.YValueOpen:
          return "#open#";

        case VariableType.YValueClose:
          return "#close#";
      }
      return "";
    }

    public void Set(string tooltip)
    {
      this.TooltipValue = tooltip;
    }

    public override string StringValue()
    {
      if (this.IsEnabled && !string.IsNullOrEmpty(this._tooltip))
      {
        return ChartUtil.EncodeNameValue("tool_tip", this.TooltipValue);
      }
      return "";
    }

    // Properties
    public string TooltipValue
    {
      get
      {
        return this._tooltip;
      }
      set
      {
        this._tooltip = value;
        this.IsEnabled = !string.IsNullOrEmpty(value);
      }
    }

    // Nested Types
    public enum VariableType
    {
      YValue,
      YValueUsingNumberFormat,
      YValueUsingTimeFormat,
      XLegendValue,
      XLabelValue,
      ChartLegend,
      YValueHigh,
      YValueLow,
      YValueOpen,
      YValueClose
    }
  }


}
