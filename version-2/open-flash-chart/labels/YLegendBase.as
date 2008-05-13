package labels {
	import org.flashdevelop.utils.FlashConnect;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.*;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import string.Utils;
	import string.Css;


	public class YLegendBase extends Sprite {
		
		public var tf:TextField;
		
		public var text:String;
		public var style:String;
		private var css:Css;
		
		[Embed(source = "C:\\Windows\\Fonts\\Verdana.ttf", fontFamily = "foo", fontName = '_Verdana')]
		private static var EMBEDDED_FONT:String;
		
		
		public function YLegendBase( json:Object, name:String )
		{

			if( json[name+'_legend'] == undefined )
				return;
				
			if( json[name+'_legend'] )
			{
				object_helper.merge_2( json[name+'_legend'], this );
			}
			
			this.css = new Css( this.style );
			
			this.build( this.text );
		}
		
		private function build( text:String ): void {
			var title:TextField = new TextField();

			title.x = 0;
			title.y = 0;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = this.css.color;
			fmt.font = "Verdana";
			fmt.size = this.css.font_size;
			fmt.align = "center";
			
			title.htmlText = text;
			title.setTextFormat(fmt);
			title.autoSize = "left";
			//title.rotation = 15;
			title.height = title.textHeight;
			
			//title.border = true;
			//title.background = true;
			//title.backgroundColor = 0xe0e0e0;
			
			///myFormat.font = "Verdana";
			//title.embedFonts = true;

			//title.defaultTextFormat = new TextFormat("_Verdana", 16, 0);
			
			title.antiAliasType = AntiAliasType.ADVANCED;
			title.autoSize = TextFieldAutoSize.LEFT;
			//title.rotation = 15;


//			this.beginFill( this.style.get( 'background-color' ), 100);
//			this.mc.moveTo(0, 0);
//			this.mc.lineTo(width, 0);
//			this.mc.lineTo(width, height);
//			this.mc.lineTo(0, height);
//			this.mc.lineTo(0, 0);
//			this.mc.endFill();

			this.addChild(title);
			
	/*
			this.mc.text = text;
			// so we can rotate the text
			this.mc.embedFonts = true;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = colour;
			// our embedded font - so we can rotate it
			// library->new font, linkage
			fmt.font = "Verdana_embed";
			
			fmt.size = size;
			fmt.align = "center";
			
			this.mc.setTextFormat(fmt);
			this.mc.autoSize = "left";
			this.mc._rotation = 270;
			this.mc.autoSize = "left";
	*/
		}
/*
 *
 * dynamic loading of fonts at run time:
 *
		private function loadFont(url:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fontLoaded);
			loader.load(new URLRequest(url));
		}
		
		private function fontLoaded(event:Event):void {
			var FontLibrary:Class = event.target.applicationDomain.getDefinition("_Verdana") as Class;
			Font.registerFont(FontLibrary._Verdana);
			this.build( this.tag_wrapper( this.text ) );
		}
*/
		
		public function resize():void {
			if ( this.text == null )
				return;
		}
		
		public function get_width(): Number {
			if( this.numChildren == 0 )
				return 0;
			else
				return this.getChildAt(0).width;
		}
	}
}