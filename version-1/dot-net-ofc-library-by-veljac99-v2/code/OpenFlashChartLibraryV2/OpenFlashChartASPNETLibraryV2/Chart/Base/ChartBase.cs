using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.ChartDataValues;
using Newtonsoft.Json;
using System.Collections;
using OpenFlashChartASPNETLibraryV2.GraphElement;

namespace OpenFlashChartASPNETLibraryV2.Chart.Base 
{
  /// <summary>
  /// Base class for all chart types
  /// </summary>
  public abstract class ChartBase
  {

    /// <summary>
    /// Chart type
    /// </summary>
    public enum ChartType
    { 
      line,
      line_dot,
      line_hollow, 
      area_hollow,

      bar,
      filled_bar,
      bar_glass,
      bar_fade,
      bar_zebra,
      bar_arrow,
      bar_3d,


      pie,
      candle,
      scatter,
      hlc
    }

    // Methods
    /// <summary>
    /// Generate chart definition for values
    /// </summary>
    /// <returns></returns>
    public abstract string StringValue();

    // Properties

    /// <summary>
    /// Chart type name
    /// </summary>
    [JsonProperty("type")]
    public abstract string ChartId { get; }

    /// <summary>
    /// Chart (y) data values
    /// </summary>
    [JsonProperty("values")]
    //public abstract ChartDataBase<object> Values { get; }
    public abstract IEnumerable Values { get; }
    //public abstract BaseChartDpublic abstract ChartDataBase<object> Values { get; }ata Values { get; }


    public abstract string ValuesAsString { get; }

    /// <summary>
    /// Calculates range (min-max) for x axis
    /// </summary>
    /// <returns></returns>
    public abstract MinMax GetXMinMax();
  }
}
