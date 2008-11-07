using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public  class BarGlassValue:BarValue
    {
        public BarGlassValue(double top):base(top)
        {
           
        }
    }
    public class BarGlass : Chart<BarGlassValue>
    {
        public BarGlass()
        {
            this.ChartType = "bar_glass";
        }
    }
}
