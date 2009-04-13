using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;

namespace OpenFlashChart
{
    public class Animation
    {
        private string type;
        private int? distance;
        public Animation(string type,int?distance)
        {
            this.type = type;
            this.distance = distance;
        }
        [JsonProperty("type")]
        public string Type
        {
            get { return type; }
            set { type = value; }
        }
        [JsonProperty("distance")]
        public int? Distance
        {
            get { return distance; }
            set { distance = value; }
        }
    }
    public class AnimationSeries:List<Animation>
    {}
}
