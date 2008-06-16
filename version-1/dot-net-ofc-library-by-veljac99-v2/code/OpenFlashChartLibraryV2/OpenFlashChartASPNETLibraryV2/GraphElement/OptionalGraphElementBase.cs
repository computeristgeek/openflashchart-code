using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
  public abstract class OptionalGraphElementBase : GraphElementBase
  {
    // Fields
    private bool _isEnabled;

    // Methods
    public void Disable()
    {
      IsEnabled = false;
    }

    public void Enable()
    {
      _isEnabled= true ;
    }

    // Properties
    [JsonIgnore]
    public bool IsEnabled {
      get { return _isEnabled; }
      set { _isEnabled = value; }
    }
  }


}
