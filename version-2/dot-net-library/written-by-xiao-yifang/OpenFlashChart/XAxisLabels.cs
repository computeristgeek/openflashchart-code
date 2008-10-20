using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class XAxisLabels
    {
        private int? steps;
        private IList<AxisLabel> labels;
        private string colour;
        private string rotate;
       
        [JsonProperty("steps")]
        public int? Steps
        {
            get
            {
                if (this.steps == null)
                    return null;
                return this.steps.Value;
            }
            set { this.steps = value; }
        }
        [JsonProperty("labels")]
        [Obsolete("just for json generation,not used.Use 'Values' instead")]
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
    }
}
