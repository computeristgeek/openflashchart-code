using System;
using System.Collections.Generic;
using System.Text;

namespace OpenFlashChart
{
    public abstract class BarBase : Chart<double>
    {
        protected BarBase()
        {
            this.ChartType = "bar";
        }
    }
}
