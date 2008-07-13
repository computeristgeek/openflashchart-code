using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace OpenFlashChart
{
    public class Title : ChartElement
    {
        public Title(string text)
        {
            base.Text = text;
        }

    }
}
