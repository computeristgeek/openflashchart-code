using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class LineDotValue
    {
        private double? val;
        private string tip;
        private string color;
        public LineDotValue()
        {}
        public LineDotValue(double val)
        {
            this.val = val;
        }
        public LineDotValue(double val,string tip,string color)
        {
            this.val = val;
            this.tip = tip;
            this.color = color;
        }
        [JsonProperty("value")]
        public double? Value
        {
            get { return val; }
            set { val = value; }
        }
        [JsonProperty("tip")]
        public string Tip
        {
            get { return tip; }
            set { tip = value; }
        }
        [JsonProperty("colour")]
        public string Color
        {
            get { return color; }
            set { color = value; }
        }
    }
    public class LineBase : Chart<LineDotValue>
    {
        private int width;
        private int dotsize;
        private int halosize;
        private string _onclick;
        private bool loop;
        
        public LineBase()
        {
            this.ChartType = "line_dot";
          
           
        }
        public void SetOnClickFunction(string func)
        {
            this._onclick = func;
        }
        [JsonProperty("on-click")]
        public virtual string OnClick
        {
            set { this._onclick = value; }
            get { return this._onclick; }
        }
        [JsonProperty("width")]
        public virtual int Width
        {
            set { this.width = value; }
            get { return this.width; }
        }
     
        [JsonProperty("dot-size")]
        public virtual int DotSize
        {
            get { return dotsize; }
            set { dotsize = value; }
        }
        [JsonProperty("halo-size")]
        public virtual int HaloSize
        {
            get { return halosize; }
            set { halosize = value; }
        }
        [JsonProperty("loop")]
        public bool Loop
        {
            get { return loop; }
            set { loop = value; }
        }
    }
}
