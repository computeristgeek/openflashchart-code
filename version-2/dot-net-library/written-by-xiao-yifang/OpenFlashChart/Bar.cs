using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;

namespace OpenFlashChart
{
    public class BarValue
    {
        private int? bottom;
        private int? top;
        private string color;
        private string tip;
        public BarValue(int top,int bottom)
        {
            this.bottom = bottom;
            this.top = top;
        }
        [JsonProperty("bottom")]
        public int? Bottom
        {
            get { return bottom; }
            set { bottom = value; }
        }
        [JsonProperty("top")]
        public int? Top
        {
            get { return top; }
            set { top = value; }
        }
        [JsonProperty("colour")]
        public string Color
        {
            get { return color; }
            set { color = value; }
        }
        [JsonProperty("tip")]
        public string Tip
        {
            get { return tip; }
            set { tip = value; }
        }
    }
    public class Bar:Chart<BarValue >
    {
        public Bar(){
            this.ChartType = "bar";
        }
        
    }
}
