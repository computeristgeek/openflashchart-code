using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class AxisLabels
    {
        private int? steps;
        private IList<AxisLabel> labels;
        private string colour;
        private string rotate;
        private int? fontsize;
       
        [JsonProperty("steps")]
        public int? Steps
        {
            get
            {
                if (this.steps == null)
                    return null;
                return this.steps;
            }
            set { this.steps = value; }
        }
        [JsonProperty("labels")]
        [Obsolete("just for json generation,not used.Use SetLabels()")]
        public IList<AxisLabel> AxisLabelValues
        {
            get { return labels; }
            set { this.labels = value; }
        }
        public void SetLabels(IList<string> labelsvalue)
        {
            if (labels == null)
                labels = new List<AxisLabel>();
            foreach (string s in labelsvalue)
            {
                labels.Add(new AxisLabel(s));
            }
        }
        public void Add(AxisLabel label)
        {
            if (labels == null)
                labels = new List<AxisLabel>();
            labels.Add(label);
        }
        [JsonProperty("colour")]
        public string Color
        {
            set { this.colour = value; }
            get { return this.colour; }
        }
        [JsonProperty("rotate")]
        public string Rotate
        {
            set { this.rotate = value; }
            get { return this.rotate; }
        }
        [JsonIgnore]
        public bool Vertical
        {
            set
            {
                if (value)
                    this.rotate = "vertical";
            }
        }
        [JsonProperty("size")]
        public int? FontSize
        {
            get { return fontsize; }
            set { fontsize = value; }
        }
    }
}
