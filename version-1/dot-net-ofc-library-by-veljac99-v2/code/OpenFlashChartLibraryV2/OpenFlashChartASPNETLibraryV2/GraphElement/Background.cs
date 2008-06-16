using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenFlashChartASPNETLibraryV2.Utility;

namespace OpenFlashChartASPNETLibraryV2.GraphElement
{
public class Background : OptionalGraphElementBase
{
    // Fields
    private string _backgroundColor = "#f8f8d8";
    private string _backgroundImage;
    private ImagePositionX _backgroundImageX = ImagePositionX.Left;
    private ImagePositionY _backgroundImageY = ImagePositionY.Top;

    // Nested Types
    public enum ImagePositionX
    {
      Center,
      Left,
      Right
    }

    public enum ImagePositionY
    {
      Middle,
      Top,
      Bottom
    }
  
  // Methods
    public Background()
    {
      this.Enable();
    }

    public void Set(string backgroundColor)
    {
        this.Color = backgroundColor;
    }

    public void Set(string color, string imageUrl, ImagePositionX imageXAlignment, ImagePositionY imageYAlignment)
    {
        this.Color = color;
        this.ImageUrl = imageUrl;
        this.ImageXAlignment = imageXAlignment;
        this.ImageYAlignment = imageYAlignment;
    }

    public override string StringValue()
    {
        if (!this.IsEnabled)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        if (!string.IsNullOrEmpty(this.ImageUrl))
        {
            sb.Append(ChartUtil.EncodeNameValue("bg_image", this.ImageUrl));
            sb.Append(ChartUtil.EncodeNameValue("bg_image_x", this.ImageXAlignment.ToString()));
            sb.Append(ChartUtil.EncodeNameValue("bg_image_y", this.ImageYAlignment.ToString()));
        }
        if (!string.IsNullOrEmpty(this.Color))
        {
            sb.Append(ChartUtil.EncodeNameValue("bg_colour", this.Color));
        }
        return sb.ToString();
    }

    public override  string ToString()
    {
        return this.ToString("\r\n");
    }

    public string ToString(string lineSeparator)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("backgroundColor={0}{1}", this.Color, lineSeparator);
        sb.AppendFormat("backgroundImage={0}{1}", this.ImageUrl, lineSeparator);
        sb.AppendFormat("backgroundImageX={0}{1}", this.ImageXAlignment.ToString(), lineSeparator);
        sb.AppendFormat("backgroundImageY={0}{1}", this.ImageYAlignment.ToString(), lineSeparator);
        return sb.ToString();
    }

    // Properties
    /// <summary>
    /// Background color, example: "#808080"
    /// </summary>
    public string Color
    {
        get
        {
            return this._backgroundColor;
        }
        set
        {
            this._backgroundColor = value;
            this.Enable();
        }
    }

    public string ImageUrl
    {
        get
        {
            return this._backgroundImage;
        }
        set
        {
            this._backgroundImage = value;
            this.Enable();
        }
    }

    public ImagePositionX ImageXAlignment
    {
        get
        {
            return this._backgroundImageX;
        }
        set
        {
            this._backgroundImageX = value;
            this.IsEnabled=true  ;
        }
    }

    public ImagePositionY ImageYAlignment
    {
        get
        {
            return this._backgroundImageY;
        }
        set
        {
            this._backgroundImageY = value;
            this.Enable();
        }
    }


}
}
