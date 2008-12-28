using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;

namespace OpenFlashChart
{
    public class BarValue
    {
        private double? bottom;
        private double? top;
        private string color;
        private string tip;
        public BarValue()
        {
            
        }
        public BarValue(double top)
        {
            this.top = top;
        }
        public BarValue(double top,double bottom)
        {
            this.bottom = bottom;
            this.top = top;
        }
        [JsonProperty("bottom")]
        public double? Bottom
        {
            get { return bottom; }
            set { bottom = value; }
        }
        [JsonProperty("top")]
        public double? Top
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
    public class Bar:BarBase
    {
        public Bar(){
            this.ChartType = "bar";
        }
        public void Add(BarValue barValue)
        {
            this.Values.Add(barValue);
        }
        
    }
}
