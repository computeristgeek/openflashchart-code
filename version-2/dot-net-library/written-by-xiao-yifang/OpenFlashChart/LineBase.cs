using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    
    public class LineBase : Chart<LineDotValue>
    {
        private int width;
        private int dotsize;
        private int halosize;
        private string _onclick;
        private bool loop;
        
        public LineBase()
        {
            this.ChartType = "line";
            this.DotStyleType.Type = DotType.SOLID_DOT;
          
           
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
