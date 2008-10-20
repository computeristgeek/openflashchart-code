using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class XAxis:Axis
    {
        private string tick_height;
        private bool offset;
        private XAxisLabels labels;
        [JsonProperty("labels")]
        public XAxisLabels Labels
        {
            get
            {
                if (this.labels == null)
                    this.labels = new XAxisLabels();
                return this.labels;
            }
            set { this.labels = value; }
        }
        public void SetLabels(IList<string> labelsvalue)
        {
            Labels.SetLabels(labelsvalue);
            //if (labels == null)
            //    labels = new List<AxisLabel>();
            //foreach (string str in labelsvalue)
            //{
            //    labels.Add(new AxisLabel(str));
            //}
        }
        public void SetRange(double min, double max)
        {
            base.Max = max;
            base.Min = min;
        }
        [JsonProperty("offset")]
        public bool Offset
        {
            set { offset = value; }
            get { return offset; }
        }
       
        [JsonProperty("tick-height")]
        public string TickHeight
        {
            get { return tick_height; }
            set { tick_height = value; }
        }
    }
}
