using System;
using System.Collections.Generic;
using System.Text;
using JsonFx.Json;


namespace OpenFlashChart
{
    public  class BarStackKey
    {
        private string colour;
        private int? fontsize;
        private string text;
        public BarStackKey(string colour,string text,int? fontsize)
        {
            this.colour = colour;
            this.text = text;
            this.fontsize = fontsize;
        }
        [JsonProperty("colour")]
        public string Colour
        {
            get { return colour; }
            set { colour = value; }
        }
        [JsonProperty("font-size")]
        public int? FontSize
        {
            get { return fontsize; }
            set { fontsize = value; }
        }
        [JsonProperty("text")]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }
    }
     public  class BarStackKeys:List<BarStackKey>
     {
         
     }
   public class BarStackValue
   {
       private string colour;
       private double val;
       public BarStackValue(double val,string color)
       {
           this.Colour = color;
           this.Val = val;
       }
       public BarStackValue(double val)
       {
           this.Val = val;
       }
       public BarStackValue()
       {
           
       }
       public static implicit operator BarStackValue(double val)
       {
           return new BarStackValue(val);
       }
       [JsonProperty("colour")]
       public string Colour
       {
           get { return colour; }
           set { colour = value; }
       }
       [JsonProperty("val")]
       public double Val
       {
           get { return val; }
           set { val = value; }
       }
   }
    public class BarStack:BarBase
    {
        private BarStackKeys barStackKeys;
        public BarStack()
        {
            this.ChartType = "bar_stack";
        }
        [JsonProperty("keys")]
        public BarStackKeys BarStackKeys
        {
            get { return barStackKeys; }
            set { barStackKeys = value; }
        }

        public void Add(BarStackValue barStackValue)
        {
            this.Values.Add(barStackValue);
        }
        public void AddStack(List<BarStackValue> barStackValues)
        {
            base.Values.Add(barStackValues);
        }
        public  void SetKeys(BarStackKeys keys)
        {
            this.BarStackKeys = keys;
        }
        public void AddBarStackKey(BarStackKey key)
        {
            if(this.barStackKeys==null)
                this.barStackKeys=new BarStackKeys();
            this.barStackKeys.Add(key);
        }
    }
}
