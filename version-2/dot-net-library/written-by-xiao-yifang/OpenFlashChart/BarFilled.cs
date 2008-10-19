using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;
namespace OpenFlashChart
{
    public class BarFilledValue
    {
        private int? bottom;
        private int? top;
        private string color;
        private string tip;
        private string outline_color;
        public BarFilledValue(int top, int bottom)
        {
            this.Bottom = bottom;
            this.Top = top;
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
        [JsonProperty("outline-colour")]
        public string OutlineColor
        {
            get { return outline_color; }
            set { outline_color = value; }
        }
    }
    public class BarFilled : Chart<BarFilledValue>
    {
        public BarFilled()
        {
            this.ChartType = "bar_filled";
        }

    }
}
