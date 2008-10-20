using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public class YAxis:Axis
    {
        private int offset;
        private int tick_length;
        private IList<String> labels;
        [JsonProperty("tick-length")]
        public int TickLength
        {
            get { return tick_length; }
            set { tick_length = value; }
        }
        public void SetRange(double min, double max)
        {
            base.Max = max;
            base.Min = min;
        }
        public void SetRange(double min, double max, int step)
        {
            base.Max = max;
            base.Min = min;
            base.Steps = step;
        }
        [JsonProperty("offset")]
        public int Offset
        {
            get { return offset; }
            set
            {
                offset = value>0 ? 1 : 0;
            }
        }
        [JsonProperty("labels")]
        public IList<string> Labels
        {
            get { return labels; }
            set { labels = value; }
        }
        public void SetLabels(IList<string> labelsvalue)
        {
            if(labels==null)
                labels = new List<string>();
            foreach (string str in labelsvalue)
            {
                labels.Add(str);
            }
        }
       
    }
}
