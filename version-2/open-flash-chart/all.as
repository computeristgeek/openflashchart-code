/* AS3JS File */
package {
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.Stage;
    //removeMeIfWant flash.text.TextField;
    //removeMeIfWant flash.text.TextFieldType;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.text.TextFieldAutoSize;
	////removeMeIfWant string.Css;
	//removeMeIfWant flash.text.StyleSheet;
	//removeMeIfWant flash.events.TextEvent;

	
	
	public class ErrorMsg extends Sprite {
		
		public function ErrorMsg( msg:String ):void {
			
			var title:TextField = new TextField();
			title.text = msg;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = 0x000000;
			fmt.font = "Courier";
			fmt.size = 10;
			fmt.align = "left";
		
			title.setTextFormat(fmt);
			title.autoSize = "left";
			title.border = true;
			title.x = 5;
			title.y = 5;
			
			this.addChild(title);
		}
		
		public function add_html( html:String ): void {
			
			var txt:TextField = new TextField();
			
			var style:StyleSheet = new StyleSheet();

			var hover:Object = new Object();
			hover.fontWeight = "bold";
			hover.color = "#0000FF";
			
			var link:Object = new Object();
			link.fontWeight = "bold";
			link.textDecoration= "underline";
			link.color = "#0000A0";
			
			var active:Object = new Object();
			active.fontWeight = "bold";
			active.color = "#0000A0";

			var visited:Object = new Object();
			visited.fontWeight = "bold";
			visited.color = "#CC0099";
			visited.textDecoration= "underline";

			style.setStyle("a:link", link);
			style.setStyle("a:hover", hover);
			style.setStyle("a:active", active);
			style.setStyle(".visited", visited); //note Flash doesn't support a:visited
			
			txt.styleSheet = style;
			txt.htmlText = html;
			txt.autoSize = "left";
			txt.border = true;
			
			var t:TextField = this.getChildAt(0) as TextField;
			txt.y = t.y + t.height + 10;
			txt.x = 5;
			
			this.addChild( txt );
			
		}
	}
}

/* AS3JS File */
package{
	//removeMeIfWant flash.external.ExternalInterface;
	
	/**
	 * This manages all External calls, not all players have this ability (Flex does not,
	 * flash in a browser does, flash standalone does not)
	 * 
	 * We also have an optional chart_id that the user may set, this is passed out
	 * as parameter one if it is set.
	 */
	public class ExternalInterfaceManager
	{
		public var has_id:Boolean;
		public var chart_id:String;
		
		private static var _instance:ExternalInterfaceManager;
		
		public static function getInstance():ExternalInterfaceManager {
			
			if (_instance == null) {
				_instance = new ExternalInterfaceManager();
			}
			
			return _instance;
		}
		
		public function setUp(chart_id:String):void {
			this.has_id = true;
			this.chart_id = chart_id;
	tr.aces('this.chart_id',this.chart_id);
		}
		
		// THIS NEEDS FIXING. I can't figure out how to preprend the chart
		// id to the optional parameters.
		public function callJavascript(functionName:String, ... optionalArgs ): * {
			
			// the debug player does not have an external interface
			// because it is NOT embedded in a browser
			if (ExternalInterface.available) {
				if ( this.has_id ) {
					tr.aces(functionName, optionalArgs);
					optionalArgs.unshift(this.chart_id);
					tr.aces(functionName, optionalArgs);
				}
				
				return ExternalInterface.call(functionName, optionalArgs);
			}
			
		}
	}
}

/* AS3JS File */
package{
	
	public class JsonErrorMsg extends ErrorMsg {
		
		public function JsonErrorMsg( json:String, e:Error ):void {
			
			var tmp:String = "Open Flash Chart\n\n";
			tmp += "JSON Parse Error ["+ e.message +"]\n";
			
			// find the end of line after the error location:
			var pos:Number = json.indexOf( "\n", e.errorID );
			var s:String = json.substr(0, pos);
			var lines:Array = s.split("\n");
			
			tmp += "Error at character " + e.errorID + ", line " + lines.length +":\n\n";
			
			for ( var i:Number = 3; i > 0; i-- ) {
				if( lines.length-i > -1 )
					tmp += (lines.length - i).toString() +": " + lines[lines.length - i];
					
			}
			
			super( tmp );
		}
	}
}

/* AS3JS File */
package{
	//removeMeIfWant com.serialization.json.JSON;
	
	/**
	 * A simple function to inspect the JSON for items
	 * before we build the chart
	 */
	public class JsonInspector
	{
		
		public static function has_pie_chart( json:Object ): Boolean
		{
			
			var elements:Array = json['elements'] as Array;
			
			for( var i:Number = 0; i < elements.length; i++ )
			{
				// tr.ace( elements[i]['type'] );
				
				if ( elements[i]['type'] == 'pie' )
					return true;
			}
			
			return false;
		}
		
		public static function is_radar( json:Object ): Boolean
		{
			
			if ( json['radar_axis'] != null )
				return true;
			
			return false;
		}
	}
}/**
* ...
* @author Default
* @version 0.1
*/


/* AS3JS File */
package{
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.filters.DropShadowFilter;

	public class Loading extends Sprite {
		private var tf:TextField;
		
		public function Loading( text:String ) {
			
			this.tf = new TextField();
			this.tf.text = text;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = 0x000000;
			fmt.font = "Verdana";
			fmt.size = 12;
			fmt.align = "center";
			
			this.tf.setTextFormat(fmt);
			this.tf.autoSize = "left";
			this.tf.x = 5;
			this.tf.y = 5;
			
			//
			// HACK! For some reason the Stage.height is not
			// correct the very first time this object is created
			// so we wait untill the first frame before placing
			// the movie clip at the center of the Stage.
			//
			
			this.addEventListener( Event.ENTER_FRAME, this.onEnter );
				
			this.addChild( this.tf );
			
			this.graphics.lineStyle( 2, 0x808080, 1 );
			this.graphics.beginFill( 0xf0f0f0 );
			this.graphics.drawRoundRect(0, 0, this.tf.width + 10, this.tf.height + 10, 5, 5);
			
			var spin:Sprite = new Sprite();
			spin.x = this.tf.width + 40;
			spin.y = (this.tf.height + 10) / 2;
			
			var radius:Number = 15;
			var dots:Number = 6;
			var colours:Array = [0xF0F0F0,0xD0D0D0,0xB0B0B0,0x909090,0x707070,0x505050,0x303030];
			
			for( var i:Number=0; i<dots; i++ )
			{
				var deg:Number = (360/dots)*i;
				var radians:Number = deg * (Math.PI/180);
				var x:Number = radius * Math.cos(radians);
				var y:Number = radius * Math.sin(radians);
				
				spin.graphics.lineStyle(0, 0, 0);
				spin.graphics.beginFill( colours[i], 1 );
				spin.graphics.drawCircle( x, y, 4 );
			}
			
			this.addChild( spin );

			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.blurX = 4;
			dropShadow.blurY = 4;
			dropShadow.distance = 4;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.5;
			// apply shadow filter
			this.filters = [dropShadow];
		
		/*
		
			
			
			spin.onEnterFrame = function ()
			{
				this._rotation += 5;
			}
		
			*/
		}
		
		private function onEnter(event:Event):void {
			
			if( this.stage ) {
				this.x = (this.stage.stageWidth/2)-((this.tf.width+10)/2);
				this.y = (this.stage.stageHeight/2)-((this.tf.height+10)/2);
				// this.removeEventListener( Event.ENTER_FRAME, this.onEnter );
				// tr.ace('ppp');
			}
			this.getChildAt(1).rotation += 5;
		}
	
	}
	
}


/* AS3JS File */
package{
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.Factory;
	//removeMeIfWant charts.ObjectCollection;
	//removeMeIfWant elements.menu.Menu;
	//removeMeIfWant charts.series.has_tooltip;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	
	// for image upload:
	//removeMeIfWant flash.events.ProgressEvent;
	//removeMeIfWant flash.net.URLVariables;
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.net.URLLoader;
	//removeMeIfWant flash.net.URLRequest;
	//removeMeIfWant flash.display.StageAlign;
	//removeMeIfWant flash.display.StageScaleMode;
	//removeMeIfWant string.Utils;
	//removeMeIfWant global.Global;
	//removeMeIfWant com.serialization.json.JSON;
	//removeMeIfWant flash.external.ExternalInterface;
	//removeMeIfWant flash.ui.ContextMenu;
	//removeMeIfWant flash.ui.ContextMenuItem;
	//removeMeIfWant flash.events.IOErrorEvent;
	//removeMeIfWant flash.events.ContextMenuEvent;
	//removeMeIfWant flash.system.System;
	
	//removeMeIfWant flash.display.LoaderInfo;

	// export the chart as an image
	//removeMeIfWant com.adobe.images.PNGEncoder;
	//removeMeIfWant com.adobe.images.JPGEncoder;
	//removeMeIfWant mx.utils.Base64Encoder;
	// //removeMeIfWant com.dynamicflash.util.Base64;
	//removeMeIfWant flash.display.BitmapData;
	//removeMeIfWant flash.utils.ByteArray;
	//removeMeIfWant flash.net.URLRequestHeader;
	//removeMeIfWant flash.net.URLRequestMethod;
	//removeMeIfWant flash.net.URLLoaderDataFormat;
	//removeMeIfWant elements.axis.XAxis;
	//removeMeIfWant elements.axis.XAxisLabels;
	//removeMeIfWant elements.axis.YAxisBase;
	//removeMeIfWant elements.axis.YAxisLeft;
	//removeMeIfWant elements.axis.YAxisRight;
	//removeMeIfWant elements.axis.RadarAxis;
	//removeMeIfWant elements.Background;
	//removeMeIfWant elements.labels.XLegend;
	//removeMeIfWant elements.labels.Title;
	//removeMeIfWant elements.labels.Keys;
	//removeMeIfWant elements.labels.YLegendBase;
	//removeMeIfWant elements.labels.YLegendLeft;
	//removeMeIfWant elements.labels.YLegendRight;
	
	
	public class main extends Sprite {
		
		public  var VERSION:String = "2 Lug Wyrm Charmer";
		private var title:Title = null;
		//private var x_labels:XAxisLabels;
		private var x_axis:XAxis;
		private var radar_axis:RadarAxis;
		private var x_legend:XLegend;
		private var y_axis:YAxisBase;
		private var y_axis_right:YAxisBase;
		private var y_legend:YLegendBase;
		private var y_legend_2:YLegendBase;
		private var keys:Keys;
		private var obs:ObjectCollection;
		public var tool_tip_wrapper:String;
		private var sc:ScreenCoords;
		private var tooltip:Tooltip;
		private var background:Background;
		private var menu:Menu;
		private var ok:Boolean;
		private var URL:String;		// ugh, vile. The IOError doesn't report the URL
		private var id:String;		// chart id passed inf from user
		private var chart_parameters:Object;
		private var json:String;
	
		
		public function main() {
			
			// hook into all the events
			this.set_the_stage();

			this.chart_parameters = LoaderInfo(this.loaderInfo).parameters;
			this.build_right_click_menu();
			
			// inform javascript that it can call our reload method
			this.addCallback("reload", reload); // mf 18nov08, line 110 of original 'main.as'
		 
			// inform javascript that it can call our load method
			this.addCallback("load", load);
			
			// inform javascript that it can call our post_image method
			this.addCallback("post_image", post_image);
			
			// 
			this.addCallback("get_img_binary",  getImgBinary);

			// more interface
			this.addCallback("get_version",	getVersion);
			
			// TODO: change all external to use this:
			
			//
			// tell our external interface manager to pass out the chart ID
			// with every external call.
			//
			if ( this.chart_parameters['id'] )
			{
				var ex:ExternalInterfaceManager = ExternalInterfaceManager.getInstance();
				ex.setUp(this.chart_parameters['id']);
			}
			
			this.load_data();
		}
		
		private function set_the_stage():void {

			tr.aces('set_the_stage()');
			
			// tell flash to align top left, and not to scale
			// anything (we do that in the code)
			this.stage.align = StageAlign.TOP_LEFT;
			//
			// ----- RESIZE ----
			//
			// noScale: now we can pick up resize events
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.addEventListener(Event.ACTIVATE, this.activateHandler);
		}
		
		private function activateHandler(event:Event):void {
			
            tr.aces("activateHandler:", event);
			//tr.aces("stage", this.stage);
		}
		
		private function load_data():void {
			
			this.ok = false;
		
			if( this.chart_parameters['loading'] == null )
				this.chart_parameters['loading'] = 'Loading data...';
				
			var l:Loading = new Loading(this.chart_parameters['loading']);
			this.addChild( l );
			
			tr.aces('find_data()');
			if( !this.find_data() )
			{
				// no data found -- debug mode?
				try {
					var file:String = "../../data-files/y-axis-auto-range-lines.txt";
					this.load_external_file( file );

					/*
					// test AJAX calls like this:
					var file:String = "../data-files/bar-2.txt";
					this.load_external_file( file );
					file = "../data-files/radar-area.txt";
					this.load_external_file( file );
					*/
				}
				catch (e:Error) {
					this.show_error( 'Loading test data\n'+file+'\n'+e.message );
				}
			}
        }
		
		private function addCallback(functionName:String, closure:Function): void {

			// the debug player does not have an external interface
			// because it is NOT embedded in a browser
			if (ExternalInterface.available)
				ExternalInterface.addCallback(functionName, closure);
			
		}
		
		private function callExternalCallback(functionName:String, ... optionalArgs ): * {
			
			// the debug player does not have an external interface
			// because it is NOT embedded in a browser
			if (ExternalInterface.available)
				return ExternalInterface.call(functionName, optionalArgs);
			
		}
		
		public function getVersion():String {return VERSION;}
		
		// public function getImgBinary():String { return Base64.encodeByteArray(image_binary()); }
		public function getImgBinary():String {
			
			tr.ace('Saving image :: image_binary()');

			var bmp:BitmapData = new BitmapData(this.stage.stageWidth, this.stage.stageHeight);
			bmp.draw(this);
			
			var b64:Base64Encoder = new Base64Encoder();
			
			var b:ByteArray = PNGEncoder.encode(bmp);
			
			// var encoder:JPGEncoder = new JPGEncoder(80);
			// var q:ByteArray = encoder.encode(bmp);
			// b64.encodeBytes(q);
			
			//
			//
			//
			b64.encodeBytes(b);
			return b64.toString();
			//
			// commented out by J vander? why?
			// return b64.flush();
			//
			//
			
			
			/*
			var b64:Base64Encoder = new Base64Encoder();
			b64.encodeBytes(image_binary());
			tr.ace( b64 as String );
			return b64 as String;
			*/
		}
		
		
		/**
		 * Called from the context menu:
		 */
		public function saveImage(e:ContextMenuEvent):void {
			// ExternalInterface.call("save_image", this.chart_parameters['id']);// , getImgBinary());
			// ExternalInterface.call("save_image", getImgBinary());
			
			// this just calls the javascript function which will grab an image from use
			// an do something with it.
			this.callExternalCallback("save_image", this.chart_parameters['id']);
		}

		
	    private function image_binary() : ByteArray {
			tr.ace('Saving image :: image_binary()');

			var pngSource:BitmapData = new BitmapData(this.width, this.height);
			pngSource.draw(this);
			return PNGEncoder.encode(pngSource);
	    }
	
		//
		// External interface called by Javascript to
		// save the flash as an image, then POST it to a URL
		//
		//public function post_image(url:String, post_params:Object, callback:String, debug:Boolean):void {
		public function post_image(url:String, callback:String, debug:Boolean):void {
          
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");

			//Make sure to use the correct path to jpg_encoder_download.php
			var request:URLRequest = new URLRequest(url);
			
			request.requestHeaders.push(header);
			request.method = URLRequestMethod.POST;
			//
			request.data = image_binary();

			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            
			/*
			 * i can't figure out how to make these work
			 * 
			var urlVars:URLVariables = new URLVariables();
			for (var key:String in post_params) {
				urlVars[key] = post_params[key];
			}
			*/
			// base64:
			// urlVars.b64_image_data =  getImgBinary();
			// RAW:
			// urlVars.b64_image_data = image_binary();
			
			// request.data = urlVars;

			var id:String = '';
			if ( this.chart_parameters['id'] )
				id = this.chart_parameters['id'];
				
			if( debug )
			{
				// debug the PHP:
				flash.net.navigateToURL(request, "_blank");
			}
			else
			{
				//we have to use the PROGRESS event instead of the COMPLETE event due to a bug in flash
				loader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void {
					
						tr.ace("progress:" + e.bytesLoaded + ", total: " + e.bytesTotal);
						if ((e.bytesLoaded == e.bytesTotal) && (callback != null)) {
							tr.aces('Calling: ', callback + '(' + id + ')'); 
							this.call(callback, id);
						}
					});

				try {
					loader.load( request );
				} catch (error:Error) {
					tr.ace("unable to load:" + error);
				}
			 
				/*
				var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.COMPLETE, function(e:Event):void {
					tr.ace('Saved image to:');
					tr.ace( url );
					//
					// when the upload has finished call the user
					// defined javascript function/method
					//
					ExternalInterface.call(callback);
					});
					
				loader.load( jpgURLRequest );
				*/
			}
		}

		
		private function onContextMenuHandler(event:ContextMenuEvent):void
		{
		}
		
		//
		// try to find some data to load,
		// check the URL for a file name,
		//
		//
		public function find_data(): Boolean {
			
			// var all:String = ExternalInterface.call("window.location.href.toString");
			var vars:String = this.callExternalCallback("window.location.search.substring", 1);
			
			if( vars != null )
			{
				var p:Array = vars.split( '&' );
				for each ( var v:String in p )
				{
					if( v.indexOf( 'ofc=' ) > -1 )
					{
						var tmp:Array = v.split('=');
						tr.ace( 'Found external file:' + tmp[1] );
						this.load_external_file( tmp[1] );
						//
						// LOOK:
						//
						return true;
					}
				}
			}
			
			if( this.chart_parameters['data-file'] )
			{
				// tr.ace( 'Found parameter:' + parameters['data-file'] );
				this.load_external_file( this.chart_parameters['data-file'] );
				//
				// LOOK:
				//
				return true;
				
			}
			
			var get_data:String = 'open_flash_chart_data';
			if( this.chart_parameters['get-data'] )
				get_data = this.chart_parameters['get-data'];
			
			var json_string:*;
			
			if( this.chart_parameters['id'] )
				json_string = this.callExternalCallback( get_data , this.chart_parameters['id']);
			else
				json_string = this.callExternalCallback( get_data );
			
			
			if( json_string != null )
			{
				if( json_string is String )
				{
					this.parse_json( json_string );
					
					//
					// We have loaded the data, so this.ok = true
					//
					this.ok = true;
					//
					// LOOK:
					//
					return true;
				}
			}
			
			return false;
		}
		
		
		//
		// an external interface, used by javascript to
		// reload JSON from a URL :: mf 18nov08
		//
		public function reload( url:String ):void {

			var l:Loading = new Loading(this.chart_parameters['loading']);
			this.addChild( l );
			this.load_external_file( url );
		}


		private function load_external_file( file:String ):void {
			
			this.URL = file;
			//
			// LOAD THE DATA
			//
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( IOErrorEvent.IO_ERROR, this.ioError );
			loader.addEventListener( Event.COMPLETE, xmlLoaded );
			
			var request:URLRequest = new URLRequest(file);
			loader.load(request);
		}
		
		private function ioError( e:IOErrorEvent ):void {
			
			// remove the 'loading data...' msg:
			this.removeChildAt(0);
			var msg:ErrorMsg = new ErrorMsg( 'Open Flash Chart\nIO ERROR\nLoading test data\n' + e.text );
			msg.add_html( 'This is the URL that I tried to open:<br><a href="'+this.URL+'">'+this.URL+'</a>' );
			this.addChild( msg );
		}
		
		private function show_error( msg:String ):void {
			
			// remove the 'loading data...' msg:
			this.removeChildAt(0);

			var m:ErrorMsg = new ErrorMsg( msg );
			//m.add_html( 'Click here to open your JSON file: <a href="http://a.com">asd</a>' );
			this.addChild(m);
		}

		public function get_x_legend() : XLegend {
			return this.x_legend;
		}
		
		
		
		
		private function mouseMove( event:Event ):void {
			// tr.ace( 'over ' + event.target );
			// tr.ace('move ' + Math.random().toString());
			// tr.ace( this.tooltip.get_tip_style() );
			
			if ( !this.tooltip )
				return;		// <- an error and the JSON was not loaded
				
			switch( this.tooltip.get_tip_style() ) {
				case Tooltip.CLOSEST:
					this.mouse_move_closest( event );
					break;
					
				case Tooltip.PROXIMITY:
					this.mouse_move_proximity( event as MouseEvent );
					break;
					
				case Tooltip.NORMAL:
					this.mouse_move_follow( event as MouseEvent );
					break;
					
			}
		}
		
		private function mouse_move_follow( event:MouseEvent ):void {

			// tr.ace( event.currentTarget );
			// tr.ace( event.target );
			
			if ( event.target is has_tooltip )
				this.tooltip.draw( event.target as has_tooltip );
			else
				this.tooltip.hide();
		}
		
		private function mouse_move_proximity( event:MouseEvent ):void {

			//tr.ace( event.currentTarget );
			//tr.ace( event.target );
			
			var elements:Array = this.obs.mouse_move_proximity( this.mouseX, this.mouseY );
			this.tooltip.closest( elements );
		}
		
		private function mouse_move_closest( event:Event ):void {
			
			var elements:Array = this.obs.closest_2( this.mouseX, this.mouseY );
			this.tooltip.closest( elements );
		}
		
		

        private function resizeHandler(event:Event):void {
            tr.aces("resizeHandler: ", event);
            this.resize();
        }
		
		//
		// pie charts are simpler to resize, they don't
		// have all the extras (X,Y axis, legends etc..)
		//
		private function resize_pie(): ScreenCoordsBase {
			
			// should this be here?
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
			
			this.background.resize();
			this.title.resize();
			
			// this object is used in the mouseMove method
			this.sc = new ScreenCoords(
				this.title.get_height(), 0, this.stage.stageWidth, this.stage.stageHeight,
				null, null, null, 0, 0, false );
			this.obs.resize( sc );
			
			return sc;
		}
		
		//
		//
		private function resize_radar(): ScreenCoordsBase {
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
			
			this.background.resize();
			this.title.resize();
			this.keys.resize( 0, this.title.get_height() );
				
			var top:Number = this.title.get_height() + this.keys.get_height();
			
			// this object is used in the mouseMove method
			var sc:ScreenCoordsRadar = new ScreenCoordsRadar(top, 0, this.stage.stageWidth, this.stage.stageHeight);
			
			sc.set_range( this.radar_axis.get_range() );
			// 0-4 = 5 spokes
			sc.set_angles( this.obs.get_max_x()-this.obs.get_min_x()+1 );
			
			// resize the axis first because they may
			// change the radius (to fit the labels on screen)
			this.radar_axis.resize( sc );
			this.obs.resize( sc );
			
			return sc;
		}
		
		private function resize():void {
			//
			// the chart is async, so we may get this
			// event before the chart has loaded, or has
			// partly loaded
			//
			if ( !this.ok )
				return;			// <-- something is wrong
		
			var sc:ScreenCoordsBase;
			
			if ( this.radar_axis != null )
				sc = this.resize_radar();
			else if ( this.obs.has_pie() )
				sc = this.resize_pie();
			else
				sc = this.resize_chart();
			
			if( this.menu )
				this.menu.resize();
			
			// tell the web page that we have resized our content
			if( this.chart_parameters['id'] )
				this.callExternalCallback("ofc_resize", sc.left, sc.width, sc.top, sc.height, this.chart_parameters['id']);
			else
				this.callExternalCallback("ofc_resize", sc.left, sc.width, sc.top, sc.height);
				
			sc = null;
		}
			
		private function resize_chart(): ScreenCoordsBase {
			//
			// we want to show the tooltip closest to
			// items near the mouse, so hook into the
			// mouse move event:
			//
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
	
			// FlashConnect.trace("stageWidth: " + stage.stageWidth + " stageHeight: " + stage.stageHeight);
			this.background.resize();
			this.title.resize();
			
			var left:Number   = this.y_legend.get_width() /*+ this.y_labels.get_width()*/ + this.y_axis.get_width();
			
			this.keys.resize( left, this.title.get_height() );
				
			var top:Number = this.title.get_height() + this.keys.get_height();
			
			var bottom:Number = this.stage.stageHeight;
			bottom -= (this.x_legend.get_height() + this.x_axis.get_height());
			
			var right:Number = this.stage.stageWidth;
			right -= this.y_legend_2.get_width();
			//right -= this.y_labels_right.get_width();
			right -= this.y_axis_right.get_width();

			// this object is used in the mouseMove method
			this.sc = new ScreenCoords(
				top, left, right, bottom,
				this.y_axis.get_range(),
				this.y_axis_right.get_range(),
				this.x_axis.get_range(),
				this.x_axis.first_label_width(),
				this.x_axis.last_label_width(),
				false );

			this.sc.set_bar_groups(this.obs.groups);
				
			this.x_axis.resize( sc,
				// can we remove this:
				this.stage.stageHeight-(this.x_legend.get_height()+this.x_axis.labels.get_height())	// <-- up from the bottom
				);
			this.y_axis.resize( this.y_legend.get_width(), sc );
			this.y_axis_right.resize( 0, sc );
			this.x_legend.resize( sc );
			this.y_legend.resize();
			this.y_legend_2.resize();
			
			this.obs.resize( sc );
			
			
			// Test code:
			this.dispatchEvent(new Event("on-show"));
			
			
			return sc;
		}
		
		private function mouseOut(event:Event):void {
			
			if( this.tooltip != null )
				this.tooltip.hide();
			
			if( this.obs != null )
				this.obs.mouse_out();
        }
		
		//
		// an external interface, used by javascript to
		// pass in a JSON string
		//
		public function load( s:String ):void {
			this.parse_json( s );
		}

		//
		// JSON is loaded from an external URL
		//
		private function xmlLoaded(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			this.parse_json( loader.data );
		}
		
		//
		// This is called from load_external (async) or
		// load via external javascript function (sync)
		// we have data! parse it and make the chart
		//
		private function parse_json( json_string:String ):void {
			
			// tr.ace(json_string);
			
			var ok:Boolean = false;
			
			try {
				var json:Object = com.serialization.json.JSON.deserialize( json_string );
				ok = true;
			}
			catch (e:Error) {
				// remove the 'loading data...' msg:
				this.removeChildAt(0);
				this.addChild( new JsonErrorMsg( json_string as String, e ) );
			}
			
			//
			// don't catch these errors:
			//
			if( ok )
			{
				// remove 'loading data...' msg:
				this.removeChildAt(0);
				this.build_chart( json );
				
				// force this to be garbage collected
				json = null;
			}
			
			json_string = '';
			
			// we are displaying things, either a chart or an error message,
			// so now we want to watch for resizes
			this.stage.addEventListener(Event.RESIZE, this.resizeHandler);
			this.stage.addEventListener(Event.MOUSE_LEAVE, this.mouseOut);
			this.addEventListener( MouseEvent.MOUSE_OVER, this.mouseMove );
			
			//
			// tell the web page that we are ready
			//
			if( this.chart_parameters['id'] )
				this.callExternalCallback("ofc_ready", this.chart_parameters['id']);
			else
				this.callExternalCallback("ofc_ready");
		}
		
		private function build_chart( json:Object ):void {
			
			tr.ace('----');
			tr.ace(com.serialization.json.JSON.serialize(json));
			tr.ace('----');
			
			if ( this.obs != null )
				this.die();
			
			// init singletons:
			NumberFormat.getInstance( json );
			NumberFormat.getInstanceY2( json );

			this.tooltip	= new Tooltip( json.tooltip )

			var g:Global = Global.getInstance();
			g.set_tooltip_string( this.tooltip.tip_text );
		
			//
			// these are common to both X Y charts and PIE charts:
			this.background	= new Background( json );
			this.title		= new Title( json.title );
			//
			this.addChild( this.background );
			//
			
			if ( JsonInspector.is_radar( json ) ) {
				
				this.obs = Factory.MakeChart( json );
				this.radar_axis = new RadarAxis( json.radar_axis );
				this.keys = new Keys( this.obs );
				
				this.addChild( this.radar_axis );
				this.addChild( this.keys );
				
			}
			else if ( !JsonInspector.has_pie_chart( json ) )
			{
				this.build_chart_background( json );
			}
			else
			{
				// this is a PIE chart
				this.obs = Factory.MakeChart( json );
				// PIE charts default to FOLLOW tooltips
				this.tooltip.set_tip_style( Tooltip.NORMAL );
			}

			// these are added in the Flash Z Axis order
			this.addChild( this.title );
			for each( var set:Sprite in this.obs.sets )
				this.addChild( set );
			this.addChild( this.tooltip );

			if (json['menu'] != null) {
				this.menu = new Menu('99', json['menu']);
				this.addChild(this.menu);
			}
			
			this.ok = true;
			this.resize();
			
			
		}
		
		//
		// PIE charts don't have this.
		// build grid, axis, legends and key
		//
		private function build_chart_background( json:Object ):void {
			//
			// This reads all the 'elements' of the chart
			// e.g. bars and lines, then creates them as sprites
			//
			this.obs			= Factory.MakeChart( json );
			//
			this.x_legend		= new XLegend( json.x_legend );			
			this.y_legend		= new YLegendLeft( json );
			this.y_legend_2		= new YLegendRight( json );
			this.x_axis			= new XAxis( json, this.obs.get_min_x(), this.obs.get_max_x() );
			this.y_axis			= new YAxisLeft();
			this.y_axis_right	= new YAxisRight();
			
			// access all our globals through this:
			var g:Global = Global.getInstance();
			// this is needed by all the elements tooltip
			g.x_labels = this.x_axis.labels;
			g.x_legend = this.x_legend;

			//
			// pick up X Axis labels for the tooltips
			// 
			this.obs.tooltip_replace_labels( this.x_axis.labels );
			//
			//
			//
			
			this.keys = new Keys( this.obs );
			
			this.addChild( this.x_legend );
			this.addChild( this.y_legend );
			this.addChild( this.y_legend_2 );
			this.addChild( this.y_axis );
			this.addChild( this.y_axis_right );
			this.addChild( this.x_axis );
			this.addChild( this.keys );
			
			// now these children have access to the stage,
			// tell them to init
			tr.ace_json(this.obs.get_y_range());
			tr.ace_json(this.obs.get_y_range(false));
			
			this.y_axis.init(this.obs.get_y_range(), json);
			this.y_axis_right.init(this.obs.get_y_range(false), json);
		}
		
		/**
		 * Remove all our referenced objects
		 */
		private function die():void {
			this.obs.die();
			this.obs = null;
			
			if ( this.tooltip != null ) this.tooltip.die();
			
			if ( this.x_legend != null )	this.x_legend.die();
			if ( this.y_legend != null )	this.y_legend.die();
			if ( this.y_legend_2 != null )	this.y_legend_2.die();
			if ( this.y_axis != null )		this.y_axis.die();
			if ( this.y_axis_right != null ) this.y_axis_right.die();
			if ( this.x_axis != null )		this.x_axis.die();
			if ( this.keys != null )		this.keys.die();
			if ( this.title != null )		this.title.die();
			if ( this.radar_axis != null )	this.radar_axis.die();
			if ( this.background != null )	this.background.die();
			
			this.tooltip = null;
			this.x_legend = null;
			this.y_legend = null;
			this.y_legend_2 = null;
			this.y_axis = null;
			this.y_axis_right = null;
			this.x_axis = null;
			this.keys = null;
			this.title = null;
			this.radar_axis = null;
			this.background = null;
			
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		
			if ( this.hasEventListener(MouseEvent.MOUSE_MOVE))
				this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
			
			// do not force a garbage collection, it is not supported:
			// http://stackoverflow.com/questions/192373/force-garbage-collection-in-as3
		
		}
		
		private function build_right_click_menu(): void {
		
			var cm:ContextMenu = new ContextMenu();
			cm.addEventListener(ContextMenuEvent.MENU_SELECT, onContextMenuHandler);
			cm.hideBuiltInItems();

			// OFC CREDITS
			var fs:ContextMenuItem = new ContextMenuItem("Charts by Open Flash Chart [Version "+VERSION+"]" );
			fs.addEventListener(
				ContextMenuEvent.MENU_ITEM_SELECT,
				function doSomething(e:ContextMenuEvent):void {
					var url:String = "http://teethgrinder.co.uk/open-flash-chart-2/";
					var request:URLRequest = new URLRequest(url);
					flash.net.navigateToURL(request, '_blank');
				});
			cm.customItems.push( fs );
			
			var save_image_message:String = ( this.chart_parameters['save_image_message'] ) ? this.chart_parameters['save_image_message'] : 'Save Image Locally';
			
			var dl:ContextMenuItem = new ContextMenuItem(save_image_message);
			dl.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.saveImage);
			cm.customItems.push( dl );
			
			this.contextMenu = cm;
		}
		/*
		public function format_y_axis_label( val:Number ): String {
//			if( this._y_format != undefined )
//			{
//				var tmp:String = _root._y_format.replace('#val#',_root.format(val));
//				tmp = tmp.replace('#val:time#',_root.formatTime(val));
//				tmp = tmp.replace('#val:none#',String(val));
//				tmp = tmp.replace('#val:number#', NumberUtils.formatNumber (Number(val)));
//				return tmp;
//			}
//			else
				return NumberUtils.format(val,2,true,true,false);
		}
*/

	}
	
}

/* AS3JS File */
package{
	//removeMeIfWant object_helper;
	
	public class NumberFormat
	{
		public static var DEFAULT_NUM_DECIMALS:Number = 2;
		
		public var numDecimals:Number = DEFAULT_NUM_DECIMALS;
		public var isFixedNumDecimalsForced:Boolean = false;
		public var isDecimalSeparatorComma:Boolean = false;
		public var isThousandSeparatorDisabled:Boolean = false;
		
		public function NumberFormat( numDecimals:Number, isFixedNumDecimalsForced:Boolean, isDecimalSeparatorComma:Boolean, isThousandSeparatorDisabled:Boolean )
		{
			this.numDecimals = Parser.getNumberValue (numDecimals, DEFAULT_NUM_DECIMALS, true, false);
			this.isFixedNumDecimalsForced = Parser.getBooleanValue(isFixedNumDecimalsForced,false);
			this.isDecimalSeparatorComma = Parser.getBooleanValue(isDecimalSeparatorComma,false);
			this.isThousandSeparatorDisabled = Parser.getBooleanValue(isThousandSeparatorDisabled,false);
		}
		
		
		//singleton
	//	public static function getInstance (lv,c:Number):NumberFormat{
	//		if (c==2){
	//			return NumberFormat.getInstanceY2(lv);
	//		} else {
	//			return NumberFormat.getInstance(lv);
	//		}
	//	}

		private static var _instance:NumberFormat = null;
		
		public static function getInstance( json:Object ):NumberFormat {
			if (_instance == null) {
//				if (lv==undefined ||  lv == null){
//					lv=_root.lv;
//				}

				var o:Object = {
					num_decimals: 2,
					is_fixed_num_decimals_forced: 0,
					is_decimal_separator_comma: 0,
					is_thousand_separator_disabled: 0
				};
				
				object_helper.merge_2( json, o );
				
				_instance = new NumberFormat (
					o.num_decimals,
					o.is_fixed_num_decimals_forced==1,
					o.is_decimal_separator_comma==1,
					o.is_thousand_separator_disabled==1
				 );
	//			 trace ("getInstance NEW!!!!");
	//			 trace (_instance.numDecimals);
	//			 trace (_instance.isFixedNumDecimalsForced);
	//			 trace (_instance.isDecimalSeparatorComma);
	//			 trace (_instance.isThousandSeparatorDisabled);
			} else {
				 //trace ("getInstance found");
			}
			return _instance;
		}

		private static var _instanceY2:NumberFormat = null;
		
		public static function getInstanceY2( json:Object ):NumberFormat{
			if (_instanceY2 == null) {
//				if (lv==undefined ||  lv == null){
//					lv=_root.lv;
//				}
				
				var o:Object = {
					num_decimals: 2,
					is_fixed_num_decimals_forced: 0,
					is_decimal_separator_comma: 0,
					is_thousand_separator_disabled: 0
				};
				
				object_helper.merge_2( json, o );
				
				_instanceY2 = new NumberFormat (
					o.num_decimals,
					o.is_fixed_num_decimals_forced==1,
					o.is_decimal_separator_comma==1,
					o.is_thousand_separator_disabled==1
				 );
				
				 //trace ("getInstanceY2 NEW!!!!");
			} else {
				 //trace ("getInstanceY2 found");
			}
			return _instanceY2;
		}
	}
}

/* AS3JS File */
package{
	public class NumberUtils {


		public static function formatNumber (i:Number) : String{
			var format:NumberFormat = NumberFormat.getInstance(null);
			return NumberUtils.format (i, 
				format.numDecimals, 
				format.isFixedNumDecimalsForced, 
				format.isDecimalSeparatorComma,
				format.isThousandSeparatorDisabled 
			);
		} 
		
		public static function formatNumberY2 (i:Number) : String{
			var format:NumberFormat = NumberFormat.getInstanceY2(null);
			return NumberUtils.format (i, 
				format.numDecimals, 
				format.isFixedNumDecimalsForced, 
				format.isDecimalSeparatorComma,
				format.isThousandSeparatorDisabled 
			);
		}	

		public static function format( 
			i:Number, 
			numDecimals:Number,
			isFixedNumDecimalsForced:Boolean, 
			isDecimalSeparatorComma:Boolean,
			isThousandSeparatorDisabled:Boolean 
		) : String {
			if ( isNaN (numDecimals )) {
				numDecimals = 4;
			}
			
			// round the number down to the number of
			// decimals we want ( fixes the -1.11022302462516e-16 bug)
			i = Math.round(i*Math.pow(10,numDecimals))/Math.pow(10,numDecimals);
			
			var s:String = '';
			var num:Array;
			if( i<0 )
				num = String(-i).split('.');
			else
				num = String(i).split('.');
			
			//trace ("a: " + num[0] + ":" + num[1]);
			var x:String = num[0];
			var pos:Number=0;
			var c:Number=0;
			for(c=x.length-1;c>-1;c--)
			{
				if( pos%3==0 && s.length>0 )
				{
					s=','+s;
					pos=0;
				}
				pos++;
					
				s=x.substr(c,1)+s;
			}
			if( num[1] != undefined ) {
				if (isFixedNumDecimalsForced){
					num[1] += "0000000000000000";
				}
				s += '.'+ num[1].substr(0,numDecimals);
			} else {
				if (isFixedNumDecimalsForced && numDecimals>0){
					num[1] = "0000000000000000";
					s += '.'+ num[1].substr(0,numDecimals);			
				}
				
			}
				
			if( i<0 )
				s = '-'+s;
			
			if (isThousandSeparatorDisabled){
				s=s.replace (",","");
			}
			
			if (isDecimalSeparatorComma) {
				s = toDecimalSeperatorComma(s);
			}			
			return s;
		}
		
		public static function toDecimalSeperatorComma (value:String) : String{
			return value
				.replace(".","|")
				.replace(",",".")
				.replace("|",",")
		}

	}
}

/* AS3JS File */
package{
	
	public class object_helper {
		
		//
		// merge two objects, one from the user
		// and is JSON, the other is the default
		// values this object should have
		//
		public static function merge( o:Object, defaults:Object ):Object {
			
			for (var prop:String in defaults ) {
				if( o[prop] == undefined )
					o[prop] = defaults[prop];
			}
			return o;
		}
		
		public static function merge_2( json:Object, defaults:Object ):void {
			
			for (var prop:String in json ) {
				
				// tr.ace( prop +' = ' + json[prop]);
				defaults[prop] = json[prop];
			}
		}
	}
}

/* AS3JS File */
package{
	public class Parser {

		//test if undefined or null
		public static function isEmptyValue ( value:Object ):Boolean {
//			if( value == undefined || value == null ) {
//				return true;
//			}	else {
				return false;
//			}
		} 
		
		
		
		
		// get valid String value from input value
		// if value is not defined, return default value
		// default value is valid String (cannot be undefined or null)
		// in case that isEmptyStringValid is false - take defaultvalue instead of value
		public static function getStringValue ( 
			value:Object, 
			defaultValue:String , 
			isEmptyStringValid:Boolean ):String{

			//defaultValue if not defined - set to empty String
			if( Parser.isEmptyValue (defaultValue)) {
				defaultValue = "";
			}
			
			//for undefined / null - return defaultValue
			if( Parser.isEmptyValue (value)) {
				return defaultValue;
			}
			
			if (!isEmptyStringValid && value.length == 0) {
				return defaultValue;
			}
			
			return String(value);
		}
		
		
		
		
		
		// get valid Number value from input value
		// if value is not defined, return default value
		// default value is valid String (cannot be undefined or null)
		// in case that isEmptyStringValid is false - take defaultvalue instead of value
		public static function getNumberValue ( 
			value:Object, 
			defaultValue:Number , 
			isZeroValueValid:Boolean ,
			isNegativeValueValid:Boolean 
			):Number{

			//defaultValue if not defined - set to zero
			if( Parser.isEmptyValue (defaultValue)
				|| isNaN(defaultValue)
				) {
				defaultValue = 0;
			}
			
			//for undefined / null - return defaultValue
			if( Parser.isEmptyValue (value) ) {
				return defaultValue;
			}
			
			var numValue:Number =  Number(value);
			if ( isNaN (numValue) ){
				return defaultValue;
			}
			
			if (!isZeroValueValid && numValue==0) {
				return defaultValue;
			}

			if (!isNegativeValueValid && numValue<0) {
				return defaultValue;
			}		
			
			return numValue;

		}
		
		
		
		public static function getBooleanValue ( 
			value:Object, 
			defaultValue:Boolean 
			):Boolean{
		
			if( Parser.isEmptyValue (value) ) {
				return defaultValue;
			}		
			
			var numValue:Number =  Number(value);
			if ( !isNaN (numValue) ){
				//for numeric value then 0 is false, everything else is true
				if (numValue==0)	{
					return false;
				} else {
					return true;
				}
			} 		

			//parse string falue 'true' -> true; else false
			var strValue:String = Parser.getStringValue (value,"false", false);
	//trace ("0------------------" + strValue);
			strValue = strValue.toLowerCase();
	//trace ("1------------------" + strValue);		
			if (strValue.indexOf('true') !=-1){
				return true;
			} else {
				return false;
			}
			
		}
		
		

		public static function runTests():void{
			var notDefinedNum:Number;
			trace ("testing Parser.getStringValue...");
			trace("1) stringOK  '" + Parser.getStringValue("stringOK","myDefault",true) + "'");
			trace("2) ''        '" + Parser.getStringValue("","myDefault",true) + "'");
			trace("3) myDefault '" + Parser.getStringValue("","myDefault",false) + "'");
//			trace("4) ''        '" + Parser.getStringValue(notDefinedNum) + "'");
//			trace("5) 999       '" + Parser.getStringValue(999) + "'");


			trace ("testing Parser.getNumberValue...");
			trace("01) 999       '" + Parser.getNumberValue(999,22222222,true,true) + "'");
			trace("02) 999       '" + Parser.getNumberValue("999",22222222,true,true) + "'");
//			trace("03) 999       '" + Parser.getNumberValue("999") + "'");
//			trace("04) 0         '" + Parser.getNumberValue("abc") + "'");
//			trace("05) -1        '" + Parser.getNumberValue("abc",-1) + "'");
			trace("06) -1        '" + Parser.getNumberValue("abc",-1, false, false) + "'");
			trace("07) -1        '" + Parser.getNumberValue(null,-1, false, false) + "'");
//			trace("08) 22222222  '" + Parser.getNumberValue(0,22222222) + "'");
//			trace("09) 0         '" + Parser.getNumberValue(0,22222222,true) + "'");
//			trace("10) 22222222  '" + Parser.getNumberValue(0,22222222,false) + "'");
			trace("11) 22222222  '" + Parser.getNumberValue(0,22222222,false,false) + "'");
			trace("12) 22222222  '" + Parser.getNumberValue(-0.1,22222222,false,false) + "'");
			trace("13) -0.1      '" + Parser.getNumberValue(-0.1,22222222,false,true) + "'");
			trace("13) 22222222  '" + Parser.getNumberValue("-0.1x",22222222,false,true) + "'");
			
			trace ("testing Parser.getBooleanValue...");
			trace("true       '" + Parser.getBooleanValue("1",false) + "'");
			trace("true       '" + Parser.getBooleanValue("-1",false) + "'");
			trace("false      '" + Parser.getBooleanValue("0.000",false) + "'");
			trace("false      '" + Parser.getBooleanValue("",false) + "'");
			trace("true       '" + Parser.getBooleanValue("",true) + "'");
			trace("false      '" + Parser.getBooleanValue("false",false) + "'");
			trace("false      '" + Parser.getBooleanValue("xxx",false) + "'");
			trace("true      '" + Parser.getBooleanValue("true",true) + "'");
			trace("true      '" + Parser.getBooleanValue("TRUE",true) + "'");
			trace("true      '" + Parser.getBooleanValue(" TRUE ",true) + "'");
		}
		
	}
}

/* AS3JS File */
package{
	public class PointCandle extends Point
	{
		public var width:Number;
		public var bar_bottom:Number;
		public var high:Number;
		public var open:Number;
		public var close:Number;
		public var low:Number;
		
		public function PointCandle( x:Number, high:Number, open:Number, close:Number, low:Number, tooltip:Number, width:Number ):void {
			super( x, high );
			
			this.width = width;
			this.high = high;
			this.open = open;
			this.close = close;
			this.low = low;
		}
		
		public override function make_tooltip(
			tip:String, key:String, val:Number, x_legend:String,
			x_axis_label:String, tip_set:String ):void {
				
		
			super.make_tooltip( tip, key, val, x_legend, x_axis_label, tip_set );
//			super.make_tooltip( tip, key, val.open, x_legend, x_axis_label, tip_set );
//			
//			var tmp:String = this.tooltip;
//			tmp = tmp.replace('#high#',NumberUtils.formatNumber(val.high));
//			tmp = tmp.replace('#open#',NumberUtils.formatNumber(val.open));
//			tmp = tmp.replace('#close#',NumberUtils.formatNumber(val.close));
//			tmp = tmp.replace('#low#',NumberUtils.formatNumber(val.low));
			
//			this.tooltip = tmp;
		}
		
		public override function get_tip_pos():Object {
			return {x:this.x+(this.width/2), y:this.y};
		}
	}
}

/* AS3JS File */
package{
	public class PointHLC// extends Point
	{
	//	private var numDecimals:Number =5;
	//	private var isFixedNumDecimalsForced:Boolean =true;
	//	private var isDecimalSeparatorComma:Boolean =true;
		
		public var width:Number;
		public var bar_bottom:Number;
		public var high:Number;
		public var close:Number;
		public var low:Number;
		
		public function PointHLC( x:Number, high:Number, close:Number, low:Number, tooltip:Number, width:Number ):void{
			//super( x, high );
			
			this.width = width;
			this.high = high;
			this.close = close;
			this.low = low;
		}
		
		public  function make_tooltip(
			tip:String, key:String, val:Number, x_legend:String,
			x_axis_label:String, tip_set:String ):void {
			
			super.make_tooltip( tip, key, val, x_legend, x_axis_label, tip_set );
//			super.make_tooltip( tip, key, val.close, x_legend, x_axis_label, tip_set );
//			
//			var tmp:String = this.tooltip;
//			tmp = tmp.replace('#high#',NumberUtils.formatNumber(val.high));
//			tmp = tmp.replace('#close#',NumberUtils.formatNumber(val.close));
//			tmp = tmp.replace('#low#',NumberUtils.formatNumber(val.low));
			
//			this.tooltip = tmp;
		}
		
		public  function get_tip_pos():Object {
			//return {x:this.x+(this.width/2), y:this.y};
			return null;
		}
	}
}

/* AS3JS File */
package{

	//removeMeIfWant flash.utils.Dictionary;
	//removeMeIfWant string.Utils;
	
	public class Properties extends Object
	{
		private var _props:Dictionary;
		private var _parent:Properties;
		
		public function Properties( json:Object, parent:Properties=null ) {
		
			// Dictionary can use an object as a key
			this._props = new Dictionary();
			this._parent = parent;
			
			// tr.ace(json);
			
			for (var prop:String in json ) {
				
				// tr.ace( prop +' = ' + json[prop]);
				this._props[prop] = json[prop];
			}
		}
		
		public function get(name:String):* {
			
			// is this key in the dictionary?
			if ( name in this._props )
				return this._props[name];
			
			// test the parent
			if ( this._parent != null )
				return this._parent.get( name );
				
			//
			// key/property not found, report and dump the stack trace
			//
			var e:Error = new Error();
			var str:String = e.getStackTrace();
			
			tr.aces( 'ERROR: property not found', name, str);
			return Number.NEGATIVE_INFINITY;
		}
		
		//
		// this is a bit dirty, I wish I could do something like:
		//   props.get('colour').as_colour()
		//
		public function get_colour(name:String):Number {
			return Utils.get_colour(this.get(name));
		}
			
		// set does not recurse down, we don't want to set
		// our parents property
		public function set(name:String, value:Object):void {
			this._props[name] = value;
		}
		
		public function has(name:String):Boolean {
			if ( this._props[name] == null ) {
				if ( this._parent != null )
					return this._parent.has(name);
				else
					return false;
			}
			else
				return true;
		}
		
		public function set_parent(p:Properties):void {
			if ( this._parent != null )
				p.set_parent( this._parent );
		
			this._parent = p;
		}
		
		//
		// recurse and kill everything
		//
		public function die(): void {
			if ( this._parent )
				this._parent.die();
			
			for (var key:Object in this._props) {
				// iterates through each object key
				this._props[key] = null;
			}
			this._parent = null;
		}
	}
}

/* AS3JS File */
package{
	
	public class Range
	{
		public var min:Number;
		public var max:Number;
		public var step:Number;
		public var offset:Boolean;
		
		public function Range( min:Number, max:Number, step:Number, offset:Boolean )
		{
			this.min = min;
			this.max = max;
			this.step = step;
			this.offset = offset;
		}
		
		public function count():Number {
			//
			// range, 5 - 10 = 10 - 5 = 5
			// range -5 - 5 = 5 - -5 = 10
			//
			//
			//  x_offset:
			//
			//   False            True
			//
			//  |               |
			//  |               |
			//  |               |
			//  +--+--+--+      |-+--+--+--+-+
			//  0  1  2  3        0  1  2  3
			//
			// Don't forget this is also used in radar axis
			//
			if( this.offset )
				return (this.max - this.min) + 1;
			else
				return this.max - this.min;			
		}
		
		public function toString():String {
			return 'Range : ' + this.min +', ' + this.max;
		}
	}
}

/* AS3JS File */
package{
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant charts.series.dots.Point;
	
	public class ScreenCoords extends ScreenCoordsBase
	{
		private var x_range:Range;
		private var y_range:Range;
		private var y_right_range:Range;
		
		// position of the zero line
		//public var zero:Number=0;
		//public var steps:Number=0;
		
		// tick_offset is set by 3D axis
		public var tick_offset:Number;
		private var x_offset:Boolean;
		private var y_offset:Boolean;
		private var bar_groups:Number;
	
		
		public function ScreenCoords( top:Number, left:Number, right:Number, bottom:Number,
							y_axis_range:Range,
							y_axis_right_range:Range,
							x_axis_range:Range,
							x_left_label_width:Number, x_right_label_width:Number,
							three_d:Boolean )
		{
			super( top, left, right, bottom );
			
			var tmp_left:Number = left;
			
			this.x_range = x_axis_range;
			this.y_range = y_axis_range;
			this.y_right_range = y_axis_right_range;
			
			// tr.ace( '-----' );
			// tr.ace( this.x_range.count() );
			// tr.ace( this.y_range.count() );
			
			
			if( x_range ) {
				right = this.jiggle( left, right, x_right_label_width, x_axis_range.count() );
				tmp_left = this.shrink_left( left, right, x_left_label_width, x_axis_range.count() );
			}
			
			this.top = top;
			this.left = Math.max(left, tmp_left);
			
			// round this down to the nearest int:
			this.right = Math.floor( right );
			this.bottom = bottom;
			this.width = this.right-this.left;
			this.height = bottom-top;
			
			if( three_d )
			{
				// tell the box object that the
				// X axis labels need to be offset
				this.tick_offset = 12;
			}
			else
				this.tick_offset = 0;
			
			//
			//  x_offset:
			//
			//   False            True
			//
			//  |               |
			//  |               |
			//  |               |
			//  +--+--+--+      |-+--+--+--+-+
			//  0  1  2  3        0  1  2  3
			//
	
			// PIE charts don't have these:
			if( x_axis_range ) {
				this.x_offset = x_axis_range.offset;
			}
			if( y_axis_range ) {
				// tr.aces( 'YYYY', y_axis_range.offset );
				this.y_offset = y_axis_range.offset;
			}
   				
			this.bar_groups = 1;
		}
		
		//
		// if the last X label is wider than the chart area, the last few letters will
		// be outside the drawing area. So we make the chart width smaller so the label
		// will fit into the screen.
		//
		//DZ: this implementation chops off the last label on scatter charts because it
		//    assumes the label is centered on the last "item" (like a bar) instead of 
		//    at the max edge of the plot.
		public function jiggle_original( left:Number, right:Number, x_label_width:Number, count:Number ): Number {
			var r:Number = 0;

			if( x_label_width != 0 )
			{
				var item_width:Number = (right-left) / count;
				r = right - (item_width / 2);
				var new_right:Number = right;
				
				// while the right most X label is off the edge of the
				// Stage, move the box.right - 1
				while( r+(x_label_width/2) > right )
				{
					new_right -= 1;
					// changing the right also changes the item_width:
					item_width = (new_right-left) / count;
					r = new_right-(item_width/2);
				}
				right = new_right;
			}
			return right;
		}
		
		//DZ: this implementation probably add white space on the right side of a
		//    non-scatter type plot because it assumes that the label is centered at
		//    the max edge of the plot instead of centered on the last "item" 
		//    (like a bar)
		public function jiggle( left:Number, right:Number, x_label_width:Number, count:Number ): Number {
			return right - (x_label_width / 2);
		}
		
		//
		// if the left label is truncated, shrink the box until
		// it fits onto the screen
		//
		public function shrink_left( left:Number, right:Number, x_label_width:Number, count:Number ): Number {
			var pos:Number = 0;

			if( x_label_width != 0 )
			{
				var item_width:Number = (right-left) / count;
				pos = left+(item_width/2);
				var new_left:Number = left;
				
				// while the left most label is hanging off the Stage
				// move the box.left in one pixel:
				while( pos-(x_label_width/2) < 0 )
				{
					new_left += 1;
					// changing the left also changes the item_width:
					item_width = (right-new_left) / count;
					pos = new_left+(item_width/2);
				}
				left = new_left;
			}
			
			return left;
			
		}
		
		//
		// the bottom point of a bar:
		//   min=-100 and max=100, use b.zero
		//   min = 10 and max = 20, use b.bottom
		//
		public override function get_y_bottom( right_axis:Boolean = false ):Number
		{
			//
			// may have min=10, max=20, or
			// min = 20, max = -20 (upside down chart)
			//
			var r:Range = right_axis ? this.y_right_range : this.y_range;
			
			var min:Number = r.min;
			var max:Number = r.max;
			min = Math.min( min, max );
			
			return this.get_y_from_val( Math.max(0,min), right_axis );
		}
		
		// takes a value and returns the screen Y location
		public function getY_old( i:Number, right_axis:Boolean ):Number
		{
			var r:Range = right_axis ? this.y_right_range : this.y_range;
			
			var steps:Number = this.height / (r.count());// ( right_axis ));
			
			// find Y pos for value=zero
			var y:Number = this.bottom-(steps*(r.min*-1));
			
			// move up (-Y) to our point (don't forget that y_min will shift it down)
			y -= i*steps;
			return y;
		}
		
		//
		// takes a value and returns the screen Y location
		// what is the Y range?
		//
		// Horizontal bar charts are offset. Note:
		//   step = 1
		//   and step/2 is offset at the bottom and top
		// so we add 1*step so we can calculate:
		//
		//   offset = true 
		//
		//     |
		//  X -|==========
		//     |
		//  Y -|===
		//     |
		//  Z -|========
		//     +--+--+--+--+--+--
		//
		// offset = false
		//
		//  2 -|
		//     |
		//  1 -|  0--0--0--0--0
		//     |
		//  0 -+--+--+--+--+--+--
		//
		public override function get_y_from_val( i:Number, right_axis:Boolean = false ):Number {
			
			var r:Range = right_axis ? this.y_right_range : this.y_range;
			
			var steps:Number = this.height / r.count();
			
			// tr.ace( 'off' );
			// tr.ace( this.y_offset.offset );
			// tr.ace( count );
			
			var tmp:Number = 0;
			if( this.y_offset )
				tmp = (steps / 2);
				
			// move up (-Y) to our point (don't forget that y_min will shift it down)
			return this.bottom-tmp-(r.min-i)*steps*-1;
		}
		
		public override function get_get_x_from_pos_and_y_from_val( index:Number, y:Number, right_axis:Boolean = false ):flash.geom.Point {
			
			return new flash.geom.Point(
				this.get_x_from_pos( index ),
				this.get_y_from_val( y, right_axis ) );
		}
		
		public function width_():Number
		{
			return this.right-this.left_();
		}
		
		private function left_():Number
		{
			var padding_left:Number = this.tick_offset;
			return this.left+padding_left;
		}
		
		//
		// Scatter and Horizontal Bar charts use this:
		//
		//   get the x position by value
		//  (e.g. what is the x position for -5 ?)
		//
		public override function get_x_from_val( i:Number ):Number {
			// Patch from DZ:
			var rev:Boolean = this.x_range.min > this.x_range.max;
			var count:Number = this.x_range.count();
			count += (rev && this.x_range.offset) ? -2 : 0;
			var item_width:Number = this.width_() / count;
			// end DZ
			
			
			var pos:Number = i-this.x_range.min;
			
			var tmp:Number = 0;
			if( this.x_offset )
				tmp = Math.abs(item_width/2);
				
			return this.left_()+tmp+(pos*item_width);
		}
		
		//
		// get the x location of the n'th item
		//
		public override function get_x_from_pos( i:Number ):Number {
			// DZ:
//			var item_width:Number = Math.abs(this.width_() / this.x_range.count());
			var rev:Boolean = this.x_range.min > this.x_range.max;
			var count:Number = this.x_range.count();
			count += (rev && this.x_range.offset) ? -2 : 0;
			var item_width:Number = Math.abs(this.width_() / count);
				
			var tmp:Number = 0;
			if( this.x_offset )
				tmp = (item_width/2);

			return this.left_()+tmp+(i*item_width);
		}
		
		//
		// get the position of the n'th X axis tick
		//
		public function get_x_tick_pos( i:Number ):Number
		{
			return this.get_x_from_pos(i) - this.tick_offset;
		}
	
		
		//
		// make a point object, using the absolute values (e.g. -5,-5 )
		/*
		public function make_point_2( x:Number, y:Number, right_axis:Boolean ):charts.Elements.Point
		{
			return new charts.Elements.Point(
				this.get_x_from_val( x ),
				this.get_y_from_val( y, right_axis )
				
				// whats this for?
				//,y
				);
		}*/
		
		public function set_bar_groups( n:Number ): void {
			this.bar_groups = n;
		}
		
		//
		// index: the n'th bar from the left
		//
		public function get_bar_coords( index:Number, group:Number ):Object {
			var item_width:Number = this.width_() / this.x_range.count();
			
			// the bar(s) have gaps between them:
			var bar_set_width:Number = item_width*0.8;
			
			// get the margin between sets of bars:
			var tmp:Number = 0;
			if( this.x_offset )
				tmp = item_width;
			
			// 1 bar == 100% wide, 2 bars = 50% wide each
			var bar_width:Number = bar_set_width / this.bar_groups;
			//bar_width -= 0.001;		// <-- hack so bars don't quite touch
			
			var bar_left:Number = this.left_()+((tmp-bar_set_width)/2);
			var left:Number = bar_left+(index*item_width);
			left += bar_width * group;
			
			return { x:left, width:bar_width };
		}
		
		public function get_horiz_bar_coords( index:Number, group:Number ):Object {
			
			// split the height into equal heights for each bar
			var bar_width:Number = this.height / this.y_range.count();
			
			// the bar(s) have gaps between them:
			var bar_set_width:Number = bar_width*0.8;
			
			// 1 bar == 100% wide, 2 bars = 50% wide each
			var group_width:Number = bar_set_width / this.bar_groups;
			
			var bar_top:Number = this.top+((bar_width-bar_set_width)/2);
			var top:Number = bar_top+(index*bar_width);
			top += group_width * group;
			
			return { y:top, width:group_width };
		}
		
		
		public function makePointHLC( x:Number, high:Number, close:Number, low:Number, right_axis:Boolean, group:Number, group_count:Number )
		:PointHLC {
	
			var item_width:Number = this.width_() / this.x_range.count();
			// the bar(s) have gaps between them:
			var bar_set_width:Number = item_width*1;

			// get the margin between sets of bars:
			var bar_left:Number = this.left_()+((item_width-bar_set_width)/2);
			// 1 bar == 100% wide, 2 bars = 50% wide each
			var bar_width:Number = bar_set_width/group_count;

			var left:Number = bar_left+(x*item_width);
			left += bar_width*group;

			return new PointHLC(
				left,
				this.get_y_from_val( high, right_axis ),
				this.get_y_from_val( close, right_axis ),
				this.get_y_from_val( low, right_axis ),
				high,
				bar_width
//				,close
				);
	
		}
	}
}

/* AS3JS File */
package{
	//removeMeIfWant flash.geom.Point;
	
	public class ScreenCoordsBase
	{
		public var top:Number;
		public var left:Number;
		public var right:Number;
		public var bottom:Number;
		public var width:Number;
		public var height:Number;
		
		public function ScreenCoordsBase( top:Number, left:Number, right:Number, bottom:Number ) {
			
			this.top = top;
			this.left = left;
			this.right = right;
			this.bottom = bottom;
			
			this.width = this.right-this.left;
			this.height = bottom-top;
		}
		
		//
		// used by the PIE slices so the pie chart is
		// centered in the screen
		//
		public function get_center_x():Number {
			return (this.width / 2)+this.left;
		}

		public function get_center_y():Number {
			return (this.height / 2)+this.top;
		}
		
		public function get_y_from_val( i:Number, right_axis:Boolean = false ):Number { return -1; }
		
		public function get_x_from_val( i:Number ):Number { return -1;  }
		
		public function get_get_x_from_pos_and_y_from_val( index:Number, y:Number, right_axis:Boolean = false ):flash.geom.Point {
			return null;
		}
		
		public function get_y_bottom( right_axis:Boolean = false ):Number {
			return -1;
		}
		
		public function get_x_from_pos( i:Number ):Number { return -1; }
	}
}

/* AS3JS File */
package{
	//removeMeIfWant flash.geom.Point;

	public class ScreenCoordsRadar extends ScreenCoordsBase
	{
		private var TO_RADIANS:Number = Math.PI / 180;
		private var range:Range;
		private var angles:Number;
		private var angle:Number;
		private var radius:Number;
		
		public function ScreenCoordsRadar( top:Number, left:Number, right:Number, bottom:Number ) {
			
			super(top, left, right, bottom);
			
			//
			// if the radar chart has labels this is going to
			// get updated so they fit onto the screen
			//
			this.radius = ( Math.min( this.width, this.height ) / 2.0 );
		}
		
		// axis range, from center to outer edge
		public function set_range( r:Range ): void {
			this.range = r;
		}
		
		public function get_max():Number {
			return this.range.max;
		}
		
		// how many axis/spokes
		public function set_angles( a:Number ):void {
			this.angles = a;
			this.angle = 360 / a;
		}
		
		public function get_angles():Number {
			return this.angles;
		}
		
		public function get_radius():Number {
			
			return this.radius;
		}
		
		public function reduce_radius():void {
			this.radius--;
		}
		
		public function get_pos( angle:Number, radius:Number ): flash.geom.Point {
			
			// flash assumes 0 degrees is horizontal to the right
			var a:Number = (angle - 90) * TO_RADIANS;
			var r:Number = this.get_radius() * radius;
			
			var p:flash.geom.Point = new flash.geom.Point(
				r * Math.cos(a),
				r * Math.sin(a) );
				
			return p;
		}
		
		public override function get_get_x_from_pos_and_y_from_val( index:Number, y:Number, right_axis:Boolean = false ):flash.geom.Point {
			
			// rotate
			var p:flash.geom.Point = this.get_pos( this.angle*index, y / this.range.count() );
			
			// translate
			p.x += this.get_center_x();
			p.y += this.get_center_y();
			
			return p;
		}
		
		public override function get_y_from_val( y:Number, right_axis:Boolean = false ):Number {
			
			// rotate
			var p:flash.geom.Point = this.get_pos( 0, y / this.range.count() );
			
			// translate
			p.y += this.get_center_y();
			
			return p.y;
		}
	}
}

/* AS3JS File */
package{
	//removeMeIfWant flash.events.Event;

	public class ShowTipEvent extends flash.events.Event {
		public static const SHOW_TIP_TYPE:String = "ShowTipEvent";

		// The amount we need to incrememnt by
		public var pos:Number;

		public function ShowTipEvent( pos:Number ) {
			super( SHOW_TIP_TYPE );
			this.pos = pos;
		}
	}
}

/* AS3JS File */
package{

	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant flash.geom.Rectangle;
	//removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant flash.filters.DropShadowFilter;
	// //removeMeIfWant charts.Elements.Element;
	//removeMeIfWant com.serialization.json.JSON;
	//removeMeIfWant string.Utils;
	//removeMeIfWant string.Css;
	//removeMeIfWant object_helper;
	//removeMeIfWant charts.series.has_tooltip;
	
	public class Tooltip extends Sprite {
		// JSON style:
		private var style:Object;
		
		private var tip_style:Number;
		private var cached_elements:Array;
		private var tip_showing:Boolean;
		
		public var tip_text:String;
		
		public static const CLOSEST:Number = 0;
		public static const PROXIMITY:Number = 1;
		public static const NORMAL:Number = 2;		// normal tooltip (ugh -- boring!!)
		
		public function Tooltip( json:Object )
		{
			//
			// we don't want mouseOver events for the
			// tooltip or any children (the text fields)
			//
			this.mouseEnabled = false;
			this.tip_showing = false;
			
			this.style = {
				shadow:		true,
				rounded:	6,
				stroke:		2,
				colour:		'#808080',
				background:	'#f0f0f0',
				title:		"color: #0000F0; font-weight: bold; font-size: 12;",
				body:		"color: #000000; font-weight: normal; font-size: 12;",
				mouse:		Tooltip.CLOSEST,
				text:		"_default"
			};

			if( json )
			{
				this.style = object_helper.merge( json, this.style );
			}

				
			this.style.colour = Utils.get_colour( this.style.colour );
			this.style.background = Utils.get_colour( this.style.background );
			this.style.title = new Css( this.style.title );
			this.style.body = new Css( this.style.body );
			
			this.tip_style = this.style.mouse;
			this.tip_text = this.style.text;
			this.cached_elements = [];
			
			if( this.style.shadow==1 )
			{
				var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
				dropShadow.blurX = 4;
				dropShadow.blurY = 4;
				dropShadow.distance = 4;
				dropShadow.angle = 45;
				dropShadow.quality = 2;
				dropShadow.alpha = 0.5;
				// apply shadow filter
				this.filters = [dropShadow];
			}
		}
		
		public function make_tip( elements:Array ):void {
			
			this.graphics.clear();
			
			while( this.numChildren > 0 )
				this.removeChildAt(0);

			var height:Number = 0;
			var x:Number = 5;
			
			for each ( var e:has_tooltip in elements ) {
				
				var o:Object = this.make_one_tip(e, x);
				height = Math.max(height, o.height);
				x += o.width + 2;
			}
			
			this.graphics.lineStyle(this.style.stroke, this.style.colour, 1);
			this.graphics.beginFill(this.style.background, 1);
		
			this.graphics.drawRoundRect(
				0,0,
				width+10, height + 5,
				this.style.rounded, this.style.rounded );
		}
			
		private function make_one_tip( e:has_tooltip, x:Number ):Object {
			
			var tt:String = e.get_tooltip();
			var lines:Array = tt.split( '<br>' );
			
			var top:Number = 5;
			var width:Number = 0;
			
			if ( lines.length > 1 ) {
				
				var title:TextField = this.make_title(lines.shift());
				title.mouseEnabled = false;
				title.x = x;
				title.y = top;
				top += title.height;
				width = title.width;
				
				this.addChild( title );
			}
			
			var text:TextField = this.make_body(lines.join( '\n' ));
			text.mouseEnabled = false;
			text.x = x;
			text.y = top;
			width = Math.max( width, text.width );
			this.addChild( text );
			
			top += text.height;
			return {width:width, height:top};
		}

		private function make_title( text:String ):TextField {
			
			var title:TextField = new TextField();
			title.mouseEnabled = false;
			
			title.htmlText =  text;
			/*
			 * 
			 * Start thinking about just using html formatting 
			 * instead of text format below.  We could do away
			 * with the title textbox entirely and let the user
			 * use:
			 * <b>title stuff</b><br>Here is the value
			 * 
			 */
			var fmt:TextFormat = new TextFormat();
			fmt.color = this.style.title.color;
			fmt.font = "Verdana";
			fmt.bold = (this.style.title.font_weight=="bold");
			fmt.size = this.style.title.font_size;
			fmt.align = "right";
			title.setTextFormat(fmt);
			title.autoSize = "left";
			
			return title;
		}			
			
		private function make_body( body:String ):TextField {
			
			var text:TextField = new TextField();
			text.mouseEnabled = false;
			
			text.htmlText =  body;
			var fmt2:TextFormat = new TextFormat();
			fmt2.color = this.style.body.color;
			fmt2.font = "Verdana";
			fmt2.bold = (this.style.body.font_weight=="bold");
			fmt2.size = this.style.body.font_size;
			fmt2.align = "left";
			text.setTextFormat(fmt2);
			text.autoSize="left";
			
			return text;
		}
		
		private function get_pos( e:has_tooltip ):flash.geom.Point {

			var pos:Object = e.get_tip_pos();

			var x:Number = (pos.x + this.width + 16) > this.stage.stageWidth ? (this.stage.stageWidth - this.width - 16) : pos.x;
			
			var y:Number = pos.y;
			y -= 4;
			y -= (this.height + 10 ); // 10 == border size
			
			if( y < 0 )
			{
				// the tooltip has drifted off the top of the screen, move it down:
				y = 0;
			}
			return new flash.geom.Point(x, y);
		}
		
		private function show_tip( e:has_tooltip ):void {
			
			// remove the 'hide' tween
			Tweener.removeTweens( this );
			var p:flash.geom.Point = this.get_pos( e );
			
			if ( this.style.mouse == Tooltip.CLOSEST )
			{
				//
				// make the tooltip appear (if invisible)
				// and shoot to the correct position
				//
				this.visible = true;
				this.alpha = 1
				this.x = p.x;
				this.y = p.y;
			}
			else
			{
				// make the tooltip fade in gently
				this.tip_showing = true;
					
				tr.ace('show');
				this.alpha = 0
				this.visible = true;
				this.x = p.x;
				this.y = p.y;
				Tweener.addTween(
					this,
					{
						alpha:1,
						time:0.4,
						transition:Equations.easeOutExpo
					} );
			}
		}
		
		public function draw( e:has_tooltip ):void {

			if ( this.cached_elements[0] == e )
			{
				// if the tip is showing, don't make it 
				// show again because this makes it flicker
				if( !this.tip_showing )
					this.show_tip(e);
			}
			else
			{

				// this is a new tooltip, tell
				// the old highlighted item to
				// return to ground state
				this.untip();
				
				// get the new text and recreate it
				this.cached_elements = [e];
				
				this.make_tip( [e] );
				this.show_tip(e);
			}
		}
		
		public function closest( elements:Array ):void {

			if( elements.length == 0 )
				return;
			
			if( this.is_cached( elements ) )
				return;
			
			this.untip();
			this.cached_elements = elements;
			this.tip();

			//
			//tr.ace( 'make new tooltip' );
			//tr.ace( Math.random() );
			//
			
			this.make_tip( elements );

			var p:flash.geom.Point = this.get_pos( elements[0] );
			
			this.visible = true;
			
			Tweener.addTween(this, { x:p.x, time:0.3, transition:Equations.easeOutExpo } );
			Tweener.addTween(this, { y:p.y, time:0.3, transition:Equations.easeOutExpo } );
		}
		
		//
		// TODO: if elements has 1 item and cached_elements has 2
		//       one of which is in elements, this function
		//       returns true which is wrong
		//
		private function is_cached( elements:Array ):Boolean {
			
			if ( this.cached_elements.length == 0 )
				return false;
				
			for each( var e:has_tooltip in elements )
				if ( this.cached_elements.indexOf(e) == -1 )
					return false;
					
			return true;
		}
		
		private function untip():void {
			for each( var e:has_tooltip in this.cached_elements )
				e.set_tip( false );
		}
		
		private function tip():void {
			for each( var e:has_tooltip in this.cached_elements )
				e.set_tip( true );
		}
		
		private function hideAway() : void {
			this.visible = false;
			this.untip();
			this.cached_elements = new Array();
			this.alpha = 1;
		}
		
		public function hide():void {
			this.tip_showing = false;
			tr.ace('hide tooltip');
			Tweener.addTween(this, { alpha:0, time:0.6, transition:Equations.easeOutExpo, onComplete:hideAway } );
		}
		
		public function get_tip_style():Number {
			return this.tip_style;
		}

		public function set_tip_style( i:Number ):void {
			this.tip_style = i;
		}
		
		public function die():void {
			
			this.filters = [];
			this.graphics.clear();
			
			while( this.numChildren > 0 )
				this.removeChildAt(0);
		
			this.style = null;
			this.cached_elements = null;
		}
	}
}

/* AS3JS File */
package{
	//removeMeIfWant org.flashdevelop.utils.FlashConnect;
	//removeMeIfWant com.serialization.json.JSON;
	
	public class tr {
		
		public static function ace( o:Object ):void	{
			if ( o == null )
				FlashConnect.trace( 'null' );
			else
				FlashConnect.trace( o.toString() );
		
			// var tempError:Error = new Error();
			// var stackTrace:String = tempError.getStackTrace();
			// FlashConnect.trace( 'stackTrace:' + stackTrace );
		
			if ( false )
				tr.trace_full();
		}
		
		//
		// e.g: tr.aces( 'my val', val );
		//
		public static function aces( ... optionalArgs ):void	{
			
			var tmp:Array = [];
			for each( var o:Object in optionalArgs )
			{
				// FlashConnect.trace( o.toString() );
				if ( o == null )
					tmp.push( 'null' );
				else
					tmp.push( o.toString() );
			}
			
			FlashConnect.trace( tmp.join(', ') );
		}
		
		// this doesn't work cos I don't know how to set 'permit debugging' yet
		/**
		 * Found this at:
		 *   http://www.ultrashock.com/forums/actionscript/can-you-trace-a-line-95261.html
		 */
		static public function ace_full(snum:uint=3):void
		{
			// FROM:
			// http://snippets.dzone.com/posts/show/3703
			//----------------------------------------------------------------------------------------------------------------
			// With debugging turned on, this is what we get:
			//
			// Error
			// <tab>at com.flickaway::Trace$/log_full()[D:\web\flickaway_branch\flash\lib\com\flickaway\Trace.as:83]
			// <tab>at com.flickaway::Trace$/print_r_full()[D:\web\flickaway_branch\flash\lib\com\flickaway\Trace.as:114]
			// <tab>at com.flickaway::Trace$/print_r()[D:\web\flickaway_branch\flash\lib\com\flickaway\Trace.as:46]
			// <tab>at com.flickaway::Params()[D:\web\flickaway_branch\flash\lib\com\flickaway\Params.as:36]                <==== this line we want
			// <tab>at com.flickaway::Params$/get_instance()[D:\web\flickaway_branch\flash\lib\com\flickaway\Params.as:27]
			// <tab>at HomeDefault()[D:\web\flickaway_branch\flash\homepage\HomeDefault.as:57]
			// <tab>at com.flickaway::Params()[D:\web\flickaway_branch\flash\lib\com\flickaway\Params.as:36])
			//
			// with debugging turned off:
			//
			// Error
			// <tab>at com.flickaway::Trace$/log_full()
			// <tab>at com.flickaway::Trace$/print_r_full()
			// <tab>at com.flickaway::Trace$/print_r()
			// <tab>at com.flickaway::Params()
			// <tab>at com.flickaway::Params$/get_instance()
			// <tab>at HomeDefault()
			//----------------------------------------------------------------------------------------------------------------
			var e:Error = new Error();
			var str:String = e.getStackTrace();                     // get the full text str

			if (str == null)                                          // means we aren't on the Debug player
			{
				FlashConnect.trace( "(!debug) " );
			}
			else
			{
				var stacks:Array = str.split("\n");                     // split into each line
				var caller:String = tr.gimme_caller(stacks[snum]);   // get the caller for just one specific line in the stack trace
				FlashConnect.trace( caller );
			}
		}

		/**
		* Returns a string like "[HomeDefault():51]" - line number present only if "permit debugging" is turned on.
		*/
		static private function gimme_caller(line:String):String
		{
			//-------------------------------------------------------------------------------------------------
			// the line can look like any of these (so we must be able to clean up all of them):
			//
			// <tab>at com.flickaway::Params()
			// <tab>at com.flickaway::Params()[D:\web\flickaway_branch\flash\lib\com\flickaway\Params.as:36]
			// <tab>at HomeDefault()
			// <tab>at HomeDefault()[D:\web\flickaway_branch\flash\homepage\HomeDefault.as:57]
			//-------------------------------------------------------------------------------------------------
			var dom_pos:int = line.indexOf("::");                  // find the '::' part
			var caller:String;

			if (dom_pos == -1)
			{
				caller = line.substr(4);                         // just remove '<tab>at ' beginning part (4 characters)
			}
			else
			{
				caller = line.substr(dom_pos+2);                 // remove '<tab>at com.flickaway::' beginning part
			}
			var lb_pos:int = caller.indexOf("[");                // get position of the left bracket (lb)

			if (lb_pos == -1)                                    // if the lb doesn't exist (then we don't have "permit debugging" turned on)
			{
				return "[" + caller + "]";
			}
			else
			{
				var line_num:String = caller.substr(caller.lastIndexOf(":"));      // find the line number
				caller = caller.substr(0, lb_pos);                                 // cut it out - it'll look like ":51]"
				return "[" + caller + line_num;                                    // line_num already has the trailing right bracket
			}
		}



		
		public static function ace_json( json:Object ):void {
			tr.ace(com.serialization.json.JSON.serialize(json));
		}
	}
}

/* AS3JS File */
package string {

	public class Css {
		public var text_align:String;
		public var font_size:Number;
		private var text_decoration:String;
		private var margin:String;
		public var margin_top:Number;
		public var margin_bottom:Number;
		public var margin_left:Number;
		public var margin_right:Number;
		
		private var padding:String;
		public var padding_top:Number=0;
		public var padding_bottom:Number=0;
		public var padding_left:Number=0;
		public var padding_right:Number=0;
		
		public var font_weight:String;
		public var font_style:String;
		public var font_family:String;
		public var color:Number;
		private var stop_process:Number;  // Flag for disable checking
		public var background_colour:Number;
		public var background_colour_set:Boolean;
		
		private var display:String;
		
		public function Css( txt:String ) {
			// To lower case
			txt.toLowerCase();
			
			// monk.e.boy: remove the { and }
			txt = txt.replace( '{', '' );
			txt = txt.replace( '}', '' );
			
			// monk.e.boy: setup some default values.
			// does this confilct with 'clear()'?
			this.margin_top		= 0;
			this.margin_bottom	= 0;
			this.margin_left	= 0;
			this.margin_right	= 0;
			
			this.padding_top	= 0;
			this.padding_bottom	= 0;
			this.padding_left	= 0;
			this.padding_right	= 0;
		
			this.color = 0;
			this.background_colour_set = false;
			this.font_size = 9;
			
			// Splitting by the ;
			var arr:Array = txt.split(";");
			
			// Checking all the types of css params we accept and writing to internal variables of the object class
			for( var i:Number = 0; i < arr.length; i++)
			{
				getAttribute(arr[i]);
			}
		}
		
		private function trim( txt:String ):String {
			var l:Number = 0;
			var r:Number = txt.length - 1;
			while(txt.charAt(l) == ' ' || txt.charAt(l) == "\t" ) l++;
			while(txt.charAt(r) == ' ' || txt.charAt(r) == "\t" ) r--;
			return txt.substring( l, r+1 );
		}
		
		private function removeDoubleSpaces( txt:String ):String {
			var aux:String;
			var auxPrev:String;
			aux = txt;
			do {
				auxPrev = aux;
				aux.replace('  ',' '); 
			} while (  auxPrev.length != aux.length  );
			return aux;
		}
		
		private function ToNumber(cad:String):Number {
			
			cad = cad.replace( 'px', '' );
			
			if ( isNaN( Number(cad) )  ) {
				return 0;
			} else {
				return Number(cad);
			}
		}
		
		private function getAttribute( txt:String ):void {
			var arr:Array = txt.split(":");
			if( arr.length==2 )
			{
				this.stop_process = 1;
				this.set( arr[0], trim(arr[1]) );
			}
		}
		/*
		public function get( cad:String ):Number {
			switch (cad) {
				case "text-align"			: return this.text_align;
				case "font-size"			: return ToNumber(this.font_size);
				case "text-decoration"		: return this.text_decoration;
				case "margin-top"			: return this.margin_top;
				case "margin-bottom"		: return this.margin_bottom;
				case "margin-left"			: return this.margin_left;
				case "margin-right"			: return this.margin_right;
				case "padding-top"			: return this.padding_top;
				case "padding-bottom"		: return this.padding_bottom;
				case "padding-left"			: return this.padding_left;
				case "padding-right"		: return this.padding_right;
				case "font-weight"			: return ToNumber(this.font_weight);
				case "font-style"			: return this.font_style;
				case "font-family"			: return this.font_family;
				case "color"				: return this.color;
				case "background-color"		: return this.bg_colour;
				case "display"				: return this.display;
				default						: return 0;
			}
		}
		*/
		// FUCKING!! Flash without By reference String parameters on functions
		public function set( cad:String, val:String ):void {
			cad = trim( cad );
		
			switch( cad )
			{
				case "text-align"			: this.text_align = val;			break;
				case "font-size"			: this.set_font_size(val);			break;
				case "text-decoration"		: this.text_decoration = val;		break;
				
				case "margin"				: this.setMargin(val);			break;
				case "margin-top"			: this.margin_top = ToNumber(val); break;
				case "margin-bottom"		: this.margin_bottom = ToNumber(val); break;
				case "margin-left"			: this.margin_left = ToNumber(val); break;
				case "margin-right"			: this.margin_right = ToNumber(val); break;
				
				case 'padding'				: this.setPadding(val);				break;
				case "padding-top"			: this.padding_top = ToNumber(val); break;
				case "padding-bottom"		: this.padding_bottom = ToNumber(val); break;
				case "padding-left"			: this.padding_left = ToNumber(val); break;
				case "padding-right"		: this.padding_right = ToNumber(val); break;
				
				case "font-weight"			: this.font_weight = val; break;
				case "font-style"			: this.font_style = val; break;
				case "font-family"			: this.font_family = val; break;
				case "color"				: this.set_color(val);				break;
				case "background-color":
					this.background_colour = Utils.get_colour(val);
					this.background_colour_set = true;
					break;
				case "display"				: this.display = val; break;
			}
		}
		
		public function set_color( val:String ):void {
			this.color = Utils.get_colour( val );
		}
		
		public function set_font_size( val:String ):void {
			this.font_size = ToNumber(val);
		}
		
		
		private function setPadding( val:String ):void {

			val = trim( val );
			var arr:Array = val.split(' ');
			
			switch( arr.length )
			{
				
				// margin: 30px;
				case 1:
					this.padding_top	= ToNumber(arr[0]);
					this.padding_right	= ToNumber(arr[0]);
					this.padding_bottom	= ToNumber(arr[0]);
					this.padding_left	= ToNumber(arr[0]);
					break;
					
				// margin: 15px 5px;
				case 2:
					this.padding_top	= ToNumber(arr[0]);
					this.padding_right	= ToNumber(arr[1]);
					this.padding_bottom	= ToNumber(arr[0]);
					this.padding_left	= ToNumber(arr[1]);
					break;
					
				// margin: 15px 5px 10px;
				case 3:
					this.padding_top	= ToNumber(arr[0]);
					this.padding_right	= ToNumber(arr[1]);
					this.padding_bottom	= ToNumber(arr[2]);
					this.padding_left	= ToNumber(arr[1]);
					break;
					
				// margin: 1px 2px 3px 4px;
				default:
					this.padding_top	= ToNumber(arr[0]);
					this.padding_right	= ToNumber(arr[1]);
					this.padding_bottom	= ToNumber(arr[2]);
					this.padding_left	= ToNumber(arr[3]);
			}
		}
		
		private function setMargin( val:String ):void {

			val = trim( val );
			var arr:Array = val.split(' ');
			
			switch( arr.length )
			{
				
				// margin: 30px;
				case 1:
					this.margin_top		= ToNumber(arr[0]);
					this.margin_right	= ToNumber(arr[0]);
					this.margin_bottom	= ToNumber(arr[0]);
					this.margin_left	= ToNumber(arr[0]);
					break;
				
				// margin: 15px 5px;
				case 2:
					this.margin_top		= ToNumber(arr[0]);
					this.margin_right	= ToNumber(arr[1]);
					this.margin_bottom	= ToNumber(arr[0]);
					this.margin_left	= ToNumber(arr[1]);
					break;
					
				// margin: 15px 5px 10px;
				case 3:
					this.margin_top		= ToNumber(arr[0]);
					this.margin_right	= ToNumber(arr[1]);
					this.margin_bottom	= ToNumber(arr[2]);
					this.margin_left	= ToNumber(arr[1]);
					break;
					
				// margin: 1px 2px 3px 4px;
				default:
					this.margin_top		= ToNumber(arr[0]);
					this.margin_right	= ToNumber(arr[1]);
					this.margin_bottom	= ToNumber(arr[2]);
					this.margin_left	= ToNumber(arr[3]);
			}
		}
		
		public function clear():void {
			this.text_align			= undefined;
			this.font_size			= undefined;
			this.text_decoration	= undefined;
			this.margin_top			= undefined;
			this.margin_bottom		= undefined;
			this.margin_left		= undefined;
			this.margin_right		= undefined;
			this.font_weight		= undefined;
			this.font_style			= undefined;
			this.font_family		= undefined;
			this.color				= undefined;
			this.display			= undefined;
		}
	}
}

/* AS3JS File */
package string
{
	public class DateUtils
	{

		protected static var dateConsts:Object = {
			shortMonths: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
			longMonths: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
			shortDays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
			longDays: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
		}

		public static function replace_magic_values( tip:String, xVal:Number):String {
			// convert from a unix timestamp to an AS3 date
			var as3Date:Date = new Date(xVal * 1000);
			tip = tip.replace('#date#', DateUtils.formatDate(as3Date, "Y-m-d"));
			// check for user formatted dates
			var begPtr:int = tip.indexOf("#date:");
			while (begPtr >= 0)
			{
				var endPtr:int = tip.indexOf("#", begPtr + 1) + 1;
				var replaceStr:String = tip.substr(begPtr, endPtr-begPtr);
				var timeFmt:String = replaceStr.substr(6, replaceStr.length - 7);
				var dateStr:String = DateUtils.formatDate(as3Date, timeFmt);
				tip = tip.replace(replaceStr, dateStr);
				begPtr = tip.indexOf("#date:");
			}

			begPtr = tip.indexOf("#gmdate:");
			while (begPtr >= 0)
			{
				endPtr = tip.indexOf("#", begPtr + 1) + 1;
				replaceStr = tip.substr(begPtr, endPtr-begPtr);
				timeFmt = replaceStr.substr(8, replaceStr.length - 9);
				dateStr= DateUtils.formatUTCDate(as3Date, timeFmt);
				tip = tip.replace(replaceStr, dateStr);
				begPtr = tip.indexOf("#gmdate:");
			}

			return tip;
		}
		
		// Simulates PHP's date function
		public static function formatDate( aDate:Date, fmt:String ): String
		{
			var returnStr:String = '';
			for (var i:int = 0; i < fmt.length; i++) {
				var curChar:String = fmt.charAt(i);
				switch (curChar)
				{
					// day
					case 'd':
							returnStr += (aDate.getDate() < 10 ? '0' : '') + aDate.getDate(); 
							break;
					case 'D':
							returnStr += DateUtils.dateConsts.shortDays[aDate.getDate()];
							break;
					case 'j':
							returnStr += aDate.getDate();
							break;
					case 'l': 
							returnStr += DateUtils.dateConsts.longDays[aDate.getDay()];
							break;
					case 'N':
							returnStr += aDate.getDay() + 1;
							break;
					case 'S':
							returnStr += (aDate.getDate() % 10 == 1 && aDate.getDate() != 11 ? 'st' : (aDate.getDate() % 10 == 2 && aDate.getDate() != 12 ? 'nd' : (aDate.getDate() % 10 == 3 && aDate.getDate() != 13 ? 'rd' : 'th')));
							break;
					case 'w':
							returnStr += aDate.getDay();
							break;
					//z: function() { return "Not Yet Supported"; },
					
					// Week
					//W: function() { return "Not Yet Supported"; },
					
					// Month
					case 'F':
						returnStr += DateUtils.dateConsts.longMonths[aDate.getMonth()];
						break;
					case 'm':
						returnStr += (aDate.getMonth() < 9 ? '0' : '') + (aDate.getMonth() + 1);
						break;
					case 'M':
						returnStr += DateUtils.dateConsts.shortMonths[aDate.getMonth()];
						break;
					case 'n':
						returnStr += aDate.getMonth() + 1;
						break;
					//t: function() { return "Not Yet Supported"; },
					
					// Year
					//L: function() { return "Not Yet Supported"; },
					//o: function() { return "Not Supported"; },
					case 'Y':
						returnStr += aDate.getFullYear();
						break;
					case 'y':
						returnStr += ('' + aDate.getFullYear()).substr(2);
						break;
						
					// Time
					case 'a':
						returnStr += aDate.getHours() < 12 ? 'am' : 'pm';
						break;
					case 'A':
						returnStr += aDate.getHours() < 12 ? 'AM' : 'PM';
						break;
					//B: function() { return "Not Yet Supported"; },
					case 'g':
						returnStr += aDate.getHours() == 0 ? 12 : (aDate.getHours() > 12 ? aDate.getHours() - 12 : aDate.getHours());
						break;
					case 'G':
						returnStr += aDate.getHours();
						break;
					case 'h':
						returnStr += (aDate.getHours() < 10 || (12 < aDate.getHours() < 22) ? '0' : '') + (aDate.getHours() < 10 ? aDate.getHours() + 1 : aDate.getHours() - 12);
						break;
					case 'H':
						returnStr += (aDate.getHours() < 10 ? '0' : '') + aDate.getHours();
						break;
					case 'i':
						returnStr += (aDate.getMinutes() < 10 ? '0' : '') + aDate.getMinutes();
						break;
					case 's':
						returnStr += (aDate.getSeconds() < 10 ? '0' : '') + aDate.getSeconds();
						break;
					
					// Timezone
					//e: function() { return "Not Yet Supported"; },
					//I: function() { return "Not Supported"; },
					case 'O':
						returnStr += (aDate.getTimezoneOffset() < 0 ? '-' : '+') + (aDate.getTimezoneOffset() / 60 < 10 ? '0' : '') + (aDate.getTimezoneOffset() / 60) + '00';
						break;
					//T: function() { return "Not Yet Supported"; },
					case 'Z':
						returnStr += aDate.getTimezoneOffset() * 60;
						break;
						
					// Full Date/Time
					//c: function() { return "Not Yet Supported"; },
					case 'r':
						returnStr += aDate.toString();
						break;
					case 'U':
						returnStr += aDate.getTime() / 1000;
						break;
							
					default:
						returnStr += curChar;
				}
			}
			return returnStr;
		};
		
		// Simulates PHP's date function
		public static function formatUTCDate( aDate:Date, fmt:String ): String
		{
			var returnStr:String = '';
			for (var i:int = 0; i < fmt.length; i++) {
				var curChar:String = fmt.charAt(i);
				switch (curChar)
				{
					// day
					case 'd':
							returnStr += (aDate.getUTCDate() < 10 ? '0' : '') + aDate.getUTCDate(); 
							break;
					case 'D':
							returnStr += DateUtils.dateConsts.shortDays[aDate.getUTCDate()];
							break;
					case 'j':
							returnStr += aDate.getUTCDate();
							break;
					case 'l': 
							returnStr += DateUtils.dateConsts.longDays[aDate.getUTCDay()];
							break;
					case 'N':
							returnStr += aDate.getUTCDay() + 1;
							break;
					case 'S':
							returnStr += (aDate.getUTCDate() % 10 == 1 && aDate.getUTCDate() != 11 ? 'st' : (aDate.getUTCDate() % 10 == 2 && aDate.getUTCDate() != 12 ? 'nd' : (aDate.getUTCDate() % 10 == 3 && aDate.getUTCDate() != 13 ? 'rd' : 'th')));
							break;
					case 'w':
							returnStr += aDate.getUTCDay();
							break;
					//z: function() { return "Not Yet Supported"; },
					
					// Week
					//W: function() { return "Not Yet Supported"; },
					
					// Month
					case 'F':
						returnStr += DateUtils.dateConsts.longMonths[aDate.getUTCMonth()];
						break;
					case 'm':
						returnStr += (aDate.getUTCMonth() < 9 ? '0' : '') + (aDate.getUTCMonth() + 1);
						break;
					case 'M':
						returnStr += DateUtils.dateConsts.shortMonths[aDate.getUTCMonth()];
						break;
					case 'n':
						returnStr += aDate.getUTCMonth() + 1;
						break;
					//t: function() { return "Not Yet Supported"; },
					
					// Year
					//L: function() { return "Not Yet Supported"; },
					//o: function() { return "Not Supported"; },
					case 'Y':
						returnStr += aDate.getUTCFullYear();
						break;
					case 'y':
						returnStr += ('' + aDate.getUTCFullYear()).substr(2);
						break;
						
					// Time
					case 'a':
						returnStr += aDate.getUTCHours() < 12 ? 'am' : 'pm';
						break;
					case 'A':
						returnStr += aDate.getUTCHours() < 12 ? 'AM' : 'PM';
						break;
					//B: function() { return "Not Yet Supported"; },
					case 'g':
						returnStr += aDate.getUTCHours() == 0 ? 12 : (aDate.getUTCHours() > 12 ? aDate.getUTCHours() - 12 : aDate.getHours());
						break;
					case 'G':
						returnStr += aDate.getUTCHours();
						break;
					case 'h':
						returnStr += (aDate.getUTCHours() < 10 || (12 < aDate.getUTCHours() < 22) ? '0' : '') + (aDate.getUTCHours() < 10 ? aDate.getUTCHours() + 1 : aDate.getUTCHours() - 12);
						break;
					case 'H':
						returnStr += (aDate.getUTCHours() < 10 ? '0' : '') + aDate.getUTCHours();
						break;
					case 'i':
						returnStr += (aDate.getUTCMinutes() < 10 ? '0' : '') + aDate.getUTCMinutes();
						break;
					case 's':
						returnStr += (aDate.getUTCSeconds() < 10 ? '0' : '') + aDate.getUTCSeconds();
						break;
					
					// Timezone
					//e: function() { return "Not Yet Supported"; },
					//I: function() { return "Not Supported"; },
					case 'O':
						returnStr += '+0000';
						break;
					//T: function() { return "Not Yet Supported"; },
					case 'Z':
						returnStr += 0;
						break;
						
					// Full Date/Time
					//c: function() { return "Not Yet Supported"; },
					case 'r':
						returnStr += aDate.toUTCString();
						break;
					case 'U':
						returnStr += aDate.getTime() / 1000;
						break;
							
					default:
						returnStr += curChar;
				}
			}
			return returnStr;
		};

		
	}
}/**
* ...
* @author Default
* @version 0.1
*/


/* AS3JS File */
package string {

	public class Utils {
		
		public function Utils() {
			
		}
		
		static public function get_colour( col:String ) : Number
		{
			if( col.substr(0,2) == '0x' )
				return Number(col);
				
			if( col.substr(0,1) == '#' )
				return Number( '0x'+col.substr(1,col.length) );
				
			if( col.length==6 )
				return Number( '0x'+col );
				
			// not recognised as a valid colour, so?
			return Number( col );
				
		}
		
	}
	
}

/* AS3JS File */
package org.flashdevelop.utils
{	
	//removeMeIfWant flash.net.*;
	//removeMeIfWant flash.events.*;
	//removeMeIfWant flash.utils.*;
	//removeMeIfWant flash.xml.*;
	
	/**
	* Connects a flash movie thru XmlSocket to the FlashDevelop program.
	* @author Mika Palmu
	* @version 3.3
	*/
	public class FlashConnect
	{
		/**
		* Public properties of the class.
		*/
		public static var status:Number = 0;
		public static var limit:Number = 1000;
		public static var host:String = "127.0.0.1";
		public static var port:Number = 1978;
		
		/**
		* Private properties of the class.
		*/
		private static var socket:XMLSocket;
		private static var messages:Array;
		private static var interval:Number;
		private static var counter:Number;
		
		/**
		* Event callbacks of the class.
		*/
		public static var onConnection:Function;
		public static var onReturnData:Function;
		
		/**
		* Adds a custom message to the message stack.
		*/
		public static function send(message:XMLNode):void 
		{
			if (messages == null) initialize();
			messages.push(message);
		}
		
		/**
		* Adds a trace command to the message stack.
		*/
		public static function trace(value:Object, level:Number = TraceLevel.DEBUG):void
		{
			var msgNode:XMLNode = createMsgNode(value.toString(), level);
			FlashConnect.send(msgNode);
		}
		
		/**
		* Adds a trace command to the message stack, AS3 style.
		*/
		public static function atrace(...rest):void
		{
			var result:String = rest.join(",");
			var message:XMLNode = createMsgNode(result, TraceLevel.DEBUG);
			FlashConnect.send(message);
		}

		/**
		* Adds a trace command to the message stack, MTASC style.
		*/
		public static function mtrace(value:Object, method:String, path:String, line:Number):void 
		{
			var fixed:String = path.split("/").join("\\");
			var formatted:String = fixed + ":" + line + ":" + value;
			FlashConnect.trace(formatted, TraceLevel.DEBUG);
		}
		
		/**
		* Send message queue immediately
		* @return Success
		*/
		public static function flush():Boolean
		{
			if (status) 
			{
				sendStack();
				return true;
			}
			else return false;
		}
		
		/**
		* Opens the xml socket connection to the target port and host.
		*/
		public static function initialize():int
		{
			if (socket) return status;
			counter = 0;
			messages = new Array();
			socket = new XMLSocket();
			socket.addEventListener(Event.CLOSE, onClose);
			socket.addEventListener(DataEvent.DATA, onData);
			socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			interval = setInterval(sendStack, 50);
			socket.connect(host, port);
			return status;
		}
		private static function onData(event:DataEvent):void
		{
			FlashConnect.status = 1;
			if (FlashConnect.onReturnData != null)
			{
				FlashConnect.onReturnData(event.data);
			}
		}
		private static function onClose(event:Event):void
		{
			socket = null;
			FlashConnect.status = -1;
			if (FlashConnect.onConnection != null) 
			{
				FlashConnect.onConnection();
			}
		}
		private static function onConnect(event:Event):void
		{
			FlashConnect.status = 1;
			if (FlashConnect.onConnection != null) 
			{
				FlashConnect.onConnection();
			}
		}
		private static function onIOError(event:IOErrorEvent):void
		{
			FlashConnect.status = -1;
			if (FlashConnect.onConnection != null) 
			{
				FlashConnect.onConnection();
			}
		}
		private static function onSecurityError(event:SecurityErrorEvent):void
		{
			FlashConnect.status = -1;
			if (FlashConnect.onConnection != null) 
			{
				FlashConnect.onConnection();
			}
		}
		
		/**
		* Creates the required xml message for the trace operation.
		*/
		private static function createMsgNode(message:String, level:Number):XMLNode
		{
			if (isNaN(level)) level = TraceLevel.DEBUG;
			var msgNode:XMLNode = new XMLNode(1, null);
			var txtNode:XMLNode = new XMLNode(3, encodeURI(message));
			msgNode.attributes.state = level.toString();
			msgNode.attributes.cmd = "trace";
			msgNode.nodeName = "message";
			msgNode.appendChild(txtNode);
			return msgNode;
		}
		
		/**
		* Sends all messages in message stack to FlashDevelop.
		*/
		private static function sendStack():void
		{
			if (messages.length > 0 && status == 1)
			{
				var message:XMLDocument = new XMLDocument();
				var rootNode:XMLNode = message.createElement("flashconnect");
				while (messages.length != 0) 
				{
					counter++;
					if (counter > limit)
					{
						clearInterval(interval);
						var msg:String = new String("FlashConnect aborted. You have reached the limit of maximum messages.");
						var errorNode:XMLNode = createMsgNode(msg, TraceLevel.ERROR);
						rootNode.appendChild(errorNode);
						messages = new Array();
						break;
					} 
					else 
					{
						var msgNode:XMLNode = XMLNode(messages.shift());
						rootNode.appendChild(msgNode);
					}
				}
				message.appendChild(rootNode);
				if (socket && socket.connected) socket.send(message);
				counter = 0;
			}
		}
		
	}
	
}

/* AS3JS File */
package org.flashdevelop.utils
{
	//removeMeIfWant flash.system.*;
	
	/**
	* Connects a flash movie from the ActiveX component to the FlashDevelop program.
	* @author Mika Palmu
	* @version 1.1
	*/
	public class FlashViewer
	{
		/**
		* Public properties of the class.
		*/
		public static var limit:Number = 1000;
		
		/**
		* Private properties of the class.
		*/
		private static var counter:Number = 0;
		private static var aborted:Boolean = false;
		
		/**
		* Sends a trace message to the ActiveX component.
		*/
		public static function trace(value:Object, level:Number = 1):void
		{
			counter++;
			if (counter > limit && !aborted)
			{
				aborted = true;
				var msg:String = "FlashViewer aborted. You have reached the limit of maximum messages.";
				fscommand("trace", "3:" + msg);
			} 
			if (!aborted) fscommand("trace", level + ":" + value);
		}
		
		/**
		* Sends a trace message to the ActiveX component, MTASC style.
		*/
		public static function mtrace(value:Object, method:String, path:String, line:Number):void 
		{
			var fixed:String = path.split("/").join("\\");
			var formatted:String = fixed + ":" + line + ":" + value;
			FlashViewer.trace(formatted, TraceLevel.DEBUG);
		}
		
		/**
		* Sends a trace message to the ActiveX component, AS3 style.
		*/
		public static function atrace(...rest):void
		{
			var result:String = rest.join(",");
			FlashViewer.trace(result, TraceLevel.DEBUG);
		}
		
	}
	
}

/* AS3JS File */
package org.flashdevelop.utils 
{
	/**
	* Predefined trace level values for the tracing classes.
	* @author Mika Palmu
	* @version 1.0
	*/
	public class TraceLevel
	{
		/**
		* Constants of the class
		*/
		public static const INFO:Number = 0;
		public static const DEBUG:Number = 1;
		public static const WARNING:Number = 2;
		public static const ERROR:Number = 3;
		public static const FATAL:Number = 4;
		
	}

}

/* AS3JS File */
package global {
	
	//removeMeIfWant elements.axis.AxisLabel;
	//removeMeIfWant elements.labels.XLegend;
	//removeMeIfWant elements.axis.XAxisLabels;
	
	public class Global {
		private static var instance:Global = null;
		private static var allowInstantiation:Boolean = false;
		
		public var x_labels:XAxisLabels;
		public var x_legend:XLegend;
		private var tooltip:String;
		
		public function Global() {
		}
		
		public static function getInstance() : Global {
			if ( Global.instance == null ) {
				Global.allowInstantiation = true;
				Global.instance = new Global();
				Global.allowInstantiation = false;
			}
			return Global.instance;
		}
		
		public function get_x_label( pos:Number ):String {
			
			// PIE charts don't have X Labels
			
			tr.ace('xxx');
			tr.ace( this.x_labels == null )
			tr.ace(pos);
//			tr.ace( this.x_labels.get(pos))
			
			
			if ( this.x_labels == null )
				return null;
			else
				return this.x_labels.get(pos);
		}
		
		public function get_x_legend(): String {
			
			// PIE charts don't have X Legend
			if( this.x_legend == null )
				return null;
			else
				return this.x_legend.text;
		}
		
		public function set_tooltip_string( s:String ):void {
			tr.ace('@@@@@@@');
			tr.ace(s);
			this.tooltip = s;
		}
		
		public function get_tooltip_string():String {
			return this.tooltip;
		}
	}
}

/* AS3JS File */
package elements {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.net.URLLoader;
	//removeMeIfWant flash.net.URLRequest;
	
	public class Background extends Sprite {
		
		private var colour:Number;
		private var img_x:Number;
		private var img_y:Number;
		
		public function Background( json:Object )
		{
			if( json.bg_colour != undefined )
				this.colour = Utils.get_colour( json.bg_colour );
			else
				this.colour = 0xf8f8d8;		// <-- default to Ivory
			
			if ( json.bg_image != undefined )
				this.load_img( json.bg_image );
			
		}
		
		private function load_img( json:Object ):void {
			
			// added by NetVicious, 05 July, 2007 ++++
				
			if( json.bg_image_x != undefined )
				this.img_x = json.bg_image_x;
					
			if( json.bg_image_y != undefined )
				this.img_y = json.bg_image_y;
					
			//
			// LOAD THE IMAGE
			/*
			var loader:URLLoader;
			loader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, imageLoaded );
			
			var loader:URLRequest = new URLRequest();
			loader.addListener({
				onLoadInit: function(mymc:MovieClip) {
					ref.positionize( mymc, ref.img_x, ref.img_y, new Square(0, 0, Stage.width, Stage.height) );
					delete loader;
				}
			});
				
			loader.loadClip(lv.bg_image, this.img_mc);
		*/
		}
		
		/*
		private function xmlLoaded(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			loader.
		}
	
		// added by NetVicious, 05 July, 2007
		function positionize( mc:MovieClip, myX, myY, s:Square )
		{
			var newX:Number = 0;
			var newY:Number = 0;

			if ( isNaN(myX) ) {
				myX.toLowerCase()
				switch ( myX ) {
					case 'center':
						newX = (s.width / 2) - (mc._width / 2);
						break;
					case 'left':
						newX = s.left;
						break;
					case 'right':
						newX = s.right - mc._width;
						break;
					default:
						newX = 0;
				}
			} else if ( myX < 0 ) {
				newX = s.right - mc._width - myX;
			} else { newX = s.left + myX; }

			if ( isNaN(myY) ) {
				myY.toLowerCase();
				switch ( myY ) {
					case 'middle':
						newY = (s.height / 2) - (mc._height / 2);
						break;
					case 'top':
						newY = s.top;
						break;
					case 'bottom':
						newY = s.bottom - mc._height;
						break;
					default:
						newY = 0;
				}
			} else if ( myY < 0 ) {
				newY = s.bottom - mc._height - myY;
			} else { newY = s.top + myY; }

			mc._x = newX;
			mc._y = newY;
		}
		*/
	
		public function resize():void {
			this.graphics.beginFill( this.colour );
			this.graphics.drawRect( 0, 0, this.stage.stageWidth, this.stage.stageHeight );
		}
		
		public function die(): void {
	
			this.graphics.clear();
		}
	}
}

/* AS3JS File */
package{
		
	//removeMeIfWant flash.display.Sprite;

	class InnerBackground extends Sprite {
		private var colour:Number=0;
		private var colour_2:Number=-1;
		private var angle:Number = 90;
		
		function InnerBackground( lv:Array )
		{
			if( lv.inner_background == undefined )
				return;
				
			var vals:Array = lv.inner_background.split(",");
			
			this.colour = _root.get_colour( vals[0] );
			
			trace( this.colour)
			
			if( vals.length > 1 )
				this.colour_2 = _root.get_colour( vals[1] ); 
				
			if( vals.length > 2 )
				this.angle = Number( vals[2] );

			this.mc = _root.createEmptyMovieClip( "inner_background", _root.getNextHighestDepth() );
			
			// create shadow filter
			var dropShadow = new flash.filters.DropShadowFilter();
			dropShadow.blurX = 5;
			dropShadow.blurY = 5;
			dropShadow.distance = 5;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.5;
			// apply shadow filter
			
			// disabled for now...
			//this.mc.filters = [dropShadow];
			
		}
		
		function move( box:Box )
		{
			if( this.mc == undefined )
				return;
			
			this.mc.clear();
			this.mc.lineStyle(1, 0xFFFFFF, 0);
			
			if( this.colour_2 > -1 )
			{
				// Gradients: http://www.lukamaras.com/tutorials/actionscript/gradient-colored-movie-background-actionscript.html
				var fillType:String = "linear";
				var colors:Array = [this.colour, this.colour_2];
				var alphas:Array = [100, 100];
				var ratios:Array = [0, 255];
				var matrix = {matrixType:"box", x:0, y:0, w:box.width, h:box.height, r:this.angle/180*Math.PI};
				this.mc.beginGradientFill(fillType, colors, alphas, ratios, matrix);
			}
			else
				this.mc.beginFill( this.colour, 100);
				
				
			this.mc.moveTo(0, 0);
			this.mc.lineTo(box.width, 0);
			this.mc.lineTo(box.width, box.height);
			this.mc.lineTo(0, box.height);
			this.mc.lineTo(0, 0);
			this.mc.endFill();

			this.mc._x = box.left;
			this.mc._y = box.top;
		}
		
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant string.Utils;
	
	
	public class RadarAxis extends Sprite {
		
		private var style:Object;
		private var TO_RADIANS:Number = Math.PI / 180;
		
		private var colour:Number;
		private var grid_colour:Number;
		private var labels:RadarAxisLabels;
		private var spoke_labels:RadarSpokeLabels;
		
		function RadarAxis( json:Object )
		{
			// default values
			this.style = {
				stroke:			2,
				colour:			'#784016',
				'grid-colour':	'#F5E1AA',
				min:			0,
				max:			null,
				steps:			1
			};
			
			if( json != null )
				object_helper.merge_2( json, this.style );
				
			this.colour = Utils.get_colour( this.style.colour );
			this.grid_colour = Utils.get_colour( this.style['grid-colour'] );
			
			this.labels = new RadarAxisLabels( json.labels );
			this.addChild( this.labels );
			
			this.spoke_labels = new RadarSpokeLabels( json['spoke-labels'] );
			this.addChild( this.spoke_labels );
		}
		
		//
		// how many items in the X axis?
		//
		public function get_range():Range {
			return new Range( this.style.min, this.style.max, this.style.steps, false );
		}
		
		public function resize( sc:ScreenCoordsRadar ):void
		{
			this.x = 0;
			this.y = 0;
			this.graphics.clear();
			
			// this is going to change the radius
			this.spoke_labels.resize( sc );
			
			var count:Number = sc.get_angles();
			
			// draw the grid behind the axis
			this.draw_grid( sc, count );
			this.draw_axis( sc, count );
			
			this.labels.resize( sc );
		}
		
		private function draw_axis( sc:ScreenCoordsRadar, count:Number ): void {
			
			this.graphics.lineStyle(this.style.stroke, this.colour, 1, true);
			
			for ( var i:Number = 0; i < count; i++ ) {

				//
				// assume 0 is MIN
				//
				var p:flash.geom.Point = sc.get_get_x_from_pos_and_y_from_val( i, 0 );
				this.graphics.moveTo( p.x, p.y );
				
				var q:flash.geom.Point = sc.get_get_x_from_pos_and_y_from_val( i, sc.get_max() );
				this.graphics.lineTo( q.x, q.y );
			}
		}
		
		private function draw_grid( sc:ScreenCoordsRadar, count:Number ):void {
		
			this.graphics.lineStyle(1, this.grid_colour, 1, true);
			
			// floating point addition error:
			var max:Number = sc.get_max() + 0.00001;
			
			var r_step:Number = this.style.steps;
			var p:flash.geom.Point;
			
			//
			// start in the middle and move out drawing the grid,
			// don't draw at 0
			//
			for ( var r_pos:Number = r_step; r_pos <= max; r_pos+=r_step ) {
				
				p = sc.get_get_x_from_pos_and_y_from_val( 0, r_pos );
				this.graphics.moveTo( p.x, p.y );
				
				// draw from each spoke
				for ( var i:Number = 1; i < (count+1); i++ ) {
					
					p = sc.get_get_x_from_pos_and_y_from_val( i, r_pos );
					this.graphics.lineTo( p.x, p.y );
				}
			}
		}
		
		public function die(): void {
			
			this.style = null;
			this.labels.die();
			this.spoke_labels.die();
		
			this.graphics.clear();
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant string.Utils;
	
	public class RadarAxisLabels extends Sprite{

		private var style:Object;
		public var labels:Array;
		
		
		public function RadarAxisLabels( json:Object ) {
			
			// default values
			this.style = {
				colour:			'#784016',
				steps:			1
			};
			
			if( json != null )
				object_helper.merge_2( json, this.style );
				
			this.style.colour = Utils.get_colour( this.style.colour );
			
			// cache the text for tooltips
			this.labels = new Array();
			var values:Array;
			var ok:Boolean = false;
			
			if( ( this.style.labels is Array ) && ( this.style.labels.length > 0 ) )
			{
				
				for each( var s:Object in this.style.labels )
					this.add( s, this.style );
			}
			
		}

		public function add( label:Object, style:Object ) : void
		{
			var label_style:Object = {
				colour:		style.colour,
				text:		'',
				size:		style.size,
				visible:	true
			};

			if( label is String )
				label_style.text = label as String;
			else {
				object_helper.merge_2( label, label_style );
			}

			// our parent colour is a number, but
			// we may have our own colour:
			if( label_style.colour is String )
				label_style.colour = Utils.get_colour( label_style.colour );

			this.labels.push( label_style.text );

			//
			// inheriting the 'visible' attribute
			// is complext due to the 'steps' value
			// only some labels will be visible
			//
			if( label_style.visible == null )
			{
				//
				// some labels will be invisible due to our parents step value
				//
				if ( ( (this.labels.length - 1) % style.steps ) == 0 )
					label_style.visible = true;
				else
					label_style.visible = false;
			}

			var l:TextField = this.make_label( label_style );
			this.addChild( l );
		}
		
		public function make_label( label_style:Object ):TextField {
			
			// we create the text in its own movie clip
			
			var tf:TextField = new TextField();
            tf.x = 0;
			tf.y = 0;
			tf.text = label_style.text;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = label_style.colour;
			fmt.font = "Verdana";
			fmt.size = label_style.size;
			fmt.align = "right";
			tf.setTextFormat(fmt);
			
			tf.autoSize = "left";
			tf.visible = label_style.visible;
			return tf;
		}
		
		// move y axis labels to the correct x pos
		public function resize( sc:ScreenCoordsRadar ):void {

			var i:Number;
			var tf:TextField;
			var center:Number = sc.get_center_x();
			
			for( i=0; i<this.numChildren; i++ ) {
				// right align
				tf = this.getChildAt(i) as TextField;
				tf.x = center - tf.width;
			}
			
			// now move it to the correct Y, vertical center align
			for ( i = 0; i < this.numChildren; i++ ) {
				
				tf = this.getChildAt(i) as TextField;
				tf.y = ( sc.get_y_from_val( i, false ) - (tf.height / 2) );
			}
		}
		
		public function die(): void {
			
			this.style = null;
			this.labels = null;
			
			this.graphics.clear();
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.geom.Point;
	
	public class RadarSpokeLabels extends Sprite{

		private var style:Object;
		public var labels:Array;
		
		
		public function RadarSpokeLabels( json:Object ) {
			
			// default values
			this.style = {
				colour:			'#784016'
			};
			
			if( json != null )
				object_helper.merge_2( json, this.style );
				
			// tr.ace_json(this.style);
				
			this.style.colour = Utils.get_colour( this.style.colour );
			
			// cache the text for tooltips
			this.labels = new Array();
			var values:Array;
			var ok:Boolean = false;
			
			if( ( this.style.labels is Array ) && ( this.style.labels.length > 0 ) )
			{
				
				for each( var s:Object in this.style.labels )
					this.add( s, this.style );
			}
			
		}

		public function add( label:Object, style:Object ) : void
		{
			var label_style:Object = {
				colour:		style.colour,
				text:		'',
				size:       11
			};

			if( label is String )
				label_style.text = label as String;
			else {
				object_helper.merge_2( label, label_style );
			}

			// our parent colour is a number, but
			// we may have our own colour:
			if( label_style.colour is String )
				label_style.colour = Utils.get_colour( label_style.colour );

			this.labels.push( label_style.text );

			var l:TextField = this.make_label( label_style );
			this.addChild( l );
		}
		
		public function make_label( label_style:Object ):TextField {
			
			// we create the text in its own movie clip
			
			var tf:TextField = new TextField();
            tf.x = 0;
			tf.y = 0;
			
			var tmp:Array = label_style.text.split( '<br>' );
			var text:String = tmp.join('\n');
			
			tf.text = text;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = label_style.colour;
			fmt.font = "Verdana";
			fmt.size = label_style.size;
			fmt.align = "right";
			
			tf.setTextFormat(fmt);
			tf.autoSize = "left";
			tf.visible = true;
			
			return tf;
		}
		
		// move y axis labels to the correct x pos
		public function resize( sc:ScreenCoordsRadar ):void {

			var tf:TextField;
			//
			// loop over the lables and make sure they are on the screen,
			// reduce the radius until they fit
			//
			var i:Number = 0;
			var outside:Boolean;
			do
			{
				outside = false;
				this.resize_2( sc );
				
				for ( i = 0; i < this.numChildren; i++ )
				{
					tf = this.getChildAt(i) as TextField;
					if( (tf.x < sc.left) ||
						(tf.y < sc.top) ||
						(tf.y + tf.height > sc.bottom ) ||
						(tf.x + tf.width > sc.right)
					)
						outside = true;
				
				}
				sc.reduce_radius();
			}
			while ( outside && sc.get_radius() > 10 );
			//
			//
			//
		}
		
		private function resize_2( sc:ScreenCoordsRadar ):void {
			
			var i:Number;
			var tf:TextField;
			var mid_x:Number = sc.get_center_x();
			
			// now move it to the correct Y, vertical center align
			for ( i = 0; i < this.numChildren; i++ ) {
				
				tf = this.getChildAt(i) as TextField;

				var p:flash.geom.Point = sc.get_get_x_from_pos_and_y_from_val( i, sc.get_max() );
				if ( p.x > mid_x )
					tf.x = p.x;					// <-- right align the text
				else
					tf.x = p.x - tf.width;		// <-- left align the text
				
				if ( i == 0 ) {
					//
					// this is the top label and will overwrite
					// the radius label -- so we right align it
					// because the radius labels are left aligned
					//
					tf.y = p.y - tf.height;
					tf.x = p.x;
				}
				else
					tf.y = p.y;
			}
		}
		
		public function die(): void {
			
			this.style = null;
			this.labels = null;
			
			this.graphics.clear();
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
	}
}/* */


/* AS3JS File */
package elements.axis {
	
	//removeMeIfWant flash.display.Sprite;
    //removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.geom.Rectangle;
	
	public class AxisLabel extends TextField {
		public var xAdj:Number = 0;
		public var yAdj:Number = 0;
		public var leftOverhang:Number = 0;
		public var rightOverhang:Number = 0;
		public var xVal:Number = NaN;
		public var yVal:Number = NaN;
		
		public function AxisLabel()	{}
		
		/**
		 * Rotate the label and align it to the X Axis tick
		 * 
		 * @param	rotation
		 */
		public function rotate_and_align( rotation:Number, align:String, parent:Sprite ): void
		{ 
			rotation = rotation % 360;
			if (rotation < 0) rotation += 360;
			
			var myright:Number = this.width * Math.cos(rotation * Math.PI / 180);
			var myleft:Number = this.height * Math.cos((90 - rotation) * Math.PI / 180);
			var mytop:Number = this.height * Math.sin((90 - rotation) * Math.PI / 180);
			var mybottom:Number = this.width * Math.sin(rotation * Math.PI / 180);
			
			if (((rotation % 90) == 0) || (align == "center"))
			{
				this.xAdj = (myleft - myright) / 2;
			}
			else
			{
				this.xAdj = (rotation < 180) ? myleft / 2 : -myright + (myleft / 2);
			}

			if (rotation > 90) {
				this.yAdj = -mytop;
			}
			if (rotation > 180) {
				this.yAdj = -mytop - mybottom;
			}
			if (rotation > 270) {
				this.yAdj = - mybottom;
			}
			this.rotation = rotation;

			var titleRect:Rectangle = this.getBounds(parent);
			this.leftOverhang = Math.abs(titleRect.x + this.xAdj);
			this.rightOverhang = Math.abs(titleRect.x + titleRect.width + this.xAdj);
      }
   }
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Matrix;
	//removeMeIfWant string.Utils;
	//removeMeIfWant charts.series.bars.Bar3D;
	//removeMeIfWant com.serialization.json.JSON;
	//removeMeIfWant Range;
	
	
	public class XAxis extends Sprite {

		private var steps:Number;
		private var alt_axis_colour:Number;
		private var alt_axis_step:Number;
		private var three_d:Boolean;
		private var three_d_height:Number;
		
		private var stroke:Number;
		private var tick_height:Number;
		private var colour:Number;
		public var offset:Boolean;
		private var grid_colour:Number;
		private var grid_visible:Boolean;
		private var user_ticks:Boolean;
		private var user_labels:Array;
		
		// make this private
		public var labels:XAxisLabels;

		private var style:Object;
		
		function XAxis( json:Object, min:Number, max:Number )
		{
			// default values
			this.style = {
				stroke:			2,
				'tick-height':	3,
				colour:			'#784016',
				offset:			true,
				'grid-colour':	'#F5E1AA',
				'grid-visible':	true,
				'3d':			0,
				steps:			1,
				min:			0,
				max:			null
			};
			
			if( json != null )
				object_helper.merge_2( json.x_axis, this.style );
			
			this.calcSteps();
			
			this.stroke = this.style.stroke;
			this.tick_height = this.style['tick-height'];
			this.colour = this.style.colour;
			// is the axis offset (see ScreenCoords)
			this.offset = this.style.offset;
			this.grid_visible = this.style['grid-visible'];

			this.colour = Utils.get_colour( this.style.colour );
			this.grid_colour = Utils.get_colour( this.style['grid-colour'] );
			
				
			if( style['3d'] > 0 )
			{
				this.three_d = true;
				this.three_d_height = int( this.style['3d'] );
			}
			else
				this.three_d = false;

			// Patch from Will Henry
			if( json )
			{
				if( json.x_label_style != undefined ) {
					if( json.x_label_style.alt_axis_step != undefined )
						this.alt_axis_step = json.x_label_style.alt_axis_step;
						
					if( json.x_label_style.alt_axis_colour != undefined )
						this.alt_axis_colour = Utils.get_colour(json.x_label_style.alt_axis_colour);
				}
			}
			
			this.labels = new XAxisLabels( json );
			this.addChild( this.labels );
						
			// the X Axis labels *may* require info from
			// this.obs
			if( !this.range_set() )
			{
				//
				// the user has not told us how long the X axis
				// is, so we figure it out:
				//
				if( this.labels.need_labels ) {
					//
					// No X Axis labels set:
					//
					
					// tr.aces( 'max x', this.obs.get_min_x(), this.obs.get_max_x() );
					this.set_range( min, max );
				}
				else
				{
					//
					// X Axis labels used, even so, make the chart
					// big enough to show all values
					//
					// tr.aces('x labels', this.obs.get_min_x(), this.x_axis.labels.count(), this.obs.get_max_x());
					if ( this.labels.count() > max ) {
						
						// Data and labesl are OK
						this.set_range( 0, this.labels.count() );
					} else {
						
						// There is more data than labels -- oops
						this.set_range( min, max );
					}
				}
			}
			else
			{
				//range set, but no labels...
				this.labels.auto_label( this.get_range(), this.get_steps() );
			}
			
			// custom ticks:
			this.make_user_ticks();
		}
		
		//
		// a little hacky, but we inspect the labels
		// to see if we need to display user custom ticks
		//
		private function make_user_ticks():void {
			
			if ((this.style.labels != null) &&
				(this.style.labels.labels != null) &&
				(this.style.labels.labels is Array) &&
				(this.style.labels.labels.length > 0))
			{
				this.user_labels = new Array();
				for each( var lbl:Object in this.style.labels.labels )
				{
					if (!(lbl is String)) {
						if (lbl.x != null) 
						{
							var tmpObj:Object = { x: lbl.x };
							if (lbl["grid-colour"])
							{
								tmpObj["grid-colour"] = Utils.get_colour(lbl["grid-colour"]);
							}
							else
							{
								tmpObj["grid-colour"] = this.grid_colour;
							}
							
							this.user_ticks = true;
							this.user_labels.push(tmpObj);
						}
					}
				}
			}
		}
		
		private function calcSteps():void {
			if (this.style.max == null) {
				this.steps = 1;
			}
			else {
				var xRange:Number = this.style.max - this.style.min;
				var rev:Boolean = (this.style.min >= this.style.max); // min-max reversed?
				this.steps = ((this.style.steps != null) && 
											(this.style.steps != 0)) ? this.style.steps : 1;

				// force max of 250 labels and tick marks
				if ((Math.abs(xRange) / this.steps) > 250) this.steps = xRange / 250;

				// guarantee lblSteps is the proper sign
				this.steps = rev ? -Math.abs(this.steps) : Math.abs(this.steps);
			}
		}

		//
		// have we been passed a range? (min and max?)
		//
		public function range_set():Boolean {
			return this.style.max != null;
		}
		
		//
		// We don't have a range, so we need to calculate it.
		// grid lines, depends on number of values,
		// the X Axis labels and X min and X max
		//
		public function set_range( min:Number, max:Number ):void
		{
			this.style.min = min;
			this.style.max = max;
			// Calc new steps
			this.calcSteps();
			
			this.labels.auto_label( this.get_range(), this.get_steps() );
		}
		
		//
		// how many items in the X axis?
		//
		public function get_range():Range {
			return new Range( this.style.min, this.style.max, this.steps, this.offset );
		}
		
		public function get_steps():Number {
			return this.steps;
		}
		
		public function resize( sc:ScreenCoords, yPos:Number ):void
		{
			this.graphics.clear();
			
			//
			// Grid lines
			//
			if (this.user_ticks) 
			{
				for each( var lbl:Object in this.user_labels )
				{
					this.graphics.beginFill(lbl["grid-colour"], 1);
					var xVal:Number = sc.get_x_from_val(lbl.x);
					this.graphics.drawRect( xVal, sc.top, 1, sc.height );
					this.graphics.endFill();
				}
			}
			else if(this.grid_visible)
			{
				var rev:Boolean = (this.style.min >= this.style.max); // min-max reversed?
				var tickMax:Number = /*(rev && this.style.offset) ? this.style.max-2 : */ this.style.max
				
				for( var i:Number=this.style.min; rev ? i >= tickMax : i <= tickMax; i+=this.steps )
				{
					if( ( this.alt_axis_step > 1 ) && ( i % this.alt_axis_step == 0 ) )
						this.graphics.beginFill(this.alt_axis_colour, 1);
					else
						this.graphics.beginFill(this.grid_colour, 1);
					
					xVal = sc.get_x_from_val(i);
					this.graphics.drawRect( xVal, sc.top, 1, sc.height );
					this.graphics.endFill();
				}
			}
			
			if( this.three_d )
				this.three_d_axis( sc );
			else
				this.two_d_axis( sc );
			
			this.labels.resize( sc, yPos );
		}
			
		public function three_d_axis( sc:ScreenCoords ):void
		{
			
			// for 3D
			var h:Number = this.three_d_height;
			var offset:Number = 12;
			var x_axis_height:Number = h+offset;
			
			//
			// ticks
			var item_width:Number = sc.width / this.style.max;
		
			// turn off out lines:
			this.graphics.lineStyle(0,0,0);
			
			var w:Number = 1;

			if (this.user_ticks) 
			{
				for each( var lbl:Object in this.user_labels )
				{
					var xVal:Number = sc.get_x_from_val(lbl.x);
					this.graphics.beginFill(this.colour, 1);
					this.graphics.drawRect( xVal, sc.bottom + x_axis_height, w, this.tick_height );
					this.graphics.endFill();
				}
			}
			else
			{
				for( var i:Number=0; i < this.style.max; i+=this.steps )
				{
					var pos:Number = sc.get_x_tick_pos(i);
					
					this.graphics.beginFill(this.colour, 1);
					this.graphics.drawRect( pos, sc.bottom + x_axis_height, w, this.tick_height );
					this.graphics.endFill();
				}
			}

			
			var lighter:Number = Bar3D.Lighten( this.colour );
			
			// TOP
			var colors:Array = [this.colour,lighter];
			var alphas:Array = [100,100];
			var ratios:Array = [0,255];
		
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(sc.width_(), offset, (270 / 180) * Math.PI, sc.left-offset, sc.bottom );
			this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
			this.graphics.moveTo(sc.left,sc.bottom);
			this.graphics.lineTo(sc.right,sc.bottom);
			this.graphics.lineTo(sc.right-offset,sc.bottom+offset);
			this.graphics.lineTo(sc.left-offset,sc.bottom+offset);
			this.graphics.endFill();
		
			// front
			colors = [this.colour,lighter];
			alphas = [100,100];
			ratios = [0, 255];
			
			matrix.createGradientBox( sc.width_(), h, (270 / 180) * Math.PI, sc.left - offset, sc.bottom + offset );
			this.graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
			this.graphics.moveTo(sc.left-offset,sc.bottom+offset);
			this.graphics.lineTo(sc.right-offset,sc.bottom+offset);
			this.graphics.lineTo(sc.right-offset,sc.bottom+offset+h);
			this.graphics.lineTo(sc.left-offset,sc.bottom+offset+h);
			this.graphics.endFill();
			
			// right side
			colors = [this.colour,lighter];
			alphas = [100,100];
			ratios = [0,255];
			
		//	var matrix:Object = { matrixType:"box", x:box.left - offset, y:box.bottom + offset, w:box.width_(), h:h, r:(225 / 180) * Math.PI };
			matrix.createGradientBox( sc.width_(), h, (225 / 180) * Math.PI, sc.left - offset, sc.bottom + offset );
			this.graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
			this.graphics.moveTo(sc.right,sc.bottom);
			this.graphics.lineTo(sc.right,sc.bottom+h);
			this.graphics.lineTo(sc.right-offset,sc.bottom+offset+h);
			this.graphics.lineTo(sc.right-offset,sc.bottom+offset);
			this.graphics.endFill();
			
		}
		
		// 2D:
		public function two_d_axis( sc:ScreenCoords ):void
		{
			//
			// ticks
			var item_width:Number = sc.width / this.style.max;
			var left:Number = sc.left+(item_width/2);
		
			//this.graphics.clear();
			// Axis line:
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( this.colour );
			this.graphics.drawRect( sc.left, sc.bottom, sc.width, this.stroke );
			this.graphics.endFill();
			
			
			if (this.user_ticks) 
			{
				for each( var lbl:Object in this.user_labels )
				{
					var xVal:Number = sc.get_x_from_val(lbl.x);
					this.graphics.beginFill(this.colour, 1);
					this.graphics.drawRect( xVal-(this.stroke/2), sc.bottom + this.stroke, this.stroke, this.tick_height );
					this.graphics.endFill();
				}
			}
			else
			{
				for( var i:Number=this.style.min; i <= this.style.max; i+=this.steps )
				{
					xVal = sc.get_x_from_val(i);
					this.graphics.beginFill(this.colour, 1);
					this.graphics.drawRect( xVal-(this.stroke/2), sc.bottom + this.stroke, this.stroke, this.tick_height );
					this.graphics.endFill();
				}
			}
		}
		
		public function get_height():Number {
			if( this.three_d )
			{
				// 12 is the size of the slanty
				// 3D part of the X axis
				return this.three_d_height+12+this.tick_height + this.labels.get_height();
			}
			else
				return this.stroke + this.tick_height + this.labels.get_height();
		}
		
		public function first_label_width() : Number
		{
			return this.labels.first_label_width();
		}
		
		public function last_label_width() : Number
		{
			return this.labels.last_label_width();
		}
		
		public function die(): void {
			
			this.style = null;
		
			this.graphics.clear();
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
			
			if (this.labels != null)
				this.labels.die();
			this.labels = null;
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant flash.display.DisplayObject;
	//removeMeIfWant flash.geom.Rectangle;
	//removeMeIfWant elements.axis.AxisLabel;
	//removeMeIfWant string.Utils;
	//removeMeIfWant string.DateUtils;
	//removeMeIfWant com.serialization.json.JSON;
	// //removeMeIfWant DateUtils;
	
	public class XAxisLabels extends Sprite {
		
		public var need_labels:Boolean;
		public var axis_labels:Array;
		// JSON style:
		private var style:Object;
		private var userSpecifiedVisible:Object;
		
		//
		// Ugh, ugly code so we can rotate the text:
		//
		// [Embed(systemFont='Arial', fontName='spArial', mimeType='application/x-font', unicodeRange='U+0020-U+007E')]
		[Embed(systemFont = 'Arial', embedAsCFF='false',fontName = 'spArial', mimeType = 'application/x-font')]
		
		public static var ArialFont__:Class;

		function XAxisLabels( json:Object ) {
			
			this.need_labels = true;
			
			// TODO: remove this and the class
			// var style:XLabelStyle = new XLabelStyle( json.x_labels );
			
			this.style = {
				rotate:		0,
				visible:	null,
				labels:		null,
				text:		'#val#',	// <-- default to display the position number or x value
				steps:		null,		// <-- null for auto labels
				size:		10,
				align:		'auto',
				colour:		'#000000',
				"visible-steps":	null
			};
			
			// cache the text for tooltips
			this.axis_labels = new Array();
			
			if( ( json.x_axis != null ) && ( json.x_axis.labels != null ) )
				object_helper.merge_2( json.x_axis.labels, this.style );
				
			// save the user specified visible value foe use with auto_labels
			this.userSpecifiedVisible = this.style.visible;
			// for user provided labels, default to visible if not specified
			if (this.style.visible == null) this.style.visible = true; 
			
			// Force rotation value if "rotate" is specified
			if ( this.style.rotate is String )
			{
				if (this.style.rotate == "vertical")
				{
					this.style.rotate = 270;
				}
				else if (this.style.rotate == "diagonal")
				{
					this.style.rotate = -45;
				}
			}
			
			this.style.colour = Utils.get_colour( this.style.colour );
			
			if( ( this.style.labels is Array ) && ( this.style.labels.length > 0 ) )
			{
				//
				// we WERE passed labels
				//
				this.need_labels = false;
				if (this.style.steps == null)
					this.style.steps = 1;
				
				//
				// BUG: this should start counting at X MIN, not zero
				//
				var x:Number = 0;
				var lblCount:Number = 0;
				// Allow for only displaying some of the labels 
				var visibleSteps:Number = (this.style["visible-steps"] == null) ? this.style.steps : this.style["visible-steps"];

				for each( var s:Object in this.style.labels )
				{
					var tmpStyle:Object = { };
					object_helper.merge_2( this.style, tmpStyle );

					tmpStyle.visible = ((lblCount % visibleSteps) == 0);
					tmpStyle.x = x;
					
					// we need the x position for #x_label# tooltips
					this.add( s, tmpStyle );
					x++;
					lblCount++;
				}
			}
		}
		
		//
		// we were not passed labels and need to make
		// them from the X Axis range
		//
		public function auto_label( range:Range, steps:Number ):void {
			
			//
			// if the user has passed labels we don't do this
			//
			if ( this.need_labels ) {
				var rev:Boolean = (range.min >= range.max); // min-max reversed?

				// Use the steps specific to labels if provided by user
				var lblSteps:Number = 1;
				if (this.style.steps != null) lblSteps = this.style.steps;

				// force max of 250 labels 
				if (Math.abs(range.count() / lblSteps) > 250) lblSteps = range.count() / 250;

				// guarantee lblSteps is the proper sign
				lblSteps = rev ? -Math.abs(lblSteps) : Math.abs(lblSteps);

				// Allow for only displaying some of the labels 
				var visibleSteps:Number = (this.style["visible-steps"] == null) ? steps : this.style["visible-steps"];

				var tempStyle:Object = {};
				object_helper.merge_2( this.style, tempStyle );
				var lblCount:Number = 0;
				for ( var i:Number = range.min; rev ? i >= range.max : i <= range.max; i += lblSteps ) {
					tempStyle.x = i;
					// restore the user specified visble value
					if (this.userSpecifiedVisible == null)
					{
						tempStyle.visible = ((lblCount % visibleSteps) == 0);
						lblCount++;
					}
					else
					{
						tempStyle.visible = this.userSpecifiedVisible;
					}
					this.add( null, tempStyle );
				}
			}
		}
		
		public function add( label:Object, style:Object ) : void
		{
			
			var label_style:Object = {
				colour:		style.colour,
				text:		style.text,
				rotate:		style.rotate,
				size:		style.size,
				align:		style.align,
				visible:	style.visible,
				x:			style.x
			};

			//
			// inherit some properties from
			// our parents 'globals'
			//
			if( label is String )
				label_style.text = label as String;
			else
				object_helper.merge_2( label, label_style );
			
			// Replace magic date variables in x label text
			if (label_style.x != null) {
				label_style.text = this.replace_magic_values(label_style.text, label_style.x);
			}
			
			var lines:Array = label_style.text.split( '<br>' );
			label_style.text = lines.join( '\n' );
			
			// Map X location to label string
			this.axis_labels[label_style.x] = label_style.text;

			// only create the label if necessary
			if (label_style.visible) {
				// our parent colour is a number, but
				// we may have our own colour:
				if( label_style.colour is String )
					label_style.colour = Utils.get_colour( label_style.colour );

				var l:TextField = this.make_label( label_style );
				
				this.addChild( l );
			}
		}
		
		public function get( i:Number ) : String
		{
			if( i<this.axis_labels.length )
				return this.axis_labels[i];
			else
				return '';
		}
	
		
		public function make_label( label_style:Object ):TextField {
			// we create the text in its own movie clip, so when
			// we rotate it, we can move the regestration point
			
			var title:AxisLabel = new AxisLabel();
            title.x = 0;
			title.y = 0;
			
			//this.css.parseCSS(this.style);
			//title.styleSheet = this.css;
			title.text = label_style.text;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = label_style.colour;
		
			// TODO: != null
			if( label_style.rotate != 0 )
			{
				// so we can rotate the text
				fmt.font = "spArial";
				title.embedFonts = true;
			}
			else
			{
				fmt.font = "Verdana";
			}

			fmt.size = label_style.size;
			fmt.align = "left";
			title.setTextFormat(fmt);
			title.autoSize = "left";
			title.rotate_and_align( label_style.rotate, label_style.align, this );
			
			// we don't know the x & y locations yet...
			
			title.visible = label_style.visible;
			if (label_style.x != null)
			{
				// store the x value for use in resize
				title.xVal = label_style.x;
			}
			
			return title;
		}
		
		
		public function count() : Number
		{
			return this.axis_labels.length-1;
		}
		
		public function get_height() : Number
		{
			var height:Number = 0;
			for( var pos:Number=0; pos < this.numChildren; pos++ )
			{
				var child:DisplayObject = this.getChildAt(pos);
				height = Math.max( height, child.height );
			}
			
			return height;
		}
		
		public function resize( sc:ScreenCoords, yPos:Number ) : void
		{
			
			this.graphics.clear();
			var i:Number = 0;
			
			for( var pos:Number=0; pos < this.numChildren; pos++ )
			{
				var child:AxisLabel = this.getChildAt(pos) as AxisLabel;
				if (isNaN(child.xVal))
				{
					child.x = sc.get_x_tick_pos(pos) + child.xAdj;
				}
				else
				{
					child.x = sc.get_x_from_val(child.xVal) + child.xAdj;
				}
				child.y = yPos + child.yAdj;
			}
		}
		
		//
		// to help Box calculate the correct width:
		//
		public function last_label_width() : Number
		{
			// is the last label shown?
//			if( ( (this.labels.length-1) % style.step ) != 0 )
//				return 0;
				
			// get the width of the right most label
			// because it may stick out past the end of the graph
			// and we don't want to truncate it.
//			return this.mcs[(this.mcs.length-1)]._width;
			if ( this.numChildren > 0 )
				// this is a kludge compensating for ScreenCoords dividing the width by 2
				return AxisLabel(this.getChildAt(this.numChildren - 1)).rightOverhang * 2;
			else
				return 0;
		}
		
		// see above comments
		public function first_label_width() : Number
		{
			if( this.numChildren>0 )
				// this is a kludge compensating for ScreenCoords dividing the width by 2
				return AxisLabel(this.getChildAt(0)).leftOverhang * 2;
			else
				return 0;
		}
		
		public function die(): void {
			
			this.axis_labels = null;
			this.style = null;
			this.graphics.clear();
			
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
		
		private function replace_magic_values(labelText:String, xVal:Number):String {
			labelText = labelText.replace('#val#', NumberUtils.formatNumber(xVal));
			labelText = DateUtils.replace_magic_values(labelText, xVal);
			return labelText;
		}

	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant string.Utils;
		
	public class XLabelStyle
	{
		public var size:Number = 10;
		public var colour:Number = 0x000000;
		public var vertical:Boolean = false;
		public var diag:Boolean = false;
		public var step:Number = 1;
		public var show_labels:Boolean;

		public function XLabelStyle( json:Object )
		{
			if( !json )
				return;
				
			if( json.x_label_style == undefined )
				return;
			
			if( json.x_label_style.visible == undefined || json.x_label_style.visible )
			{
				this.show_labels = true;
				
				if( json.x_label_style.size != undefined )
					this.size = json.x_label_style.size;
					
				if( json.x_label_style.colour != undefined )
					this.colour = string.Utils.get_colour(json.x_label_style.colour);
	
				if( json.x_label_style.rotation != undefined )
				{
					this.vertical = (json.x_label_style.rotation==1);
					this.diag = (json.x_label_style.rotation==2);
				}
				
				if( json.x_label_style.step != undefined )
					this.step = json.x_label_style.step;
			}
			else
				this.show_labels = true;
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant string.Utils;
	
	public class YAxisBase extends Sprite {
		
		protected var stroke:Number;
		protected var tick_length:Number;
		protected var colour:Number;
		protected var grid_colour:Number;
		
		public var style:Object;
		
		protected var labels:YAxisLabelsBase;
		private var user_labels:Array;
		private var user_ticks:Boolean;
		
		function YAxisBase() {}
		
		public function init(range:Object, json:Object): void {}
		
		// called once the sprite has been added to the stage
		// so now it has access to the stage
		protected function _init(range:Object, json:Object, name:String, style:Object): void {
			
			this.style = style;
			
			if( json[name] )
				object_helper.merge_2( json[name], this.style );
				
			
			this.colour = Utils.get_colour( style.colour );
			this.grid_colour = Utils.get_colour( style['grid-colour'] );
			this.stroke = style.stroke;
			this.tick_length = style['tick-length'];
			
			tr.aces('YAxisBase auto', this.round_dn( range.min ), this.round_up( range.max ));
			tr.aces('YAxisBase min, max', this.style.min, this.style.max);
			
			if ( this.labels.i_need_labels )
			{
				if ( this.style.max == null && this.style.min == null ) {
					// No labels and not min, max set:
					this.style.min = this.round_dn( range.min );
					this.style.max = this.round_up( range.max );
				}
			
			}
			else
			{
				if ( this.style.max == null ) {
					// we have labels, so use the number of labels as Y MAX
					this.style.max = this.labels.y_max;
				}
			}
			
			// make sure we don't have 1,000,000 steps
			var min:Number = Math.min(this.style.min, this.style.max);
			var max:Number = Math.max(this.style.min, this.style.max);
			this.style.steps = this.get_steps(min, max, this.stage.stageHeight);
			
			if ( this.labels.i_need_labels )
				this.labels.make_labels(min, max, this.style.steps);
			
			//
			// colour the grid lines
			//
			// TODO: remove this and
			//       this.user_ticks
			//       this.user_labels
			//
			if ((this.style.labels != null) &&
				(this.style.labels.labels != null) &&
				(this.style.labels.labels is Array) &&
				(this.style.labels.labels.length > 0))
			{
				this.user_labels = new Array();
				for each( var lbl:Object in this.style.labels.labels )
				{
					if (!(lbl is String)) {
						if (lbl.y != null) 
						{
							var tmpObj:Object = { y: lbl.y };
							if (lbl["grid-colour"])
							{
								tmpObj["grid-colour"] = Utils.get_colour(lbl["grid-colour"]);
							}
							else
							{
								tmpObj["grid-colour"] = this.grid_colour;
							}
							
							this.user_ticks = true;
							this.user_labels.push(tmpObj);
						}
					}
				}
			}
		}
		
		// round so that:
		//  25.5 ==  26
		// -25.5 == -26
		
		public function round_dn(max:Number): Number {
			
			var factor:Number = 50;
			
			return Math.floor(max / factor) * factor;
		}
		
		public function round_up(max:Number): Number {
			
			var factor:Number = 50;
			
			return Math.round(max / factor) * factor;
			
			/*
			var minus:Boolean = false;
			
			if (max < 0 ) {
				max *= -1;
				minus = true;
			}
				
			var maxValue:Number = max * 1.07;
			var l:Number = Math.round(Math.log(maxValue)/Math.log(10));
			var p:Number = Math.pow(10, l) / 2;
			maxValue = Math.round((maxValue * 1.1) / p) * p;
			if (minus)
				maxValue *= -1;
				
			return maxValue;
			*/
			/**/
			
			/*
			var maxValue:Number = Math.max($bar_1->data) * 1.07;
			$l = round(log($maxValue)/log(10));
			$p = pow(10, $l) / 2;
			$maxValue = round($maxValue * 1.1 / $p) * $p;
			*/
			
			/*
			 * http://forums.openflashchart.com/viewtopic.php?f=5&t=617&start=0
			 * cdcarson
			    // y axis data...
    $counts = array_values($data);
    $ymax = max($counts);
    // add a bit of padding to the top, not strictly necessary...
    $ymax += ceil(.1 * $ymax);
    //$max_steps could be anything,depending on the height of the chart, font-size, etc..
    $max_steps = 10;
    /**
    * The step sizes to test are created using an
    * array of multipliers and a power of 10, starting at 0.
    * $step_size = $multiplier * pow(10, $exponent);
    * Assuming $multipliers = array(1, 2, 5) this would give us...
    * 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000,...
    * /
    $n = 0;
    $multipliers = array(1, 2, 5);
    $num_multipliers = count($multipliers);
    $exponent = floor($n / $num_multipliers);
    $multiplier = $multipliers[$n % $num_multipliers];
    $step_size = $multiplier * pow(10, $exponent);
    $num_steps = ceil($ymax/$step_size);
    //keep testing until we have the right step_size...
    while ($num_steps >= $max_steps){
       $n ++;
       $exponent = floor($n / $num_multipliers);
       $multiplier = $multipliers[$n % $num_multipliers];
       $step_size = $multiplier * pow(10, $exponent);
       $num_steps = ceil($ymax/$step_size);
    }
    $yaxis = new y_axis();
    $yaxis->set_range(0, $ymax, $step_size);

			 */

		}
		
		private function doMultiplier(steps:Number):Number
		{
			// TODO: This starting value will not work on decimal values: 0.001, 0.00001...
			var multiplier:Number = 0.1;
			// Multiply "multiplier" by the digits in "multiplierStep" to get a sequence of: 1, 2, 5, 10, 20, 50...
			var multiplierStep:Array = [2, 2.5, 2];
			var i:Number = 0;
			do {
				multiplier *= multiplierStep[i];
				//tr.ace("MULTIPLIER: " + multiplier + " index: " + i + " step: " + multiplierStep[i] + " steps: " + steps);
				if ((steps / multiplier) < multiplierStep[i])
					break;
				i++;
				if (i >= multiplierStep.length)
					i = 0;
			} while (true);
			return multiplier;
		} 

		public function get_style():Object { return null;  }
		
		//
		// may be called by the labels
		//
		public function set_y_max( m:Number ):void {
			this.style.max = m;
		}
		
		public function get_range():Range {
			return new Range( this.style.min, this.style.max, this.style.steps, this.style.offset );
		}
		
		public function get_width():Number {
			return this.stroke + this.tick_length + this.labels.width;
		}
		
		public function die(): void {
			
			//this.offset = null;
			this.style = null;
			if (this.labels != null) this.labels.die();
			this.labels = null;
			
			this.graphics.clear();
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
		
		private function get_steps(min:Number, max:Number, height:Number):Number {
			// try to avoid infinite loops...
			if ( this.style.steps == 0 )
				//this.style.steps = 1;
				this.style.steps = doMultiplier (Math.round((max - min) / (height / 40))); 
				
			if ( this.style.steps < 0 )
				this.style.steps *= -1;
			
			// how many steps (grid lines) do we have?
			var s:Number = (max - min) / this.style.steps;

			if ( s > (height/2) ) {
				// either no steps are set, or they are wrong and
				// we have more grid lines than pixels to show them.
				// E.g: 
				//      max = 1,001,000
				//      min =     1,000
				//      s   =   200,000
				return (max - min) / 5;
			}
			
			return this.style.steps;
		}
		
		public function resize(label_pos:Number, sc:ScreenCoords):void { }
		
		protected function resize_helper(label_pos:Number, sc:ScreenCoords, right:Boolean):void {
			
			// Set opacity for the first line to 0 (otherwise it overlaps the x-axel line)
			//
			// Bug? Does this work on graphs with minus values?
			//
			var i2:Number = 0;
			var i:Number;
			var y:Number;
			var lbl:Object;
			
			var min:Number = Math.min(this.style.min, this.style.max);
			var max:Number = Math.max(this.style.min, this.style.max);
		
			if( !right )
				this.labels.resize( label_pos, sc );
			else
				this.labels.resize( sc.right + this.stroke + this.tick_length, sc );
			
			if ( !this.style.visible )
				return;
			
			this.graphics.clear();
			this.graphics.lineStyle( 0, 0, 0 );
			
			if ( this.style['grid-visible'] )
				this.draw_grid_lines(this.style.steps, min, max, right, sc);
			
			var pos:Number;
			
			if (!right)
				pos = sc.left - this.stroke;
			else
				pos = sc.right;
			
			// Axis line:
			this.graphics.beginFill( this.colour, 1 );
			this.graphics.drawRect(
				int(pos),	// <-- pixel align
				sc.top,
				this.stroke,
				sc.height );
			this.graphics.endFill();
			
			// ticks..
			var width:Number;
			if (this.user_ticks) 
			{
				for each( lbl in this.user_labels )
				{
					y = sc.get_y_from_val(lbl.y, right);
					
					if ( !right )
						tick_pos = sc.left - this.stroke - this.tick_length;
					else
						tick_pos = sc.right + this.stroke;
					
					this.graphics.beginFill( this.colour, 1 );
					this.graphics.drawRect( tick_pos, y - (this.stroke / 2), this.tick_length, this.stroke );
					this.graphics.endFill();
				}
			}
			else
			{
				for(i=min; i<=max; i+=this.style.steps) {
					
					// start at the bottom and work up:
					y = sc.get_y_from_val(i, right);
					
					var tick_pos:Number;
					if ( !right )
						tick_pos = sc.left - this.stroke - this.tick_length;
					else
						tick_pos = sc.right + this.stroke;
					
					this.graphics.beginFill( this.colour, 1 );
					this.graphics.drawRect( tick_pos, y - (this.stroke / 2), this.tick_length, this.stroke );
					this.graphics.endFill();
				}
			}
		}
		
		private function draw_grid_lines(steps:Number, min:Number, max:Number, right:Boolean, sc:ScreenCoords): void {
			
			var y:Number;
			var lbl:Object;
			//
			// draw GRID lines
			//
			if (this.user_ticks) 
			{
				for each(lbl in this.user_labels )
				{
					y = sc.get_y_from_val(lbl.y, right);
					this.graphics.beginFill(lbl["grid-colour"], 1);
					this.graphics.drawRect( sc.left, y, sc.width, 1 );
					this.graphics.endFill();
				}
			}
			else
			{
				//
				// hack: http://kb.adobe.com/selfservice/viewContent.do?externalId=tn_13989&sliceId=1
				//
				max += 0.000004;
				
				for( var i:Number = min; i<=max; i+=steps ) {
					
					y = sc.get_y_from_val(i, right);
					this.graphics.beginFill( this.grid_colour, 1 );
					this.graphics.drawRect(
						int(sc.left),
						int(y),		// <-- make sure they are pixel aligned (2.5 - 3.5 == fuzzy lines)
						sc.width,
						1 );
					this.graphics.endFill();
				}
			}
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant elements.axis.YTextField;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant org.flashdevelop.utils.FlashConnect;
	//removeMeIfWant br.com.stimuli.string.printf;
	//removeMeIfWant string.Utils;
	
	public class YAxisLabelsBase extends Sprite {
		
		private var steps:Number;
		private var right:Boolean;
		protected var style:Object;
		public var i_need_labels:Boolean;
		protected var lblText:String;
		public var y_max:Number;
		
		public function YAxisLabelsBase(json:Object, axis_name:String) {
			var i:Number;
			var s:String;
			var values:Array;
			var steps:Number;
			
			// TODO: calculate Y max from the data
			this.y_max = 10;
			
			if( json[axis_name] )
			{
				//
				// Old crufty JSON, refactor out at some point,
				// 
				//
				if( json[axis_name].labels is Array )
				{
					values = [];
					
					// use passed in min if provided else zero
					i = (json[axis_name] && json[axis_name].min) ? json[axis_name].min : 0;
					for each( s in json[axis_name].labels )
					{
						values.push( { val:s, pos:i } );
						i++;
					}
					//
					// alter the MinMax object:
					//
					// use passed in max if provided else the number of values less 1
					this.y_max = (json[axis_name] && json[axis_name].max) ? json[axis_name].max : values.length - 1;
					this.i_need_labels = false;
				}
			}

			//
			// an object, that contains an array of objects:
			//
			if( json[axis_name] )
			{
				if ( json[axis_name].labels is Object ) 
				{
					if ( json[axis_name].labels.text is String )
						this.lblText = json[axis_name].labels.text;

					var visibleSteps:Number = 1;
					if( json[axis_name].steps is Number )
						visibleSteps = json[axis_name].steps;
						
					if( json[axis_name].labels.steps is Number )
						visibleSteps = json[axis_name].labels.steps;
					
					if ( json[axis_name].labels.labels is Array )
					{
						values = [];
						// use passed in min if provided else zero
						var label_pos:Number = (json[axis_name] && json[axis_name].min) ? json[axis_name].min : 0;
						
						for each( var obj:Object in json[axis_name].labels.labels )
						{
							if(obj is Number)
							{
								values.push( { val:lblText, pos:obj } );
								//i = (obj > i) ? obj as Number : i;
							}
							else if(obj is String)
							{
								values.push( {
									val:	obj,
									pos:	label_pos,
									visible:	((label_pos % visibleSteps) == 0)
									} );
								//i = (obj > i) ? obj as Number : i;
							}
							else if (obj.y is Number)
							{
								s = (obj.text is String) ? obj.text : lblText;
								var style:Object = { val:s, pos:obj.y }
								if (obj.colour != null)
									style.colour = obj.colour;
									
								if (obj.size != null)
									style.size = obj.size;
									
								if (obj.rotate != null)
									style.rotate = obj.rotate;
									
								values.push( style );
								//i = (obj.y > i) ? obj.y : i;
							}
							
							label_pos++;
						}
						this.i_need_labels = false;
					}
				}				
			}
			
			this.steps = steps;
			
			var lblStyle:YLabelStyle = new YLabelStyle(json, name);
			this.style = lblStyle.style;
			
			//
			// TODO: hack, if the user has not defined either left or right
			//       by default set left axis to show and right to hide.
			//
			if ( !json[axis_name] && axis_name!='y_axis' )
				this.style.show_labels = false;
			//
			//
			
			// Default to using "rotate" from the y_axis level
			if ( json[axis_name] && json[axis_name].rotate ) {
				this.style.rotate = json[axis_name].rotate;
			}

			// Next override with any values at the y_axis.labels level
			if (( json[axis_name] != null ) && 
				( json[axis_name].labels != null ) ) {
				object_helper.merge_2( json[axis_name].labels, this.style );
			}
			
			this.add_labels(values);
		}
		
		private function add_labels(values:Array): void {
			
			// are the Y Labels visible?
			if( !this.style.show_labels )
				return;
			
			// labels
			var pos:Number = 0;
			
			for each ( var v:Object in values )
			{
				var lblStyle:Object = { };
				object_helper.merge_2( this.style, lblStyle );
				object_helper.merge_2( v, lblStyle );
			
				if ( lblStyle.visible )
				{
					var tmp:YTextField = this.make_label( lblStyle );
					tmp.y_val = v.pos;
					this.addChild(tmp);
				
					pos++;
				}
			}
		}

		/**
		 * This is called from the init function, because it is only after the Sprite
		 * is added to the stagethat we know the size of the flash window and know
		 * how many ticks/labelswe auto generate
		 */
		public function make_labels(min:Number, max:Number, steps:Number): void {

			tr.aces('make_labels', this.i_need_labels, min, max, false, steps, this.lblText);
			tr.aces(this.style.show_labels);
			
			if ( !this.i_need_labels )
				return;
				
			this.i_need_labels = false;
			this.make_labels_(min, max, false, steps, this.lblText);
		}
		
		//
		// use Y Min, Y Max and Y Steps to create an array of
		// Y labels:
		//
		protected function make_labels_(min:Number, max:Number, right:Boolean, steps:Number, lblText:String):void {
			var values:Array = [];
			
			var min_:Number = Math.min( min, max );
			var max_:Number = Math.max( min, max );
			
			// hack: hack: http://kb.adobe.com/selfservice/viewContent.do?externalId=tn_13989&sliceId=1
			max_ += 0.000004;
			
			var eek:Number = 0;
			for( var i:Number = min_; i <= max_; i+=steps ) {
				values.push( { val:lblText, pos:i } );
				
				// make sure we don't generate too many labels:
				if( eek++ > 250 ) break;
			}
			
			this.add_labels(values);
		}
		
		private function make_label( lblStyle:Object ):YTextField
		{
			
			lblStyle.colour = string.Utils.get_colour(lblStyle.colour);
			
			var tf:YTextField = new YTextField();
			//tf.border = true;
			tf.text = this.replace_magic_values(lblStyle.val, lblStyle.pos);
			var fmt:TextFormat = new TextFormat();
			fmt.color = lblStyle.colour;
			fmt.font = lblStyle.rotate == "vertical" ? "spArial" : "Verdana";
			fmt.size = lblStyle.size;
			fmt.align = "right";
			tf.setTextFormat(fmt);
			tf.autoSize = "right";
			if (lblStyle.rotate == "vertical")
			{
				tf.rotation = 270;
				tf.embedFonts = true;
				tf.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			} 
			return tf;
		}

		// move y axis labels to the correct x pos
		public function resize( left:Number, sc:ScreenCoords ):void
		{
		}


		public function get_width():Number{
			var max:Number = 0;
			for( var i:Number=0; i<this.numChildren; i++ )
			{
				var tf:YTextField = this.getChildAt(i) as YTextField;
				max = Math.max( max, tf.width );
			}
			return max;
		}
		
		public function die(): void {
			
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}

		private function replace_magic_values(labelText:String, yVal:Number):String {
			labelText = labelText.replace('#val#', NumberUtils.formatNumber(yVal));
			return labelText;
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.text.TextField;
	
	public class YAxisLabelsLeft extends YAxisLabelsBase {

		public function YAxisLabelsLeft(json:Object) {
			
			this.lblText = "#val#";
			this.i_need_labels = true;
			
			super(json,'y_axis');
		}

		// move y axis labels to the correct x pos
		public override function resize( left:Number, sc:ScreenCoords ):void {
			
			var maxWidth:Number = this.get_width();
			var i:Number;
			var tf:YTextField;
			
			for( i=0; i<this.numChildren; i++ ) {
				// right align
				tf = this.getChildAt(i) as YTextField;
				tf.x = left - tf.width + maxWidth;
			}
			
			// now move it to the correct Y, vertical center align
			for ( i=0; i < this.numChildren; i++ ) {
				tf = this.getChildAt(i) as YTextField;
				if (tf.rotation != 0) {
					tf.y = sc.get_y_from_val( tf.y_val, false ) + (tf.height / 2);
				}
				else {
					tf.y = sc.get_y_from_val( tf.y_val, false ) - (tf.height / 2);
				}
				
				//
				// this is a hack so if the top
				// label is off the screen (no chart title or key set)
				// then move it down a little.
				//
				if (tf.y < 0 && sc.top == 0) // Tried setting tf.height but that didnt work 
					tf.y = (tf.rotation != 0) ? tf.height : tf.textHeight - tf.height;
			}
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.text.TextField;
	
	public class YAxisLabelsRight extends YAxisLabelsBase {
		
		public function YAxisLabelsRight(json:Object) {
			
			this.lblText = "#val#";
			this.i_need_labels = true;
	
			super(json, 'y_axis_right');
		}

		// move y axis labels to the correct x pos
		public override function resize( left:Number, box:ScreenCoords ):void {
			var maxWidth:Number = this.get_width();
			var i:Number;
			var tf:YTextField;
			
			for( i=0; i<this.numChildren; i++ ) {
				// left align
				tf = this.getChildAt(i) as YTextField;
				tf.x = left; // - tf.width + maxWidth;
			}
			
			// now move it to the correct Y, vertical center align
			for ( i=0; i < this.numChildren; i++ ) {
				tf = this.getChildAt(i) as YTextField;
				if (tf.rotation != 0) {
					tf.y = box.get_y_from_val( tf.y_val, true ) + (tf.height / 2);
				}
				else {
					tf.y = box.get_y_from_val( tf.y_val, true ) - (tf.height / 2);
				}
				if (tf.y < 0 && box.top == 0) // Tried setting tf.height but that didnt work 
					tf.y = (tf.rotation != 0) ? tf.height : tf.textHeight - tf.height;
			}
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.display.Sprite;
	
	public class YAxisLeft extends YAxisBase {

		function YAxisLeft() {}
		
		public override function init(range:Object, json:Object): void {

			this.labels = new YAxisLabelsLeft(json);
			this.addChild( this.labels );
			
			//
			// default values for a left axis
			//
			var style:Object = {
				stroke:			2,
				'tick-length':	3,
				colour:			'#784016',
				offset:			false,
				'grid-colour':	'#F5E1AA',
				'grid-visible':	true,
				'3d':			0,
				steps:			1,
				visible:		true,
				min:			null,
				max:			null
			};
			
			super._init(range, json, 'y_axis', style);
		}
		
		public override function resize( label_pos:Number, sc:ScreenCoords ):void {
			
			super.resize_helper( label_pos, sc, false);
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant flash.display.Sprite;
	
	public class YAxisRight extends YAxisBase {

		function YAxisRight() {}
		
		public override function init(range:Object, json:Object): void {
		
			this.labels = new YAxisLabelsRight(json);
			this.addChild( this.labels );
			
			//
			// default values for a right axis (turned off)
			//
			var style:Object = {
				stroke:			2,
				'tick-length':	3,
				colour:			'#784016',
				offset:			false,
				'grid-colour':	'#F5E1AA',
				'grid-visible':	false,	// <-- this is off by default for RIGHT axis
				'3d':			0,
				steps:			1,
				visible:		false,	// <-- by default this is invisible
				min:			null,
				max:			null
			};

			//
			// OK, the user has set the right Y axis,
			// but forgot to specifically set visible to
			// true, I think we can forgive them:
			//
			if( json.y_axis_right )
				style.visible = true;

			super._init(range, json, 'y_axis_right', style);
		}
		
		public override function resize( label_pos:Number, sc:ScreenCoords ):void {
			
			super.resize_helper( label_pos, sc, true);
		}
	}
}

/* AS3JS File */
package elements.axis {
	//removeMeIfWant string.Utils;
	
	public class YLabelStyle
	{
		public var style:Object;

		public function YLabelStyle( json:Object, name:String )
		{

			this.style = {	size: 10,
							colour: 0x000000,
							show_labels: true,
							visible: true
						 };

			var comma:Number;
			var none:Number;
			var tmp:Array;
			
			if( json[name+'_label_style'] == undefined )
				return;
					
			// is it CSV?
			comma = json[name+'_label_style'].lastIndexOf(',');
				
			if( comma<0 )
			{
				none = json[name+'_label_style'].lastIndexOf('none',0);
				if( none>-1 )
				{
					this.style.show_labels = false;
				}
			}
			else
			{
				tmp = json[name+'_label_style'].split(',');
				if( tmp.length > 0 )
					this.style.size = tmp[0];
					
				if( tmp.length > 1 )
					this.style.colour = Utils.get_colour(tmp[1]);
			}
		}
	}
}

/* AS3JS File */
package elements.axis {
	
	//removeMeIfWant flash.text.TextField;
	
	public class YTextField extends TextField {
		public var y_val:Number;
		
		//
		// mini class to hold the y value of the
		// Y Axis label (so we can position it later )
		//
		public function YTextField() {
			super();
			this.y_val = 0;
		}
	}
}/* */


/* AS3JS File */
package elements.labels {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.Stage;
    //removeMeIfWant flash.text.TextField;
    //removeMeIfWant flash.text.TextFieldType;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.text.TextFieldAutoSize;
	//removeMeIfWant string.Css;
	
	
	public class BaseLabel extends Sprite {
		public var text:String;
		protected var css:Css;
		public var style:String;
		protected var _height:Number;
		
		public function BaseLabel()	{}
		
		protected function build( text:String ):void {
			
			var title:TextField = new TextField();
            title.x = 0;
			title.y = 0;
			
			this.text = text;
			
			title.htmlText = this.text;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = this.css.color;
			//fmt.font = "Verdana";
			fmt.font = this.css.font_family?this.css.font_family:'Verdana';
			fmt.bold = this.css.font_weight == 'bold'?true:false;
			fmt.size = this.css.font_size;
			fmt.align = "center";
		
			title.setTextFormat(fmt);
			title.autoSize = "left";
			
			title.y = this.css.padding_top+this.css.margin_top;
			title.x = this.css.padding_left+this.css.margin_left;
			
//			title.border = true;
			
			if ( this.css.background_colour_set )
			{
				this.graphics.beginFill( this.css.background_colour, 1);
				this.graphics.drawRect(0,0,this.css.padding_left + title.width + this.css.padding_right, this.css.padding_top + title.height + this.css.padding_bottom );
				this.graphics.endFill();
			}

			this.addChild(title);
		}
		
		public function get_width():Number {
			return this.getChildAt(0).width;
		}
		
		public function die(): void {
			
			this.graphics.clear();
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
	}
}

/* AS3JS File */
package elements.labels {
	//removeMeIfWant charts.Base;
	//removeMeIfWant charts.ObjectCollection;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant org.flashdevelop.utils.FlashConnect;
	
	public class Keys extends Sprite {
		private var _height:Number = 0;
		private var count:Number = 0;
		public var colours:Array;
		
		public function Keys( stuff:ObjectCollection )
		{
			this.colours = new Array();
			
			var key:Number = 0;
			for each( var b:Base in stuff.sets )
			{
				for each( var o:Object in b.get_keys() ) {
					
					this.make_key( o.text, o['font-size'], o.colour );
					this.colours.push( o.colour );
					key++;

				}
			}
			
			this.count = key;
		}
		
		// each key is a MovieClip with text on it
		private function make_key( text:String, font_size:Number, colour:Number ) : void
		{

			var tf:TextField = new TextField();
			
			tf.text = text;
			var fmt:TextFormat = new TextFormat();
			fmt.color = colour;
			fmt.font = "Verdana";
			fmt.size = font_size;
			fmt.align = "left";
			
			tf.setTextFormat(fmt);
			tf.autoSize="left";
		
			this.addChild(tf);
		}
		
		//
		// draw the colour block for the data set
		//
		private function draw_line( x:Number, y:Number, height:Number, colour:Number ):Number {
			y += (height / 2);
			this.graphics.beginFill( colour, 100 );
			this.graphics.drawRect( x, y - 1, 10, 2 );
			this.graphics.endFill();
			return x+12;
		}

		// shuffle the keys into place, keeping note of the total
		// height the key block has taken up
		public function resize( x:Number, y:Number ):void {
			if( this.count == 0 )
				return;
			
			this.x = x;
			this.y = y;
			
			var height:Number = 0;
			var x:Number = 0;
			var y:Number = 0;
			
			this.graphics.clear();
			
			for( var i:Number=0; i<this.numChildren; i++ )
			{
				var width:Number = this.getChildAt(i).width;
				
				if( ( this.x + x + width + 12 ) > this.stage.stageWidth )
				{
					// it is past the edge of the stage, so move it down a line
					x = 0;
					y += this.getChildAt(i).height;
					height += this.getChildAt(i).height;
				}
					
				this.draw_line( x, y, this.getChildAt(i).height, this.colours[i] );
				x += 12;

				this.getChildAt(i).x = x;
				this.getChildAt(i).y = y;
				
				// move next key to the left + some padding between keys
				x += width + 10;
			}
			
			// Ugly code:
			height += this.getChildAt(0).height;
			this._height = height;
		}
		
		public function get_height() : Number {
			return this._height;
		}
		
		public function die(): void {
			
			this.colours = null;
		
			this.graphics.clear();
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
		
	}
}/* */


/* AS3JS File */
package elements.labels {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.Stage;
    //removeMeIfWant flash.text.TextField;
    //removeMeIfWant flash.text.TextFieldType;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant flash.text.StyleSheet;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.text.TextFieldAutoSize;
	//removeMeIfWant string.Css;
	//removeMeIfWant string.Utils;
	
	public class Title extends BaseLabel {
		public var colour:Number;
		public var size:Number;
		private var top_padding:Number = 0;
		
		public function Title( json:Object )
		{
			super();
				
			if( !json )
				return;
			
			// defaults:
			this.style = "font-size: 12px";
			
			object_helper.merge_2( json, this );
			
			this.css = new Css( this.style );
			this.build( this.text );
		}
		
		public function resize():void {
			if( this.text == null )
				return;
				
			this.getChildAt(0).width = this.stage.stageWidth;
			
			
			//
			// is the title aligned (text-align: xxx)?
			//
			var tmp:String = this.css.text_align;
			switch( tmp )
			{
				case 'left':
					this.x = this.css.margin_left;
					break;
						
				case 'right':
					this.x = this.stage.stageWidth - ( this.get_width() + this.css.margin_right );
					break;
						
				case 'center':
				default:
					this.x = (this.stage.stageWidth/2) - (this.get_width()/2);
					break;
			}
				
			this.y = this.css.margin_top;
		}
		
		public function get_height():Number {
			
			if ( this.text == null )
				return 0;
			else
				return this.css.padding_top+
					this.css.margin_top+
					this.getChildAt(0).height+
					this.css.padding_bottom+
					this.css.margin_bottom;
		}
	}
}

/* AS3JS File */
package elements.labels {
	//removeMeIfWant org.flashdevelop.utils.FlashConnect;
	//removeMeIfWant string.Css;
	
	public class XLegend extends BaseLabel {

		public function XLegend( json:Object )
		{
			super();
			
			if( !json )
				return;
			
			object_helper.merge_2( json, this );
			
			this.css = new Css( this.style );
			
			// call our parent constructor:
			this.build( this.text );
		}
		
		
		public function resize( sc:ScreenCoords ):void {
			if ( this.text == null )
				return;
				
			// this will center it in the X
			// this will align bottom:
			this.x = sc.left + ( (sc.width/2) - (this.get_width()/2) );
			//this.getChildAt(0).width = this.stage.stageWidth;
			this.getChildAt(0).y = this.stage.stageHeight - this.getChildAt(0).height;
		}
		
		//
		// this is only here while title has CSS and x legend does not.
		// remove this when we put css in this object
		//
		public function get_height():Number{
			// the title may be turned off:
			return this.height;
		}
	
	}
}

/* AS3JS File */
package elements.labels {
	//removeMeIfWant org.flashdevelop.utils.FlashConnect;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.Stage;
	//removeMeIfWant flash.text.*;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.text.TextFieldAutoSize;
	//removeMeIfWant flash.display.Loader;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.net.URLRequest;
	//removeMeIfWant string.Utils;
	//removeMeIfWant string.Css;


	public class YLegendBase extends Sprite {
		
		public var tf:TextField;
		
		public var text:String;
		public var style:String;
		private var css:Css;
		
//		[Embed(source = "C:\\Windows\\Fonts\\Verdana.ttf", fontFamily = "foo", fontName = '_Verdana')]
//		private static var EMBEDDED_FONT:String;
		
//		[Embed(systemFont='Arial', fontName='spArial', mimeType='application/x-font')]
//		public static var ArialFont:Class;
		
		[Embed(systemFont='Arial', embedAsCFF='false',fontName='spArial', mimeType='application/x-font')]
		public static var ArialFont:Class;
		
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
			fmt.font = "spArial";
			fmt.size = this.css.font_size;
			fmt.align = "center";
			
			title.htmlText = text;
			title.setTextFormat(fmt);
			title.autoSize = "left";
			title.embedFonts = true;
			title.rotation = 270;
			title.height = title.textHeight;
			title.antiAliasType = AntiAliasType.ADVANCED;
			title.autoSize = TextFieldAutoSize.LEFT;

			this.addChild(title);
		}
		
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
		
		public function die(): void {
			
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
	}
}

/* AS3JS File */
package elements.labels {
	
	public class YLegendLeft extends YLegendBase {
		
		public function YLegendLeft( json:Object ) {
			super( json, 'y' );
		}
		
		public override function resize():void {
			if ( this.numChildren == 0 )
				return;
			
			this.y = (this.stage.stageHeight/2)+(this.getChildAt(0).height/2);
			this.x = 0;
		}
	}
}

/* AS3JS File */
package elements.labels {
	public class YLegendRight extends YLegendBase {
		
		public function YLegendRight( json:Object ) {
			super( json, 'y2' );
		}
		
		public override function resize():void {
			if ( this.numChildren == 0 )
				return;
			
			this.y = (this.stage.stageHeight/2)+(this.getChildAt(0).height/2);
			this.x = this.stage.stageWidth-this.getChildAt(0).width;
		}
	}
}

/* AS3JS File */
package elements.menu {

	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant flash.external.ExternalInterface;
	
	//removeMeIfWant flash.text.TextField;
    //removeMeIfWant flash.text.TextFieldType;
	//removeMeIfWant flash.text.TextFormat;

	public class CameraIcon extends menuItem {
		
		public function CameraIcon(chartId:String, props:Properties) {
			super(chartId, props);
		}
		
		protected override function add_elements(): Number {
	
			this.draw_camera();
			var width:Number = this.add_text(this.props.get('text'), 35);
			
			return width+30;	// 30 is the icon width
		}
		
		private function draw_camera():void {
			
			var s:Sprite = new Sprite();
			
			s.graphics.beginFill(0x505050);
			s.graphics.drawRoundRect(2, 4, 26, 14, 2, 2);
			s.graphics.drawRect(20, 1, 5, 3);
			s.graphics.endFill();

			s.graphics.beginFill(0x202020);
			s.graphics.drawCircle(9, 11, 4.5);
			s.graphics.endFill();
			
			this.addChild(s);
			
		}
	}
}

/* AS3JS File */
package elements.menu {

	public class DefaultCameraIconProperties extends Properties
	{
		public function DefaultCameraIconProperties( json:Object ) {
			
			// the user JSON can override any of these:
			var parent:Properties = new Properties( {
				'colour':				'#0000E0',
				'text':					"Save chart",
				'javascript-function':	"save_image",
				'background-colour':	"#ffffff",
				'glow-colour':			"#148DCF",
				'text-colour':			"#0000ff"
				} );
			
			super( json, parent );
	
		}
	}
}

/* AS3JS File */
package elements.menu {

	public class DefaultMenuProperties extends Properties
	{
		public function DefaultMenuProperties( json:Object ) {
			
			// the user JSON can override any of these:
			var parent:Properties = new Properties( {
				'colour':			'#E0E0E0',
				"outline-colour":	"#707070",
				'camera-text':		"Save chart"
				} );
			
			super( json, parent );
	
		}
	}
}

/* AS3JS File */
package elements.menu {

	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant elements.menu.menuItem;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.filters.DropShadowFilter;
	
	public class Menu extends Sprite {
		
		private var original_alpha:Number;
		private var props:Properties;
		private var first_showing:Boolean;
		private var hidden_pos:Number;
		
		public function Menu( chartID:String, json:Object ) {
			
			this.props = new DefaultMenuProperties(json);
			
			this.original_alpha = 0.4;
			this.alpha = 1;
			
			var pos:Number = 5;
			var height:Number = 0;
			this.first_showing = true;
			
			for each ( var val:Object in json.values )
			{
				var tmp:DefaultCameraIconProperties = new DefaultCameraIconProperties(val);
				var menu_item:menuItem = menu_item_factory.make(chartID, tmp);
				menu_item.x = 5;
				menu_item.y = pos;
				this.addChild(menu_item);
				height = menu_item.y + menu_item.height + 5;
				pos += menu_item.height + 5;
			}
			
			var width:Number = 0;
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
				width = Math.max( width, this.getChildAt(i).width );
			
			this.draw(width+10, height);
			this.hidden_pos = height;
			
			/*
			var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
			dropShadow.blurX = 4;
			dropShadow.blurY = 4;
			dropShadow.distance = 4;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.5;
			// apply shadow filter
			this.filters = [dropShadow];
			*/
			
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function draw(width:Number, height:Number): void {
			
			this.graphics.clear();
			
			var colour:Number = string.Utils.get_colour( this.props.get('colour') );
			var o_colour:Number = string.Utils.get_colour( this.props.get('outline-colour') );
			
			this.graphics.lineStyle( 1, o_colour );
			this.graphics.beginFill(colour, 1);
			this.graphics.moveTo( 0, -2 );
			this.graphics.lineTo( 0, height );
			this.graphics.lineTo( width-25, height );
			this.graphics.lineTo( width-20, height+10 );
			this.graphics.lineTo( width, height+10 );
			this.graphics.lineTo( width, -2 );
			this.graphics.endFill();
			
			// arrows
			this.graphics.lineStyle( 1, o_colour );
			this.graphics.moveTo( width-15, height+3 );
			this.graphics.lineTo( width-10, height+8 );
			this.graphics.lineTo( width-5, height+3 );
			
			this.graphics.moveTo( width-15, height );
			this.graphics.lineTo( width-10, height+5 );
			this.graphics.lineTo( width-5, height );
			
		}
		
		public function mouseOverHandler(event:MouseEvent):void {
			Tweener.removeTweens(this);
			Tweener.addTween(this, { y:0, time:0.4, transition:Equations.easeOutBounce } );
			Tweener.addTween(this, { alpha:1, time:0.4, transition:Equations.easeOutBounce } );
		}

		public function mouseOutHandler(event:MouseEvent):void {
			this.hide_menu();
		}
		
		private function hide_menu(): void
		{
			Tweener.removeTweens(this);
			Tweener.addTween(this, { y:-this.hidden_pos, time:0.4, transition:Equations.easeOutBounce } );
			Tweener.addTween(this, { alpha:this.original_alpha, time:0.4, transition:Equations.easeOutBounce } );
		}
		
		public function resize(): void {
			
			if ( this.first_showing ) {
				this.y = 0;
				this.first_showing = false;
				Tweener.removeTweens(this);
				Tweener.addTween(this, { time:3, onComplete:this.hide_menu } );
			}
			else {
				this.y = -(this.height) + 10;
			}
			this.x = this.stage.stageWidth - this.width - 5;
			
		}
	}
}

/* AS3JS File */
package elements.menu {

	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant flash.external.ExternalInterface;
	//removeMeIfWant flash.text.TextField;
    //removeMeIfWant flash.text.TextFieldType;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant flash.filters.GlowFilter;
	//removeMeIfWant string.Utils;

	public class menuItem extends Sprite {
		
		protected var chartId:String;
		protected var props:Properties;
		
		public function menuItem(chartId:String, props:Properties) {
			
			this.props = props;
			
			this.buttonMode = true;
			this.useHandCursor = true;
			this.chartId = chartId;
			 
			this.alpha = 0.5;
			
			var width:Number = this.add_elements();
			
			this.draw_bg(
				width +
				10 // 5px padding on either side
				);
			
			this.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		protected function add_elements(): Number {
			var width:Number = this.add_text(this.props.get('text'), 5);
			return width;
		}
		
		private function draw_bg( width:Number ):void {
			this.graphics.beginFill(string.Utils.get_colour( this.props.get('background-colour') ));
			this.graphics.drawRoundRect(0, 0, width, 20, 5, 5 );
			this.graphics.endFill();
		}
		
		
		protected function add_text(text:String, left:Number): Number {
			var title:TextField = new TextField();
            title.x = left;
			title.y = 0;
			
			//this.text = 'Save chart';
			
			title.htmlText = text;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = string.Utils.get_colour( this.props.get('text-colour') );
			fmt.font = 'Verdana';
//			fmt.bold = this.css.font_weight == 'bold'?true:false;
			fmt.size = 10;// this.css.font_size;
			fmt.underline = true;
//			fmt.align = "center";
		
			title.setTextFormat(fmt);
			title.autoSize = "left";
			
			// so we don't get an I-beam cursor when we mouse
			// over the text - pass mouse messages onto the button
			title.mouseEnabled = false;
			
//			title.border = true;
			
			this.addChild(title);
			
			return title.width;
		}

		public function mouseClickHandler(event:MouseEvent):void {
			this.alpha = 0.0;
			tr.aces('Menu item clicked:', this.props.get('javascript-function')+'('+this.chartId+')');
			ExternalInterface.call(this.props.get('javascript-function'), this.chartId);
			this.alpha = 1.0;
		}

		public function mouseOverHandler(event:MouseEvent):void {
			this.alpha = 1;

			///Glow Filter
			var glow:GlowFilter = new GlowFilter();
			glow.color = string.Utils.get_colour( this.props.get('glow-colour') );
			glow.alpha = 0.8;
			glow.blurX = 4;
			glow.blurY = 4;
			glow.inner = false;
			
			this.filters = new Array(glow);
		}
		
		public function mouseDownHandler(event:MouseEvent):void {
			this.alpha = 1.0;
		}

		public function mouseOutHandler(event:MouseEvent):void {
			this.alpha = 0.5;
			this.filters = new Array();
		}
	}
}

/* AS3JS File */
package elements.menu {
	
	public class menu_item_factory {
		
		public static function make(chartID:String, style:Properties ):menuItem {
			
			switch( style.get('type') )
			{
				case 'camera-icon':
					return new CameraIcon(chartID, style);
					break;
					
				default:
					return new menuItem(chartID, style);
					break;
			}
		}
	}
}

/* AS3JS File */
package br.com.stimuli.string{

         public function printf(raw : String, ...rest) : String{
         	/**
			* Pretty ugly!
			*   basicaly
			*   % -> the start of a substitution hole
			*   (some_var_name) -> [optional] used in named substitutions
			*   .xx -> [optional] the precision with witch numbers will be formated  
			*   x -> the formatter (string, hexa, float, date part)
			*/
			var SUBS_RE : RegExp = /%(\((?P<var_name>[\w_\d]+)\))?(\.(?P<precision>[0-9]))?(?P<formater>[sxofaAbBcdHIjmMpSUwWxXyYZ])/ig;

            var matches : Array = [];
            var result : Object = SUBS_RE.exec(raw);
            var match : Match;
            var runs : int = 0;
            var numMatches : int = 0;
            var numberVariables : int = rest.length;
            // quick check if we find string subs amongst the text to match (something like %(foo)s
            var isPositionalSubts : Boolean = !Boolean(raw.match(/%\(\s*[\w\d_]+\s*\)/));
            trace(raw, isPositionalSubts);
            var replacementValue : *;
            var formater : String;
            var varName : String;
            var precision : String;
            // matched through the string, creating Match objects for easier later reuse
            while (Boolean(result)){
                match = new Match();
                match.startIndex = result.index;
                match.length = String(result[0]).length;
                match.endIndex = match.startIndex + match.length;
                match.content = String(result[0]);
                trace(match.content);
                // try to get substitution properties
                formater = result.formater;
                varName = result.var_name;
                precision = result.precision;
                
                if (isPositionalSubts){
                    // by position, grab next subs:
                    try{
                        replacementValue = rest[matches.length];        
                    }catch(e : Error){
                        throw new Error(BAD_VARIABLE_NUMBER)
                    }
                    
                }else{
                    // be hash / properties 
                    replacementValue = rest[0][varName];
                    if (replacementValue == undefined){
                        // check for bad variable names
                        var errorMsg : String = "Var name:'" + varName + "' not found on " + rest[0];
                        throw new Error(errorMsg);
                    }
                    
                    
                }
                // format the string accodingly to the formatter
                if (formater == STRING_FORMATTER){
                    match.replacement = replacementValue.toString();
                }else if (formater == FLOAT_FORMATER){
                    // floats, check if we need to truncate precision
                    if (precision){
                        match.replacement = truncateNumber(Number(replacementValue), int(precision)).toString()
                    }else{
                        match.replacement = replacementValue.toString();
                    }
                }else if (formater == OCTAL_FORMATER){
                    match.replacement = int(replacementValue).toString(8);
                }else if (formater == HEXA_FORMATER){
                    match.replacement = "0x" + int(replacementValue).toString(16);
                }else if(DATES_FORMATERS.indexOf(formater) > -1){
                    switch (formater){
                        case DATE_DAY_FORMATTER:
                            match.replacement = replacementValue.date;
                            break
                        case DATE_FULLYEAR_FORMATTER:
                            match.replacement = replacementValue.fullYear;
                            break
                        case DATE_YEAR_FORMATTER:
                            match.replacement = replacementValue.fullYear.toString().substr(2,2);
                            break
                        case DATE_MONTH_FORMATTER:
                            match.replacement = replacementValue.month + 1;
                            break
                        case DATE_HOUR24_FORMATTER:
                            match.replacement = replacementValue.hours;
                            break
                        case DATE_HOUR_FORMATTER:
                            var hours24 : Number = replacementValue.hours;
                            match.replacement =  (hours24 -12).toString();
                            break
                        case DATE_HOUR_AMPM_FORMATTER:
                            match.replacement =  (replacementValue.hours  >= 12 ? "p.m" : "a.m");
                            break
                        case DATE_TOLOCALE_FORMATTER:
                            match.replacement = replacementValue.toLocaleString();
                            break
                        case DATE_MINUTES_FORMATTER:
                            match.replacement = replacementValue.minutes;
                            break
                        case DATE_SECONDS_FORMATTER:
                            match.replacement = replacementValue.seconds;
                            break    
                    }
                }else{
                    trace("no good replacment " );
                }
                matches.push(match);
                // just a small check in case we get stuck: kludge!
                runs ++;
                if (runs > 10000){
                    trace("something is wrong, breaking out")
                    break
                }
                numMatches ++;
                // iterates next match
                result = SUBS_RE.exec(raw);
            }
            // in case there's nothing to substitute, just return the initial string
            if(matches.length == 0){
                trace("no matches, returning" );
                return raw;
            }
            // now actually do the substitution, keeping a buffer to be joined at 
            //the end for better performance
            var buffer : Array = [];
            var lastMatch : Match;  
            // beggininf os string, if it doesn't start with a substitition
            var previous : String = raw.substr(0, matches[0].startIndex);
            var subs : String;
            for each(match in matches){
                // finds out the previous string part and the next substitition
                if (lastMatch){
                    previous = raw.substring(lastMatch.endIndex  ,  match.startIndex);
                }
                buffer.push(previous);
                buffer.push(match.replacement);
                lastMatch = match;
                
            }
            // buffer the tail of the string: text after the last substitution
            buffer.push(raw.substr(match.endIndex, raw.length - match.endIndex));
            return buffer.join("");
        }


// internal usage
/** @private */
const BAD_VARIABLE_NUMBER : String = "The number of variables to be replaced and template holes don't match";
/** Converts to a string*/
const STRING_FORMATTER : String = "s";
/** Outputs as a Number, can use the precision specifier: %.2sf will output a float with 2 decimal digits.*/
const FLOAT_FORMATER : String = "f";
/** Converts to an OCTAL number */
const OCTAL_FORMATER : String = "o";
/** Converts to a Hexa number (includes 0x) */
const HEXA_FORMATER : String = "x";
/** @private */
const DATES_FORMATERS : String = "aAbBcdHIjmMpSUwWxXyYZ";
/** Day of month, from 0 to 30 on <code>Date</code> objects.*/
const DATE_DAY_FORMATTER : String = "d";
/** Full year, e.g. 2007 on <code>Date</code> objects.*/
const DATE_FULLYEAR_FORMATTER : String = "Y";
/** Year, e.g. 07 on <code>Date</code> objects.*/
const DATE_YEAR_FORMATTER : String = "y";
/** Month from 1 to 12 on <code>Date</code> objects.*/
const DATE_MONTH_FORMATTER : String = "m";
/** Hours (0-23) on <code>Date</code> objects.*/
const DATE_HOUR24_FORMATTER : String = "H";
/** Hours 0-12 on <code>Date</code> objects.*/
const DATE_HOUR_FORMATTER : String = "I";
/** a.m or p.m on <code>Date</code> objects.*/
const DATE_HOUR_AMPM_FORMATTER : String = "p";
/** Minutes on <code>Date</code> objects.*/
const DATE_MINUTES_FORMATTER : String = "M";
/** Seconds on <code>Date</code> objects.*/
const DATE_SECONDS_FORMATTER : String = "S";
/** A string rep of a <code>Date</code> object on the current locale.*/
const DATE_TOLOCALE_FORMATTER : String = "c";

var version : String = "$Id: printf.as 5 2008-08-01 12:18:25Z debert $"

  

/** @private
 * Internal class that normalizes matching information.
 */
class Match{
    public var startIndex : int;
    public var endIndex : int;
    public var length : int;
    public var content : String;
    public var replacement : String;
    public var before : String;
    public function toString() : String{
        return "Match [" + startIndex + " - " + endIndex + "] (" + length + ") " + content + ", replacement:" +replacement + ";"
    }
}
/** @private */
function truncateNumber(raw : Number, decimals :int =2) : Number {
    var power : int = Math.pow(10, decimals);
   return Math.round(raw * ( power )) / power;
}
}

/* AS3JS File */
package caurina.transitions {

	/**
	 * Generic, auxiliary functions
	 *
	 * @author		Zeh Fernando
	 * @version		1.0.0
	 * @private
	 */

	public class AuxFunctions {

		/**
		 * Gets the R (xx0000) bits from a number
		 *
		 * @param		p_num				Number		Color number (ie, 0xffff00)
		 * @return							Number		The R value
		 */
		public static function numberToR(p_num:Number):Number {
			// The initial & is meant to crop numbers bigger than 0xffffff
			return (p_num & 0xff0000) >> 16;
		}

		/**
		 * Gets the G (00xx00) bits from a number
		 *
		 * @param		p_num				Number		Color number (ie, 0xffff00)
		 * @return							Number		The G value
		 */
		public static function numberToG(p_num:Number):Number {
			return (p_num & 0xff00) >> 8;
		}

		/**
		 * Gets the B (0000xx) bits from a number
		 *
		 * @param		p_num				Number		Color number (ie, 0xffff00)
		 * @return							Number		The B value
		 */
		public static function numberToB(p_num:Number):Number {
			return (p_num & 0xff);
		}

		/**
		 * Checks whether a string is on an array
		 *
		 * @param		p_string			String		String to search for
		 * @param		p_array				Array		Array to be searched
		 * @return							Boolean		Whether the array contains the string or not
		 */
		public static function isInArray(p_string:String, p_array:Array):Boolean {
			var l:uint = p_array.length;
			for (var i:uint = 0; i < l; i++) {
				if (p_array[i] == p_string) return true;
			}
			return false;
		}

		/**
		 * Returns the number of properties an object has
		 *
		 * @param		p_object			Object		Target object with a number of properties
		 * @return							Number		Number of total properties the object has
		 */
		public static function getObjectLength(p_object:Object):uint {
			var totalProperties:uint = 0;
			for (var pName:String in p_object) totalProperties ++;
			return totalProperties;
		}
        
        /* Takes a variable number of objects as parameters and "adds" their properties, form left to right. If a latter object defines a property as null, it will be removed from the final object
    	* @param		args				Object(s)	A variable number of objects
    	* @return							Object		An object with the sum of all paremeters added as properties.
    	*/
    	public static function concatObjects(...args) : Object{
    		var finalObject : Object = {};
    		var currentObject : Object;
    		for (var i : int = 0; i < args.length; i++){
    			currentObject = args[i];
    			for (var prop : String in currentObject){
    				if (currentObject[prop] == null){
    				    // delete in case is null
    					delete finalObject[prop];
    				}else{
    					finalObject[prop] = currentObject[prop]
    				}
    			}
    		}
    		return finalObject;
    	}
	}
}/**
 * Equations
 * Main equations for the Tweener class
 *
 * @author		Zeh Fernando, Nate Chatellier
 * @version		1.0.2
 */

/*
Disclaimer for Robert Penner's Easing Equations license:

TERMS OF USE - EASING EQUATIONS

Open source under the BSD License.

Copyright © 2001 Robert Penner
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package caurina.transitions {
	
	public class Equations {
	
		/**
		 * There's no constructor.
		 * @private
		 */
		public function Equations () {
			trace ("Equations is a static class and should not be instantiated.")
		}
	
		/**
		 * Registers all the equations to the Tweener class, so they can be found by the direct string parameters.
		 * This method doesn't actually have to be used - equations can always be referenced by their full function
		 * names. But "registering" them make them available as their shorthand string names.
		 */
		public static function init():void {
			Tweener.registerTransition("easenone",			easeNone);
			Tweener.registerTransition("linear",			easeNone);		// mx.transitions.easing.None.easeNone
			
			Tweener.registerTransition("easeinquad",		easeInQuad);	// mx.transitions.easing.Regular.easeIn
			Tweener.registerTransition("easeoutquad",		easeOutQuad);	// mx.transitions.easing.Regular.easeOut
			Tweener.registerTransition("easeinoutquad",		easeInOutQuad);	// mx.transitions.easing.Regular.easeInOut
			Tweener.registerTransition("easeoutinquad",		easeOutInQuad);
			
			Tweener.registerTransition("easeincubic",		easeInCubic);
			Tweener.registerTransition("easeoutcubic",		easeOutCubic);
			Tweener.registerTransition("easeinoutcubic",	easeInOutCubic);
			Tweener.registerTransition("easeoutincubic",	easeOutInCubic);
			
			Tweener.registerTransition("easeinquart",		easeInQuart);
			Tweener.registerTransition("easeoutquart",		easeOutQuart);
			Tweener.registerTransition("easeinoutquart",	easeInOutQuart);
			Tweener.registerTransition("easeoutinquart",	easeOutInQuart);
			
			Tweener.registerTransition("easeinquint",		easeInQuint);
			Tweener.registerTransition("easeoutquint",		easeOutQuint);
			Tweener.registerTransition("easeinoutquint",	easeInOutQuint);
			Tweener.registerTransition("easeoutinquint",	easeOutInQuint);
			
			Tweener.registerTransition("easeinsine",		easeInSine);
			Tweener.registerTransition("easeoutsine",		easeOutSine);
			Tweener.registerTransition("easeinoutsine",		easeInOutSine);
			Tweener.registerTransition("easeoutinsine",		easeOutInSine);
			
			Tweener.registerTransition("easeincirc",		easeInCirc);
			Tweener.registerTransition("easeoutcirc",		easeOutCirc);
			Tweener.registerTransition("easeinoutcirc",		easeInOutCirc);
			Tweener.registerTransition("easeoutincirc",		easeOutInCirc);
			
			Tweener.registerTransition("easeinexpo",		easeInExpo);		// mx.transitions.easing.Strong.easeIn
			Tweener.registerTransition("easeoutexpo", 		easeOutExpo);		// mx.transitions.easing.Strong.easeOut
			Tweener.registerTransition("easeinoutexpo", 	easeInOutExpo);		// mx.transitions.easing.Strong.easeInOut
			Tweener.registerTransition("easeoutinexpo", 	easeOutInExpo);
			
			Tweener.registerTransition("easeinelastic", 	easeInElastic);		// mx.transitions.easing.Elastic.easeIn
			Tweener.registerTransition("easeoutelastic", 	easeOutElastic);	// mx.transitions.easing.Elastic.easeOut
			Tweener.registerTransition("easeinoutelastic", 	easeInOutElastic);	// mx.transitions.easing.Elastic.easeInOut
			Tweener.registerTransition("easeoutinelastic", 	easeOutInElastic);
			
			Tweener.registerTransition("easeinback", 		easeInBack);		// mx.transitions.easing.Back.easeIn
			Tweener.registerTransition("easeoutback", 		easeOutBack);		// mx.transitions.easing.Back.easeOut
			Tweener.registerTransition("easeinoutback", 	easeInOutBack);		// mx.transitions.easing.Back.easeInOut
			Tweener.registerTransition("easeoutinback", 	easeOutInBack);
			
			Tweener.registerTransition("easeinbounce", 		easeInBounce);		// mx.transitions.easing.Bounce.easeIn
			Tweener.registerTransition("easeoutbounce", 	easeOutBounce);		// mx.transitions.easing.Bounce.easeOut
			Tweener.registerTransition("easeinoutbounce", 	easeInOutBounce);	// mx.transitions.easing.Bounce.easeInOut
			Tweener.registerTransition("easeoutinbounce", 	easeOutInBounce);
		}

	// ==================================================================================================================================
	// TWEENING EQUATIONS functions -----------------------------------------------------------------------------------------------------
	// (the original equations are Robert Penner's work as mentioned on the disclaimer)

		/**
		 * Easing equation function for a simple linear tweening, with no easing.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeNone (t:Number, b:Number, c:Number, d:Number):Number {
			return c*t/d + b;
		}
	
		/**
		 * Easing equation function for a quadratic (t^2) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInQuad (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t + b;
		}
	
		/**
		 * Easing equation function for a quadratic (t^2) easing out: decelerating to zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutQuad (t:Number, b:Number, c:Number, d:Number):Number {
			return -c *(t/=d)*(t-2) + b;
		}
	
		/**
		 * Easing equation function for a quadratic (t^2) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInOutQuad (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2*t*t + b;
			return -c/2 * ((--t)*(t-2) - 1) + b;
		}
	
		/**
		 * Easing equation function for a quadratic (t^2) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutInQuad (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOutQuad (t*2, b, c/2, d);
			return easeInQuad((t*2)-d, b+c/2, c/2, d);
		}
	
		/**
		 * Easing equation function for a cubic (t^3) easing in: accelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInCubic (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t*t + b;
		}
	
		/**
		 * Easing equation function for a cubic (t^3) easing out: decelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutCubic (t:Number, b:Number, c:Number, d:Number):Number {
			return c*((t=t/d-1)*t*t + 1) + b;
		}
	
		/**
		 * Easing equation function for a cubic (t^3) easing in/out: acceleration until halfway, then deceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInOutCubic (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2*t*t*t + b;
			return c/2*((t-=2)*t*t + 2) + b;
		}
	
		/**
		 * Easing equation function for a cubic (t^3) easing out/in: deceleration until halfway, then acceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutInCubic (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOutCubic (t*2, b, c/2, d);
			return easeInCubic((t*2)-d, b+c/2, c/2, d);
		}
	
		/**
		 * Easing equation function for a quartic (t^4) easing in: accelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInQuart (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t*t*t + b;
		}
	
		/**
		 * Easing equation function for a quartic (t^4) easing out: decelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutQuart (t:Number, b:Number, c:Number, d:Number):Number {
			return -c * ((t=t/d-1)*t*t*t - 1) + b;
		}
	
		/**
		 * Easing equation function for a quartic (t^4) easing in/out: acceleration until halfway, then deceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInOutQuart (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
			return -c/2 * ((t-=2)*t*t*t - 2) + b;
		}
	
		/**
		 * Easing equation function for a quartic (t^4) easing out/in: deceleration until halfway, then acceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutInQuart (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOutQuart (t*2, b, c/2, d);
			return easeInQuart((t*2)-d, b+c/2, c/2, d);
		}
	
		/**
		 * Easing equation function for a quintic (t^5) easing in: accelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInQuint (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t*t*t*t + b;
		}
	
		/**
		 * Easing equation function for a quintic (t^5) easing out: decelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutQuint (t:Number, b:Number, c:Number, d:Number):Number {
			return c*((t=t/d-1)*t*t*t*t + 1) + b;
		}
	
		/**
		 * Easing equation function for a quintic (t^5) easing in/out: acceleration until halfway, then deceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInOutQuint (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
			return c/2*((t-=2)*t*t*t*t + 2) + b;
		}
	
		/**
		 * Easing equation function for a quintic (t^5) easing out/in: deceleration until halfway, then acceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutInQuint (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOutQuint (t*2, b, c/2, d);
			return easeInQuint((t*2)-d, b+c/2, c/2, d);
		}
	
		/**
		 * Easing equation function for a sinusoidal (sin(t)) easing in: accelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInSine (t:Number, b:Number, c:Number, d:Number):Number {
			return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
		}
	
		/**
		 * Easing equation function for a sinusoidal (sin(t)) easing out: decelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutSine (t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sin(t/d * (Math.PI/2)) + b;
		}
	
		/**
		 * Easing equation function for a sinusoidal (sin(t)) easing in/out: acceleration until halfway, then deceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInOutSine (t:Number, b:Number, c:Number, d:Number):Number {
			return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
		}
	
		/**
		 * Easing equation function for a sinusoidal (sin(t)) easing out/in: deceleration until halfway, then acceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutInSine (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOutSine (t*2, b, c/2, d);
			return easeInSine((t*2)-d, b+c/2, c/2, d);
		}
	
		/**
		 * Easing equation function for an exponential (2^t) easing in: accelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInExpo (t:Number, b:Number, c:Number, d:Number):Number {
			return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b - c * 0.001;
		}
	
		/**
		 * Easing equation function for an exponential (2^t) easing out: decelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutExpo (t:Number, b:Number, c:Number, d:Number):Number {
			return (t==d) ? b+c : c * 1.001 * (-Math.pow(2, -10 * t/d) + 1) + b;
		}
	
		/**
		 * Easing equation function for an exponential (2^t) easing in/out: acceleration until halfway, then deceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInOutExpo (t:Number, b:Number, c:Number, d:Number):Number {
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b - c * 0.0005;
			return c/2 * 1.0005 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
	
		/**
		 * Easing equation function for an exponential (2^t) easing out/in: deceleration until halfway, then acceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutInExpo (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOutExpo (t*2, b, c/2, d);
			return easeInExpo((t*2)-d, b+c/2, c/2, d);
		}
	
		/**
		 * Easing equation function for a circular (sqrt(1-t^2)) easing in: accelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInCirc (t:Number, b:Number, c:Number, d:Number):Number {
			return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
		}
	
		/**
		 * Easing equation function for a circular (sqrt(1-t^2)) easing out: decelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutCirc (t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
		}
	
		/**
		 * Easing equation function for a circular (sqrt(1-t^2)) easing in/out: acceleration until halfway, then deceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInOutCirc (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
			return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
		}
	
		/**
		 * Easing equation function for a circular (sqrt(1-t^2)) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutInCirc (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOutCirc (t*2, b, c/2, d);
			return easeInCirc((t*2)-d, b+c/2, c/2, d);
		}
	
		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		public static function easeInElastic (t:Number, b:Number, c:Number, d:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			var s:Number;
			if (!a || a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		}
	
		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		public static function easeOutElastic (t:Number, b:Number, c:Number, d:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			var s:Number;
			if (!a || a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
		}
	
		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		public static function easeInOutElastic (t:Number, b:Number, c:Number, d:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
			if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
			var s:Number;
			if (!a || a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
			return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
		}
	
		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		public static function easeOutInElastic (t:Number, b:Number, c:Number, d:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
			if (t < d/2) return easeOutElastic (t*2, b, c/2, d, a, p);
			return easeInElastic((t*2)-d, b+c/2, c/2, d, a, p);
		}
	
		/**
		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
		 * @return		The correct value.
		 */
		public static function easeInBack (t:Number, b:Number, c:Number, d:Number, s:Number = Number.NaN):Number {
			if (!s) s = 1.70158;
			return c*(t/=d)*t*((s+1)*t - s) + b;
		}
	
		/**
		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
		 * @return		The correct value.
		 */
		public static function easeOutBack (t:Number, b:Number, c:Number, d:Number, s:Number = Number.NaN):Number {
			if (!s) s = 1.70158;
			return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
		}
	
		/**
		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
		 * @return		The correct value.
		 */
		public static function easeInOutBack (t:Number, b:Number, c:Number, d:Number, s:Number = Number.NaN):Number {
			if (!s) s = 1.70158;
			if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
			return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
		}
	
		/**
		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
		 * @return		The correct value.
		 */
		public static function easeOutInBack (t:Number, b:Number, c:Number, d:Number, s:Number = Number.NaN):Number {
			if (t < d/2) return easeOutBack (t*2, b, c/2, d, s);
			return easeInBack((t*2)-d, b+c/2, c/2, d, s);
		}
	
		/**
		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInBounce (t:Number, b:Number, c:Number, d:Number):Number {
			return c - easeOutBounce (d-t, 0, c, d) + b;
		}
	
		/**
		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutBounce (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d) < (1/2.75)) {
				return c*(7.5625*t*t) + b;
			} else if (t < (2/2.75)) {
				return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
			} else if (t < (2.5/2.75)) {
				return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
			} else {
				return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
			}
		}
	
		/**
		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInOutBounce (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeInBounce (t*2, 0, c, d) * .5 + b;
			else return easeOutBounce (t*2-d, 0, c, d) * .5 + c*.5 + b;
		}
	
		/**
		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutInBounce (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOutBounce (t*2, b, c/2, d);
			return easeInBounce((t*2)-d, b+c/2, c/2, d);
		}
	}
}

/* AS3JS File */
package caurina.transitions {

	/**
	 * PropertyInfoObj
	 * An object containing the updating info for a given property (its starting value, and its final value)
	 *
	 * @author		Zeh Fernando
	 * @version		1.0.0
	 * @private
	 */

	public class PropertyInfoObj {
		
		public var valueStart				:Number;	// Starting value of the tweening (null if not started yet)
		public var valueComplete			:Number;	// Final desired value
		public var hasModifier				:Boolean;	// Whether or not it has a modifier function
		public var modifierFunction		:Function;	// Modifier function, if any
		public var modifierParameters		:Array;		// Additional array of modifier parameters

		// ==================================================================================================================================
		// CONSTRUCTOR function -------------------------------------------------------------------------------------------------------------

		/**
		 * Initializes the basic PropertyInfoObj.
		 * 
		 * @param	p_valueStart		Number		Starting value of the tweening (null if not started yet)
		 * @param	p_valueComplete		Number		Final (desired) property value
		 */
		function PropertyInfoObj(p_valueStart:Number, p_valueComplete:Number, p_modifierFunction:Function, p_modifierParameters:Array) {
			valueStart			=	p_valueStart;
			valueComplete		=	p_valueComplete;
			hasModifier			=	Boolean(p_modifierFunction);
			modifierFunction 	=	p_modifierFunction;
			modifierParameters	=	p_modifierParameters;
		}


		// ==================================================================================================================================
		// OTHER functions ------------------------------------------------------------------------------------------------------------------

		/**
		 * Clones this property info and returns the new PropertyInfoObj
		 *
		 * @param	omitEvents		Boolean			Whether or not events such as onStart (and its parameters) should be omitted
		 * @return 					TweenListObj	A copy of this object
		 */
		public function clone():PropertyInfoObj {
			var nProperty:PropertyInfoObj = new PropertyInfoObj(valueStart, valueComplete, modifierFunction, modifierParameters);
			return nProperty;
		}

		/**
		 * Returns this object described as a String.
		 *
		 * @return 					String		The description of this object.
		 */
		public function toString():String {
			var returnStr:String = "\n[PropertyInfoObj ";
			returnStr += "valueStart:" + String(valueStart);
			returnStr += ", ";
			returnStr += "valueComplete:" + String(valueComplete);
			returnStr += ", ";
			returnStr += "modifierFunction:" + String(modifierFunction);
			returnStr += ", ";
			returnStr += "modifierParameters:" + String(modifierParameters);
			returnStr += "]\n";
			return returnStr;
		}
		
	}

}

/* AS3JS File */
package caurina.transitions {

	//removeMeIfWant flash.filters.BitmapFilter;
	//removeMeIfWant flash.filters.BlurFilter;
//	//removeMeIfWant flash.filters.GlowFilter;
	//removeMeIfWant flash.geom.ColorTransform;
	//removeMeIfWant flash.media.SoundTransform;

	/**
	 * SpecialPropertiesDefault
	 * List of default special properties for the Tweener class
	 * The function names are strange/inverted because it makes for easier debugging (alphabetic order). They're only for internal use (on this class) anyways.
	 *
	 * @author		Zeh Fernando, Nate Chatellier
	 * @version		1.0.1
	 * @private
	 */

	public class SpecialPropertiesDefault {
	
		/**
		 * There's no constructor.
		 */
		public function SpecialPropertiesDefault () {
			trace ("SpecialProperties is a static class and should not be instantiated.")
		}
	
		/**
		 * Registers all the special properties to the Tweener class, so the Tweener knows what to do with them.
		 */
		public static function init():void {

			// Normal properties
			Tweener.registerSpecialProperty("_frame", frame_get, frame_set);
			Tweener.registerSpecialProperty("_sound_volume", _sound_volume_get, _sound_volume_set);
			Tweener.registerSpecialProperty("_sound_pan", _sound_pan_get, _sound_pan_set);
			Tweener.registerSpecialProperty("_color_ra", _color_property_get, _color_property_set, ["redMultiplier"]);
			Tweener.registerSpecialProperty("_color_rb", _color_property_get, _color_property_set, ["redOffset"]);
			Tweener.registerSpecialProperty("_color_ga", _color_property_get, _color_property_set, ["greenMultiplier"]);
			Tweener.registerSpecialProperty("_color_gb", _color_property_get, _color_property_set, ["greenOffset"]);
			Tweener.registerSpecialProperty("_color_ba", _color_property_get, _color_property_set, ["blueMultiplier"]);
			Tweener.registerSpecialProperty("_color_bb", _color_property_get, _color_property_set, ["blueOffset"]);
			Tweener.registerSpecialProperty("_color_aa", _color_property_get, _color_property_set, ["alphaMultiplier"]);
			Tweener.registerSpecialProperty("_color_ab", _color_property_get, _color_property_set, ["alphaOffset"]);
			Tweener.registerSpecialProperty("_autoAlpha", _autoAlpha_get, _autoAlpha_set);

			// Normal splitter properties
			Tweener.registerSpecialPropertySplitter("_color", _color_splitter);
			Tweener.registerSpecialPropertySplitter("_colorTransform", _colorTransform_splitter);

			// Scale splitter properties
			Tweener.registerSpecialPropertySplitter("_scale", _scale_splitter);

			// Filter tweening properties - BlurFilter
			Tweener.registerSpecialProperty("_blur_blurX", _filter_property_get, _filter_property_set, [BlurFilter, "blurX"]);
			Tweener.registerSpecialProperty("_blur_blurY", _filter_property_get, _filter_property_set, [BlurFilter, "blurY"]);
			Tweener.registerSpecialProperty("_blur_quality", _filter_property_get, _filter_property_set, [BlurFilter, "quality"]);

			// Filter tweening splitter properties
			Tweener.registerSpecialPropertySplitter("_filter", _filter_splitter);

			// Bezier modifiers
			Tweener.registerSpecialPropertyModifier("_bezier", _bezier_modifier, _bezier_get);

		}
	

		// ==================================================================================================================================
		// PROPERTY GROUPING/SPLITTING functions --------------------------------------------------------------------------------------------


		// ----------------------------------------------------------------------------------------------------------------------------------
		// _color

		/**
		 * Splits the _color parameter into specific color variables
		 *
		 * @param		p_value				Number		The original _color value
		 * @return							Array		An array containing the .name and .value of all new properties
		 */
		public static function _color_splitter (p_value:*, p_parameters:Array):Array {
			var nArray:Array = new Array();
			if (p_value == null) {
				// No parameter passed, so just resets the color
				nArray.push({name:"_color_ra", value:1});
				nArray.push({name:"_color_rb", value:0});
				nArray.push({name:"_color_ga", value:1});
				nArray.push({name:"_color_gb", value:0});
				nArray.push({name:"_color_ba", value:1});
				nArray.push({name:"_color_bb", value:0});
			} else {
				// A color tinting is passed, so converts it to the object values
				nArray.push({name:"_color_ra", value:0});
				nArray.push({name:"_color_rb", value:AuxFunctions.numberToR(p_value)});
				nArray.push({name:"_color_ga", value:0});
				nArray.push({name:"_color_gb", value:AuxFunctions.numberToG(p_value)});
				nArray.push({name:"_color_ba", value:0});
				nArray.push({name:"_color_bb", value:AuxFunctions.numberToB(p_value)});
			}
			return nArray;
		}


		// ----------------------------------------------------------------------------------------------------------------------------------
		// _colorTransform

		/**
		 * Splits the _colorTransform parameter into specific color variables
		 *
		 * @param		p_value				Number		The original _colorTransform value
		 * @return							Array		An array containing the .name and .value of all new properties
		 */
		public static function _colorTransform_splitter (p_value:*, p_parameters:Array):Array {
			var nArray:Array = new Array();
			if (p_value == null) {
				// No parameter passed, so just resets the color
				nArray.push({name:"_color_ra", value:1});
				nArray.push({name:"_color_rb", value:0});
				nArray.push({name:"_color_ga", value:1});
				nArray.push({name:"_color_gb", value:0});
				nArray.push({name:"_color_ba", value:1});
				nArray.push({name:"_color_bb", value:0});
			} else {
				// A color tinting is passed, so converts it to the object values
				if (p_value.ra != undefined) nArray.push({name:"_color_ra", value:p_value.ra});
				if (p_value.rb != undefined) nArray.push({name:"_color_rb", value:p_value.rb});
				if (p_value.ga != undefined) nArray.push({name:"_color_ba", value:p_value.ba});
				if (p_value.gb != undefined) nArray.push({name:"_color_bb", value:p_value.bb});
				if (p_value.ba != undefined) nArray.push({name:"_color_ga", value:p_value.ga});
				if (p_value.bb != undefined) nArray.push({name:"_color_gb", value:p_value.gb});
				if (p_value.aa != undefined) nArray.push({name:"_color_aa", value:p_value.aa});
				if (p_value.ab != undefined) nArray.push({name:"_color_ab", value:p_value.ab});
			}
			return nArray;
		}


		// ----------------------------------------------------------------------------------------------------------------------------------
		// scale
		public static function _scale_splitter(p_value:Number, p_parameters:Array) : Array{
			var nArray:Array = new Array();
			nArray.push({name:"scaleX", value: p_value});
			nArray.push({name:"scaleY", value: p_value});
			return nArray;
		}


		// ----------------------------------------------------------------------------------------------------------------------------------
		// filters

		/**
		 * Splits the _filter, _blur, etc parameter into specific filter variables
		 *
		 * @param		p_value				BitmapFilter	A BitmapFilter instance
		 * @return							Array			An array containing the .name and .value of all new properties
		 */
		public static function _filter_splitter (p_value:BitmapFilter, p_parameters:Array):Array {
			var nArray:Array = new Array();
			if (p_value is BlurFilter) {
				nArray.push({name:"_blur_blurX",		value:BlurFilter(p_value).blurX});
				nArray.push({name:"_blur_blurY",		value:BlurFilter(p_value).blurY});
				nArray.push({name:"_blur_quality",		value:BlurFilter(p_value).quality});
			} else {
				// ?
				trace ("??");
			}
			return nArray;
		}

		// ==================================================================================================================================
		// NORMAL SPECIAL PROPERTY functions ------------------------------------------------------------------------------------------------


		// ----------------------------------------------------------------------------------------------------------------------------------
		// _frame
	
		/**
		 * Returns the current frame number from the movieclip timeline
		 *
		 * @param		p_obj				Object		MovieClip object
		 * @return							Number		The current frame
		 */
		public static function frame_get (p_obj:Object):Number {
			return p_obj.currentFrame;
		}
	
		/**
		 * Sets the timeline frame
		 *
		 * @param		p_obj				Object		MovieClip object
		 * @param		p_value				Number		New frame number
		 */
		public static function frame_set (p_obj:Object, p_value:Number):void {
			p_obj.gotoAndStop(Math.round(p_value));
		}
	
		
		// ----------------------------------------------------------------------------------------------------------------------------------
		// _sound_volume
	
		/**
		 * Returns the current sound volume
		 *
		 * @param		p_obj				Object		Sound object
		 * @return							Number		The current volume
		 */
		public static function _sound_volume_get (p_obj:Object):Number {
			return p_obj.soundTransform.volume;
		}
	
		/**
		 * Sets the sound volume
		 *
		 * @param		p_obj				Object		Sound object
		 * @param		p_value				Number		New volume
		 */
		public static function _sound_volume_set (p_obj:Object, p_value:Number):void {
			var sndTransform:SoundTransform = p_obj.soundTransform;
			sndTransform.volume = p_value;
			p_obj.soundTransform = sndTransform;
		}
	
	
		// ----------------------------------------------------------------------------------------------------------------------------------
		// _sound_pan
	
		/**
		 * Returns the current sound pan
		 *
		 * @param		p_obj				Object		Sound object
		 * @return							Number		The current pan
		 */
		public static function _sound_pan_get (p_obj:Object):Number {
			return p_obj.soundTransform.pan;
		}
	
		/**
		 * Sets the sound volume
		 *
		 * @param		p_obj				Object		Sound object
		 * @param		p_value				Number		New pan
		 */
		public static function _sound_pan_set (p_obj:Object, p_value:Number):void {
			var sndTransform:SoundTransform = p_obj.soundTransform;
			sndTransform.pan = p_value;
			p_obj.soundTransform = sndTransform;
		}


		// ----------------------------------------------------------------------------------------------------------------------------------
		// _color_*

		/**
		 * _color_*
		 * Generic function for the ra/rb/ga/gb/ba/bb/aa/ab components of the colorTransform object
		 */
		public static function _color_property_get (p_obj:Object, p_parameters:Array):Number {
			return p_obj.transform.colorTransform[p_parameters[0]];
		}
		public static function _color_property_set (p_obj:Object, p_value:Number, p_parameters:Array):void {
			var tf:ColorTransform = p_obj.transform.colorTransform;
			tf[p_parameters[0]] = p_value;
			p_obj.transform.colorTransform = tf;
		}


		// ----------------------------------------------------------------------------------------------------------------------------------
		// _autoAlpha
	
		/**
		 * Returns the current alpha
		 *
		 * @param		p_obj				Object		MovieClip or Textfield object
		 * @return							Number		The current alpha
		 */
		public static function _autoAlpha_get (p_obj:Object):Number {
			return p_obj.alpha;
		}
	
		/**
		 * Sets the current autoAlpha
		 *
		 * @param		p_obj				Object		MovieClip or Textfield object
		 * @param		p_value				Number		New alpha
		 */
		public static function _autoAlpha_set (p_obj:Object, p_value:Number):void {
			p_obj.alpha = p_value;
			p_obj.visible = p_value > 0;
		}


		// ----------------------------------------------------------------------------------------------------------------------------------
		// filters

		/**
		 * (filters)
		 * Generic function for the properties of filter objects
		 */
		public static function _filter_property_get (p_obj:Object, p_parameters:Array):Number {
			var f:Array = p_obj.filters;
			var i:uint;
			var filterClass:Object = p_parameters[0];
			var propertyName:String = p_parameters[1];
			for (i = 0; i < f.length; i++) {
				if (f[i] is BlurFilter && filterClass == BlurFilter) return (f[i][propertyName]);
			}
			
			// No value found for this property - no filter instance found using this class!
			// Must return default desired values
			var defaultValues:Object;
			switch (filterClass) {
				case BlurFilter:
					defaultValues = {blurX:0, blurY:0, quality:NaN};
					break;
			}
			// When returning NaN, the Tweener engine sets the starting value as being the same as the final value
			// When returning null, the Tweener engine doesn't tween it at all, just setting it to the final value
			return defaultValues[propertyName];
		}

		public static function _filter_property_set (p_obj:Object, p_value:Number, p_parameters:Array): void {
			var f:Array = p_obj.filters;
			var i:uint;
			var filterClass:Object = p_parameters[0];
			var propertyName:String = p_parameters[1];
			for (i = 0; i < f.length; i++) {
				if (f[i] is BlurFilter && filterClass == BlurFilter) {
					f[i][propertyName] = p_value;
					p_obj.filters = f;
					return;
				}
			}

			// The correct filter class wasn't found - create a new one
			if (f == null) f = new Array();
			var fi:BitmapFilter;
			switch (filterClass) {
				case BlurFilter:
					fi = new BlurFilter(0, 0);
					break;
			}
			fi[propertyName] = p_value;
			f.push(fi);
			p_obj.filters = f;
		}


		// ==================================================================================================================================
		// SPECIAL PROPERTY MODIFIER functions ----------------------------------------------------------------------------------------------


		// ----------------------------------------------------------------------------------------------------------------------------------
		// _bezier

		/**
		 * Given the parameter object passed to this special property, return an array listing the properties that should be modified, and their parameters
		 *
		 * @param		p_obj				Object		Parameter passed to this property
		 * @return							Array		Array listing name and parameter of each property
		 */
		public static function _bezier_modifier (p_obj:*):Array {
			var mList:Array = []; // List of properties to be modified
			var pList:Array; // List of parameters passed, normalized as an array
			if (p_obj is Array) {
				// Complex
				pList = p_obj;
			} else {
				pList = [p_obj];
			}

			var i:uint;
			var istr:String;
			var mListObj:Object = {}; // Object describing each property name and parameter

			for (i = 0; i < pList.length; i++) {
				for (istr in pList[i]) {
					if (mListObj[istr] == undefined) mListObj[istr] = [];
					mListObj[istr].push(pList[i][istr]);
				}
			}
			for (istr in mListObj) {
				mList.push({name:istr, parameters:mListObj[istr]});
			}
			return mList;
		}

		/**
		 * Given tweening specifications (beging, end, t), applies the property parameter to it, returning new t
		 *
		 * @param		b					Number		Beginning value of the property
		 * @param		e					Number		Ending (desired) value of the property
		 * @param		t					Number		Current t of this tweening (0-1), after applying the easing equation
		 * @param		p					Array		Array of parameters passed to this specific property
		 * @return							Number		New t, with the p parameters applied to it
		 */
		public static function _bezier_get (b:Number, e:Number, t:Number, p:Array):Number {
			// This is based on Robert Penner's code
			if (p.length == 1) {
				// Simple curve with just one bezier control point
				return b + t*(2*(1-t)*(p[0]-b) + t*(e - b));
			} else {
				// Array of bezier control points, must find the point between each pair of bezier points
				var ip:uint = Math.floor(t * p.length); // Position on the bezier list
				var it:Number = (t - (ip * (1 / p.length))) * p.length; // t inside this ip
				var p1:Number, p2:Number;
				if (ip == 0) {
					// First part: belongs to the first control point, find second midpoint
					p1 = b;
					p2 = (p[0]+p[1])/2;
				} else if (ip == p.length - 1) {
					// Last part: belongs to the last control point, find first midpoint
					p1 = (p[ip-1]+p[ip])/2;
					p2 = e;
				} else {
					// Any middle part: find both midpoints
					p1 = (p[ip-1]+p[ip])/2;
					p2 = (p[ip]+p[ip+1])/2;
				}
				return p1+it*(2*(1-it)*(p[ip]-p1) + it*(p2 - p1));
			}
		}

	}
}

/* AS3JS File */
package caurina.transitions {
	
	/**
	 * SpecialProperty
	 * A kind of a getter/setter for special properties
	 *
	 * @author		Zeh Fernando
	 * @version		1.0.0
	 * @private
	 */

	public class SpecialProperty {
	
		public var getValue:Function;
		public var setValue:Function;
		public var parameters:Array;

		/**
		 * Builds a new special property object.
		 * 
		 * @param		p_getFunction		Function	Reference to the function used to get the special property value
		 * @param		p_setFunction		Function	Reference to the function used to set the special property value
		 */
		public function SpecialProperty (p_getFunction:Function, p_setFunction:Function, p_parameters:Array = null) {
			getValue = p_getFunction;
			setValue = p_setFunction;
			parameters = p_parameters;
		}
	
		/**
		 * Converts the instance to a string that can be used when trace()ing the object
		 */
		public function toString():String {
			var value:String = "";
			value += "[SpecialProperty ";
			value += "getValue:"+String(getValue); // .toString();
			value += ", ";
			value += "setValue:"+String(setValue); // .toString();
			value += ", ";
			value += "parameters:"+String(parameters); // .toString();
			value += "]";
			return value;
		}
	}
}

/* AS3JS File */
package caurina.transitions {

	/**
	 * SpecialPropertyModifier
	 * A special property which actually acts on other properties
	 *
	 * @author		Zeh Fernando
	 * @version		1.0.0
	 * @private
	 */

	public class SpecialPropertyModifier {

		public var modifyValues:Function;
		public var getValue:Function;

		/**
		 * Builds a new special property modifier object.
		 * 
		 * @param		p_modifyFunction		Function		Function that returns the modifider parameters.
		 */
		public function SpecialPropertyModifier (p_modifyFunction:Function, p_getFunction:Function) {
			modifyValues = p_modifyFunction;
			getValue = p_getFunction;
		}

	/**
	 * Converts the instance to a string that can be used when trace()ing the object
	 */
	public function toString():String {
		var value:String = "";
		value += "[SpecialPropertyModifier ";
		value += "modifyValues:"+String(modifyValues);
		value += ", ";
		value += "getValue:"+String(getValue);
		value += "]";
		return value;
	}

	}

}

/* AS3JS File */
package caurina.transitions {

	/**
	 * SpecialPropertySplitter
	 * A proxy setter for special properties
	 *
	 * @author		Zeh Fernando
	 * @version		1.0.0
	 * @private
	 */

	public class SpecialPropertySplitter {

		public var parameters:Array;
		public var splitValues:Function;

		/**
		 * Builds a new group special property object.
		 *
		 * @param		p_splitFunction		Function	Reference to the function used to split a value
		 */
		public function SpecialPropertySplitter (p_splitFunction:Function, p_parameters:Array) {
			splitValues = p_splitFunction;
		}

		/**
		 * Converts the instance to a string that can be used when trace()ing the object
		 */
		public function toString():String {
			var value:String = "";
			value += "[SpecialPropertySplitter ";
			value += "splitValues:"+String(splitValues); // .toString();
			value += ", ";
			value += "parameters:"+String(parameters);
			value += "]";
			return value;
		}

	}

}
/**
 * Tweener
 * Transition controller for movieclips, sounds, textfields and other objects
 *
 * @author		Zeh Fernando, Nate Chatellier, Arthur Debert
 * @version		1.26.62
 */

/*
Licensed under the MIT License

Copyright (c) 2006-2007 Zeh Fernando and Nate Chatellier

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

http://code.google.com/p/tweener/
http://code.google.com/p/tweener/wiki/License
*/


/* AS3JS File */
package caurina.transitions {
	
	//removeMeIfWant flash.display.*;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.utils.getTimer;

	public class Tweener {
	
		private static var __tweener_controller__:MovieClip;	// Used to ensure the stage copy is always accessible (garbage collection)
		
		private static var _engineExists:Boolean = false;		// Whether or not the engine is currently running
		private static var _inited:Boolean = false;				// Whether or not the class has been initiated
		private static var _currentTime:Number;					// The current time. This is generic for all tweenings for a "time grid" based update
	
		private static var _tweenList:Array;					// List of active tweens
	
		private static var _timeScale:Number = 1;				// Time scale (default = 1)
	
		private static var _transitionList:Object;				// List of "pre-fetched" transition functions
		private static var _specialPropertyList:Object;			// List of special properties
		private static var _specialPropertyModifierList:Object;	// List of special property modifiers
		private static var _specialPropertySplitterList:Object;	// List of special property splitters

	
		/**
		 * There's no constructor.
		 * @private
		 */
		public function Tweener () {
			trace ("Tweener is a static class and should not be instantiated.")
		}

		// ==================================================================================================================================
		// TWEENING CONTROL functions -------------------------------------------------------------------------------------------------------

		/**
		 * Adds a new tweening.
		 *
		 * @param		(first-n param)		Object				Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
		 * @param		(last param)		Object				Object containing the specified parameters in any order, as well as the properties that should be tweened and their values
		 * @param		.time				Number				Time in seconds or frames for the tweening to take (defaults 2)
		 * @param		.delay				Number				Delay time (defaults 0)
		 * @param		.useFrames			Boolean				Whether to use frames instead of seconds for time control (defaults false)
		 * @param		.transition			String/Function		Type of transition equation... (defaults to "easeoutexpo")
		 * @param		.onStart			Function			* Direct property, See the TweenListObj class
		 * @param		.onUpdate			Function			* Direct property, See the TweenListObj class
		 * @param		.onComplete			Function			* Direct property, See the TweenListObj class
		 * @param		.onOverwrite		Function			* Direct property, See the TweenListObj class
		 * @param		.onStartParams		Array				* Direct property, See the TweenListObj class
		 * @param		.onUpdateParams		Array				* Direct property, See the TweenListObj class
		 * @param		.onCompleteParams	Array				* Direct property, See the TweenListObj class
		 * @param		.onOverwriteParams	Array				* Direct property, See the TweenListObj class
		 * @param		.rounded			Boolean				* Direct property, See the TweenListObj class
		 * @param		.skipUpdates		Number				* Direct property, See the TweenListObj class
		 * @return							Boolean				TRUE if the tween was successfully added, FALSE if otherwise
		 */
		public static function addTween (p_arg1:Object = null, p_arg2:Object = null):Boolean {
			if (arguments.length < 2 || arguments[0] == undefined) return false;
	
			var rScopes:Array = new Array(); // List of objects to tween
			var i:Number, j:Number, istr:String, jstr:String;
	
			if (arguments[0] is Array) {
				// The first argument is an array
				for (i = 0; i<arguments[0].length; i++) rScopes.push(arguments[0][i]);
			} else {
				// The first argument(s) is(are) object(s)
				for (i = 0; i<arguments.length-1; i++) rScopes.push(arguments[i]);
			}
			// rScopes = arguments.concat().splice(1); // Alternate (should be tested for speed later)
	
			// make properties chain ("inheritance")
    		var p_obj:Object = TweenListObj.makePropertiesChain(arguments[arguments.length-1]);
	
			// Creates the main engine if it isn't active
			if (!_inited) init();
			if (!_engineExists || !Boolean(__tweener_controller__)) startEngine(); // Quick fix for Flash not resetting the vars on double ctrl+enter...
	
			// Creates a "safer", more strict tweening object
			var rTime:Number = (isNaN(p_obj.time) ? 0 : p_obj.time); // Real time
			var rDelay:Number = (isNaN(p_obj.delay) ? 0 : p_obj.delay); // Real delay
	
			// Creates the property list; everything that isn't a hardcoded variable
			var rProperties:Array = new Array(); // array containing object { .name, .valueStart, .valueComplete }
			var restrictedWords:Object = {time:true, delay:true, useFrames:true, skipUpdates:true, transition:true, onStart:true, onUpdate:true, onComplete:true, onOverwrite:true, rounded:true, onStartParams:true, onUpdateParams:true, onCompleteParams:true, onOverwriteParams:true};
			var modifiedProperties:Object = new Object();
			for (istr in p_obj) {
				if (!restrictedWords[istr]) {
					// It's an additional pair, so adds
					if (_specialPropertySplitterList[istr]) {
						// Special property splitter
						var splitProperties:Array = _specialPropertySplitterList[istr].splitValues(p_obj[istr], _specialPropertySplitterList[istr].parameters);
						for (i = 0; i < splitProperties.length; i++) {
							rProperties[splitProperties[i].name] = {valueStart:undefined, valueComplete:splitProperties[i].value};
						}
					} else if (_specialPropertyModifierList[istr] != undefined) {
						// Special property modifier
						var tempModifiedProperties:Array = _specialPropertyModifierList[istr].modifyValues(p_obj[istr]);
						for (i = 0; i < tempModifiedProperties.length; i++) {
							modifiedProperties[tempModifiedProperties[i].name] = {modifierParameters:tempModifiedProperties[i].parameters, modifierFunction:_specialPropertyModifierList[istr].getValue};
						}
					} else {
						// Regular property or special property, just add the property normally
						rProperties[istr] = {valueStart:undefined, valueComplete:p_obj[istr]};
					}
				}
			}
	
			// Adds the modifiers to the list of properties
			for (istr in modifiedProperties) {
				if (rProperties[istr] != undefined) {
					rProperties[istr].modifierParameters = modifiedProperties[istr].modifierParameters;
					rProperties[istr].modifierFunction = modifiedProperties[istr].modifierFunction;
				}
				
			}

			var rTransition:Function; // Real transition
	
			if (typeof p_obj.transition == "string") {
				// String parameter, transition names
				var trans:String = p_obj.transition.toLowerCase();
				rTransition = _transitionList[trans];
			} else {
				// Proper transition function
				rTransition = p_obj.transition;
			}
			if (!Boolean(rTransition)) rTransition = _transitionList["easeoutexpo"];
	
			var nProperties:Object;
			var nTween:TweenListObj;
			var myT:Number;
	
			for (i = 0; i < rScopes.length; i++) {
				// Makes a copy of the properties
				nProperties = new Object();
				for (istr in rProperties) {
					nProperties[istr] = new PropertyInfoObj(rProperties[istr].valueStart, rProperties[istr].valueComplete, rProperties[istr].modifierFunction, rProperties[istr].modifierParameters);
				}
				
				nTween = new TweenListObj(
					/* scope			*/	rScopes[i],
					/* timeStart		*/	_currentTime + ((rDelay * 1000) / _timeScale),
					/* timeComplete		*/	_currentTime + (((rDelay * 1000) + (rTime * 1000)) / _timeScale),
					/* useFrames		*/	(p_obj.useFrames == true),
					/* transition		*/	rTransition
				);
				
				nTween.properties			=	nProperties;
				nTween.onStart				=	p_obj.onStart;
				nTween.onUpdate				=	p_obj.onUpdate;
				nTween.onComplete			=	p_obj.onComplete;
				nTween.onOverwrite			=	p_obj.onOverwrite;
				nTween.onError			    =	p_obj.onError;
				nTween.onStartParams		=	p_obj.onStartParams;
				nTween.onUpdateParams		=	p_obj.onUpdateParams;
				nTween.onCompleteParams		=	p_obj.onCompleteParams;
				nTween.onOverwriteParams	=	p_obj.onOverwriteParams;
				nTween.rounded				=	p_obj.rounded;
				nTween.skipUpdates			=	p_obj.skipUpdates;

				// Remove other tweenings that occur at the same time
				removeTweensByTime(nTween.scope, nTween.properties, nTween.timeStart, nTween.timeComplete);
	
				// And finally adds it to the list
				_tweenList.push(nTween);
	
				// Immediate update and removal if it's an immediate tween -- if not deleted, it executes at the end of this frame execution
				if (rTime == 0 && rDelay == 0) {
					myT = _tweenList.length-1;
					updateTweenByIndex(myT);
					removeTweenByIndex(myT);
				}
			}
	
			return true;
		}
	
		// A "caller" is like this: [          |     |  | ||] got it? :)
		// this function is crap - should be fixed later/extend on addTween()
	
		/**
		 * Adds a new caller tweening.
		 *
		 * @param		(first-n param)		Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
		 * @param		(last param)		Object containing the specified parameters in any order, as well as the properties that should be tweened and their values
		 * @param		.time				Number				Time in seconds or frames for the tweening to take (defaults 2)
		 * @param		.delay				Number				Delay time (defaults 0)
		 * @param		.count				Number				Number of times this caller should be called
		 * @param		.transition			String/Function		Type of transition equation... (defaults to "easeoutexpo")
		 * @param		.onStart			Function			Event called when tween starts
		 * @param		.onUpdate			Function			Event called when tween updates
		 * @param		.onComplete			Function			Event called when tween ends
		 * @param		.waitFrames			Boolean				Whether to wait (or not) one frame for each call
		 * @return							<code>true</code> if the tween was successfully added, <code>false</code> if otherwise.
		 */
		public static function addCaller (p_arg1:Object = null, p_arg2:Object = null):Boolean {
			if (arguments.length < 2 || arguments[0] == undefined) return false;
	
			var rScopes:Array = new Array(); // List of objects to tween
			var i:Number, j:Number;
	
			if (arguments[0] is Array) {
				// The first argument is an array
				for (i = 0; i<arguments[0].length; i++) rScopes.push(arguments[0][i]);
			} else {
				// The first argument(s) is(are) object(s)
				for (i = 0; i<arguments.length-1; i++) rScopes.push(arguments[i]);
			}
			// rScopes = arguments.concat().splice(1); // Alternate (should be tested for speed later)
	
			var p_obj:Object = arguments[arguments.length-1];
	
			// Creates the main engine if it isn't active
			if (!_inited) init();
			if (!_engineExists || !Boolean(__tweener_controller__)) startEngine(); // Quick fix for Flash not resetting the vars on double ctrl+enter...
	
			// Creates a "safer", more strict tweening object
			var rTime:Number = (isNaN(p_obj.time) ? 0 : p_obj.time); // Real time
			var rDelay:Number = (isNaN(p_obj.delay) ? 0 : p_obj.delay); // Real delay
	
			var rTransition:Function; // Real transition
			if (typeof p_obj.transition == "string") {
				// String parameter, transition names
				var trans:String = p_obj.transition.toLowerCase();
				rTransition = _transitionList[trans];
			} else {
				// Proper transition function
				rTransition = p_obj.transition;
			}
			if (!Boolean(rTransition)) rTransition = _transitionList["easeoutexpo"];
	
			var nTween:TweenListObj;
			var myT:Number;
			for (i = 0; i < rScopes.length; i++) {
				
				nTween = new TweenListObj(
					/* Scope			*/	rScopes[i],
					/* TimeStart		*/	_currentTime + ((rDelay * 1000) / _timeScale),
					/* TimeComplete		*/	_currentTime + (((rDelay * 1000) + (rTime * 1000)) / _timeScale),
					/* UseFrames		*/	(p_obj.useFrames == true),
					/* Transition		*/	rTransition
				);

				nTween.properties			=	null;
				nTween.onStart				=	p_obj.onStart;
				nTween.onUpdate				=	p_obj.onUpdate;
				nTween.onComplete			=	p_obj.onComplete;
				nTween.onOverwrite			=	p_obj.onOverwrite;
				nTween.onStartParams		=	p_obj.onStartParams;
				nTween.onUpdateParams		=	p_obj.onUpdateParams;
				nTween.onCompleteParams		=	p_obj.onCompleteParams;
				nTween.onOverwriteParams	=	p_obj.onOverwriteParams;
				nTween.isCaller				=	true;
				nTween.count				=	p_obj.count;
				nTween.waitFrames			=	p_obj.waitFrames;

				// And finally adds it to the list
				_tweenList.push(nTween);
	
				// Immediate update and removal if it's an immediate tween -- if not deleted, it executes at the end of this frame execution
				if (rTime == 0 && rDelay == 0) {
					myT = _tweenList.length-1;
					updateTweenByIndex(myT);
					removeTweenByIndex(myT);
				}
			}
	
			return true;
		}
	
		/**
		 * Remove an specified tweening of a specified object the tweening list, if it conflicts with the given time.
		 *
		 * @param		p_scope				Object						List of objects affected
		 * @param		p_properties		Object 						List of properties affected (PropertyInfoObj instances)
		 * @param		p_timeStart			Number						Time when the new tween starts
		 * @param		p_timeComplete		Number						Time when the new tween ends
		 * @return							Boolean						Whether or not it actually deleted something
		 */
		public static function removeTweensByTime (p_scope:Object, p_properties:Object, p_timeStart:Number, p_timeComplete:Number):Boolean {
			var removed:Boolean = false;
			var removedLocally:Boolean;
	
			var i:uint;
			var tl:uint = _tweenList.length;
			var pName:String;

			for (i = 0; i < tl; i++) {
				if (Boolean(_tweenList[i]) && p_scope == _tweenList[i].scope) {
					// Same object...
					if (p_timeComplete > _tweenList[i].timeStart && p_timeStart < _tweenList[i].timeComplete) {
						// New time should override the old one...
						removedLocally = false;
						for (pName in _tweenList[i].properties) {
							if (Boolean(p_properties[pName])) {
								// Same object, same property
								// Finally, remove this old tweening and use the new one
								if (Boolean(_tweenList[i].onOverwrite)) {
									try {
										_tweenList[i].onOverwrite.apply(_tweenList[i].scope, _tweenList[i].onOverwriteParams);
									} catch(e:Error) {
										handleError(_tweenList[i], e, "onOverwrite");
									}
								}
								_tweenList[i].properties[pName] = undefined;
								delete _tweenList[i].properties[pName];
								removedLocally = true;
								removed = true;
							}
						}
						if (removedLocally) {
							// Verify if this can be deleted
							if (AuxFunctions.getObjectLength(_tweenList[i].properties) == 0) removeTweenByIndex(i);
						}
					}
				}
			}

			return removed;
		}
	
		/**
		 * Remove tweenings from a given object from the tweening list.
		 *
		 * @param		p_tween				Object		Object that must have its tweens removed
		 * @param		(2nd-last params)	Object		Property(ies) that must be removed
		 * @return							Boolean		Whether or not it successfully removed this tweening
		 */
		public static function removeTweens (p_scope:Object, ...args):Boolean {
			// Create the property list
			var properties:Array = new Array();
			var i:uint;
			for (i = 0; i < args.length; i++) {
				if (typeof(args[i]) == "string" && !AuxFunctions.isInArray(args[i], properties)) properties.push(args[i]);
			}
			// Call the affect function on the specified properties
			return affectTweens(removeTweenByIndex, p_scope, properties);
		}


		/**
		 * Remove all tweenings from the engine.
		 *
		 * @return					<code>true</code> if it successfully removed any tweening, <code>false</code> if otherwise.
		 */
		public static function removeAllTweens ():Boolean {
			if (!Boolean(_tweenList)) return false;
			var removed:Boolean = false;
			var i:uint;
			for (i = 0; i<_tweenList.length; i++) {
				removeTweenByIndex(i);
				removed = true;
			}
			return removed;
		}

		/**
		 * Pause tweenings for a given object.
		 *
		 * @param		p_scope				Object that must have its tweens paused
		 * @param		(2nd-last params)	Property(ies) that must be paused
		 * @return					<code>true</code> if it successfully paused any tweening, <code>false</code> if otherwise.
		 */
		public static function pauseTweens (p_scope:Object, ...args):Boolean {
			// Create the property list
			var properties:Array = new Array();
			var i:uint;
			for (i = 0; i < args.length; i++) {
				if (typeof(args[i]) == "string" && !AuxFunctions.isInArray(args[i], properties)) properties.push(args[i]);
			}
			// Call the affect function on the specified properties
			return affectTweens(pauseTweenByIndex, p_scope, properties);
		}

		/**
		 * Pause all tweenings on the engine.
		 *
		 * @return					<code>true</code> if it successfully paused any tweening, <code>false</code> if otherwise.
		 * @see #resumeAllTweens()
		 */
		public static function pauseAllTweens ():Boolean {
			if (!Boolean(_tweenList)) return false;
			var paused:Boolean = false;
			var i:uint;
			for (i = 0; i < _tweenList.length; i++) {
				pauseTweenByIndex(i);
				paused = true;
			}
			return paused;
		}

		/**
		 * Resume tweenings from a given object.
		 *
		 * @param		p_scope				Object		Object that must have its tweens resumed
		 * @param		(2nd-last params)	Object		Property(ies) that must be resumed
		 * @return							Boolean		Whether or not it successfully resumed something
		 */
		public static function resumeTweens (p_scope:Object, ...args):Boolean {
			// Create the property list
			var properties:Array = new Array();
			var i:uint;
			for (i = 0; i < args.length; i++) {
				if (typeof(args[i]) == "string" && !AuxFunctions.isInArray(args[i], properties)) properties.push(args[i]);
			}
			// Call the affect function on the specified properties
			return affectTweens(resumeTweenByIndex, p_scope, properties);
		}

		/**
		 * Resume all tweenings on the engine.
		 *
		 * @return <code>true</code> if it successfully resumed any tweening, <code>false</code> if otherwise.
		 * @see #pauseAllTweens()
		 */
		public static function resumeAllTweens ():Boolean {
			if (!Boolean(_tweenList)) return false;
			var resumed:Boolean = false;
			var i:uint;
			for (i = 0; i < _tweenList.length; i++) {
				resumeTweenByIndex(i);
				resumed = true;
			}
			return resumed;
		}

		/**
		 * Do some generic action on specific tweenings (pause, resume, remove, more?)
		 *
		 * @param		p_function			Function	Function to run on the tweenings that match
		 * @param		p_scope				Object		Object that must have its tweens affected by the function
		 * @param		p_properties		Array		Array of strings that must be affected
		 * @return							Boolean		Whether or not it successfully affected something
		 */
		private static function affectTweens (p_affectFunction:Function, p_scope:Object, p_properties:Array):Boolean {
			var affected:Boolean = false;
			var i:uint;

			if (!Boolean(_tweenList)) return false;

			for (i = 0; i < _tweenList.length; i++) {
				if (_tweenList[i] && _tweenList[i].scope == p_scope) {
					if (p_properties.length == 0) {
						// Can affect everything
						p_affectFunction(i);
						affected = true;
					} else {
						// Must check whether this tween must have specific properties affected
						var affectedProperties:Array = new Array();
						var j:uint;
						for (j = 0; j < p_properties.length; j++) {
							if (Boolean(_tweenList[i].properties[p_properties[j]])) {
								affectedProperties.push(p_properties[j]);
							}
						}
						if (affectedProperties.length > 0) {
							// This tween has some properties that need to be affected
							var objectProperties:uint = AuxFunctions.getObjectLength(_tweenList[i].properties);
							if (objectProperties == affectedProperties.length) {
								// The list of properties is the same as all properties, so affect it all
								p_affectFunction(i);
								affected = true;
							} else {
								// The properties are mixed, so split the tween and affect only certain specific properties
								var slicedTweenIndex:uint = splitTweens(i, affectedProperties);
								p_affectFunction(slicedTweenIndex);
								affected = true;
							}
						}
					}
				}
			}
			return affected;
		}

		/**
		 * Splits a tweening in two
		 *
		 * @param		p_tween				Number		Object that must have its tweens split
		 * @param		p_properties		Array		Array of strings containing the list of properties that must be separated
		 * @return							Number		The index number of the new tween
		 */
		public static function splitTweens (p_tween:Number, p_properties:Array):uint {
			// First, duplicates
			var originalTween:TweenListObj = _tweenList[p_tween];
			var newTween:TweenListObj = originalTween.clone(false);

			// Now, removes tweenings where needed
			var i:uint;
			var pName:String;

			// Removes the specified properties from the old one
			for (i = 0; i < p_properties.length; i++) {
				pName = p_properties[i];
				if (Boolean(originalTween.properties[pName])) {
					originalTween.properties[pName] = undefined;
					delete originalTween.properties[pName];
				}
			}

			// Removes the unspecified properties from the new one
			var found:Boolean;
			for (pName in newTween.properties) {
				found = false;
				for (i = 0; i < p_properties.length; i++) {
					if (p_properties[i] == pName) {
						found = true;
						break;
					}
				}
				if (!found) {
					newTween.properties[pName] = undefined;
					delete newTween.properties[pName];
				}
			}

			// If there are empty property lists, a cleanup is done on the next updateTweens() cycle
			_tweenList.push(newTween);
			return (_tweenList.length - 1);
			
		}

		// ==================================================================================================================================
		// ENGINE functions -----------------------------------------------------------------------------------------------------------------
	
		/**
		 * Updates all existing tweenings.
		 *
		 * @return							Boolean		FALSE if no update was made because there's no tweening (even delayed ones)
		 */
		private static function updateTweens ():Boolean {
			if (_tweenList.length == 0) return false;
			var i:int;
			for (i = 0; i < _tweenList.length; i++) {
				// Looping throught each Tweening and updating the values accordingly
				if (_tweenList[i] == undefined || !_tweenList[i].isPaused) {
					if (!updateTweenByIndex(i)) removeTweenByIndex(i);
					if (_tweenList[i] == null) {
						removeTweenByIndex(i, true);
						i--;
					}
				}
			}
	
			return true;
		}
	
		/**
		 * Remove a specific tweening from the tweening list.
		 *
		 * @param		p_tween				Number		Index of the tween to be removed on the tweenings list
		 * @return							Boolean		Whether or not it successfully removed this tweening
		 */
		public static function removeTweenByIndex (i:Number, p_finalRemoval:Boolean = false):Boolean {
			_tweenList[i] = null;
			if (p_finalRemoval) _tweenList.splice(i, 1);
			return true;
		}
	
		/**
		 * Pauses a specific tween.
		 *
		 * @param		p_tween				Number		Index of the tween to be paused
		 * @return							Boolean		Whether or not it successfully paused this tweening
		 */
		public static function pauseTweenByIndex (p_tween:Number):Boolean {
			var tTweening:TweenListObj = _tweenList[p_tween];	// Shortcut to this tweening
			if (tTweening == null || tTweening.isPaused) return false;
			tTweening.timePaused = _currentTime;
			tTweening.isPaused = true;
	
			return true;
		}
	
		/**
		 * Resumes a specific tween.
		 *
		 * @param		p_tween				Number		Index of the tween to be resumed
		 * @return							Boolean		Whether or not it successfully resumed this tweening
		 */
		public static function resumeTweenByIndex (p_tween:Number):Boolean {
			var tTweening:TweenListObj = _tweenList[p_tween];	// Shortcut to this tweening
			if (tTweening == null || !tTweening.isPaused) return false;
			tTweening.timeStart += _currentTime - tTweening.timePaused;
			tTweening.timeComplete += _currentTime - tTweening.timePaused;
			tTweening.timePaused = undefined;
			tTweening.isPaused = false;
	
			return true;
		}
	
		/**
		 * Updates a specific tween.
		 *
		 * @param		i					Number		Index (from the tween list) of the tween that should be updated
		 * @return							Boolean		FALSE if it's already finished and should be deleted, TRUE if otherwise
		 */
		private static function updateTweenByIndex (i:Number):Boolean {
	
			var tTweening:TweenListObj = _tweenList[i];	// Shortcut to this tweening

			if (tTweening == null || !Boolean(tTweening.scope)) return false;

			var isOver:Boolean = false;		// Whether or not it's over the update time
			var mustUpdate:Boolean;			// Whether or not it should be updated (skipped if false)
	
			var nv:Number;					// New value for each property
	
			var t:Number;					// current time (frames, seconds)
			var b:Number;					// beginning value
			var c:Number;					// change in value
			var d:Number; 					// duration (frames, seconds)
	
			var pName:String;				// Property name, used in loops
	
			// Shortcut stuff for speed
			var tScope:Object;				// Current scope
			var tProperty:Object;			// Property being checked

			if (_currentTime >= tTweening.timeStart) {
				// Can already start
	
				tScope = tTweening.scope;
	
				if (tTweening.isCaller) {
					// It's a 'caller' tween
					do {
						t = ((tTweening.timeComplete - tTweening.timeStart)/tTweening.count) * (tTweening.timesCalled+1);
						b = tTweening.timeStart;
						c = tTweening.timeComplete - tTweening.timeStart;
						d = tTweening.timeComplete - tTweening.timeStart;
						nv = tTweening.transition(t, b, c, d);
	
						if (_currentTime >= nv) {
							if (Boolean(tTweening.onUpdate)) {
								try {
									tTweening.onUpdate.apply(tScope, tTweening.onUpdateParams);
								} catch(e:Error) {
									handleError(tTweening, e, "onUpdate");
								}
							}

							tTweening.timesCalled++;
							if (tTweening.timesCalled >= tTweening.count) {
								isOver = true;
								break;
							}
							if (tTweening.waitFrames) break;
						}
	
					} while (_currentTime >= nv);
				} else {
					// It's a normal transition tween

					mustUpdate = tTweening.skipUpdates < 1 || !tTweening.skipUpdates || tTweening.updatesSkipped >= tTweening.skipUpdates;

					if (_currentTime >= tTweening.timeComplete) {
						isOver = true;
						mustUpdate = true;
					}

					if (!tTweening.hasStarted) {
						// First update, read all default values (for proper filter tweening)
						if (Boolean(tTweening.onStart)) {
							try {
								tTweening.onStart.apply(tScope, tTweening.onStartParams);
							} catch(e:Error) {
								handleError(tTweening, e, "onStart");
							}
						}
						for (pName in tTweening.properties) {
							var pv:Number = getPropertyValue (tScope, pName);
							tTweening.properties[pName].valueStart = isNaN(pv) ? tTweening.properties[pName].valueComplete : pv;
						}
						mustUpdate = true;
						tTweening.hasStarted = true;
					}

					if (mustUpdate) {
						for (pName in tTweening.properties) {
							tProperty = tTweening.properties[pName];

							if (isOver) {
								// Tweening time has finished, just set it to the final value
								nv = tProperty.valueComplete;
							} else {
								if (tProperty.hasModifier) {
									// Modified
									t = _currentTime - tTweening.timeStart;
									d = tTweening.timeComplete - tTweening.timeStart;
									nv = tTweening.transition(t, 0, 1, d);
									nv = tProperty.modifierFunction(tProperty.valueStart, tProperty.valueComplete, nv, tProperty.modifierParameters);
								} else {
									// Normal update
									t = _currentTime - tTweening.timeStart;
									b = tProperty.valueStart;
									c = tProperty.valueComplete - tProperty.valueStart;
									d = tTweening.timeComplete - tTweening.timeStart;
									nv = tTweening.transition(t, b, c, d);
								}
							}

							if (tTweening.rounded) nv = Math.round(nv);
							setPropertyValue(tScope, pName, nv);
						}

						tTweening.updatesSkipped = 0;

						if (Boolean(tTweening.onUpdate)) {
							try {
								tTweening.onUpdate.apply(tScope, tTweening.onUpdateParams);
							} catch(e:Error) {
								handleError(tTweening, e, "onUpdate");
							}
						}
					} else {
						tTweening.updatesSkipped++;
					}
				}
	
				if (isOver && Boolean(tTweening.onComplete)) {
					try {
						tTweening.onComplete.apply(tScope, tTweening.onCompleteParams);
					} catch(e:Error) {
						handleError(tTweening, e, "onComplete");
					}
				}

				return (!isOver);
			}
	
			// On delay, hasn't started, so returns true
			return (true);
	
		}
	
		/**
		 * Initiates the Tweener--should only be ran once.
		 */
		public static function init(p_object:* = null):void {
			_inited = true;

			// Registers all default equations
			_transitionList = new Object();
			Equations.init();

			// Registers all default special properties
			_specialPropertyList = new Object();
			_specialPropertyModifierList = new Object();
			_specialPropertySplitterList = new Object();
			SpecialPropertiesDefault.init();
		}
	
		/**
		 * Adds a new function to the available transition list "shortcuts".
		 *
		 * @param		p_name				String		Shorthand transition name
		 * @param		p_function			Function	The proper equation function
		 */
		public static function registerTransition(p_name:String, p_function:Function): void {
			if (!_inited) init();
			_transitionList[p_name] = p_function;
		}
	
		/**
		 * Adds a new special property to the available special property list.
		 *
		 * @param		p_name				Name of the "special" property.
		 * @param		p_getFunction		Function that gets the value.
		 * @param		p_setFunction		Function that sets the value.
		 */
		public static function registerSpecialProperty(p_name:String, p_getFunction:Function, p_setFunction:Function, p_parameters:Array = null): void {
			if (!_inited) init();
			var sp:SpecialProperty = new SpecialProperty(p_getFunction, p_setFunction, p_parameters);
			_specialPropertyList[p_name] = sp;
		}

		/**
		 * Adds a new special property modifier to the available modifier list.
		 *
		 * @param		p_name				Name of the "special" property modifier.
		 * @param		p_modifyFunction	Function that modifies the value.
		 * @param		p_getFunction		Function that gets the value.
		 */
		public static function registerSpecialPropertyModifier(p_name:String, p_modifyFunction:Function, p_getFunction:Function): void {
			if (!_inited) init();
			var spm:SpecialPropertyModifier = new SpecialPropertyModifier(p_modifyFunction, p_getFunction);
			_specialPropertyModifierList[p_name] = spm;
		}

		/**
		 * Adds a new special property splitter to the available splitter list.
		 *
		 * @param		p_name				Name of the "special" property splitter.
		 * @param		p_splitFunction		Function that splits the value.
		 */
		public static function registerSpecialPropertySplitter(p_name:String, p_splitFunction:Function, p_parameters:Array = null): void {
			if (!_inited) init();
			var sps:SpecialPropertySplitter = new SpecialPropertySplitter(p_splitFunction, p_parameters);
			_specialPropertySplitterList[p_name] = sps;
		}

		/**
		 * Starts the Tweener class engine. It is supposed to be running every time a tween exists.
		 */
		private static function startEngine():void {
			_engineExists = true;
			_tweenList = new Array();
			
			__tweener_controller__ = new MovieClip();
			__tweener_controller__.addEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
			
			updateTime();
		}
	
		/**
		 * Stops the Tweener class engine.
		 */
		private static function stopEngine():void {
			_engineExists = false;
			_tweenList = null;
			_currentTime = 0;
			__tweener_controller__.removeEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
			__tweener_controller__ = null;
		}
	
		/**
		 * Gets a property value from an object.
		 *
		 * @param		p_obj				Object		Any given object
		 * @param		p_prop				String		The property name
		 * @return							Number		The value
		 */
		private static function getPropertyValue(p_obj:Object, p_prop:String):Number {
			if (_specialPropertyList[p_prop] != undefined) {
				// Special property
				if (Boolean(_specialPropertyList[p_prop].parameters)) {
					// Uses additional parameters
					return _specialPropertyList[p_prop].getValue(p_obj, _specialPropertyList[p_prop].parameters);
				} else {
					// Doesn't use additional parameters
					return _specialPropertyList[p_prop].getValue(p_obj);
				}
			} else {
				// Regular property
				return p_obj[p_prop];
			}
		}
	
		/**
		 * Sets the value of an object property.
		 *
		 * @param		p_obj				Object		Any given object
		 * @param		p_prop				String		The property name
		 * @param		p_value				Number		The new value
		 */
		private static function setPropertyValue(p_obj:Object, p_prop:String, p_value:Number): void {
			if (_specialPropertyList[p_prop] != undefined) {
				// Special property
				if (Boolean(_specialPropertyList[p_prop].parameters)) {
					// Uses additional parameters
					_specialPropertyList[p_prop].setValue(p_obj, p_value, _specialPropertyList[p_prop].parameters);
				} else {
					// Doesn't use additional parameters
					_specialPropertyList[p_prop].setValue(p_obj, p_value);
				}
			} else {
				// Regular property
				p_obj[p_prop] = p_value;
			}
		}
	
		/**
		 * Updates the time to enforce time grid-based updates.
		 */
		public static function updateTime():void {
			_currentTime = getTimer();
		}
	
		/**
		 * Ran once every frame. It's the main engine; updates all existing tweenings.
		 */
		public static function onEnterFrame(e:Event):void {
			updateTime();
			var hasUpdated:Boolean = false;
			hasUpdated = updateTweens();
			if (!hasUpdated) stopEngine();	// There's no tweening to update or wait, so it's better to stop the engine
		}
	
		/**
		 * Sets the new time scale.
		 *
		 * @param		p_time				Number		New time scale (0.5 = slow, 1 = normal, 2 = 2x fast forward, etc)
		 */
		public static function setTimeScale(p_time:Number):void {
			var i:Number;
	
			if (isNaN(p_time)) p_time = 1;
			if (p_time < 0.00001) p_time = 0.00001;
			if (p_time != _timeScale) {
				if (_tweenList != null) {
					// Multiplies all existing tween times accordingly
					for (i = 0; i<_tweenList.length; i++) {
						_tweenList[i].timeStart = _currentTime - ((_currentTime - _tweenList[i].timeStart) * _timeScale / p_time);
						_tweenList[i].timeComplete = _currentTime - ((_currentTime - _tweenList[i].timeComplete) * _timeScale / p_time);
						if (_tweenList[i].timePaused != undefined) _tweenList[i].timePaused = _currentTime - ((_currentTime - _tweenList[i].timePaused) * _timeScale / p_time);
					}
				}
				// Sets the new timescale value (for new tweenings)
				_timeScale = p_time;
			}
		}


		// ==================================================================================================================================
		// AUXILIARY functions --------------------------------------------------------------------------------------------------------------

		/**
		 * Finds whether or not an object has any tweening.
		 *
		 * @param		p_scope		Target object.
		 * @return					<code>true</code> if there's a tweening occuring on this object (paused, delayed, or active), <code>false</code> if otherwise.
		 */
		public static function isTweening (p_scope:Object):Boolean {
			if (!Boolean(_tweenList)) return false;
			var i:uint;

			for (i = 0; i<_tweenList.length; i++) {
				if (_tweenList[i].scope == p_scope) {
					return true;
				}
			}
			return false;
		}

		/**
		 * Returns an array containing a list of the properties being tweened for this object.
		 *
		 * @param		p_scope		Target object.
		 * @return					Total number of properties being tweened (including delayed or paused tweens).
		 */
		public static function getTweens (p_scope:Object):Array {
			if (!Boolean(_tweenList)) return [];
			var i:uint;
			var pName:String;
 			var tList:Array = new Array();

			for (i = 0; i<_tweenList.length; i++) {
				if (_tweenList[i].scope == p_scope) {
					for (pName in _tweenList[i].properties) tList.push(pName);
				}
			}
			return tList;
		}

		/**
		 * Returns the number of properties being tweened for a given object.
		 *
		 * @param		p_scope		Target object.
		 * @return					Total number of properties being tweened (including delayed or paused tweens).
		 */
		public static function getTweenCount (p_scope:Object):Number {
			if (!Boolean(_tweenList)) return 0;
			var i:uint;
			var c:Number = 0;

			for (i = 0; i<_tweenList.length; i++) {
				if (_tweenList[i].scope == p_scope) {
					c += AuxFunctions.getObjectLength(_tweenList[i].properties);
				}
			}
			return c;
		}


        /* Handles errors when Tweener executes any callbacks (onStart, onUpdate, etc)
        *  If the TweenListObj specifies an <code>onError</code> callback it well get called, passing the <code>Error</code> object and the current scope as parameters. If no <code>onError</code> callback is specified, it will trace a stackTrace.
        */
        private static function handleError(pTweening : TweenListObj, pError : Error, pCallBackName : String) : void{
            // do we have an error handler?
            if (Boolean(pTweening.onError) && (pTweening.onError is Function)){
                // yup, there's a handler. Wrap this in a try catch in case the onError throws an error itself.
                try{
                    pTweening.onError.apply(pTweening.scope, [pTweening.scope, pError]);
                }catch (metaError : Error){
                    trace("## [Tweener] Error:", pTweening.scope, "raised an error while executing the 'onError' handler. Original error:\n", pError.getStackTrace() , "\nonError error:", metaError.getStackTrace());
                }
            }else{
                // o handler, simply trace the stack trace:
                if (!Boolean(pTweening.onError)){
                    trace("## [Tweener] Error: :", pTweening.scope, "raised an error while executing the'" + pCallBackName + "'handler. \n", pError.getStackTrace() );
                }
            }
        }


		/**
		 * Returns the current tweener version.
		 * @return					The identification string of the current Tweener version, composed of an identification of the platform version ("AS2", "AS2_FL7", or "AS3") followed by space and then the version number.
		 * @example The following code returns the current used version of Tweener:
		 * <listing version="3.0">
		 * //removeMeIfWant caurina.transitions.Tweener;
		 *
		 * var tVersion:String = Tweener.getVersion();
		 * trace ("Using Tweener version " + tVersion + "."); // Outputs: "Using Tweener version AS3 1.24.47."</listing>
		 */
		public static function getVersion ():String {
			return "AS3 1.26.62";
		}


		// ==================================================================================================================================
		// DEBUG functions ------------------------------------------------------------------------------------------------------------------

		/**
		 * Lists all existing tweenings.
		 *
		 * @return					A string containing the list of all tweenings that currently exist inside the engine.
		 */
		public static function debug_getList():String {
			var ttl:String = "";
			var i:uint, k:uint;
			for (i = 0; i<_tweenList.length; i++) {
				ttl += "["+i+"] ::\n";
				for (k = 0; k<_tweenList[i].properties.length; k++) {
					ttl += "  " + _tweenList[i].properties[k].name +" -> " + _tweenList[i].properties[k].valueComplete + "\n";
				}
			}
			return ttl;
		}

	}
}

/* AS3JS File */
package caurina.transitions {
    //removeMeIfWant caurina.transitions.AuxFunctions;
	/**
	 * The tween list object. Stores all of the properties and information that pertain to individual tweens.
	 *
	 * @author		Nate Chatellier, Zeh Fernando
	 * @version		1.0.4
	 * @private
	 */

	public class TweenListObj {
		
		public var scope					:Object;	// Object affected by this tweening
		public var properties				:Object;	// List of properties that are tweened (PropertyInfoObj instances)
			// .valueStart					:Number		// Initial value of the property
			// .valueComplete				:Number		// The value the property should have when completed
		public var auxProperties			:Object;	// Dynamic object containing properties used on this tweening
		public var timeStart				:Number;	// Time when this tweening should start
		public var timeComplete				:Number;	// Time when this tweening should end
		public var useFrames				:Boolean;	// Whether or not to use frames instead of time
		public var transition				:Function;	// Equation to control the transition animation
		public var onStart					:Function;	// Function to be executed on the object when the tween starts (once)
		public var onUpdate					:Function;	// Function to be executed on the object when the tween updates (several times)
		public var onComplete				:Function;	// Function to be executed on the object when the tween completes (once)
		public var onOverwrite				:Function;	// Function to be executed on the object when the tween is overwritten
		public var onError					:Function;	// Function to be executed if an error is thrown when tweener exectues a callback (onComplete, onUpdate etc)
		public var onStartParams			:Array;		// Array of parameters to be passed for the event
		public var onUpdateParams			:Array;		// Array of parameters to be passed for the event
		public var onCompleteParams			:Array;		// Array of parameters to be passed for the event
		public var onOverwriteParams		:Array;		// Array of parameters to be passed for the event
		public var rounded					:Boolean;	// Use rounded values when updating
		public var isPaused					:Boolean;	// Whether or not this tween is paused
		public var timePaused				:Number;	// Time when this tween was paused
		public var isCaller					:Boolean;	// Whether or not this tween is a "caller" tween
		public var count					:Number;	// Number of times this caller should be called
		public var timesCalled				:Number;	// How many times the caller has already been called ("caller" tweens only)
		public var waitFrames				:Boolean;	// Whether or not this caller should wait at least one frame for each call execution ("caller" tweens only)
		public var skipUpdates				:Number;	// How many updates should be skipped (default = 0; 1 = update-skip-update-skip...)
		public var updatesSkipped			:Number;	// How many updates have already been skipped
		public var hasStarted				:Boolean;	// Whether or not this tween has already started

		// ==================================================================================================================================
		// CONSTRUCTOR function -------------------------------------------------------------------------------------------------------------

		/**
		 * Initializes the basic TweenListObj.
		 * 
		 * @param	p_scope				Object		Object affected by this tweening
		 * @param	p_timeStart			Number		Time when this tweening should start
		 * @param	p_timeComplete		Number		Time when this tweening should end
		 * @param	p_useFrames			Boolean		Whether or not to use frames instead of time
		 * @param	p_transition		Function	Equation to control the transition animation
		 */
		function TweenListObj(p_scope:Object, p_timeStart:Number, p_timeComplete:Number, p_useFrames:Boolean, p_transition:Function) {
			scope			=	p_scope;
			timeStart		=	p_timeStart;
			timeComplete	=	p_timeComplete;
			useFrames		=	p_useFrames;
			transition		=	p_transition;

			// Other default information
			auxProperties	=	new Object();
			properties		=	new Object();
			isPaused		=	false;
			timePaused		=	undefined;
			isCaller		=	false;
			updatesSkipped	=	0;
			timesCalled		=	0;
			skipUpdates		=	0;
			hasStarted		=	false;
		}


		// ==================================================================================================================================
		// OTHER functions ------------------------------------------------------------------------------------------------------------------
	
		/**
		 * Clones this tweening and returns the new TweenListObj
		 *
		 * @param	omitEvents		Boolean			Whether or not events such as onStart (and its parameters) should be omitted
		 * @return					TweenListObj	A copy of this object
		 */
		public function clone(omitEvents:Boolean):TweenListObj {
			var nTween:TweenListObj = new TweenListObj(scope, timeStart, timeComplete, useFrames, transition);
			nTween.properties = new Array();
			for (var pName:String in properties) {
				nTween.properties[pName] = properties[pName].clone();
			}
			nTween.skipUpdates = skipUpdates;
			nTween.updatesSkipped = updatesSkipped;
			if (!omitEvents) {
				nTween.onStart = onStart;
				nTween.onUpdate = onUpdate;
				nTween.onComplete = onComplete;
				nTween.onOverwrite = onOverwrite;
				nTween.onError = onError;
				nTween.onStartParams = onStartParams;
				nTween.onUpdateParams = onUpdateParams;
				nTween.onCompleteParams = onCompleteParams;
				nTween.onOverwriteParams = onOverwriteParams;
			}
			nTween.rounded = rounded;
			nTween.isPaused = isPaused;
			nTween.timePaused = timePaused;
			nTween.isCaller = isCaller;
			nTween.count = count;
			nTween.timesCalled = timesCalled;
			nTween.waitFrames = waitFrames;
			nTween.hasStarted = hasStarted;

			return nTween;
		}

		/**
		 * Returns this object described as a String.
		 *
		 * @return					String		The description of this object.
		 */
		public function toString():String {
			var returnStr:String = "\n[TweenListObj ";
			returnStr += "scope:" + String(scope);
			returnStr += ", properties:";
			for (var i:uint = 0; i < properties.length; i++) {
				if (i > 0) returnStr += ",";
				returnStr += "[name:"+properties[i].name;
				returnStr += ",valueStart:"+properties[i].valueStart;
				returnStr += ",valueComplete:"+properties[i].valueComplete;
				returnStr += "]";
			} // END FOR
			returnStr += ", timeStart:" + String(timeStart);
			returnStr += ", timeComplete:" + String(timeComplete);
			returnStr += ", useFrames:" + String(useFrames);
			returnStr += ", transition:" + String(transition);

			if (skipUpdates)		returnStr += ", skipUpdates:"		+ String(skipUpdates);
			if (updatesSkipped)		returnStr += ", updatesSkipped:"	+ String(updatesSkipped);

			if (Boolean(onStart))			returnStr += ", onStart:"			+ String(onStart);
			if (Boolean(onUpdate))			returnStr += ", onUpdate:"			+ String(onUpdate);
			if (Boolean(onComplete))		returnStr += ", onComplete:"		+ String(onComplete);
			if (Boolean(onOverwrite))		returnStr += ", onOverwrite:"		+ String(onOverwrite);
			if (Boolean(onError))			returnStr += ", onError:"			+ String(onError);
			
			if (onStartParams)		returnStr += ", onStartParams:"		+ String(onStartParams);
			if (onUpdateParams)		returnStr += ", onUpdateParams:"	+ String(onUpdateParams);
			if (onCompleteParams)	returnStr += ", onCompleteParams:"	+ String(onCompleteParams);
			if (onOverwriteParams)	returnStr += ", onOverwriteParams:" + String(onOverwriteParams);

			if (rounded)			returnStr += ", rounded:"			+ String(rounded);
			if (isPaused)			returnStr += ", isPaused:"			+ String(isPaused);
			if (timePaused)			returnStr += ", timePaused:"		+ String(timePaused);
			if (isCaller)			returnStr += ", isCaller:"			+ String(isCaller);
			if (count)				returnStr += ", count:"				+ String(count);
			if (timesCalled)		returnStr += ", timesCalled:"		+ String(timesCalled);
			if (waitFrames)			returnStr += ", waitFrames:"		+ String(waitFrames);
			if (hasStarted)			returnStr += ", hasStarted:"		+ String(hasStarted);
			
			returnStr += "]\n";
			return returnStr;
		}
		
		/**
		 * Checks if p_obj "inherits" properties from other objects, as set by the "base" property. Will create a new object, leaving others intact.
		 * o_bj.base can be an object or an array of objects. Properties are collected from the first to the last element of the "base" filed, with higher
		 * indexes overwritting smaller ones. Does not modify any of the passed objects, but makes a shallow copy of all properties.
		 *
		 * @param		p_obj		Object				Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
		 * @return					Object				A new object with all properties from the p_obj and p_obj.base.
		 */

		public static function makePropertiesChain(p_obj : Object) : Object{
			// Is this object inheriting properties from another object?
			var baseObject : Object = p_obj.base;
			if(baseObject){
				// object inherits. Are we inheriting from an object or an array
				var chainedObject : Object = {};
				var chain : Object;
				if (baseObject is Array){
					// Inheritance chain is the base array
					chain = [];
					// make a shallow copy
					for (var k : Number = 0 ; k< baseObject.length; k++) chain.push(baseObject[k]);
				}else{
					// Only one object to be added to the array
					chain = [baseObject];
				}
				// add the final object to the array, so it's properties are added last
				chain.push(p_obj);
				var currChainObj : Object;
				// Loops through each object adding it's property to the final object
				var len : Number = chain.length;
				for(var i : Number = 0; i < len ; i ++){
					if(chain[i]["base"]){
						// deal with recursion: watch the order! "parent" base must be concatenated first!
						currChainObj = AuxFunctions.concatObjects( makePropertiesChain(chain[i]["base"] ), chain[i]);
					}else{
						currChainObj = chain[i] ;
					}
					chainedObject = AuxFunctions.concatObjects(chainedObject, currChainObj );
				}
				if( chainedObject["base"]){
				    delete chainedObject["base"];
				}
				return chainedObject;	
			}else{
				// No inheritance, just return the object it self
				return p_obj;
			}
		}
		

	}
	
	

	
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.dots.PointDotBase;
	//removeMeIfWant charts.series.dots.Point;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant charts.series.dots.DefaultDotProperties;

	public class Area extends Line {
		private var fill_colour:Number;
		private var area_base:Number;
		
		public function Area( json:Object ) {
			super(json);
			
			var fill:String;
			if (json.fill)
				fill = json.fill;
			else
				fill = json.colour;
				
			this.fill_colour = string.Utils.get_colour(fill);
			
		}
		
		
		public override function resize( sc:ScreenCoordsBase ): void {
			
			var right_axis:Boolean = false;
			
			if ( props.has('axis') )
				if ( props.get('axis') == 'right' )
					right_axis = true;
					
			// save this position
			this.area_base = sc.get_y_bottom(right_axis);
			
			// let line deal with the resize
			super.resize(sc);
		}
		
		//
		// this is called from both resize and the animation manager,
		//
		protected override function draw(): void {
			this.graphics.clear();
			this.fill_area();
			// draw the line on top of the area (z axis)
			this.draw_line();
		}
		
		private function fill_area():void {
			
			var last:Element;
			var first:Boolean = true;
			var tmp:Sprite;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				
				tmp = this.getChildAt(i) as Sprite;
				
				// filter out the masks
				if( tmp is Element ) {
					
					var e:Element = tmp as Element;
					
					if( first )
					{
						
						first = false;
						
						if (this.props.get('loop'))
						{
							// assume we are in a radar chart
							this.graphics.moveTo( e.x, e.y );
						}
						else
						{
							// draw line from Y=0 up to Y pos
							this.graphics.moveTo( e.x, this.area_base );
						}
						
						//
						// TO FIX BUG: you must do a graphics.moveTo before
						//             starting a fill:
						//
						this.graphics.lineStyle(0,0,0);
						this.graphics.beginFill( this.fill_colour, this.props.get('fill-alpha') );
						
						if (!this.props.get('loop'))
							this.graphics.lineTo( e.x, e.y );
						
					}
					else
					{
						this.graphics.lineTo( e.x, e.y );
						last = e;
					}
				}
			}
			
			if ( last != null ) {
				if ( !this.props.get('loop')) {
					this.graphics.lineTo( last.x, this.area_base );
				}
			}
			

			this.graphics.endFill();
		}
	
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant string.Utils;
	
	public class Arrow extends Base {
		
		private var style:Object;
		
		public function Arrow( json:Object )
		{
			this.style = {
				start:				[],
				end:				[],
				colour:				'#808080',
				alpha:				0.5,
				'barb-length':		20
				
			};
			
			object_helper.merge_2( json, this.style );
			
			this.style.colour		= string.Utils.get_colour( this.style.colour );
			
//			for each ( var val:Object in json.values )
//				this.style.points.push( new flash.geom.Point( val.x, val.y ) );
		}
		
		public override function resize( sc:ScreenCoordsBase ): void {
			
			this.graphics.clear();
			this.graphics.lineStyle(1, this.style.colour, 1);
			
			this.graphics.moveTo(
				sc.get_x_from_val(this.style.start.x),
				sc.get_y_from_val(this.style.start.y));
			
			var x:Number = sc.get_x_from_val(this.style.end.x);
			var y:Number = sc.get_y_from_val(this.style.end.y);
			this.graphics.lineTo(x, y);
			
			var angle:Number = Math.atan2(
				sc.get_y_from_val(this.style.start.y) - y,
				sc.get_x_from_val(this.style.start.x) - x
				);
		
			var barb_length:Number = this.style['barb-length'];
			var barb_angle:Number = 0.34;

			//first point is end of one barb
			var a:Number = x + (barb_length * Math.cos(angle - barb_angle));
			var b:Number = y + (barb_length * Math.sin(angle - barb_angle));

			//final point is end of the second barb
			var c:Number = x + (barb_length * Math.cos(angle + barb_angle));
			var d:Number = y + (barb_length * Math.sin(angle + barb_angle));

			this.graphics.moveTo(x, y);
			this.graphics.lineTo(a, b);
			
			this.graphics.moveTo(x, y);
			this.graphics.lineTo(c, d);
			
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Bar3D;
	//removeMeIfWant string.Utils;
	
	
	public class Bar3D extends BarBase {
		
		public function Bar3D( json:Object, group:Number ) {
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new charts.series.bars.Bar3D( index, this.get_element_helper_prop( value ), this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Bar;
	//removeMeIfWant string.Utils;

	
	public class Bar extends BarBase {
		
		public function Bar( json:Object, group:Number ) {
			
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new charts.series.bars.Bar( index, this.get_element_helper_prop( value ), this.group );
		}
	}
}

/* AS3JS File */
package charts {
	
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.Base;
	//removeMeIfWant string.Utils;
	//removeMeIfWant global.Global;

	
	public class BarBase extends Base
	{
		protected var group:Number;
		protected var on_show:Properties;
		
		public function BarBase( json:Object, group:Number )
		{
		
			var root:Properties = new Properties( {
				values:				[],
				colour:				'#3030d0',
				text:				'',		// <-- default not display a key
				'font-size':		12,
				tip:				'#val#<br>#x_label#',
				alpha:				0.6,
				'on-click':			false,
				'axis':				'left'
			} );
			
			this.props = new Properties(json, root);
			
		/*
			var on_show_root:Properties = new Properties( {
				type:		"none",		//"pop-up",
				cascade:	3,
				delay:		0
				});
			this.on_show = new Properties(json['on-show'], on_show_root);
		*/
			this.on_show = this.get_on_show(json['on-show']);
			
			this.colour		= this.props.get_colour('colour');
			this.key		= this.props.get('text');
			this.font_size	= this.props.get('font-size');

			// Minor hack, replace all #key# with this key text:
			this.props.set( 'tip', this.props.get('tip').replace('#key#', this.key) );
			
			
			//
			// bars are grouped, so 3 bar sets on one chart
			// will arrange them selves next to each other
			// at each value of X, this.group tell the bar
			// where it is in that grouping
			//
			this.group = group;
			
			this.values = this.props.get('values');
			this.add_values();
		}
		
		protected function get_on_show(json:Object): Properties {
			
			var on_show_root:Properties = new Properties( {
				type:		"none",		//"pop-up",
				cascade:	3,
				delay:		0
				});
				
			return new Properties(json, on_show_root);
		}
		
		
		//
		// hello people in the future! I was doing OK until I found some red wine. Now I can't figure stuff out,
		// like, do I pass in this.axis, or do I make it a member of each PointBarBase? I don't know. Hey, I know
		// I'll flip a coin and see what happens. It was heads. What does it mean? Mmmmm.... red wine....
		// Fuck it, I'm passing it in. Makes the resize method messy, but keeps the PointBarBase clean.
		//
		public override function resize( sc:ScreenCoordsBase ): void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var e:Element = this.getChildAt(i) as Element;
				e.resize( sc );
			}
		}
		
		
		public override function get_max_x():Number {
			
			var max_index:Number = Number.MIN_VALUE;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				
				var e:Element = this.getChildAt(i) as Element;
				max_index = Math.max( max_index, e.index );
			}
			
			// 0 is a position, so count it:
			return max_index;
		}
		
		public override function get_min_x():Number {
			return 0;
		}
		
		//
		// override or don't call this if you need better help
		//
		protected function get_element_helper_prop( value:Object ): Properties {
			
			var default_style:Properties = new Properties({
				colour:		this.props.get('colour'),
				tip:		this.props.get('tip'),
				alpha:		this.props.get('alpha'),
				'on-click':	this.props.get('on-click'),
				axis:		this.props.get('axis'),
				'on-show':	this.on_show
			});
		
			var s:Properties;
			if( value is Number )
				s = new Properties({'top': value}, default_style);
			else
				s = new Properties(value, default_style);
		
			return s;
		}
		
		/*
				
			      +-----+
			      |  B  |
			+-----+     |   +-----+
			|  A  |     |   |  C  +- - -
			|     |     |   |     |  D
			+-----+-----+---+-----+- - -
			         1   2
			
		*/
			
		
		public override function closest( x:Number, y:Number ): Object {
			var shortest:Number = Number.MAX_VALUE;
			var ex:Element = null;
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var e:Element = this.getChildAt(i) as Element;

				e.is_tip = false;
				
				if( (x > e.x) && (x < e.x+e.width) )
				{
					// mouse is in position 1
					shortest = Math.min( Math.abs( x - e.x ), Math.abs( x - (e.x+e.width) ) );
					ex = e;
					break;
				}
				else
				{
					// mouse is in position 2
					// get distance to left side and right side
					var d1:Number = Math.abs( x - e.x );
					var d2:Number = Math.abs( x - (e.x+e.width) );
					var min:Number = Math.min( d1, d2 );
					if( min < shortest )
					{
						shortest = min;
						ex = e;
					}
				}
			}
			var dy:Number = Math.abs( y - ex.y );
			
			return { element:ex, distance_x:shortest, distance_y:dy };
		}
		
		public override function die():void {
			super.die();
			this.props.die();
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.Elements.Element;
	//removeMeIfWant charts.Elements.PointBarCandle;
	//removeMeIfWant string.Utils;
	
	public class BarCandle extends BarBase {
		//private var line_width:Number;
		
		public function BarCandle( lv:Array, num:Number, group:Number ) {
			super( lv, num, group, 'candle' );
		}
		
		public override function parse_bar( val:Object ):void {
			var vals:Array = val.split(",");
		
			//this.alpha = Number( vals[0] );
			this.line_width = Number( vals[1] );
			this.colour = Utils.get_colour(vals[2]);
			
			if( vals.length > 3 )
				this.key = vals[3].replace('#comma#',',');
				
			if( vals.length > 4 )
				this.font_size = Number( vals[4] );
		}
	
		//
		// the data looks like "[1,2,3,4],[2,3,4,5]"
		// this returns an array of strings like '1,2,3,4','2,3,4,5'
		// these are then parsed further in PointBarCandle
		//
		protected override function parse_list( values:String ):Array {
			var groups:Array=new Array();
			var tmp:String = '';
			var start:Boolean = false;

			for( var i:Number=0; i<values.length; i++ )
			{
				switch( values.charAt(i) )
				{
					case '[':
						start=true;
						break;
					case ']':
						start = false;
						groups.push( tmp );
						tmp = '';
						break;
					default:
						if( start )
							tmp += values.charAt(i);
						break;
				}
			}
			return groups;
		}
		
		
		//
		// called from the base object
		//
		protected override function get_element( x:Number, value:Object ): Element {
			return new PointBarCandle( x, value, this.line_width, this.colour, this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Cylinder;

	public class BarCylinder extends BarBase {


		public function BarCylinder( json:Object, group:Number ) {

			super( json, group );
		}

		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			return new Cylinder( index, this.get_element_helper_prop( value ), this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.CylinderOutline;

	public class BarCylinderOutline extends BarBase {

		public function BarCylinderOutline( json:Object, group:Number ) {

			super( json, group );
		}

       //
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new CylinderOutline( index, this.get_element_helper_prop( value ), this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Dome;

	public class BarDome extends BarBase {


		public function BarDome( json:Object, group:Number ) {

			super( json, group );
		}

		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new Dome( index, this.get_element_helper_prop( value ), this.group );
		}

	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.Elements.PointBarFade;
	
	public class BarFade extends BarBase {
		
		public function BarFade( json:Object, group:Number ) {
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			return new PointBarFade( index, value, this.colour, this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Glass;
	//removeMeIfWant string.Utils;
	
	public class BarGlass extends BarBase {

		
		public function BarGlass( json:Object, group:Number ) {
			
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new Glass( index, this.get_element_helper_prop( value ), this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Outline;
	//removeMeIfWant string.Utils;
	
	public class BarOutline extends BarBase {
		private var outline_colour:Number;
		
		//TODO: remove
		protected var style:Object;
		
		
		public function BarOutline( json:Object, group:Number ) {
			
			//
			// specific value for outline
			//
			this.style = {
				'outline-colour':	"#000000"
			};
			
			object_helper.merge_2( json, this.style );
			
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			var root:Properties = new Properties( {
				'outline-colour':	this.style['outline-colour']
				} );
		
			var default_style:Properties = this.get_element_helper_prop( value );
			default_style.set_parent( root );
			
	/*
			if ( !default_style['outline-colour'] )
				default_style['outline-colour'] = this.style['outline-colour'];
			
			if( default_style['outline-colour'] is String )
				default_style['outline-colour'] = Utils.get_colour( default_style['outline-colour'] );
	*/

			return new Outline( index, default_style, this.group );
		}
	}
}    
/* AS3JS File */
package charts {
       //removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Plastic;
       //removeMeIfWant string.Utils;
       
       public class BarPlastic extends BarBase {

          
          public function BarPlastic( json:Object, group:Number ) {
             
             super( json, group );
          }
          
          //
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new Plastic( index, this.get_element_helper_prop( value ), this.group );
		}
        
       }
    }    
/* AS3JS File */
package charts {
		
       //removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.PlasticFlat;
       //removeMeIfWant string.Utils;
       
       public class BarPlasticFlat extends BarBase {

          
          public function BarPlasticFlat( json:Object, group:Number ) {
             
             super( json, group );
          }
          
          //
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new PlasticFlat( index, this.get_element_helper_prop( value ), this.group );
		}
          
       }
    }

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Round3D;
       
       public class BarRound3D extends BarBase {

          
          public function BarRound3D( json:Object, group:Number ) {
             
             super( json, group );
          }
          
          //
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new charts.series.bars.Round3D( index, this.get_element_helper_prop( value ), this.group );
		}
	   }
    }

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Round;

	public class BarRound extends BarBase {

		public function BarRound( json:Object, group:Number ) {

			super( json, group );
		}

		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new Round( index, this.get_element_helper_prop( value ), this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.RoundGlass;

	public class BarRoundGlass extends BarBase {


		public function BarRoundGlass( json:Object, group:Number ) {

			super( json, group );
		}

		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new RoundGlass( index, this.get_element_helper_prop( value ), this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Sketch;
	//removeMeIfWant string.Utils;
	
	public class BarSketch extends BarBase {
		private var outline_colour:Number;
		private var offset:Number;
		
		// TODO: remove
		protected var style:Object;
		
		public function BarSketch( json:Object, group:Number ) {
			
			//
			// these are specific values to the Sketch
			// and so we need to sort them out here
			//
			this.style = {
				'outline-colour':	"#000000",
				offset:				6
			};
			
			object_helper.merge_2( json, this.style );
			
			super( style, group );
		}
	
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			var root:Properties = new Properties( {
				'outline-colour':	this.style['outline-colour'],
				offset:				this.style.offset
				} );
		
			var default_style:Properties = this.get_element_helper_prop( value );	
			default_style.set_parent( root );
	
/**
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = Utils.get_colour( default_style.colour );
				
			if ( !default_style['outline-colour'] )
				default_style['outline-colour'] = this.style['outline-colour'];
				
			if( default_style['outline-colour'] is String )
				default_style['outline-colour'] = Utils.get_colour( default_style['outline-colour'] );
			
			if ( !default_style.offset )
				default_style.offset = this.style.offset;
**/
			return new Sketch( index, default_style, this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.StackCollection;
	//removeMeIfWant string.Utils;
	//removeMeIfWant com.serialization.json.JSON;
	//removeMeIfWant flash.geom.Point;
	
	
	public class BarStack extends BarBase {
		
		public function BarStack( json:Object, num:Number, group:Number ) {
	
			// don't let the parent do anything, we just want to
			// use some of the more useful methods
			super( { }, 0);
			
			// now do all the setup
			var root:Properties = new Properties( {
				values:				[],
				keys:				[],
				colours:			['#FF0000','#00FF00'],	// <-- ugly default colours
				text:				'',		// <-- default not display a key
				'font-size':		12,
				tip:				'#x_label# : #val#<br>Total: #total#',
				alpha:				0.6,
				'on-click':			false,
				'axis':				'left'
			} );
			
			this.props = new Properties(json, root);
			
			this.on_show = this.get_on_show(json['on-show']);
			//
			// bars are grouped, so 3 bar sets on one chart
			// will arrange them selves next to each other
			// at each value of X, this.group tell the bar
			// where it is in that grouping
			//
			this.group = group;
		
			this.values = json.values;

			this.add_values();
		}
		
		//
		// return an array of key info objects:
		//
		public override function get_keys(): Object {
			
			var tmp:Array = [];
			
			for each( var o:Object in this.props.get('keys') ) {
				if ( o.text && o['font-size'] && o.colour ) {
					o.colour = string.Utils.get_colour( o.colour );
					tmp.push( o );
				}
			}
			
			return tmp;
		}
		
		//
		// value is an array (a stack) of bar stacks
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			//
			// this is the style for a stack:
			//
			var default_style:Properties = new Properties({
				colours:		this.props.get('colours'),
				tip:			this.props.get('tip'),
				alpha:			this.props.get('alpha'),
				'on-click':		this.props.get('on-click'),
				axis:			this.props.get('axis'),
				'on-show':		this.on_show,
				values:			value
			});

			return new StackCollection( index, default_style, this.group );
		}
		
		
		//
		// get all the Elements at this X position
		//
		protected override function get_all_at_this_x_pos( x:Number ):Array {
			
			var tmp:Array = new Array();
			var p:flash.geom.Point;
			var e:StackCollection;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
			
				// some of the children will will mask
				// Sprites, so filter those out:
				//
				if( this.getChildAt(i) is Element ) {
		
					e = this.getChildAt(i) as StackCollection;
				
					p = e.get_mid_point();
					if ( p.x == x ) {
						var children:Array = e.get_children();
						for each( var child:Element in children )
							tmp.push( child );
					}
				}
			}
			
			return tmp;
		}
	}
}

/* AS3JS File */
package charts {

	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant elements.axis.XAxisLabels;
	
	public class Base extends Sprite {
		
		// accessed by the Keys object to display the key
		protected var key:String;
		protected var font_size:Number;
		protected var colour:Number;
		
		protected var props:Properties;
		
		
//		TODO: remove this after release 'm'
//		
//		public var line_width:Number;
//		public var circle_size:Number;
//		protected var axis:Number;

		//
		// hold the Element values, for lines this is an
		// array of string Y values, for Candle it is an
		// array of string 'high,open,low,close' values,
		// for scatter it is 'x,y' etc...
		//
		public var values:Array;
		
		
		public function Base() {}
		
		public function get_colour(): Number {
			return this.colour;
		}
		
		//
		// return an array of key info objects:
		//
		public function get_keys(): Object {
			
			var tmp:Array = [];
			
			// some lines may not have a key
			if( (this.font_size > 0) && (this.key != '' ) )
				tmp.push( { 'text':this.key, 'font-size':this.font_size, 'colour':this.get_colour() } );
				
			return tmp;
		}
		
		//
		// whatever sets of data that *may* be attached to the right
		// Y Axis call this to see if they are attached to it or not.
		// All lines, area and bar charts call this.
		/*
		protected function which_axis_am_i_attached_to( data:Array, i:Number ): Number {
			//
			// some data sets are attached to the right
			// Y axis (and min max), in the future we
			// may support many axis
			//
			if( data['show_y2'] != undefined )
				if( data['show_y2'] != 'false' )
					if( data['y2_lines'] != undefined )
					{
						var tmp:Array = data.y2_lines.split(",");
						var pos:Number = tmp.indexOf( i.toString() );
						
						if ( pos == -1 )
							return 1;
						else
							return 2;	// <-- this line found in y2_lines, so it is attached to axis 2 (right axis)
					}
					
			return 1;
		}
		*/
		
		/**
		 * may be called by main.as to make the X Axis labels
		 * @return
		 */
		public function get_max_x():Number {
			
			var max:Number = Number.MIN_VALUE;
			//
			// count the non-mask items:
			//
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				if ( this.getChildAt(i) is Element ) {
					
					var e:Element = this.getChildAt(i) as Element
					max = Math.max( max, e.get_x() );
				}
			}
	
			return max;
		}
		
		public function get_min_x():Number {
			
			var min:Number = Number.MAX_VALUE;
			//
			// count the non-mask items:
			//
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				if ( this.getChildAt(i) is Element ) {
					
					var e:Element = this.getChildAt(i) as Element
					min = Math.min( min, e.get_x() );
				}
			}
	
			return min;
		}
		
		public function get_y_range():Object {
			
			var max:Number = Number.MIN_VALUE;
			var min:Number = Number.MAX_VALUE;
			//
			// count the non-mask items:
			//
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				if ( this.getChildAt(i) is Element ) {
					
					var e:Element = this.getChildAt(i) as Element;
					var y:Number = e.get_y();
					max = Math.max(max, y);
					min = Math.min(min, y);
				}
			}
	
			return {max: max, min: min};
		}
		
		public function left_axis():Boolean {
			
			// anything that is not 'right' defaults to the left axis
			return this.props.get('axis')!='right';
		}
		
		//
		// this should be overriden
		//
		public function resize( sc:ScreenCoordsBase ):void{}
		
		
		//
		// TODO: old remove when tooltips tested
		//
		public function closest( x:Number, y:Number ): Object {
			var shortest:Number = Number.MAX_VALUE;
			var closest:Element = null;
			var dx:Number;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
			
				//
				// some of the children will will mask
				// Sprites, so filter those out:
				//
				if( this.getChildAt(i) is Element ) {
					
					var e:Element = this.getChildAt(i) as Element;
					e.set_tip( false );
				
					dx = Math.abs( x -e.x );
				
					if( dx < shortest )	{
						shortest = dx;
						closest = e;
					}
				}
			}
			
			var dy:Number = 0;
			if( closest )
				dy = Math.abs( y - closest.y );
				
			return { element:closest, distance_x:shortest, distance_y:dy };
		}
		
		//
		// Line and bar charts will normally only have one
		// Element at any X position, but when using Radar axis
		// you may get many at any give X location.
		//
		// Scatter charts can have many items at the same X position
		//
		public function closest_2( x:Number, y:Number ): Array {

			// get the closest Elements X value
			var x:Number		= closest_x(x);
			var tmp:Array		= this.get_all_at_this_x_pos(x);
			
			// tr.aces('tmp.length', tmp.length);
			
			var closest:Array	= this.get_closest_y(tmp, y);
			var dy:Number = Math.abs( y - closest.y );
			// tr.aces('closest.length', closest.length);
			
			return closest;
		}
		
		//
		// get the X value of the closest points to the mouse
		//
		private function closest_x( x:Number ):Number {
			
			var closest:Number = Number.MAX_VALUE;
			var p:flash.geom.Point;
			var x_pos:Number;
			var dx:Number;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
			
				//
				// some of the children will will mask
				// Sprites, so filter those out:
				//
				if( this.getChildAt(i) is Element ) {
		
					var e:Element = this.getChildAt(i) as Element;
				
					p = e.get_mid_point();
					dx = Math.abs( x - p.x );

					if( dx < closest )	{
						closest = dx;
						x_pos = p.x;
					}
				}
			}
			
			return x_pos;
		}
		
		//
		// get all the Elements at this X position
		// BarStack overrides this
		//
		protected function get_all_at_this_x_pos( x:Number ):Array {
			
			var tmp:Array = new Array();
			var p:flash.geom.Point;
			var e:Element;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
			
				// some of the children will will mask
				// Sprites, so filter those out:
				//
				if( this.getChildAt(i) is Element ) {
		
					e = this.getChildAt(i) as Element;
					
					//
					// Point elements are invisible by default.
					//
					// Prevent invisible points from showing tooltips
					// For scatter line area
					//if (e.visible)
					//{
						p = e.get_mid_point();
						if ( p.x == x )
							tmp.push( e );
					//}
				}
			}
			
			return tmp;
		}
		
		//
		// scatter charts may have many Elements in the same
		// x, y location
		//
		private function get_closest_y( elements:Array, y:Number):Array {
			
			var y_min:Number = Number.MAX_VALUE;
			var dy:Number;
			var closest:Array = new Array();
			var p:flash.geom.Point;
			var e:Element;
			
			// get min Y distance
			for each( e in elements ) {
				
				p = e.get_mid_point();
				dy = Math.abs( y - p.y );
				
				y_min = Math.min( dy, y_min );
			}
			
			// select all Elements at this Y pos
			for each( e in elements ) {
				
				p = e.get_mid_point();
				dy = Math.abs( y - p.y );
				if( dy == y_min )
					closest.push(e);
			}

			return closest;
		}
		
		//
		// scatter charts may have many Elements in the same
		// x, y location
		//
		public function mouse_proximity( x:Number, y:Number ): Array {
			
			var closest:Number = Number.MAX_VALUE;
			var p:flash.geom.Point;
			var i:Number;
			var e:Element;
			var mouse:flash.geom.Point = new flash.geom.Point(x, y);
			
			//
			// find the closest Elements
			//
			for ( i=0; i < this.numChildren; i++ ) {
			
				// filter mask Sprites
				if( this.getChildAt(i) is Element ) {
		
					e = this.getChildAt(i) as Element;
					closest = Math.min( flash.geom.Point.distance(e.get_mid_point(), mouse), closest );
				}
			}
			
			//
			// grab all Elements at this distance
			//
			var close:Array = [];
			for ( i=0; i < this.numChildren; i++ ) {
			
				// filter mask Sprites
				if( this.getChildAt(i) is Element ) {
		
					e = this.getChildAt(i) as Element;
					if ( flash.geom.Point.distance(e.get_mid_point(), mouse) == closest )
						close.push(e);
				}
			}
			
			return close;
		}
		
		
		
		//
		// this is a backup function so if the mouse leaves the
		// movie for some reason without raising the mouse
		// out event (this happens if the user is wizzing the mouse about)
		//
		public function mouse_out():void {
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				
				// filter out the mask elements in line charts
				if( this.getChildAt(i) is Element ) {
					
					var e:Element = this.getChildAt(i) as Element;
					e.set_tip(false);
				}
			}
		}
		
		
		//
		// index of item (bar, point, pie slice, horizontal bar) may be used
		// to look up its X value (bar,point) or Y value (H Bar) or used as
		// the sequence number (Pie)
		//
		protected function get_element( index:Number, value:Object ): Element {
			return null;
		}
		
		public function add_values():void {
			
			// keep track of the X position (column)
			var index:Number = 0;
			
			for each ( var val:Object in this.values )
			{
				var tmp:Element;
				
				//
				// TODO: fix or document what is happening in link-null-bug.txt
				//
				
				// filter out the 'null' values
				if( val != null )
				{
					tmp = this.get_element( index, val );
					
					if( tmp.line_mask != null )
						this.addChild( tmp.line_mask );
						
					this.addChild( tmp );
				}
				
				index++;
			}
		}
		
		/**
		 * See ObjectCollection tooltip_replace_labels
		 * 
		 * @param	labels
		 */
		public function tooltip_replace_labels( labels:XAxisLabels ):void {
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				
				// filter out the mask elements in line charts
				if( this.getChildAt(i) is Element ) {
					
					var e:Element = this.getChildAt(i) as Element;
					e.tooltip_replace_labels( labels );
				}
			}
		}
		
		public function die():void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
				if ( this.getChildAt(i) is Element ) {
					
					var e:Element = this.getChildAt(i) as Element;
					e.die();
				}
			
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.ECandle;
	//removeMeIfWant string.Utils;

	
	public class Candle extends BarBase {
		private var negative_colour:Number;
		
		public function Candle( json:Object, group:Number ) {
			
			super( json, group );
			
		tr.aces('---');
		tr.ace_json(json);
		tr.aces( 'neg', props.has('negative-colour'), props.get_colour('negative-colour'));
		
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
		
			var default_style:Properties = this.get_element_helper_prop( value );	
			if(this.props.has('negative-colour'))
				default_style.set('negative-colour', this.props.get('negative-colour'));
			
			return new ECandle( index, default_style, this.group );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant com.serialization.json.JSON;
	
	public class Factory
	{
		private var attach_right:Array;

		public static function MakeChart( json:Object ) : ObjectCollection
		{
			var collection:ObjectCollection = new ObjectCollection();
			
			// multiple bar charts all have the same X values, so
			// they are grouped around each X value, this tells
			// ScreenCoords how to group them:
			var bar_group:Number = 0;
			var name:String = '';
			var c:Number=1;
			
			var elements:Array = json['elements'] as Array;
			
			for( var i:Number = 0; i < elements.length; i++ )
			{
				// tr.ace( elements[i]['type'] );
				
				switch( elements[i]['type'] ) {
					case 'bar' :
						collection.add( new Bar( elements[i], bar_group ) );
						bar_group++;
						break;
					
					case 'line':
						collection.add( new Line( elements[i] ) );
						break;
						
					case 'area':
						collection.add( new Area( elements[i] ) );
						break;
						
					case 'pie':
						collection.add( new Pie( elements[i] ) );
						break;
						
					case 'hbar':
						collection.add( new HBar( elements[i] ) );
						bar_group++;
						break;
						
					case 'bar_stack':
						collection.add( new BarStack( elements[i], c, bar_group ) );
						bar_group++;
						break;
						
					case 'scatter':
						collection.add( new Scatter( elements[i] ) );
						break;
						
					case 'scatter_line':
						collection.add( new ScatterLine( elements[i] ) );
						break;
						
					case 'bar_sketch':
						collection.add( new BarSketch( elements[i], bar_group ) );
						bar_group++;
						break;
						
					case 'bar_glass':
						collection.add( new BarGlass( elements[i], bar_group ) );
						bar_group++;
						break;
						
					case 'bar_cylinder':
						collection.add( new BarCylinder( elements[i], bar_group ) );
						bar_group++;
						break;

					case 'bar_cylinder_outline':
						collection.add( new BarCylinderOutline( elements[i], bar_group ) );
						bar_group++;
						break;

					case 'bar_dome':
						collection.add( new BarDome( elements[i], bar_group ) );
						bar_group++;
						break;

					case 'bar_round':
						collection.add( new BarRound( elements[i], bar_group ) );
						bar_group++;
						break;

					case 'bar_round_glass':
						collection.add( new BarRoundGlass( elements[i], bar_group ) );
						bar_group++;
						break;

					case 'bar_round3d':
						collection.add( new BarRound3D( elements[i], bar_group ) );
						bar_group++;
						break;
					
					case 'bar_fade':
						collection.add( new BarFade( elements[i], bar_group ) );
						bar_group++;
						break;
					
					case 'bar_3d':
						collection.add( new Bar3D( elements[i], bar_group ) );
						bar_group++;
						break;
					
					case 'bar_filled':
						collection.add( new BarOutline( elements[i], bar_group ) );
						bar_group++;
						break;
					
					case 'bar_plastic':
						collection.add( new BarPlastic( elements[i], bar_group ) );
						bar_group++;
						break;
					
					case 'bar_plastic_flat':
						collection.add( new BarPlasticFlat( elements[i], bar_group ) );
						bar_group++;
						break;
						
					case 'shape':
						collection.add( new Shape( elements[i] ) );
						break;
					
					case 'candle':
						collection.add( new Candle( elements[i], bar_group ) );
						bar_group++;
						break;
		
					case 'tags':
						collection.add( new Tags( elements[i] ) );
						break;
						
					case 'arrow':
						collection.add( new Arrow( elements[i] ) );
						break;
						
				}
			}
			/*
					
			
				else if ( lv['candle' + name] != undefined )
				{
					ob = new BarCandle(lv, c, bar_group);
					bar_group++;
				}
				
			*/
		
			var y2:Boolean = false;
			var y2lines:Array;
			
			//
			// some data sets are attached to the right
			// Y axis (and min max)
			//
//			this.attach_right = new Array();
				
//			if( lv.show_y2 != undefined )
//				if( lv.show_y2 != 'false' )
//					if( lv.y2_lines != undefined )
//					{
//						this.attach_right = lv.y2_lines.split(",");
//					}
			
			collection.groups = bar_group;
			return collection;
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.bars.Horizontal;
	//removeMeIfWant string.Utils;
	//removeMeIfWant global.Global;
	
	public class HBar extends Base {
		
		protected var group:Number;
		protected var style:Object;
		
		public function HBar( json:Object ) {
			
			this.style = {
				values:				[],
				colour:				'#3030d0',
				text:				'',		// <-- default not display a key
				'font-size':		12,
				tip:				'#val#'
			};
			
			object_helper.merge_2( json, style );
			
			//this.alpha = Number( vals[0] );
			this.colour = string.Utils.get_colour( style.colour );
			this.key = json.text;
			this.font_size = json['font-size'];
			
			//
			// bars are grouped, so 3 bar sets on one chart
			// will arrange them selves next to each other
			// at each value of X, this.group tell the bar
			// where it is in that grouping
			//
			this.group = 0;
			
			this.values = json['values'];
			
			this.style['on-click'] = json['on-click'];
			
			this.add_values();
		}
		
		//
		// called from the base object, in this case the
		// value is the X value of the bar and the index
		// is the Y positiont
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			var default_style:Object = {
					colour:		this.style.colour,
					tip:		this.style.tip,
					'on-click': this.style['on-click']
			};
			
			if( value is Number )
				default_style.top = value;
			else
				object_helper.merge_2( value, default_style );
				
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = Utils.get_colour( default_style.colour );
			
			return new Horizontal( index, default_style, this.group );
		}
		
		public override function resize( sc:ScreenCoordsBase ): void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var p:Horizontal = this.getChildAt(i) as Horizontal;
				p.resize( sc );
			}
		}
		
		public override function get_max_x():Number {
			
			var x:Number = 0;
			//
			// count the non-mask items:
			//
			for ( var i:Number = 0; i < this.numChildren; i++ )
				if( this.getChildAt(i) is Horizontal ) {
					
					var h:Horizontal = this.getChildAt(i) as Horizontal;
					x = Math.max( x, h.get_max_x() );
					
				}
	
			return x;
		}
		
		public override function get_min_x():Number {
			return 0;
		}

	}
}

/* AS3JS File */
package charts {

	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant flash.display.Sprite;
	
	//removeMeIfWant charts.series.dots.DefaultDotProperties;
	//removeMeIfWant charts.series.dots.dot_factory;
	
	//removeMeIfWant flash.utils.Timer;
	//removeMeIfWant flash.events.TimerEvent;
	//removeMeIfWant charts.series.dots.PointDotBase;
	
	public class Line extends Base
	{
		// JSON style:
		private var dot_style:Properties;
		private var on_show:Properties;
		private var line_style:LineStyle;
	
		private var on_show_timer:Timer;
		private var on_show_start:Boolean;
		
		public function Line( json:Object ) {
		
			var root:Properties = new Properties({
				values: 		[],
				width:			2,
				colour: 		'#3030d0',
				text: 			'',		// <-- default not display a key
				'font-size': 	12,
				tip:			'#val#',
				loop:			false,
				axis:			'left'
			});
			this.props = new Properties(json, root);
			
			this.line_style = new LineStyle(json['line-style']);
			this.dot_style = new DefaultDotProperties(json['dot-style'], this.props.get('colour'), this.props.get('axis'));
			
			//
			// see scatter base
			//
			var on_show_root:Properties = new Properties( {
				type:		"none",		// "pop-up",
				cascade:	0.5,
				delay:		0
				});
			this.on_show = new Properties(json['on-show'], on_show_root);
			this.on_show_start = true;// this.on_show.get('type');
			//
			//
			
			this.key		= this.props.get('text');
			this.font_size	= this.props.get('font-size');
			
			this.values = this.props.get('values');
			this.add_values();

			//
			// this allows the dots to erase part of the line
			//
			this.blendMode = BlendMode.LAYER;
		}
		
		//
		// called from the Base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			if ( value is Number )
				value = { value:value };
			
			var tmp:Properties = new Properties(value, this.dot_style);
			
			// Minor hack, replace all #key# with this key text,
			// we do this *after* the merge.
			tmp.set( 'tip', tmp.get('tip').replace('#key#', this.key) );
			
			// attach the animation bits:
			tmp.set('on-show', this.on_show);
				
			return dot_factory.make( index, tmp );
		}
		
		
		// Draw lines...
		public override function resize( sc:ScreenCoordsBase ): void {
			this.x = this.y = 0;

			this.move_dots(sc);
			
			if ( this.on_show_start )
				this.start_on_show_timer();
			else
				this.draw();
			
		}
	
		//
		// this is a bit dirty, as the dots animate we draw the line 60 times a second
		//
		private function start_on_show_timer(): void {
			this.on_show_start = false;
			this.on_show_timer = new Timer(1000 / 60);	// <-- 60 frames a second = 1000ms / 60
			this.on_show_timer.addEventListener("timer", animationManager);
			// Start the timer
			this.on_show_timer.start();
		}
		
		protected function animationManager(eventArgs:TimerEvent): void {
			
			this.draw();
			
			if( !this.still_animating() ) {
				tr.ace( 'Line.as : on show animation stop' );
				this.on_show_timer.stop();
			}
		}
		
		private function still_animating(): Boolean {
			var i:Number;
			var tmp:Sprite;
		
			for ( i=0; i < this.numChildren; i++ ) {

				tmp = this.getChildAt(i) as Sprite;
				
				// filter out the line masks
				if( tmp is PointDotBase )
				{
					var e:PointDotBase = tmp as PointDotBase;
					if ( e.is_tweening() )
						return true;
				}
			}
			return false;
		}
		
		//
		// this is called from both resize and the animation manager
		//
		protected function draw(): void {
			this.graphics.clear();
			this.draw_line();
		}
		
		// this is also called from area
		protected function draw_line(): void {
			
			
			this.graphics.lineStyle( this.props.get_colour('width'), this.props.get_colour('colour') );
			
			if( this.line_style.style != 'solid' )
				this.dash_line();
			else
				this.solid_line();
		
		}
		
		public function move_dots( sc:ScreenCoordsBase ): void {
			
			var i:Number;
			var tmp:Sprite;
		
			for ( i=0; i < this.numChildren; i++ ) {

				tmp = this.getChildAt(i) as Sprite;
				
				// filter out the line masks
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					// tell the point where it is on the screen
					// we will use this info to place the tooltip
					e.resize( sc );
				}
			}
		}
		
		public function solid_line(): void {
			
			var first:Boolean = true;
			var i:Number;
			var tmp:Sprite;
			var x:Number;
			var y:Number;
			
			for ( i=0; i < this.numChildren; i++ ) {

				tmp = this.getChildAt(i) as Sprite;
				
				// filter out the line masks
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					if( first )
					{
						this.graphics.moveTo(e.x, e.y);
						x = e.x;
						y = e.y;
						first = false;
					}
					else
						this.graphics.lineTo(e.x, e.y);
				}
			}
			
			if ( this.props.get('loop') ) {
				// close the line loop (radar charts)
				this.graphics.lineTo(x, y);
			}
		}
		
		// Dashed lines by Arseni
		public function dash_line(): void {
			
			var first:Boolean = true;
			
			var prev_x:int = 0;
			var prev_y:int = 0;
			var on_len_left:Number = 0;
			var off_len_left:Number = 0;
			var on_len:Number = this.line_style.on; //Stroke Length
			var off_len:Number = this.line_style.off; //Space Length
			var now_on:Boolean = true;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {				
				var tmp:Sprite = this.getChildAt(i) as Sprite;				
				//
				// filter out the line masks
				//
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					if( first )
					{
						this.graphics.moveTo(e.x, e.y);
						on_len_left = on_len;
						off_len_left = off_len;
						now_on = true;
						first = false;
						prev_x = e.x;
						prev_y = e.y;
						var x_tmp_1:Number = prev_x;
						var x_tmp_2:Number;
						var y_tmp_1:Number = prev_y;
						var y_tmp_2:Number;						
					}
					else {
						var part_len:Number = Math.sqrt((e.x - prev_x) * (e.x - prev_x) + (e.y - prev_y) * (e.y - prev_y) );
						var sinus:Number = ((e.y - prev_y) / part_len); 
						var cosinus:Number = ((e.x - prev_x) / part_len); 
						var part_len_left:Number = part_len;
						var inside_part:Boolean = true;
							
						while (inside_part) {
							//Draw Lines And spaces one by one in loop
							if ( now_on ) {
								//Draw line
								//If whole stroke fits
								if (  on_len_left < part_len_left ) {
									//Fits - draw whole stroke
									x_tmp_2 = x_tmp_1 + on_len_left * cosinus;
									y_tmp_2 = y_tmp_1 + on_len_left * sinus;
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									part_len_left = part_len_left - on_len_left;
									now_on = false;
									off_len_left = off_len;															
								} else {
									//Does not fit - draw part of the stroke
									x_tmp_2 = e.x;
									y_tmp_2 = e.y;
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									on_len_left = on_len_left - part_len_left;
									inside_part = false;									
								}
								this.graphics.lineTo(x_tmp_2, y_tmp_2);								
							} else {
								//Draw space
								//If whole space fits
								if (  off_len_left < part_len_left ) {
									//Fits - draw whole space
									x_tmp_2 = x_tmp_1 + off_len_left * cosinus;
									y_tmp_2 = y_tmp_1 + off_len_left * sinus;
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									part_len_left = part_len_left - off_len_left;								
									now_on = true;
									on_len_left = on_len;
								} else {
									//Does not fit - draw part of the space
									x_tmp_2 = e.x;									
									y_tmp_2 = e.y;									
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									off_len_left = off_len_left - part_len_left;
									inside_part = false;																		
								}
								this.graphics.moveTo(x_tmp_2, y_tmp_2);								
							}
						}
					}
					prev_x = e.x;
					prev_y = e.y;
				}
			}
		}
		
		public override function get_colour(): Number {
			return this.props.get_colour('colour');
		}
	}
}

/* AS3JS File */
package charts {
	
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.dots.PointDotBase;
	//removeMeIfWant flash.display.Graphics;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant string.Utils;
	// //removeMeIfWant charts.series.dots.PointDot;
	//removeMeIfWant charts.series.dots.dot_factory;
	
	
	public class LineBase extends Base
	{
		// JSON style:
		protected var style:Object;
		
		
		public function LineBase() {}
		
		//
		// called from the BaseLine object
		//
		protected override function get_element( index:Number, value:Object ): Element {

//			var s:Object = this.merge_us_with_value_object( value );
			//
			// the width of the hollow circle is the same as the width of the line
			//

			var tmp:Properties;
			if( value is Number )
				tmp = new Properties( { value:value }, this.style['--dot-style']);
			else
				tmp = new Properties( value, this.style['--dot-style']);
				
			return dot_factory.make( index, tmp );
		}
		
		
		// Draw lines...
		public override function resize( sc:ScreenCoordsBase ): void {
			this.x = this.y = 0;

			this.graphics.clear();
			this.graphics.lineStyle( this.style.width, this.style.colour );
			
			if( this.style['line-style'].style != 'solid' )
				this.dash_line(sc);
			else
				this.solid_line(sc);
		
		}
		
		public function solid_line( sc:ScreenCoordsBase ): void {
			
			var first:Boolean = true;
			var i:Number;
			var tmp:Sprite;
			var x:Number;
			var y:Number;
			
			for ( i=0; i < this.numChildren; i++ ) {

				tmp = this.getChildAt(i) as Sprite;
				
				//
				// filter out the line masks
				//
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					// tell the point where it is on the screen
					// we will use this info to place the tooltip
					e.resize( sc );
					if( first )
					{
						this.graphics.moveTo(e.x, e.y);
						x = e.x;
						y = e.y;
						first = false;
					}
					else
						this.graphics.lineTo(e.x, e.y);
				}
			}
			
			if ( this.style.loop ) {
				// close the line loop (radar charts)
				this.graphics.lineTo(x, y);
			}
		}
		
		// Dashed lines by Arseni
		public function dash_line( sc:ScreenCoordsBase ): void {
			
			var first:Boolean = true;
			
			var prev_x:int = 0;
			var prev_y:int = 0;
			var on_len_left:Number = 0;
			var off_len_left:Number = 0;
			var on_len:Number = this.style['line-style'].on; //Stroke Length
			var off_len:Number = this.style['line-style'].off; //Space Length
			var now_on:Boolean = true;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {				
				var tmp:Sprite = this.getChildAt(i) as Sprite;				
				//
				// filter out the line masks
				//
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					// tell the point where it is on the screen
					// we will use this info to place the tooltip
					e.resize( sc );
					if( first )
					{
						this.graphics.moveTo(e.x, e.y);
						on_len_left = on_len;
						off_len_left = off_len;
						now_on = true;
						first = false;
						prev_x = e.x;
						prev_y = e.y;
						var x_tmp_1:Number = prev_x;
						var x_tmp_2:Number;
						var y_tmp_1:Number = prev_y;
						var y_tmp_2:Number;						
					}
					else {
						var part_len:Number = Math.sqrt((e.x - prev_x) * (e.x - prev_x) + (e.y - prev_y) * (e.y - prev_y) );
						var sinus:Number = ((e.y - prev_y) / part_len); 
						var cosinus:Number = ((e.x - prev_x) / part_len); 
						var part_len_left:Number = part_len;
						var inside_part:Boolean = true;
							
						while (inside_part) {
							//Draw Lines And spaces one by one in loop
							if ( now_on ) {
								//Draw line
								//If whole stroke fits
								if (  on_len_left < part_len_left ) {
									//Fits - draw whole stroke
									x_tmp_2 = x_tmp_1 + on_len_left * cosinus;
									y_tmp_2 = y_tmp_1 + on_len_left * sinus;
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									part_len_left = part_len_left - on_len_left;
									now_on = false;
									off_len_left = off_len;															
								} else {
									//Does not fit - draw part of the stroke
									x_tmp_2 = e.x;
									y_tmp_2 = e.y;
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									on_len_left = on_len_left - part_len_left;
									inside_part = false;									
								}
								this.graphics.lineTo(x_tmp_2, y_tmp_2);								
							} else {
								//Draw space
								//If whole space fits
								if (  off_len_left < part_len_left ) {
									//Fits - draw whole space
									x_tmp_2 = x_tmp_1 + off_len_left * cosinus;
									y_tmp_2 = y_tmp_1 + off_len_left * sinus;
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									part_len_left = part_len_left - off_len_left;								
									now_on = true;
									on_len_left = on_len;
								} else {
									//Does not fit - draw part of the space
									x_tmp_2 = e.x;									
									y_tmp_2 = e.y;									
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									off_len_left = off_len_left - part_len_left;
									inside_part = false;																		
								}
								this.graphics.moveTo(x_tmp_2, y_tmp_2);								
							}
						}
					}
					prev_x = e.x;
					prev_y = e.y;
				}
			}
		}
		
		protected function merge_us_with_value_object( value:Object ): Object {
			
			var default_style:Object = {
				'dot-size':		this.style['dot-size'],
				colour:			this.style.colour,
				'halo-size':	this.style['halo-size'],
				tip:			this.style.tip,
				'on-click':		this.style['on-click'],
				'axis':			this.style.axis
			}
			
			if( value is Number )
				default_style.value = value;
			else
				object_helper.merge_2( value, default_style );
			
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = Utils.get_colour( default_style.colour );
				
			// Minor hack, replace all #key# with this LINEs key text:
			default_style.tip = default_style.tip.replace('#key#', this.style.text);
			
			return default_style;
		}
		
		public override function get_colour(): Number {
			return this.style.colour;
		}
	}
}

/* AS3JS File */
package charts {
	////removeMeIfWant caurina.transitions.Tweener;

	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.dots.PointDot;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.display.BlendMode;
	
	public class LineDot extends LineBase
	{
		
		public function LineDot( json:Object )
		{
			
			this.style = {
				values:			[],
				width:			2,
				colour:			'#3030d0',
				text:			'',		// <-- default not display a key
				'dot-size':		5,
				'halo-size':	2,
				'font-size':	12,
				tip:			'#val#',
				'line-style':	new LineStyle( json['line-style'] )
			};
			
			object_helper.merge_2( json, style );
			
			this.style.colour = string.Utils.get_colour( this.style.colour );
			
			this.key = style.text;
			this.font_size = style['font-size'];
			
//			this.axis = which_axis_am_i_attached_to(data, num);
//			tr.ace( name );
//			tr.ace( 'axis : ' + this.axis );
				
			this.values = style['values'];
			this.add_values();
			
			//
			// this allows the dots to erase part of the line
			//
			this.blendMode = BlendMode.LAYER;
			
		}
		
		
		//
		// called from the BaseLine object
		/*
		protected override function get_element( index:Number, value:Object ): Element {

			var s:Object = this.merge_us_with_value_object( value );
			//
			// the width of the hollow circle is the same as the width of the line
			//
			s.width = this.style.width;
			if( s.type == null )
				s.type = 'solid-dot';
				
			return new PointDot( index, s );
		}
		*/
	}
}

/* AS3JS File */
package charts {
	////removeMeIfWant caurina.transitions.Tweener;

	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant charts.series.Element;
	////removeMeIfWant charts.series.dots.PointDot;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant charts.series.dots.Hollow;
	//removeMeIfWant charts.series.dots.dot_factory;
	
	public class LineHollow extends LineBase
	{
		
		public function LineHollow( json:Object )
		{
			//
			// so the mask child can punch a hole through the line
			//
			this.blendMode = BlendMode.LAYER;
			
			this.style = {
				values: 		[],
				width:			2,
				colour:			'#80a033',
				text:			'',
				'font-size':	10,
				'dot-size':		6,
				'halo-size':	2,
				tip:			'#val#',
				'line-style':	new LineStyle( json['line-style'] ),
				'axis':			'left'
			};
			
			this.style = object_helper.merge( json, this.style );
			
			this.style.colour = string.Utils.get_colour( this.style.colour );
			this.values = style.values;
			
			this.key = style.text;
			this.font_size = style['font-size'];
			
			
//			this.axis = which_axis_am_i_attached_to(data, num);
//			tr.ace( name );
//			tr.ace( 'axis : ' + this.axis );

			this.add_values();
			
		}
		
		//
		// called from the base object
		/*
		protected override function get_element( index:Number, value:Object ): charts.series.Element {
			
			var s:Object = this.merge_us_with_value_object( value );
			//
			// the width of the hollow circle is the same as the width of the line
			//
			s.width = this.style.width;
			if( s.type == null )
				s.type = 'hollow-dot';
			
			return dot_factory.make( index, s );
		}
		*/
	}
}

/* AS3JS File */
package charts {

	public class LineStyle extends Object
	{
		public var style:String;
		public var on:Number;
		public var off:Number;
		
		public function LineStyle( json:Object ) {
		
			// tr.ace(json);
			
			// default values:
			this.style = 'solid';
			this.on = 1;
			this.off = 5;
			
			object_helper.merge_2( json, this );
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant elements.axis.XAxisLabels;

	public class ObjectCollection
	{
		public var sets:Array;
		public var groups:Number;
		
		public function ObjectCollection() {
			this.sets = new Array();
		}
		
		public function add( set:Base ): void {
			this.sets.push( set );
		}
		
		
		public function get_max_x():Number {
			
			var max:Number = Number.MIN_VALUE;

			for each( var o:Base in this.sets )
				max = Math.max( max, o.get_max_x() );

			return max;
		}
		
		public function get_min_x():Number {
			
			var min:Number = Number.MAX_VALUE;

			for each( var o:Base in this.sets )
				min = Math.min( min, o.get_min_x() );

			return min;
		}
		
		public function get_y_range(left_axis:Boolean = true):Object {
			
			var max:Number = Number.MIN_VALUE;
			var min:Number = Number.MAX_VALUE;

			for each( var o:Base in this.sets ) {
				
				if (left_axis == o.left_axis())
				{
					var range:Object = o.get_y_range();
					max = Math.max(max, range.max);
					min = Math.min(min, range.min);
				}
			}

			return {max: max, min: min};
		}
		
		// get x, y co-ords of vals
		public function resize( sc:ScreenCoordsBase ):void {
			for each ( var o:Base in this.sets )
				o.resize( sc );
		}
		
		/**
		 * Tell each set to update the tooltip string and
		 * eplace all #x_label# with the label
		 * 
		 * @param	labels
		 */
		public function tooltip_replace_labels( labels:XAxisLabels ):void {
			
			for each ( var o:Base in this.sets )
				o.tooltip_replace_labels( labels );			
		}
		
		public function mouse_out():void {
			for each( var s:Base in this.sets )
				s.mouse_out();
		}
		
		
		private function closest( x:Number, y:Number ):Element {
			var o:Object;
			var s:Base;
			
			// get closest points from each data set
			var closest:Array = new Array();
			for each( s in this.sets )
				closest.push( s.closest( x, y ) );
			
			// find closest point along X axis
			var min:Number = Number.MAX_VALUE;
			for each( o in closest )
				min = Math.min( min, o.distance_x );
				
			//
			// now select all points that are the
			// min (see above) distance along the X axis
			//
			var xx:Object = {element:null, distance_x:Number.MAX_VALUE, distance_y:Number.MAX_VALUE };
			for each( o in closest ) {
				
				if( o.distance_x == min )
				{
					// these share the same X position, so choose
					// the closest to the mouse in the Y
					if( o.distance_y < xx.distance_y )
						xx = o;
				}
			}
			
			// pie charts may not return an element
			if( xx.element )
				xx.element.set_tip( true );
				
			return xx.element;
		}
		
		/*
		
		hollow
		  line --> ------O---------------O-----
				
			             +-----+
			             |  B  |
			       +-----+     |   +-----+
			       |  A  |     |   |  C  +- - -
			       |     |     |   |     |  D
			       +-----+-----+---+-----+- - -
			                1    2
			
		*/
		public function mouse_move( x:Number, y:Number ):Element {
			//
			// is the mouse over, above or below a
			// bar or point? For grouped bar charts,
			// two bars will share an X co-ordinate
			// and be the same distance from the
			// mouse. For example, if the mouse is
			// in position 1 in diagram above. This
			// filters out all items that are not
			// above or below the mouse:
			//
			var e:Element = null;// this.inside__(x, y);
			
			if ( !e )
			{
				//
				// no Elements are above or below the mouse,
				// so we select the BEST item to show (mouse
				// is in position 2)
				//
				e = this.closest(x, y);
			}
			
			return e;
		}
		
		
		//
		// Usually this will return an Array of one Element to
		// the Tooltip, but some times 2 (or more) Elements will
		// be on top of each other
		//
		public function closest_2( x:Number, y:Number ):Array {

			var e:Element;
			var s:Base;
			var p:flash.geom.Point;
			
			//
			// get closest points from each data set
			//
			var closest:Array = new Array();
			for each( s in this.sets ) {
				
				var tmp:Array = s.closest_2( x, y );
				for each( e in tmp )
					closest.push( e );
			}
			
			//
			// find closest point along X axis
			// different sets may return Elements
			// in different X locations
			//
			var min_x:Number = Number.MAX_VALUE;
			for each( e in closest ) {
				
				p = e.get_mid_point();
				min_x = Math.min( min_x, Math.abs( x - p.x ) );
			}
			
			//
			// filter out the Elements that
			// are too far away along the X axis
			//
			var good_x:Array = new Array();
			for each( e in closest ) {
				
				p = e.get_mid_point();
				if ( Math.abs( x - p.x ) == min_x )
					good_x.push( e );
			}
			
			//
			// now get min_y from filtered array
			//
			var min_y:Number = Number.MAX_VALUE;
			for each( e in good_x ) {
				
				p = e.get_mid_point();
				min_y = Math.min( min_y, Math.abs( y - p.y ) );
			}
			
			//
			// now filter out any that are not min_y
			//
			var good_x_and_y:Array = new Array();
			for each( e in good_x ) {
				
				p = e.get_mid_point();
				if ( Math.abs( y - p.y ) == min_y )
					good_x_and_y.push( e );
			}

			return good_x_and_y;
		}
		
		//
		// find the closest point to the mouse
		//
		public function mouse_move_proximity( x:Number, y:Number ):Array {
			var e:Element;
			var s:Base;
			var p:flash.geom.Point;
			
			//
			// get closest points from each data set
			//
			var closest:Array = new Array();
			for each( s in this.sets ) {
				
				var tmp:Array = s.mouse_proximity( x, y );
				for each( e in tmp )
					closest.push( e );
			}
			
			//
			// find the min distance to these
			//
			var min_dist:Number = Number.MAX_VALUE;
			var mouse:flash.geom.Point = new flash.geom.Point(x, y);
			for each( e in closest ) {
				min_dist = Math.min( flash.geom.Point.distance(e.get_mid_point(), mouse), min_dist );
			}
			
			// keep these closest Elements
			var close:Array = [];
			for each( e in closest ) {
				if ( flash.geom.Point.distance(e.get_mid_point(), mouse) == min_dist )
					close.push( e );
			}
			
			return close;
		}
		
		//
		// are we resizing a PIE chart?
		//
		public function has_pie():Boolean {
			
			if ( this.sets.length > 0 && ( this.sets[0] is Pie ) )
				return true;
			else
				return false;
		}
		
		/**
		 * To stop memory leaks we explicitly kill all
		 * our children
		 */
		public function die():void {

			for each( var o:Base in this.sets )
				o.die();
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant charts.series.pies.PieLabel;
	//removeMeIfWant flash.external.ExternalInterface;
	//removeMeIfWant string.Utils;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.pies.PieSliceContainer;
	//removeMeIfWant charts.series.pies.DefaultPieProperties;
	//removeMeIfWant global.Global;
	
	//removeMeIfWant flash.display.Sprite;

	public class Pie extends Base
	{
		
		private var labels:Array;
		private var links:Array;
		private var colours:Array;
		private var gradientFill:String = 'true'; //toggle gradients
		private var border_width:Number = 1;
		private var label_line:Number;
		private var easing:Function;
		public var style:Object;
		public var total_value:Number = 0;
		
		public function Pie( json:Object )
		{
			this.labels = new Array();
			this.links = new Array();
			this.colours = new Array();
			
			this.style = {
				colours:			["#900000", "#009000"]	// slices colours
			}
			
			object_helper.merge_2( json, this.style );			
			
			for each( var colour:String in this.style.colours )
				this.colours.push( string.Utils.get_colour( colour ) );
				
			//
			//
			//
			this.props = new DefaultPieProperties(json);
			//
			//
			//
			
			this.label_line = 10;

			this.values = json.values;
			this.add_values();
		}
		
		
		//
		// Pie chart make is quite different to a normal make
		//
		public override function add_values():void {
//			this.Elements= new Array();
			
			//
			// Warning: this is our global singleton
			//
			var g:Global = Global.getInstance();
			
			var total:Number = 0;
			var slice_start:Number = this.props.get('start-angle');
			var i:Number;
			var val:Object;
			
			for each ( val in this.values ) {
				if( val is Number )
					total += val;
				else
					total += val.value;
			}
			this.total_value = total;
			
			i = 0;
			for each ( val in this.values ) {
				
				var value:Number = val is Number ? val as Number : val.value;
				var slice_angle:Number = value*360/total;
				
				if( slice_angle >= 0 )
				{
					
					var t:String = this.props.get('tip').replace('#total#', NumberUtils.formatNumber( this.total_value ));
					t = t.replace('#percent#', NumberUtils.formatNumber( value / this.total_value * 100 ) + '%');
				
					this.addChild(
						this.add_slice(
							i,
							slice_start,
							slice_angle,
							val,		// <-- NOTE: val (object) NOT value (a number)
							t,
							this.colours[(i % this.colours.length)]
							)
						);

					// TODO: fix this and remove
					// tmp.make_tooltip( this.key );
				}
				i++;
				slice_start += slice_angle;
			}
		}
		
		private function add_slice( index:Number, start:Number, angle:Number, value:Object, tip:String, colour:String ): PieSliceContainer {
			
				
			// Properties chain:
			//   pie-slice -> calculated-stuff -> pie
			//
			// calculated-stuff:
			var calculated_stuff:Properties = new Properties(
				{
					colour:				colour,		// <-- from the colour cycle array
					tip:				tip,		// <-- replaced the #total# & #percent# for this slice
					start:				start,		// <-- calculated
					angle:				angle		// <-- calculated
				},
				this.props );
			
			var tmp:Object = {};			
			if ( value is Number )
				tmp.value = value;
			else
				tmp = value;
				
			var p:Properties = new Properties( tmp, calculated_stuff );
			
			// no user defined label?
			if ( !p.has('label') )
				p.set('label', p.get('value').toString());
			
			// tr.aces( 'value', p.get('value'), p.get('label'), p.get('colour') );
			return new PieSliceContainer( index, p );
		}
		
		
		public override function closest( x:Number, y:Number ): Object {
			// PIE charts don't do closest to mouse tooltips
			return { Element:null, distance_x:0, distance_y:0 };
		}


		public override function resize( sc:ScreenCoordsBase ): void {
			var radius:Number = this.style.radius;
			if (isNaN(radius)){
				radius = ( Math.min( sc.width, sc.height ) / 2.0 );
				var offsets:Object = {top:0, right:0, bottom:0, left:0};
				trace("sc.width, sc.height, radius", sc.width, sc.height, radius);

				var i:Number;
				var sliceContainer:PieSliceContainer;

				// loop to gather and merge offsets
				for ( i = 0; i < this.numChildren; i++ ) {
					sliceContainer = this.getChildAt(i) as PieSliceContainer;
					var pie_offsets:Object = sliceContainer.get_radius_offsets();
					for (var key:Object in offsets) {
						if ( pie_offsets[key] > offsets[key] ) {
							offsets[key] = pie_offsets[key];
						}
					}
				}
				var vRadius:Number = radius;
				// Calculate minimum radius assuming the contraint is vertical
				// Shrink radius by the largest top/bottom offset
				vRadius -= Math.max(offsets.top, offsets.bottom);
				// check to see if the left/right labels will fit
				if ((vRadius + offsets.left) > (sc.width / 2))
				{
					//radius -= radius + offsets.left - (sc.width / 2);
					vRadius = (sc.width / 2) - offsets.left;
				}
				if ((vRadius + offsets.right) > (sc.width / 2))
				{
					//radius -= radius + offsets.right - (sc.width / 2);
					vRadius = (sc.width / 2) - offsets.right;
				}

				// Make sure the radius is at least 10
				radius = Math.max(vRadius, 10);
			}

			var rightTopTicAngle:Number		= 720;
			var rightTopTicIdx:Number		= -1;
			var rightBottomTicAngle:Number	= -720;
			var rightBottomTicIdx:Number	= -1;

			var leftTopTicAngle:Number		= 720;
			var leftTopTicIdx:Number		= -1;
			var leftBottomTicAngle:Number	= -720;
			var leftBottomTicIdx:Number		= -1;

			// loop and resize
			for ( i = 0; i < this.numChildren; i++ )
			{
				sliceContainer = this.getChildAt(i) as PieSliceContainer;
				sliceContainer.pie_resize(sc, radius);

				// While we are looping through the children, we determine which
				// labels are the starting points in each quadrant so that we
				// move the labels around to prevent overlaps
				var ticAngle:Number = sliceContainer.getTicAngle();
				if (ticAngle >= 270)
				{
					// Right side - Top
					if ((ticAngle < rightTopTicAngle) || (rightTopTicAngle <= 90))
					{
						rightTopTicAngle = ticAngle;
						rightTopTicIdx = i;
					}
					// Just in case no tics in Right-Bottom
					if ((rightBottomTicAngle < 0) ||
						((rightBottomTicAngle > 90) && (rightBottomTicAngle < ticAngle)))
					{
						rightBottomTicAngle = ticAngle;
						rightBottomTicIdx = i;
					}
				}
				else if (ticAngle <= 90)
				{
					// Right side - Bottom
					if ((ticAngle > rightBottomTicAngle) || (rightBottomTicAngle > 90))
					{
						rightBottomTicAngle = ticAngle;
						rightBottomTicIdx = i;
					}
					// Just in case no tics in Right-Top
					if ((rightTopTicAngle > 360) ||
						((rightTopTicAngle <= 90) && (ticAngle < rightBottomTicAngle)))
					{
						rightTopTicAngle = ticAngle;
						rightTopTicIdx = i;
					}
				}
				else if (ticAngle <= 180)
				{
				// Left side - Bottom
				if ((leftBottomTicAngle < 0) || (ticAngle < leftBottomTicAngle))
				{
					leftBottomTicAngle = ticAngle;
					leftBottomTicIdx = i;
				}
				// Just in case no tics in Left-Top
				if ((leftTopTicAngle > 360) || (leftTopTicAngle < ticAngle))
				{
					leftTopTicAngle = ticAngle;
					leftTopTicIdx = i;
				}
				}
				else
				{
					// Left side - Top
					if ((leftTopTicAngle > 360) || (ticAngle > leftTopTicAngle))
					{
						leftTopTicAngle = ticAngle;
						leftTopTicIdx = i;
					}
					// Just in case no tics in Left-Bottom
					if ((leftBottomTicAngle < 0) || (leftBottomTicAngle > ticAngle))
					{
						leftBottomTicAngle = ticAngle;
						leftBottomTicIdx = i;
					}
				}
			}

			// Make a clockwise pass on right side of pie trying to move
			// the labels so that they do not overlap
			var childIdx:Number = rightTopTicIdx;
			var yVal:Number = sc.top;
			var bDone:Boolean = false;
			while ((childIdx >= 0) && (!bDone))
			{
				sliceContainer = this.getChildAt(childIdx) as PieSliceContainer;
				ticAngle = sliceContainer.getTicAngle();
				if ((ticAngle >= 270) || (ticAngle <= 90))
				{
					yVal = sliceContainer.moveLabelDown(sc, yVal);
	
					childIdx++;
					if (childIdx >= this.numChildren) childIdx = 0;

					bDone = (childIdx == rightTopTicIdx);
				}
				else
				{
					bDone = true;
				}
			}

			// Make a counter-clockwise pass on right side of pie trying to move
			// the labels so that they do not overlap
			childIdx = rightBottomTicIdx;
			yVal = sc.bottom;
			bDone = false;
			while ((childIdx >= 0) && (!bDone))
			{
				sliceContainer = this.getChildAt(childIdx) as PieSliceContainer;
				ticAngle = sliceContainer.getTicAngle();
				if ((ticAngle >= 270) || (ticAngle <= 90))
				{
					yVal = sliceContainer.moveLabelUp(sc, yVal);

					childIdx--;
					if (childIdx < 0) childIdx = this.numChildren - 1;

					bDone = (childIdx == rightBottomTicIdx);
				}
				else
				{
					bDone = true;
				}
			}

			// Make a clockwise pass on left side of pie trying to move
			// the labels so that they do not overlap
			childIdx = leftBottomTicIdx;
			yVal = sc.bottom;
			bDone = false;
			while ((childIdx >= 0) && (!bDone))
			{
				sliceContainer = this.getChildAt(childIdx) as PieSliceContainer;
				ticAngle = sliceContainer.getTicAngle();
				if ((ticAngle > 90) && (ticAngle < 270))
				{
					yVal = sliceContainer.moveLabelUp(sc, yVal);

					childIdx++;
					if (childIdx >= this.numChildren) childIdx = 0;

					bDone = (childIdx == leftBottomTicIdx);
				}
				else
				{
					bDone = true;
				}
			}

			// Make a counter-clockwise pass on left side of pie trying to move
			// the labels so that they do not overlap
			childIdx = leftTopTicIdx;
			yVal = sc.top;
			bDone = false;
			while ((childIdx >= 0) && (!bDone))
			{
				sliceContainer = this.getChildAt(childIdx) as PieSliceContainer;
				ticAngle = sliceContainer.getTicAngle();
				if ((ticAngle > 90) && (ticAngle < 270))
				{
					yVal = sliceContainer.moveLabelDown(sc, yVal);

					childIdx--;
					if (childIdx < 0) childIdx = this.numChildren - 1;

					bDone = (childIdx == leftTopTicIdx);
				}
				else
				{
					bDone = true;
				}
			}
		}

		
		public override function toString():String {
			return "Pie with "+ this.numChildren +" children";
		}
	}
}

/* AS3JS File */
package charts {

	//removeMeIfWant string.Utils;
	//removeMeIfWant charts.series.dots.DefaultDotProperties;
	
	public class Scatter extends ScatterBase
	{
		public function Scatter( json:Object )
		{
			super(json);
			
			this.style = {
				values:			[],
				width:			2,
				colour:			'#3030d0',
				text:			'',		// <-- default not display a key
				'font-size':	12,
				tip:			'[#x#,#y#] #size#',
				axis:			'left'
			};
			
			// hack: keep this incase the merge kills it, we'll
			// remove the merge later (and this hack)
			var tmp:Object = json['dot-style'];
			
			object_helper.merge_2( json, style );
			
			this.default_style = new DefaultDotProperties(
				json['dot-style'], this.style.colour, this.style.axis);
			
//			this.line_width = style.width;
			this.colour		= string.Utils.get_colour( style.colour );
			this.key		= style.text;
			this.font_size	= style['font-size'];
//			this.circle_size = style['dot-size'];
			
			this.values = style.values;

			this.add_values();
		}
	}
}

/* AS3JS File */
package charts {
	
	//removeMeIfWant charts.series.dots.scat;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.dots.dot_factory;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant charts.series.dots.DefaultDotProperties;
	
	public class ScatterBase extends Base {


		protected var style:Object;
		private var on_show:Properties;
		private var dot_style:Properties;
		//
		
		protected var default_style:DefaultDotProperties;
		
		public function ScatterBase(json:Object) {
		
			//
			// merge into Line.as and Base.as
			//
			var root:Properties = new Properties({
				colour: 		'#3030d0',
				text: 			'',		// <-- default not display a key
				'font-size': 	12,
				tip:			'#val#',
				axis:			'left'
			});
			//
			this.props = new Properties(json, root);
			//
			this.dot_style = new DefaultDotProperties(json['dot-style'], this.props.get('colour'), this.props.get('axis'));
			//
			// LOOK for a scatter chart the default dot is NOT invisible!!
			//
		//	this.dot_style.set('type', 'solid-dot');
			//
			// LOOK default animation for scatter is explode, no cascade
			//
			var on_show_root:Properties = new Properties( {
				type:		"explode",
				cascade:	0,
				delay:		0.3
				});
			this.on_show = new Properties(json['on-show'], on_show_root);
			//this.on_show_start = true;
			//
			//
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			// we ignore the X value (index) passed to us,
			// the user has provided their own x value
			
			var default_style:Object = {
				width:			this.style.width,	// stroke
				colour:			this.style.colour,
				tip:			this.style.tip,
				'dot-size':		10
			};
			
			// Apply dot style defined at the plot level
			object_helper.merge_2( this.style['dot-style'], default_style );
			// Apply attributes defined at the value level
			object_helper.merge_2( value, default_style );
				
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = Utils.get_colour( default_style.colour );
			
			//var tmp:Properties = new Properties( value, this.default_style);
			var tmp:Properties = new Properties(value, this.dot_style);
	
			// attach the animation bits:
			tmp.set('on-show', this.on_show);
			
			return dot_factory.make( index, tmp );
		}
		
		// Draw points...
		public override function resize( sc:ScreenCoordsBase ): void {
			
			var tmp:Sprite;
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				tmp = this.getChildAt(i) as Sprite;
				
				//
				// filter out the line masks
				//
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					e.resize( sc );
				}
			}
		}
	}
}

/* AS3JS File */
package charts {
	
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.series.dots.scat;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant charts.series.dots.DefaultDotProperties;
	
	
	public class ScatterLine extends ScatterBase
	{
		public var stepgraph:Number = 0;
		public static const STEP_HORIZONTAL:Number = 1;
		public static const STEP_VERTICAL:Number = 2;

		public function ScatterLine( json:Object )
		{
			super(json);
			//
			// so the mask child can punch a hole through the line
			//
			this.blendMode = BlendMode.LAYER;
			//
			
			this.style = {
				values:			[],
				width:			2,
				colour:			'#3030d0',
				text:			'',		// <-- default not display a key
				'font-size':	12,
				stepgraph:		0,
				axis:			'left'
			};
			
			// hack: keep this incase the merge kills it, we'll
			// remove the merge later (and this hack)
			var tmp:Object = json['dot-style'];
			
			object_helper.merge_2( json, style );
			
			this.default_style = new DefaultDotProperties(
				json['dot-style'], this.style.colour, this.style.axis);
				
			this.style.colour = string.Utils.get_colour( style.colour );

//	TODO: do we use this?
//			this.line_width = style.width;
			this.colour		= this.style.colour;
			this.key		= style.text;
			this.font_size	= style['font-size'];
			//this.circle_size = style['dot-size'];
			
			switch (style['stepgraph']) {
				case 'horizontal':
					stepgraph = STEP_HORIZONTAL;
					break;
				case 'vertical':
					stepgraph = STEP_VERTICAL;
					break;
			}
	
			this.values = style.values;
			this.add_values();
		}
		

		
		// Draw points...
		public override function resize( sc:ScreenCoordsBase ): void {
			
			// move the dots:
			super.resize( sc );
			
			this.graphics.clear();
			this.graphics.lineStyle( this.style.width, this.style.colour );
			
			//if( this.style['line-style'].style != 'solid' )
			//	this.dash_line(sc);
			//else
			this.solid_line(sc);
				
		}
		
		//
		// This is cut and paste from LineBase
		//
		public function solid_line( sc:ScreenCoordsBase ): void {
			
			var first:Boolean = true;
			var last_x:Number = 0;
			var last_y:Number = 0;

			var areaClosed:Boolean = true;
			var isArea:Boolean = false;
			var areaBaseX:Number = NaN;
			var areaBaseY:Number = NaN;
			var areaColour:Number = this.colour;
			var areaAlpha:Number = 0.4;
			var areaStyle:Object = this.style['area-style'];
			if (areaStyle != null)
			{
				isArea = true;
				if (areaStyle.x != null)
				{
					areaBaseX = areaStyle.x;
				}
				if (areaStyle.y != null)
				{
					areaBaseY = areaStyle.y;
				}
				if (areaStyle.colour != null)
				{
					areaColour = string.Utils.get_colour( areaStyle.colour );
				}
				if (areaStyle.alpha != null)
				{
					areaAlpha = areaStyle.alpha;
				}
				if (!isNaN(areaBaseX)) 
				{
					// Convert X Value to screen position
					areaBaseX = sc.get_x_from_val(areaBaseX);
				}
				if (!isNaN(areaBaseY)) 
				{
					// Convert Y Value to screen position
					areaBaseY = sc.get_y_from_val(areaBaseY);  // TODO: Allow for right Y-Axis??
				}
			}
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				
				var tmp:Sprite = this.getChildAt(i) as Sprite;
				
				//
				// filter out the line masks
				//
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					// tell the point where it is on the screen
					// we will use this info to place the tooltip
					e.resize( sc );
					if (!e.visible)
					{
						// Creates a gap in the plot and closes out the current area if defined
						if ((isArea) && (i > 0))
						{
							// draw an invisible line back to the base and close the fill
							areaX = isNaN(areaBaseX) ? last_x : areaBaseX;
							areaY = isNaN(areaBaseY) ? last_y : areaBaseY;
							this.graphics.lineStyle( 0, areaColour, 0 );
							this.graphics.lineTo(areaX, areaY);
							this.graphics.endFill();
							areaClosed = true;
						}
						first = true;
					}
					else if( first )
					{
						if (isArea)
						{
							// draw an invisible line from the base to the point
							var areaX:Number = isNaN(areaBaseX) ? e.x : areaBaseX;
							var areaY:Number = isNaN(areaBaseY) ? e.y : areaBaseY;
							// Begin the fill for the area
							this.graphics.beginFill(areaColour, areaAlpha);
							this.graphics.lineStyle( 0, areaColour, 0 );
							this.graphics.moveTo(areaX, areaY);
							this.graphics.lineTo(e.x, e.y);
							areaClosed = false;
							// change the line style back to normal
							this.graphics.lineStyle( this.style.width, this.style.colour, 1.0 );
						}
						else
						{
							// just move to the point
							this.graphics.moveTo(e.x, e.y);
						}
						first = false;
					}
					else
					{
						if (this.stepgraph == STEP_HORIZONTAL)
							this.graphics.lineTo(e.x, last_y);
						else if (this.stepgraph == STEP_VERTICAL)
							this.graphics.lineTo(last_x, e.y);
					
						this.graphics.lineTo(e.x, e.y);
					}
					last_x = e.x;
					last_y = e.y;
				}
			}

			// Close out the area if defined
			if (isArea && !areaClosed)
			{
				// draw an invisible line back to the base and close the fill
				areaX = isNaN(areaBaseX) ? last_x : areaBaseX;
				areaY = isNaN(areaBaseY) ? last_y : areaBaseY;
				this.graphics.lineStyle( 0, areaColour, 0 );
				this.graphics.lineTo(areaX, areaY);
				this.graphics.endFill();
			}
		}
		
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant string.Utils;
	
	public class Shape extends Base {
		
		private var style:Object;
		
		public function Shape( json:Object )
		{
			this.style = {
				points:				[],
				colour:				'#808080',
				alpha:				0.5
			};
			
			object_helper.merge_2( json, this.style );
			
			this.style.colour		= string.Utils.get_colour( this.style.colour );
			
			for each ( var val:Object in json.values )
				this.style.points.push( new flash.geom.Point( val.x, val.y ) );
		}
		
		public override function resize( sc:ScreenCoordsBase ): void {
			
			this.graphics.clear();
			//this.graphics.lineStyle( this.style.width, this.style.colour );
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( this.style.colour, this.style.alpha );
			
			var moved:Boolean = false;
			
			for each( var p:flash.geom.Point in this.style.points ) {
				if( !moved )
					this.graphics.moveTo( sc.get_x_from_val(p.x), sc.get_y_from_val(p.y) );
				else
					this.graphics.lineTo( sc.get_x_from_val(p.x), sc.get_y_from_val(p.y) );
				
				moved = true;
			}
			
			this.graphics.endFill();
		}
	}
}

/* AS3JS File */
package charts {
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant string.Utils;
	//removeMeIfWant charts.series.tags.Tag;
	
	public class Tags extends Base {
		
		private var style:Object;
		
		public function Tags( json:Object )
		{
			this.style = {
				values:				[],
				colour:				'#000000',
				text:				'[#x#, #y#]',  
				'align-x':			'center',  // center, left, right
				'align-y':			'above',   // above, below, center
				'pad-x':			4,
				'pad-y':			4,
				font:				'Verdana',
				bold:				false,
				'on-click':			null,
				rotate:				0,
				'font-size':		12,
				border:				false,
				underline:			false,
				alpha:				1
			};
			
			object_helper.merge_2( json, this.style );
			
			for each ( var v:Object in this.style.values )
			{
				var tmp:Tag = this.make_tag( v );
				this.addChild(tmp);
			}
		}
		
		private function make_tag( json:Object ):Tag
		{
			var tagStyle:Object = { };
			object_helper.merge_2( this.style, tagStyle );
			object_helper.merge_2( json, tagStyle );
			tagStyle.colour = string.Utils.get_colour(tagStyle.colour);
			
			return new Tag(tagStyle);
		}
		
		public override function resize( sc:ScreenCoordsBase ): void {
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				var tag:Tag = this.getChildAt(i) as Tag;
				tag.resize( sc );
			}
		}
	}
	
}

/* AS3JS File */
package charts.Elements {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant charts.series.bars.Base;
	
	public class PointBarFade extends Base
	{
		
		public function PointBarFade( index:Number, value:Object, colour:Number, group:Number )
		{
			var p:Properties = new Properties(value);
			super(index, p, group);
			//super(index,value,colour,'',0.6,group);
		}
		
		public override function resize( sc:ScreenCoordsBase ):void {
			/*
			var tmp:Object = sc.get_bar_coords(this._x,this.group);
			this.screen_x = tmp.x;
			this.screen_y = sc.get_y_from_val(this._y,axis==2);
			
			var bar_bottom:Number = sc.getYbottom( false );
			
			var top:Number;
			var height:Number;
			
			if( bar_bottom < this.screen_y ) {
				top = bar_bottom;
				height = this.screen_y-bar_bottom;
			}
			else
			{
				top = this.screen_y
				height = bar_bottom-this.screen_y;
			}
			*/
			var h:Object = this.resize_helper( sc as ScreenCoords );
			
			this.graphics.clear();
			this.graphics.beginFill( this.colour, 1.0 );
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo( h.width, 0 );
			this.graphics.lineTo( h.width, h.height );
			this.graphics.lineTo( 0, h.height );
			this.graphics.lineTo( 0, 0 );
			this.graphics.endFill();
		}
	}
}

/* AS3JS File */
package charts.Elements {
	//removeMeIfWant charts.Elements.PointDotBase;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant flash.display.Graphics;
	//removeMeIfWant flash.display.Sprite;
	
	public class Star extends PointDotBase {
		
		public function Star( index:Number, style:Object ) {
			
			super( index, style );
			
			this.visible = true;
			
			this.graphics.clear();
			this.graphics.lineStyle( style.width, style.colour, 1);// style.alpha );
			var rotation:Number = isNaN(style['rotation']) ? 0 : style['rotation'];
			
			this.drawStar( this.graphics, style['dot-size'], rotation );
			
			var haloSize:Number = style['halo-size']+style['dot-size'];
			var s:Sprite = new Sprite();
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( 0, 1 );
			this.drawStar(s.graphics, haloSize, rotation );
			s.blendMode = BlendMode.ERASE;
			s.graphics.endFill();
			this.line_mask = s;
			
			this.attach_events();
			
		}
		
		private function calcXOnCircle(radius:Number, degrees:Number):Number
		{
			return radius * Math.cos(degrees / 180 * Math.PI);
		}
		
		private function calcYOnCircle(radius:Number, degrees:Number):Number
		{
			return radius * Math.sin(degrees / 180 * Math.PI);
		}
		
		private function drawStar( graphics:Graphics, radius:Number, rotation:Number ):void 
		{
			var angle:Number = 360 / 5;

			// Start at top point (unrotated)
			var degrees:Number = -90 + rotation;
			for (var i:int = 0; i <= 5; i++)
			{
				var x:Number = this.calcXOnCircle(radius, degrees);
				var y:Number = this.calcYOnCircle(radius, degrees);
				
				if (i == 0)
					graphics.moveTo(x, y);
				else
					graphics.lineTo(x, y);
					
				// Move 2 points clockwise
				degrees += (2 * angle);
			}
		}
	}
}


/* AS3JS File */
package charts.series {
	
	//removeMeIfWant charts.series.has_tooltip;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant string.Utils;
	//removeMeIfWant global.Global;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant flash.net.URLRequest;
	//removeMeIfWant flash.net.navigateToURL;
	//removeMeIfWant flash.external.ExternalInterface;
	//removeMeIfWant elements.axis.XAxisLabels;
	
	public class Element extends Sprite implements has_tooltip {
		//
		// for line data
		//
		public var _x:Number;
		public var _y:Number;
		
		public var index:Number;
		protected var tooltip:String;
		private var link:String;
		public var is_tip:Boolean;
		
		public var line_mask:Sprite;
		protected var right_axis:Boolean;
		
		
		public function Element()
		{
			// elements don't change shape much, so lets
			// cache it
			this.cacheAsBitmap = true;
			this.right_axis = false;	
		}
		
		public function resize( sc:ScreenCoordsBase ):void {
			
			var p:flash.geom.Point = sc.get_get_x_from_pos_and_y_from_val( this._x, this._y, this.right_axis );
			this.x = p.x;
			this.y = p.y;
		}
		
		//
		// for tooltip closest - return the middle point
		//
		public function get_mid_point():flash.geom.Point {
			
			//
			// dots have x, y in the center of the dot
			//
			return new flash.geom.Point( this.x, this.y );
		}
		
		public function get_x(): Number {
			return this._x;
		}
		
		public function get_y(): Number {
			return this._y;
		}

		/**
		 * When true, this element is displaying a tooltip
		 * and should fade-in, pulse, or become active
		 * 
		 * override this to show hovered states.
		 * 
		 * @param	b
		 */
		public function set_tip( b:Boolean ):void {}
		
		
		//
		// if this is put in the Element constructor, it is
		// called multiple times for some reason :-(
		//
		protected function attach_events():void {
			
			// weak references so the garbage collector will kill them:
			this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut, false, 0, true);
		}
		
		public function mouseOver(event:Event):void {
			this.pulse();
		}
		
		public function pulse():void {
			// pulse:
			Tweener.addTween(this, {alpha:.5, time:0.4, transition:"linear"} );
			Tweener.addTween(this, {alpha:1,  time:0.4, delay:0.4, onComplete:this.pulse, transition:"linear"});
		}

		public function mouseOut(event:Event):void {
			// stop the pulse, then fade in
			Tweener.removeTweens(this);
			Tweener.addTween(this, { alpha:1, time:0.4, transition:Equations.easeOutElastic } );
		}
		
		public function set_on_click( s:String ):void {
			this.link = s;
			this.buttonMode = true;
			this.useHandCursor = true;
			// weak references so the garbage collector will kill it:
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp, false, 0, true);
		}
		
		private function mouseUp(event:Event):void {
			
			if ( this.link.substring(0, 6) == 'trace:' ) {
				// for the test JSON files:
				tr.ace( this.link );
			}
			else if ( this.link.substring(0, 5) == 'http:' )
				this.browse_url( this.link );
			else if ( this.link.substring(0, 6) == 'https:' )
				this.browse_url( this.link );
			else {
				//
				// TODO: fix the on click to pass out the chart id:
				//
				// var ex:ExternalInterfaceManager = ExternalInterfaceManager.getInstance();
				// ex.callJavascript(this.link, this.index);
				ExternalInterface.call( this.link, this.index );
			}
		}
			
		private function browse_url( url:String ):void {
			var req:URLRequest = new URLRequest(this.link);
			try
			{
				navigateToURL(req);
			}
			catch (e:Error)
			{
				trace("Error opening link: " + this.link);
			}
		}
		
		public function get_tip_pos():Object {
			return {x:this.x, y:this.y};
		}
		
		
		//
		// this may be overriden by Collection objects
		//
		public function get_tooltip():String {
			return this.tooltip;
		}

		/**
		 * Replace #x_label# with the label. This is called
		 * after the X Label object has been built (see main.as)
		 * 
		 * @param	labels
		 */
		public function tooltip_replace_labels( labels:XAxisLabels ):void {
			
			tr.aces('x label', this._x, labels.get( this._x ));
			this.tooltip = this.tooltip.replace('#x_label#', labels.get( this._x ) );
		}
		
		/**
		 * Mem leaks
		 */
		public function die():void {
			
			if ( this.line_mask != null ) {
				
				this.line_mask.graphics.clear();
				this.line_mask = null;
			}
		}
	}
}

/* AS3JS File */
package charts.series {
	
	/**
	 * anything that wants to use our tooltips
	 * must implement this interface
	 */
	public interface has_tooltip {
		
		// get the tip string
		function get_tooltip():String;
		
		// this should return a Point
		function get_tip_pos():Object;
		
		// if true, show hover state,
		// if false the item should go
		// back to the ground state. Not hovered.
		function set_tip( b:Boolean ):void;
	}
}

/* AS3JS File */
package charts.series.bars {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Matrix;
	//removeMeIfWant flash.filters.DropShadowFilter;
	//removeMeIfWant charts.series.bars.Base;
	
	public class Bar3D extends Base {
		
		public function Bar3D( index:Number, props:Properties, group:Number ) {
			
			super(index, props, group);
			//super(index, style, style.colour, style.tip, style.alpha, group);
			//super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
			
			var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
			dropShadow.blurX = 5;
			dropShadow.blurY = 5;
			dropShadow.distance = 3;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.4;
			// apply shadow filter
			this.filters = [dropShadow];
		}
	
		public override function resize( sc:ScreenCoordsBase  ):void {
			
			var h:Object = this.resize_helper( sc as ScreenCoords );
			
			this.graphics.clear();
			
			this.draw_top( h.width, h.height );
			this.draw_front( h.width, h.height );
			this.draw_side( h.width, h.height );
		}
		
		private function draw_top( w:Number, h:Number ):void {
			
			this.graphics.lineStyle(0, 0, 0);
			//set gradient fill
			
			var lighter:Number = Bar3D.Lighten( this.colour );
			
			var colors:Array = [this.colour,lighter];
			var alphas:Array = [1,1];
			var ratios:Array = [0,255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w + 12, 12, (270 / 180) * Math.PI );
			this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
			
			
			var y:Number = 0;
			if( h<0 )
				y = h;
			
			this.graphics.moveTo(0, y);
			this.graphics.lineTo(w, y);
			this.graphics.lineTo(w-12, y+12);
			this.graphics.lineTo(-12, y+12);
			this.graphics.endFill();
		}
		
		private function draw_front( w:Number, h:Number ):void {
			//
			var rad:Number = 7;
			
			var lighter:Number = Bar3D.Lighten( this.colour );

			// Darken a light color
			//var darker:Number = this.colour;
			//darker &= 0x7F7F7F;

			var colors:Array = [lighter,this.colour];
			var alphas:Array = [1,1];
			var ratios:Array = [0, 127];
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w - 12, h+12, (90 / 180) * Math.PI );
			this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
			
			this.graphics.moveTo(-12, 12);
			this.graphics.lineTo(-12, h+12);
			this.graphics.lineTo(w-12, h+12);
			this.graphics.lineTo(w-12, 12);
			this.graphics.endFill();
		}
		
		private function draw_side( w:Number, h:Number ):void {
			//
			var rad:Number = 7;
			
			var lighter:Number = Bar3D.Lighten( this.colour );
			
			var colors:Array = [this.colour,lighter];
			var alphas:Array = [1,1];
			var ratios:Array = [0,255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h+12, (270 / 180) * Math.PI );
			this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
			
			
			this.graphics.lineStyle(0, 0, 0);
			this.graphics.moveTo(w, 0);
			this.graphics.lineTo(w, h);
			this.graphics.lineTo(w-12, h+12);
			this.graphics.lineTo(w-12, 12);
			this.graphics.endFill();
		}
		
		//
		// JG: lighten a colour by splitting it
		//     into RGB, then adding a bit to each
		//     value...
		//
		public static function Lighten( col:Number ):Number {
			var rgb:Number = col; //decimal value for a purple color
			var red:Number = (rgb & 16711680) >> 16; //extacts the red channel
			var green:Number = (rgb & 65280) >> 8; //extacts the green channel
			var blue:Number = rgb & 255; //extacts the blue channel
			var p:Number = 2;
			red += red/p;
			if( red > 255 )
				red = 255;
				
			green += green/p;
			if( green > 255 )
				green = 255;
				
			blue += blue/p;
			if( blue > 255 )
				blue = 255;
				
			return red << 16 | green << 8 | blue;
		}
	}
}

/* AS3JS File */
package charts.series.bars {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant charts.series.bars.Base;
	
	public class Bar extends Base {
	
		public function Bar( index:Number, props:Properties, group:Number ) {
			
			super(index, props, group);
		}
		
		public override function resize( sc:ScreenCoordsBase ):void {
			
			var h:Object = this.resize_helper( sc as ScreenCoords );
			
			this.graphics.clear();
			this.graphics.beginFill( this.colour, 1.0 );
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo( h.width, 0 );
			this.graphics.lineTo( h.width, h.height );
			this.graphics.lineTo( 0, h.height );
			this.graphics.lineTo( 0, 0 );
			this.graphics.endFill();
		}
		
	}
}

/* AS3JS File */
package charts.series.bars {

	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant global.Global;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant string.Utils;
	
	public class Base extends Element
	{
		protected var tip_pos:flash.geom.Point;
		protected var colour:Number;
		protected var group:Number;
		protected var top:Number;
		protected var bottom:Number;
		protected var mouse_out_alpha:Number;
		private var on_show_animate:Boolean;
		protected var on_show:Properties;
		
		
		public function Base( index:Number, props:Properties, group:Number )
		{
			super();
			this.index = index;
			this.parse_value(props);
			this.colour = props.get_colour('colour');
				
			this.tooltip = this.replace_magic_values( props.get('tip') );
			
			this.group = group;
			this.visible = true;
			this.on_show_animate = true;
			this.on_show = props.get('on-show');
			
			// remember what our original alpha is:
			this.mouse_out_alpha = props.get('alpha');
			// set the sprit alpha:
			this.alpha = this.mouse_out_alpha;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut);
			
			//
			// This is UGLY!!! We need to decide if we are passing in a SINGLE style object,
			// or many parameters....
			//
			if ( props.has('on-click') )	// <-- may be null/not set
				if( props.get('on-click') != false )	// <-- may be FALSE
					this.set_on_click( props.get('on-click') );
				
			if( props.has('axis') )
				if( props.get('axis') == 'right' )
					this.right_axis = true;
		}
		
		//
		// most line and bar charts have a single value which is the
		// Y position, some like candle and scatter have many values
		// and will override this method to parse their value
		//
		protected function parse_value( props:Properties ):void {
			
			if ( !props.has('bottom') ) {
				// align to Y min OR zero
				props.set('bottom', Number.MIN_VALUE );
			}
			
			this.top = props.get('top');
			this.bottom = props.get('bottom');
		}
		
		protected function replace_magic_values( t:String ): String {
			
			t = t.replace('#top#', NumberUtils.formatNumber( this.top ));
			t = t.replace('#bottom#', NumberUtils.formatNumber( this.bottom ));
			t = t.replace('#val#', NumberUtils.formatNumber( this.top - this.bottom ));
			
			return t;
		}
		
		
		//
		// for tooltip closest - return the middle point
		//
		public override function get_mid_point():flash.geom.Point {
			
			//
			// bars mid point
			//
			return new flash.geom.Point( this.x + (this.width/2), this.y );
		}
		
		public override function mouseOver(event:Event):void {
			this.is_tip = true;
			Tweener.addTween(this, { alpha:1, time:0.6, transition:Equations.easeOutCirc } );
		}

		public override function mouseOut(event:Event):void {
			this.is_tip = false;
			Tweener.addTween(this, { alpha:this.mouse_out_alpha, time:0.8, transition:Equations.easeOutElastic } );
		}
		
		// override this:
		public override function resize( sc:ScreenCoordsBase ):void {}
		
		//
		// tooltip.left for bars center over the bar
		//
		public override function get_tip_pos(): Object {
			return {x:this.tip_pos.x, y:this.tip_pos.y };
		}
		

		//
		// Called by most of the bar charts.
		// Moves the Sprite into the correct position, then
		// returns the bounds so the bar can draw its self.
		//
		protected function resize_helper( sc:ScreenCoords ):Object {
			var tmp:Object = sc.get_bar_coords(this.index, this.group);

			var bar_top:Number = sc.get_y_from_val(this.top, this.right_axis);
			var bar_bottom:Number;
			
			if( this.bottom == Number.MIN_VALUE )
				bar_bottom = sc.get_y_bottom(this.right_axis);
			else
				bar_bottom = sc.get_y_from_val(this.bottom, this.right_axis);
			
			var top:Number;
			var height:Number;
			var upside_down:Boolean = false;
			
			if( bar_bottom < bar_top ) {
				top = bar_bottom;
				upside_down = true;
			}
			else
			{
				top = bar_top;
			}
			
			height = Math.abs( bar_bottom - bar_top );
			
			
			//
			// tell the tooltip where to show its self
			//
			this.tip_pos = new flash.geom.Point( tmp.x + (tmp.width / 2), top );
			
			if ( this.on_show_animate )
				this.first_show(tmp.x, top, tmp.width, height);
			else {
				//
				// move the Sprite to the correct screen location:
				//
				this.y = top;
				this.x = tmp.x;
			}
				
			//
			// return the bounds to draw the item:
			//
			return { width:tmp.width, top:top, height:height, upside_down:upside_down };
		}
		
		protected function first_show(x:Number, y:Number, width:Number, height:Number): void {
			
			this.on_show_animate = false;
			Tweener.removeTweens(this);
			
			// tr.aces('base.as', this.on_show.get('type') );
			var d:Number = x / this.stage.stageWidth;
			d *= this.on_show.get('cascade');
			d += this.on_show.get('delay');
		
			switch( this.on_show.get('type') ) {
				
				case 'pop-up':
					this.x = x;
					this.y = this.stage.stageHeight + this.height + 3;
					Tweener.addTween(this, { y:y, time:1, delay:d, transition:Equations.easeOutBounce } );
					break;
					
				case 'drop':
					this.x = x;
					this.y = -height - 10;
					Tweener.addTween(this, { y:y, time:1, delay:d, transition:Equations.easeOutBounce } );
					break;

				case 'fade-in':
					this.x = x;
					this.y = y;
					this.alpha = 0;
					Tweener.addTween(this, { alpha:this.mouse_out_alpha, time:1.2, delay:d, transition:Equations.easeOutQuad } );
					break;
					
				case 'grow-down':
					this.x = x;
					this.y = y;
					this.scaleY = 0.01;
					Tweener.addTween(this, { scaleY:1, time:1.2, delay:d, transition:Equations.easeOutQuad } );
					break;
					
				case 'grow-up':
					this.x = x;
					this.y = y+height;
					this.scaleY = 0.01;
					Tweener.addTween(this, { scaleY:1, time:1.2, delay:d, transition:Equations.easeOutQuad } );
					Tweener.addTween(this, { y:y, time:1.2, delay:d, transition:Equations.easeOutQuad } );
					break;
				
				case 'pop':
					this.y = top;
					this.alpha = 0.2;
					Tweener.addTween(this, { alpha:this.mouse_out_alpha, time:0.7, delay:d, transition:Equations.easeOutQuad } );
					
					// shrink the bar to 3x3 px
					this.x = x + (width/2);
					this.y = y + (height/2);
					this.width = 3;
					this.height = 3;
					
					Tweener.addTween(this, { x:x, y:y, width:width, height:height, time:1.2, delay:d, transition:Equations.easeOutElastic } );
					break;
					
				default:
					this.y = y;
					this.x = x;
				
			}
		}	
	}
}

/* AS3JS File */
package charts.series.bars {

	//removeMeIfWant charts.series.bars.Base;
	//removeMeIfWant flash.filters.DropShadowFilter;
	//removeMeIfWant flash.geom.Matrix;

	public class Cylinder extends Base
	{

		public function Cylinder( index:Number, props:Properties, group:Number ) {

			super(index, props, group);
			// MASSIVE HACK:
			//super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

			//super(index, style, style.colour, style.tip, style.alpha, group);

			var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
			dropShadow.blurX = 5;
			dropShadow.blurY = 5;
			dropShadow.distance = 3;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.4;
			// apply shadow filter
			this.filters = [dropShadow];
		}

		public override function resize( sc:ScreenCoordsBase ):void {

			this.graphics.clear();
			var h:Object = this.resize_helper( sc as ScreenCoords );

			this.bg( h.width, h.height, h.upside_down );
			this.glass( h.width, h.height, h.upside_down );
		}

		private function bg( w:Number, h:Number, upside_down:Boolean ):void {

			var rad:Number = w/3;
			if ( rad > ( w / 2 ) )
				rad = w / 2;

			this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);

			var bgcolors:Array = GetColours(this.colour);
			var bgalphas:Array = [1, 1];
			var bgratios:Array = [0, 255];
			var bgmatrix:Matrix = new Matrix();
			var xRadius:Number;
			var yRadius:Number;
			var x:Number;
			var y:Number;

			bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
			this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );

			/* draw bottom half ellipse */
			x = w/2;
			y = h;
			xRadius = w / 2;
			yRadius = rad / 2;
			halfEllipse(x, y, xRadius, yRadius, 100);

			/* draw connecting rectangle */
			this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, h);
			this.graphics.lineTo(w, h);
			this.graphics.lineTo(w, 0);   

			/* draw top ellipse */
			this.graphics.beginFill(this.colour, 1);
			x = w / 2;
			y = 0;
			xRadius = w / 2;
			yRadius = rad / 2;
			Ellipse(x, y, xRadius, yRadius, 100);

			this.graphics.endFill();
		}

		private function glass( w:Number, h:Number, upside_down:Boolean ): void {

			/* if this section is commented out, the white shine overlay will not be drawn */

			this.graphics.lineStyle(0, 0, 0);
			//set gradient fill
			var colors:Array = [0xFFFFFF, 0xFFFFFF];
			var alphas:Array = [0, 0.5];
			var ratios:Array = [150,255];         
			var xRadius:Number;
			var yRadius:Number;
			var x:Number;
			var y:Number;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
			this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
			var rad:Number = w / 3;

			/* draw bottom half ellipse shine */
			x = w/2;
			y = h;
			xRadius = w / 2;
			yRadius = rad / 2;
			halfEllipse(x, y, xRadius, yRadius, 100);

			/*draw connecting rectangle shine */
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, h);
			this.graphics.lineTo(w, h);
			this.graphics.lineTo(w, 0);   
			 

			/* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
			this.graphics.beginFill(this.colour, 1);
			x = w / 2;
			y = 0;
			xRadius = w / 2;
			yRadius = rad / 2;
			Ellipse(x, y, xRadius, yRadius, 100);   

			/* draw top ellipse shine */
			this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, [25,255], matrix, 'pad'/*SpreadMethod.PAD*/ );
			x = w / 2;
			y = 0;
			xRadius = w / 2;
			yRadius = rad / 2;
			Ellipse(x, y, xRadius, yRadius, 100);

			this.graphics.endFill();
		}

		/* function to process colors */
		/* returns a base color and a highlight color for the gradients based on the color passed in */
		public static function GetColours( col:Number ):Array {
			var rgb:Number = col; /* decimal value for color */
			var red:Number = (rgb & 16711680) >> 16; /* extacts the red channel */
			var green:Number = (rgb & 65280) >> 8; /* extacts the green channel */
			var blue:Number = rgb & 255; /* extacts the blue channel */
			var shift:Number = 2; /* shift factor */
			var basecolor:Number = col; /* base color to be returned */
			var highlight:Number = col; /* highlight color to be returned */
			var bgred:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
			var bggreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
			var bgblue:Number = rgb & 255; /* blue channel for highlight */
			var hired:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
			var higreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
			var hiblue:Number = rgb & 255; /* blue channel for highlight */

			/* set base color components based on ability to shift lighter */   
			if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255)
			{
				bgred = red - red / shift;
				bggreen = green - green / shift;
				bgblue = blue - blue / shift;
			}            

			/* set highlight components based on base colors */   
			hired = bgred + red / shift;
			hiblue = bgblue + blue / shift;
			higreen = bggreen + green / shift;

			/* reconstruct base and highlight */
			basecolor = bgred << 16 | bggreen << 8 | bgblue;
			highlight = hired << 16 | higreen << 8 | hiblue;

			/* return base and highlight */
			return [highlight, basecolor];
		}

		/* ellipse cos helper function */
		public static function magicTrigFunctionX (pointRatio:Number):Number{
			return Math.cos(pointRatio*2*Math.PI);
		}

		/* ellipse sin helper function */
		public static function magicTrigFunctionY (pointRatio:Number):Number{
			return Math.sin(pointRatio*2*Math.PI);
		}

		/* ellipse function */
		/* draws an ellipse from passed center coordinates, x and y radii, and number of sides */
		public function Ellipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{

			/* move to first point on ellipse */
			this.graphics.moveTo(centerX + xRadius,  centerY);

			/* loop through sides and draw curves */
			for(var i:Number=0; i<=sides; i++){
				var pointRatio:Number = i/sides;
				var xSteps:Number = magicTrigFunctionX(pointRatio);
				var ySteps:Number = magicTrigFunctionY(pointRatio);
				var pointX:Number = centerX + xSteps * xRadius;
				var pointY:Number = centerY + ySteps * yRadius;
				this.graphics.lineTo(pointX, pointY);
			}

			/* return 1 */
			return 1;
		}

		/* (bottom) half ellipse function */
		/* draws the bottom half of an ellipse from passed center coordinates, x and y radii, and number of sides */
		public function halfEllipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{

			/* move to first point on ellipse */
			this.graphics.moveTo(centerX + xRadius,  centerY);

			/* loop through sides and draw curves */
			for(var i:Number=0; i<=sides/2; i++){
				var pointRatio:Number = i/sides;
				var xSteps:Number = magicTrigFunctionX(pointRatio);
				var ySteps:Number = magicTrigFunctionY(pointRatio);
				var pointX:Number = centerX + xSteps * xRadius;
				var pointY:Number = centerY + ySteps * yRadius;
				this.graphics.lineTo(pointX, pointY);
			}

			/* return 1 */
			return 1;
		}
	}
}

/* AS3JS File */
package charts.series.bars {
		
	//removeMeIfWant charts.series.bars.Base;
	//removeMeIfWant flash.filters.DropShadowFilter;
	//removeMeIfWant flash.geom.Matrix;

	public class CylinderOutline extends Base {

		public function CylinderOutline( index:Number, props:Properties, group:Number ) {

			super(index, props, group);
			//// MASSIVE HACK:
			//super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

//             super(index, style, style.colour, style.tip, style.alpha, group);

			var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
			dropShadow.blurX = 5;
			dropShadow.blurY = 5;
			dropShadow.distance = 3;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.4;
			// apply shadow filter
			this.filters = [dropShadow];
		}

		public override function resize( sc:ScreenCoordsBase ):void {

			this.graphics.clear();
			var h:Object = this.resize_helper( sc as ScreenCoords );

			this.bg( h.width, h.height, h.upside_down );
			this.glass( h.width, h.height, h.upside_down );
		}

          private function bg( w:Number, h:Number, upside_down:Boolean ):void {

             var rad:Number = w/3;
             if ( rad > ( w / 2 ) )
                rad = w / 2;
                
             this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);
             
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
             
                /* draw bottom half ellipse */
                x = w/2;
                y = h;
                xRadius = w / 2;
                yRadius = rad / 2;
                halfEllipse(x, y, xRadius, yRadius, 100, false);
                   
                /* draw connecting rectangle */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                this.graphics.moveTo(0, 0);
                this.graphics.lineTo(0, h);
                this.graphics.lineTo(w, h);
                this.graphics.lineTo(w, 0);   
                   
                /* draw top ellipse */
                //this.graphics.beginFill(this.colour, 1);
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                x = w / 2;
                y = 0;
                xRadius = w / 2;
                yRadius = rad / 2;
                Ellipse(x, y, xRadius, yRadius, 100);
             
             this.graphics.endFill();
          }
          
          private function glass( w:Number, h:Number, upside_down:Boolean ): void {
             
             /* if this section is commented out, the white shine overlay will not be drawn */
             
             this.graphics.lineStyle(0, 0, 0);
             //set gradient fill
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             var colors:Array = [0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.5];
             var ratios:Array = [150,255];         
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var matrix:Matrix = new Matrix();
             matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
             var rad:Number = w / 3;
                
                /* draw bottom half ellipse shine */
                x = w/2;
                y = h;
                xRadius = w / 2 - (0.025*w);
                yRadius = rad / 2 - (0.025*w);
                halfEllipse(x, y, xRadius, yRadius, 100, false);
                
                /*draw connecting rectangle shine */
                this.graphics.moveTo(0 + (0.025*w), 0 + (0.025*w));
                this.graphics.lineTo(0 + (0.025*w), h);
                this.graphics.lineTo(w - (0.025*w), h);
                this.graphics.lineTo(w - (0.025*w), 0 + (0.025*w));   
                         
                      
                /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
                //this.graphics.beginFill(this.colour, 1);
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                x = w / 2;
                y = 0;
                xRadius = w / 2;
                yRadius = rad / 2;
                Ellipse(x, y, xRadius, yRadius, 100);   
                
                /* draw top ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, [25,255], matrix, 'pad'/*SpreadMethod.PAD*/ );
                x = w / 2;
                y = 0;
                xRadius = w / 2  - (0.025*w);
                yRadius = rad / 2  - (0.025*w);
                Ellipse(x, y, xRadius, yRadius, 100);
                   
                this.graphics.endFill();
          }
          
          /* function to process colors */
          /* returns a base color and a highlight color for the gradients based on the color passed in */
          public static function GetColours( col:Number ):Array {
             var rgb:Number = col; /* decimal value for color */
             var red:Number = (rgb & 16711680) >> 16; /* extacts the red channel */
             var green:Number = (rgb & 65280) >> 8; /* extacts the green channel */
             var blue:Number = rgb & 255; /* extacts the blue channel */
             var shift:Number = 2; /* shift factor */
             var basecolor:Number = col; /* base color to be returned */
             var highlight:Number = col; /* highlight color to be returned */
             var bgred:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var bggreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var bgblue:Number = rgb & 255; /* blue channel for highlight */
             var hired:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var higreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var hiblue:Number = rgb & 255; /* blue channel for highlight */
             
             /* set base color components based on ability to shift lighter */   
             if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255)
             {
                bgred = red - red / shift;
                bggreen = green - green / shift;
                bgblue = blue - blue / shift;
             }            
                
             /* set highlight components based on base colors */   
             hired = bgred + red / shift;
             hiblue = bgblue + blue / shift;
             higreen = bggreen + green / shift;
             
             /* reconstruct base and highlight */
             basecolor = bgred << 16 | bggreen << 8 | bgblue;
             highlight = hired << 16 | higreen << 8 | hiblue;
                      
             /* return base and highlight */
             return [highlight, basecolor];
          }
          
          /* ellipse cos helper function */
          public static function magicTrigFunctionX (pointRatio:Number):Number{
             return Math.cos(pointRatio*2*Math.PI);
          }
          
          /* ellipse sin helper function */
          public static function magicTrigFunctionY (pointRatio:Number):Number{
             return Math.sin(pointRatio*2*Math.PI);
          }
          
          /* ellipse function */
          /* draws an ellipse from passed center coordinates, x and y radii, and number of sides */
          public function Ellipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=0; i<=sides; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
          /* half ellipse function */
          /* draws half of an ellipse from passed center coordinates, x and y radii, number of sides , and top/bottom */
          public function halfEllipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number, top:Boolean):Number{
             
             var loopStart:Number;
             var loopEnd:Number;
             
             if (top == true)
             {
                loopStart = sides / 2;
                loopEnd = sides;
             }
             else
             {
                loopStart = 0;
                loopEnd = sides / 2;            
             }
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=loopStart; i<=loopEnd; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
       }
    }

/* AS3JS File */
package charts.series.bars {
	//removeMeIfWant flash.filters.DropShadowFilter;
	//removeMeIfWant flash.geom.Matrix;
	//removeMeIfWant charts.series.bars.Base;

	public class Dome extends Base
	{

		public function Dome( index:Number, props:Properties, group:Number ) {

			super(index, props, group);
			//super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
			//super(index, style, style.colour, style.tip, style.alpha, group);

			var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
			dropShadow.blurX = 5;
			dropShadow.blurY = 5;
			dropShadow.distance = 3;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.4;
			// apply shadow filter
			this.filters = [dropShadow];
		}

		public override function resize( sc:ScreenCoordsBase ):void {

			this.graphics.clear();
			var h:Object = this.resize_helper( sc as ScreenCoords );

			this.bg( h.width, h.height, h.upside_down );
			this.glass( h.width, h.height, h.upside_down );
		}
          
          private function bg( w:Number, h:Number, upside_down:Boolean ):void {

             var rad:Number = w/3;
             if ( rad > ( w / 2 ) )
                rad = w / 2;
                
             this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);
             
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
             
                if (!upside_down && h > 0)
                { /* draw bar upward */
                
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                      
                      /* draw bottom half ellipse */
                      x = w/2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                                        
                      /* draw connecting rectangle */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                      this.graphics.moveTo(0, w/2);
                      this.graphics.lineTo(0, h);
                      this.graphics.lineTo(w, h);
                      this.graphics.lineTo(w, w / 2);   
                               
                      /* draw top ellipse */
                      //this.graphics.beginFill(this.colour, 1);
                      x = w / 2;
                      y = w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                   
                   else
                   
                   { /* bar is too short for normal draw */
                      
                      /* draw bottom half ellipse */
                      x = w/2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);   
                               
                      /* draw top ellipse */
                      x = w / 2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = h;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                }
                
                else
                
                { /*draw bar downward */
                   
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                
                      /* draw top half ellipse */
                      x = w/2;
                      y = 0;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                         
                      /* draw connecting rectangle */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                      this.graphics.moveTo(0, 0);
                      this.graphics.lineTo(0, h - w / 2);
                      this.graphics.lineTo(w, h - w / 2);
                      this.graphics.lineTo(w, 0);   
                         
                      /* draw bottom ellipse */
                      //this.graphics.beginFill(this.colour, 1);
                      x = w / 2;
                      y = h - w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                   
                   }
                   
                   else
                   
                   { /* bar is too short for normal draw */
                   
                      if (h > 0)
                      
                      { /* bar greater than zero */
                      
                         /* draw top half ellipse */
                         x = w/2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = rad / 2;
                         halfEllipse(x, y, xRadius, yRadius, 100, true);   
                                  
                         /* draw bottom ellipse */
                         x = w / 2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = h;
                         halfEllipse(x, y, xRadius, yRadius, 100, false);
                         
                      }
                      
                      else
                      
                      { /* bar is zero */
                      
                         /* draw top ellipse */
                         x = w/2;
                         y = h;
                         xRadius = w / 2;
                         yRadius = rad / 4;
                         Ellipse(x, y, xRadius, yRadius, 100);         
                         
                      }
                      
                   }
                   
                }
             
             this.graphics.endFill();
          }
          
          private function glass( w:Number, h:Number, upside_down:Boolean ): void {
             
             /* if this section is commented out, the white shine overlay will not be drawn */
             
             this.graphics.lineStyle(0, 0, 0);
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             
             /* set gradient fill */
             var colors:Array = [0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.75];
             var ratios:Array = [100,255];         
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var matrix:Matrix = new Matrix();
             matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
             var rad:Number = w / 3;
                
                if (!upside_down && h > 0)
                { /* draw shine upward */
                
                   if (h >= w / 2)
                   { /* bar is tall enough for normal draw */
                
                      /* draw bottom half ellipse shine */
                      x = w/2;
                      y = h;
                      xRadius = w / 2 - (0.05 * w);
                      yRadius = rad / 2 - (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                      
                      /*draw connecting rectangle shine */
                      this.graphics.moveTo(0 + (0.05 * w), w/2);
                      this.graphics.lineTo(0 + (0.05 * w), h);
                      this.graphics.lineTo(w - (0.05 * w), h);
                      this.graphics.lineTo(w - (0.05 * w), w/2);   
                               
                            
                      /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w / 2;
                      y = w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                      /* draw top ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                   
                   }
                   
                   else
                   
                   { /* bar is not tall enough for normal draw */
                
                      /* draw bottom half ellipse shine */
                      x = w/2;
                      y = h;
                      xRadius = w / 2 - (0.05 * w);
                      yRadius = rad / 2 - (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);      
                      
                      /* draw top ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = h - 2.5*(0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                
                }
                
                else
                
                { /* draw shine downward */
                   
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                   
                      /* draw top half ellipse shine */
                      x = w/2;
                      y = 0;
                      xRadius = w / 2 - (0.05 * w);
                      yRadius = rad / 2 - (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                      /*draw connecting rectangle shine */
                      this.graphics.moveTo(0 + (0.05 * w), 0);
                      this.graphics.lineTo(0 + (0.05 * w), h - w / 2);
                      this.graphics.lineTo(w - (0.05 * w), h - w / 2);
                      this.graphics.lineTo(w - (0.05 * w), 0);   
                               
                            
                      /* redraw bottom ellipse (to overwrite connecting rectangle shine overlap)*/
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w / 2;
                      y = h - w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                      
                      /* draw bottom ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h - w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                   
                   }
                   
                   else
                   
                   { /* bar is not tall enough for normal draw */
                   
                      if (h > 0)
                      { /* bar is greater than zero */
                         
                         /* draw top half ellipse shine */
                         x = w/2;
                         y = 0;
                         xRadius = w / 2 - (0.05 * w);
                         yRadius = rad / 2 - (0.05 * w);
                         halfEllipse(x, y, xRadius, yRadius, 100, true);
                         
                         /* draw bottom ellipse shine */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                         x = w / 3;
                         y = 0;
                         xRadius = w / 3 - (0.05 * w);
                         yRadius = h - 2.5*(0.05 * w);
                         halfEllipse(x, y, xRadius, yRadius, 100, false);   
                         
                      }
                      
                      else
                      
                      { /* bar is zero */
                   
                         /* draw top ellipse shine */
                         x = w/2;
                         y = h;
                         xRadius = w / 2 - (0.05 * w);
                         yRadius = rad / 4 - (0.05 * w);
                         Ellipse(x, y, xRadius, yRadius, 100);
                         
                      }   
                      
                   }
                   
                }
                   
                this.graphics.endFill();
          }
          
          /* function to process colors */
          /* returns a base color and a highlight color for the gradients based on the color passed in */
          public static function GetColours( col:Number ):Array {
             var rgb:Number = col; /* decimal value for color */
             var red:Number = (rgb & 16711680) >> 16; /* extacts the red channel */
             var green:Number = (rgb & 65280) >> 8; /* extacts the green channel */
             var blue:Number = rgb & 255; /* extacts the blue channel */
             var shift:Number = 2; /* shift factor */
             var basecolor:Number = col; /* base color to be returned */
             var highlight:Number = col; /* highlight color to be returned */
             var bgred:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var bggreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var bgblue:Number = rgb & 255; /* blue channel for highlight */
             var hired:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var higreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var hiblue:Number = rgb & 255; /* blue channel for highlight */
             
             /* set base color components based on ability to shift lighter */   
             if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255)
             {
                bgred = red - red / shift;
                bggreen = green - green / shift;
                bgblue = blue - blue / shift;
             }            
                
             /* set highlight components based on base colors */   
             hired = bgred + red / shift;
             hiblue = bgblue + blue / shift;
             higreen = bggreen + green / shift;
             
             /* reconstruct base and highlight */
             basecolor = bgred << 16 | bggreen << 8 | bgblue;
             highlight = hired << 16 | higreen << 8 | hiblue;
                      
             /* return base and highlight */
             return [highlight, basecolor];
          }
          
          /* ellipse cos helper function */
          public static function magicTrigFunctionX (pointRatio:Number):Number{
             return Math.cos(pointRatio*2*Math.PI);
          }
          
          /* ellipse sin helper function */
          public static function magicTrigFunctionY (pointRatio:Number):Number{
             return Math.sin(pointRatio*2*Math.PI);
          }
          
          /* ellipse function */
          /* draws an ellipse from passed center coordinates, x and y radii, and number of sides */
          public function Ellipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=0; i<=sides; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
          /* half ellipse function */
          /* draws half of an ellipse from passed center coordinates, x and y radii, number of sides , and top/bottom */
          public function halfEllipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number, top:Boolean):Number{
             
             var loopStart:Number;
             var loopEnd:Number;
             
             if (top == true)
             {
                loopStart = sides / 2;
                loopEnd = sides;
             }
             else
             {
                loopStart = 0;
                loopEnd = sides / 2;            
             }
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=loopStart; i<=loopEnd; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
       }
    }

/* AS3JS File */
package charts.series.bars {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant charts.series.bars.Base;
	
	public class ECandle extends Base {
		protected var high:Number;
		protected var low:Number;
		protected var negative_colour:Number;

		
		public function ECandle( index:Number, props:Properties, group:Number ) {
			
			super(index, props, group);
			
			tr.aces( props.has('negative-colour'), props.get_colour('negative-colour'));
			
			if( props.has('negative-colour') )
				this.negative_colour = props.get_colour('negative-colour');
			else
				this.negative_colour = this.colour;
		}
		
		//
		// a candle chart has many values used to display each point
		//
		protected override function parse_value( props:Properties ):void {
			
			// set top (open) and bottom (close)
			super.parse_value( props );
			this.high = props.get('high');
			this.low = props.get('low');
		}
		
		protected override function replace_magic_values( t:String ): String {
			
			t = super.replace_magic_values( t );
			t = t.replace('#high#', NumberUtils.formatNumber( this.high ));
			t = t.replace('#open#', NumberUtils.formatNumber( this.top ));
			t = t.replace('#close#', NumberUtils.formatNumber( this.bottom ));
			t = t.replace('#low#', NumberUtils.formatNumber( this.low ));
			
			return t;
		}
		
		public override function resize( sc:ScreenCoordsBase ):void {
			
			// this moves everyting relative to the box (NOT the whiskers)
			var h:Object = this.resize_helper( sc as ScreenCoords );
			
			// 
			//var bar_high:Number = 0;
			//var bar_low:Number = height;
			
			// calculate the box position:
			var tmp:Number			= sc.get_y_from_val(Math.max(this.top, this.bottom), this.right_axis);
			var bar_high:Number		= sc.get_y_from_val(this.high, this.right_axis) - tmp;
			var bar_top:Number		= 0;
			var bar_bottom:Number	= sc.get_y_from_val(this.bottom, this.right_axis) - tmp;
			var bar_low:Number		= sc.get_y_from_val(this.low, this.right_axis) - tmp;
			
			//var height:Number = Math.abs( bar_bottom - bar_top );
			
			//
			// move the Sprite to the correct screen location:
			//
			//this.y = bar_high;
			//this.x = tmp.x;
			
			//
			// tell the tooltip where to show its self
			//
			this.tip_pos = new flash.geom.Point( this.x + (h.width / 2), this.y );
			
			var mid:Number = h.width / 2;
			this.graphics.clear();
			var c:Number = this.colour;
			if ( h.upside_down)
				c = this.negative_colour;
			
			this.top_line(c, mid, bar_high);
			
			if ( this.top == this.bottom )
				this.draw_doji(c, h.width, bar_top);
			else
				this.draw_box(c, bar_top, h.height, h.width, h.upside_down);
			
			this.bottom_line(c, mid, h.height, bar_low);
			// top line
			
			//
			// tell the tooltip where to show its self
			//
			this.tip_pos = new flash.geom.Point(
				this.x + (h.width / 2),
				this.y + bar_high );
		}
		
		private function top_line(colour:Number, mid:Number, height:Number): void {
			// top line
			this.graphics.beginFill( colour, 1.0 );
			this.graphics.moveTo( mid-1, 0 );
			this.graphics.lineTo( mid+1, 0 );
			this.graphics.lineTo( mid+1, height );
			this.graphics.lineTo( mid-1, height );
			this.graphics.endFill();
		}
		
		private function bottom_line(colour:Number, mid:Number, top:Number, bottom:Number):void {
			this.graphics.beginFill( colour, 1.0 );
			this.graphics.moveTo( mid-1, top );
			this.graphics.lineTo( mid+1, top );
			this.graphics.lineTo( mid+1, bottom );
			this.graphics.lineTo( mid-1, bottom );
			this.graphics.endFill();
		}
		
		//
		// http://en.wikipedia.org/wiki/Candlestick_chart
		//
		private function draw_doji(colour:Number, width:Number, pos:Number):void {
			// box
			this.graphics.beginFill( colour, 1.0 );
			this.graphics.moveTo( 0, pos-1 );
			this.graphics.lineTo( width, pos-1 );
			this.graphics.lineTo( width, pos+1 );
			this.graphics.lineTo( 0, pos+1 );
			this.graphics.endFill();
		}
		
	
		
		private function draw_box(colour:Number, top:Number, bottom:Number, width:Number, upside_down:Boolean):void {
			
			// box
			this.graphics.beginFill( colour, 1.0 );
			this.graphics.moveTo( 0, top );
			this.graphics.lineTo( width, top );
			this.graphics.lineTo( width, bottom );
			this.graphics.lineTo( 0, bottom );
			this.graphics.lineTo( 0, top );
			
			if ( upside_down) {
				// snip out the middle of the box:
				this.graphics.moveTo( 2, top+2 );
				this.graphics.lineTo( width-2, top+2 );
				this.graphics.lineTo( width-2, bottom-2 );
				this.graphics.lineTo( 2, bottom-2 );
				this.graphics.lineTo( 2, top+2 );
			}
			this.graphics.endFill();
			
			if ( upside_down ) {
				
				//
				// HACK: we fill an invisible rect over
				//       the hollow rect so the mouse over
				//       event fires correctly (even when the
				//       mouse is in the hollow part)
				//
				this.graphics.lineStyle( 0, 0, 0 );
				this.graphics.beginFill(0, 0);
				this.graphics.moveTo( 2, top-2 );
				this.graphics.lineTo( width-2, top-2 );
				this.graphics.lineTo( width-2, bottom-2 );
				this.graphics.lineTo( 2, bottom-2 );
				this.graphics.endFill();
			}
		}
			
	}
}

/* AS3JS File */
package charts.series.bars {
	
	//removeMeIfWant flash.filters.DropShadowFilter;
	//removeMeIfWant flash.geom.Matrix;
	//removeMeIfWant charts.series.bars.Base;
	
	public class Glass extends Base
	{
		
		public function Glass( index:Number, props:Properties, group:Number ) {
			
			super(index, props, group);
			//super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
			//super(index, style, style.colour, style.tip, style.alpha, group);
			
			var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
			dropShadow.blurX = 5;
			dropShadow.blurY = 5;
			dropShadow.distance = 3;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.4;
			// apply shadow filter
			this.filters = [dropShadow];
		}
		
		public override function resize( sc:ScreenCoordsBase ):void {
			
			this.graphics.clear();
			var h:Object = this.resize_helper( sc as ScreenCoords );
			if (h.height == 0)
				return;
			
			this.bg( h.width, h.height, h.upside_down );
			this.glass( h.width, h.height, h.upside_down );
		}
		
		private function bg( w:Number, h:Number, upside_down:Boolean ):void {
			//
			var rad:Number = 7;
			if ( rad > ( w / 2 ) )
				rad = w / 2;
				
			this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);
			this.graphics.beginFill(this.colour, 1);
			
			if( !upside_down )
			{
				// bar goes up
				this.graphics.moveTo(0+rad, 0);
				this.graphics.lineTo(w-rad, 0);
				this.graphics.curveTo(w, 0, w, rad);
				this.graphics.lineTo(w, h);
				this.graphics.lineTo(0, h);
				this.graphics.lineTo(0, 0+rad);
				this.graphics.curveTo(0, 0, 0+rad, 0);
			}
			else
			{
				// bar goes down
				this.graphics.moveTo(0, 0);
				this.graphics.lineTo(w, 0);
				this.graphics.lineTo(w, h-rad);
				this.graphics.curveTo(w,h,w-rad, h);
				this.graphics.lineTo(rad, h);
				this.graphics.curveTo(0,h,0, h-rad);
				this.graphics.lineTo(0, 0);
			}
			this.graphics.endFill();
		}
		
		private function glass( w:Number, h:Number, upside_down:Boolean ): void {
			var x:Number = 2;
			var y:Number = x;
			var width:Number = (w/2)-x;
			
			if( upside_down )
				y -= x;
			
			h -= x;
			
			this.graphics.lineStyle(0, 0, 0);
			//set gradient fill
			var colors:Array = [0xFFFFFF,0xFFFFFF];
			var alphas:Array = [0.3, 0.7];
			var ratios:Array = [0,255];
			//var matrix:Object = { matrixType:"box", x:x, y:y, w:width, h:height, r:(180/180)*Math.PI };
			//mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
			this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
			
			var rad:Number = 4;
			var w:Number = width;
			
			if( !upside_down )
			{
				this.graphics.moveTo(x+rad, y);		// <-- top
				this.graphics.lineTo(x+w, y);
				this.graphics.lineTo(x+w, y+h);
				this.graphics.lineTo(x, y+h);
				this.graphics.lineTo(x, y+rad);
				this.graphics.curveTo(x, y, x+rad, y);
			}
			else
			{
				this.graphics.moveTo(x, y);
				this.graphics.lineTo(x+w, y);
				this.graphics.lineTo(x+w, y+h);
				this.graphics.lineTo(x + rad, y + h);
				this.graphics.curveTo(x, y+h, x, y+h-rad);
			}
			this.graphics.endFill();
		}
	}
}

/* AS3JS File */
package charts.series.bars {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant charts.series.Element;
	
	public class Horizontal extends Element
	{
		private var right:Number;
		private var left:Number;
		//protected var width:Number;
		
		public var colour:Number;
		protected var group:Number;
		
		public function Horizontal( index:Number, style:Object, group:Number )
		{
			super();
			//
			// we use the index of this bar to find its Y position
			//
			this.index = index;
			//
			// horizontal bar: value = X Axis position
			// we'll use the ScreenCoords object to go [value -> x location]
			//
			
			this.left = style.left ? style.left : 0;
			this.right = style.right ? style.right : 0;
			
			this.colour = style.colour;
			this.group = group;
			this.visible = true;
			
			this.alpha = 0.5;
			
			this.tooltip = this.replace_magic_values( style.tip );
			
			this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut);
			
		}

		protected function replace_magic_values( t:String ): String {
			
			t = t.replace('#right#', NumberUtils.formatNumber( this.right ));
			t = t.replace('#left#', NumberUtils.formatNumber( this.left ));
			t = t.replace('#val#', NumberUtils.formatNumber( this.right - this.left ));
			
			return t;
		}
		
		public override function mouseOver(event:Event):void {
			Tweener.addTween(this, { alpha:1, time:0.6, transition:Equations.easeOutCirc } );
		}

		public override function mouseOut(event:Event):void {
			Tweener.addTween(this, { alpha:0.5, time:0.8, transition:Equations.easeOutElastic } );
		}
		
		public override function resize( sc:ScreenCoordsBase ):void {
			
			// is it OK to cast up like this?
			var sc2:ScreenCoords = sc as ScreenCoords;
			
			var tmp:Object = sc2.get_horiz_bar_coords( this.index, this.group );
			
			var left:Number  = sc.get_x_from_val( this.left );
			var right:Number = sc.get_x_from_val( this.right );
			var width:Number = right - left;
			
			this.graphics.clear();
			this.graphics.beginFill( this.colour, 1.0 );
			this.graphics.drawRect( 0, 0, width, tmp.width );
			this.graphics.endFill();
			
			this.x = left;
			this.y = tmp.y;
		}
		
		//
		// for tooltip closest - return the middle point
		//
		public override function get_mid_point():flash.geom.Point {
			
			//
			// bars mid point
			//
			return new flash.geom.Point( this.x + (this.width/2), this.y );
		}
		
		public override function get_tip_pos():Object {
			//
			// Hover the tip over the right of the bar
			//
			return {x:this.x+this.width-20, y:this.y};
		}
		
		public function get_max_x():Number {
			return this.right;
		}
	}
}

/* AS3JS File */
package charts.series.bars {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant charts.series.bars.Base;
	
	public class Outline extends Base {
		private var outline:Number;
		
		public function Outline( index:Number, props:Properties, group:Number )	{
			
			super(index, props, group);
			//super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
			this.outline = props.get_colour('outline-colour');
		}
		
		public override function resize( sc:ScreenCoordsBase ):void {
			
			var h:Object = this.resize_helper( sc as ScreenCoords );
			
			this.graphics.clear();
			this.graphics.lineStyle(1, this.outline, 1);
			this.graphics.beginFill( this.colour, 1.0 );
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo( h.width, 0 );
			this.graphics.lineTo( h.width, h.height );
			this.graphics.lineTo( 0, h.height );
			this.graphics.lineTo( 0, 0 );
			this.graphics.endFill();
			
		}
	}
}

/* AS3JS File */
package charts.series.bars {
	//removeMeIfWant flash.filters.DropShadowFilter;
	//removeMeIfWant flash.geom.Matrix;

	public class Plastic extends Base
	{

		public function Plastic( index:Number, props:Properties, group:Number ) {

			super(index, props, group);

			var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
			dropShadow.blurX = 5;
			dropShadow.blurY = 5;
			dropShadow.distance = 3;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.4;
			// apply shadow filter
			this.filters = [dropShadow];
		}

		public override function resize( sc:ScreenCoordsBase ):void {

			this.graphics.clear();
			var h:Object = this.resize_helper( sc as ScreenCoords );

			this.bg( h.width, h.height, h.upside_down );
			this.glass( h.width, h.height, h.upside_down );
		}
          
          private function bg( w:Number, h:Number, upside_down:Boolean ):void {

             var rad:Number = w/3;
             if ( rad > ( w / 2 ) )
                rad = w / 2;
                
             this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);
             
             var allcolors:Array = GetColours(this.colour);
             var lowlight:Number = allcolors[2];
             var highlight:Number = allcolors[0];
             var bgcolors:Array = [allcolors[1], allcolors[2], allcolors[2]];
             var bgalphas:Array = [1, 1, 1];
             var bgratios:Array = [0, 115, 255];
             //var bgcolors:Array = [allcolors[1], allcolors[2]];
             //var bgalphas:Array = [1, 1];
             //var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var bevel:Number = 0.02 * w;
             var div:Number = 3;
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
             
                if ( h > 0 || h < 0)
                { /* height is not zero */
                   
                   /* draw outline darker rounded rectangle */
                   this.graphics.beginFill(0x000000, 1);         
                   this.graphics.drawRoundRect(0, 0, w, h, w/div, w/div);
                   
                   /* draw inner highlight rounded rectangle */
                   this.graphics.beginFill(highlight, 1);
                   this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                   /* draw inner gradient rounded rectangle */
                   bevel = bevel * 3;
                   this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                   this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                }
                else
                {
                   
                   /* draw outline darker rounded rectangle */
                   this.graphics.beginFill(0x000000, 1);         
                   this.graphics.drawRoundRect(0, 0 - 2*bevel, w, h + 4*bevel, w/div, w/div);
                   
                   /* draw inner highlight rounded rectangle */
                   this.graphics.beginFill(highlight, 1);
                   this.graphics.drawRoundRect(0 + bevel, 0 - 2*bevel + bevel, w - 2 * bevel, h + 4*bevel - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                   /* draw inner gradient rounded rectangle */
                   bevel = bevel * 3;
                   this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                   this.graphics.drawRoundRect(0 + bevel, 0 - 2*bevel + bevel, w - 2 * bevel, h + 4*bevel - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                }
                
                
             this.graphics.endFill();
          }
          
          private function glass( w:Number, h:Number, upside_down:Boolean ): void {
             
             /* if this section is commented out, the white shine overlay will not be drawn */
             
             this.graphics.lineStyle(0, 0, 0);
             var bgcolors:Array = GetColours(this.colour);
             var bgmatrix:Matrix = new Matrix();
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             /*var colors:Array = [0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.75];
             var ratios:Array = [127,255];   */
             var colors:Array = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.05, 0.75];
             var ratios:Array = [0, 123, 255];         
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var matrix:Matrix = new Matrix();
             var bevel:Number = 0.02 * w;
             var div:Number = 3;
             
             matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
             var rad:Number = w / 3;
                
                if ( h > 0 || h < 0 )
                {
                   /* draw shine rounded rectangle */      
                   this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                }
                else
                {
                   /* draw shine rounded rectangle */      
                   this.graphics.drawRoundRect(0 + bevel, 0 - 2*bevel + bevel, w - 2 * bevel, h + 4*bevel - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                }
                   this.graphics.endFill();
                
          }
          
          /* function to process colors */
          /* returns a base color, a lowlight color, and a highlight color for the gradients based on the color passed in */
          public static function GetColours( col:Number):Array {
             var rgb:Number = col; /* decimal value for color */
             var red:Number = (rgb & 16711680) >> 16; /* extacts the red channel */
             var green:Number = (rgb & 65280) >> 8; /* extacts the green channel */
             var blue:Number = rgb & 255; /* extacts the blue channel */
             var shift:Number = 0.15; /* shift factor */
             var loshift:Number = 1.75; /* lowlight shift factor */
             var basecolor:Number = col; /* base color to be returned */
             var lowlight:Number = col; /* lowlight color to be returned */
             var highlight:Number = col; /* highlight color to be returned */
             var bgred:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var bggreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var bgblue:Number = rgb & 255; /* blue channel for highlight */
             var lored:Number = (rgb & 16711680) >> 16; /* red channel for lowlight */
             var logreen:Number = (rgb & 65280) >> 8; /* green channel for lowlight */
             var loblue:Number = rgb & 255; /* blue channel for lowlight */
             var hired:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var higreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var hiblue:Number = rgb & 255; /* blue channel for highlight */
             
             /* set base color components based on ability to shift lighter and darker */   
             if (red + red * shift < 255 && red - loshift * red * shift > 0)
             { /* red can be shifted both lighter and darker */
                bgred = red;
             }
             else
             { /* red can be shifter either lighter or darker */
                if (red + red * shift < 255)
                { /* red can be shifter lighter */
                   bgred = red + red / shift;
                }
                else
                { /* red can be shifted darker */
                   bgred = red - loshift * red * shift;
                }
             }
                
             if (blue + blue * shift < 255 && blue - loshift * blue * shift > 0)
             { /* blue can be shifted both lighter and darker */
                bgblue = blue;
             }
             else
             { /* blue can be shifter either lighter or darker */
                if (blue + blue * shift < 255)
                { /* blue can be shifter lighter */
                   bgblue = blue + blue * shift;
                }
                else
                { /* blue can be shifted darker */
                   bgblue = blue - loshift * blue * shift;
                }
             }
                
             if (green + green * shift < 255 && green - loshift * green * shift > 0)
             { /* green can be shifted both lighter and darker */
                bggreen = green;
             }
             else
             { /* green can be shifted either lighter or darker */
                if (green + green * shift < 255)
                { /* green can be shifter lighter */
                   bggreen = green + green * shift;
                }
                else
                { /* green can be shifted darker */
                   bggreen = green - loshift * green * shift;
                }
             }
             
             /* set highlight and lowlight components based on base colors */   
             hired = bgred + red * shift;
             lored = bgred - loshift * (red * shift);
             hiblue = bgblue + blue * shift;
             loblue = bgblue - loshift * (blue * shift);
             higreen = bggreen + green * shift;
             logreen = bggreen - loshift * (green * shift);
             
             /* reconstruct base and highlight */
             basecolor = bgred << 16 | bggreen << 8 | bgblue;
             highlight = hired << 16 | higreen << 8 | hiblue;
             lowlight = lored << 16 | logreen << 8 | loblue;
                      
             /* return base, lowlight, and highlight */
             return [highlight, basecolor, lowlight];
          }
          
          /* ellipse cos helper function */
          public static function magicTrigFunctionX (pointRatio:Number):Number{
             return Math.cos(pointRatio*2*Math.PI);
          }
          
          /* ellipse sin helper function */
          public static function magicTrigFunctionY (pointRatio:Number):Number{
             return Math.sin(pointRatio*2*Math.PI);
          }
          
          /* ellipse function */
          /* draws an ellipse from passed center coordinates, x and y radii, and number of sides */
          public function Ellipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=0; i<=sides; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
                
       }
    }    
/* AS3JS File */
package charts.series.bars {
       //removeMeIfWant flash.filters.DropShadowFilter;
       //removeMeIfWant flash.geom.Matrix;
       
       public class PlasticFlat extends Base
       {
          
          public function PlasticFlat( index:Number, props:Properties, group:Number ) {
             
             super(index, props, group);
             //super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
             
             var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
             dropShadow.blurX = 5;
             dropShadow.blurY = 5;
             dropShadow.distance = 3;
             dropShadow.angle = 45;
             dropShadow.quality = 2;
             dropShadow.alpha = 0.4;
             // apply shadow filter
             this.filters = [dropShadow];
          }
          
          public override function resize( sc:ScreenCoordsBase ):void {
             
             this.graphics.clear();
             var h:Object = this.resize_helper( sc as ScreenCoords );
             
             this.bg( h.width, h.height, h.upside_down );
             this.glass( h.width, h.height, h.upside_down );
          }
          
          private function bg( w:Number, h:Number, upside_down:Boolean ):void {

             var rad:Number = w/3;
             if ( rad > ( w / 2 ) )
                rad = w / 2;
                
             this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);
             
             var allcolors:Array = GetColours(this.colour);
             var lowlight:Number = allcolors[2];
             var highlight:Number = allcolors[0];
             var bgcolors:Array = [allcolors[1], allcolors[2], allcolors[2]];
             var bgalphas:Array = [1, 1, 1];
             var bgratios:Array = [0, 115, 255];
             //var bgcolors:Array = [allcolors[1], allcolors[2]];
             //var bgalphas:Array = [1, 1];
             //var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var bevel:Number = 0.02 * w;
             var div:Number = 3;
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
             
                if ( h > 0 || h < 0)
                { /* height is not zero */
                   
                   /* draw outline darker rounded rectangle */
                   this.graphics.beginFill(0x000000, 1);         
                   this.graphics.drawRoundRect(0, 0, w, h, w/div, w/div);
                   
                   /* draw inner highlight rounded rectangle */
                   this.graphics.beginFill(highlight, 1);
                   this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                   /* draw inner gradient rounded rectangle */
                   bevel = bevel * 3;
                   this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                   this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                }
                else
                {
                   
                   /* draw outline darker rounded rectangle */
                   this.graphics.beginFill(0x000000, 1);         
                   this.graphics.drawRoundRect(0, 0 - 2*bevel, w, h + 4*bevel, w/div, w/div);
                   
                   /* draw inner highlight rounded rectangle */
                   this.graphics.beginFill(highlight, 1);
                   this.graphics.drawRoundRect(0 + bevel, 0 - 2*bevel + bevel, w - 2 * bevel, h + 4*bevel - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                   /* draw inner gradient rounded rectangle */
                   bevel = bevel * 3;
                   this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                   this.graphics.drawRoundRect(0 + bevel, 0 - 2*bevel + bevel, w - 2 * bevel, h + 4*bevel - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                }
                
                
             this.graphics.endFill();
          }
          
          private function glass( w:Number, h:Number, upside_down:Boolean ): void {
             
             /* if this section is commented out, the white shine overlay will not be drawn */
             
             this.graphics.lineStyle(0, 0, 0);
             var allcolors:Array = GetColours(this.colour);
             var lowlight:Number = allcolors[2];
             var highlight:Number = allcolors[0];
             var bgcolors:Array = [allcolors[1], allcolors[2], allcolors[2]];
             var bgalphas:Array = [1, 1, 1];
             var bgratios:Array = [0, 115, 255];
             var bgmatrix:Matrix = new Matrix();
             /*var colors:Array = [0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.75];
             var ratios:Array = [127,255];   */
             var colors:Array = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.05, 0.75];
             var ratios:Array = [0, 123, 255];         
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var matrix:Matrix = new Matrix();
             var bevel:Number = 0.02 * w;
             var div:Number = 3;
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
             var rad:Number = w / 3;
                
                if ( h > 0 && !upside_down )
                { /* draw bar upwards */
                
                   /* draw shine rounded rectangle */      
                   this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                   /* draw outline darker rectangle */
                   this.graphics.beginFill(0x000000, 1);         
                   this.graphics.drawRect(0, h - h / 2, w, h/2);
                   
                   /* draw inner highlight rectangle */
                   this.graphics.beginFill(highlight, 1);
                   this.graphics.drawRect(0 + bevel, h - h / 2, w - 2 * bevel, h /2 - bevel);
                   
                   /* draw inner gradient rectangle */
                   bevel = bevel * 3;
                   this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                   this.graphics.drawRect(0 + bevel, h - h / 2, w - 2 * bevel, h / 2 - bevel);
                   
                   /* draw shine rounded rectangle */      
                   bevel = bevel / 3;
                   this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                   this.graphics.drawRect(0 + bevel, h - h / 2, w - 2 * bevel, h / 2 - bevel);
                   
                }
                else if ( h > 0 )
                {/* draw bar downwards */
                
                   /* draw shine rounded rectangle */      
                   this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                   /* draw outline darker rectangle */
                   this.graphics.beginFill(0x000000, 1);         
                   this.graphics.drawRect(0, 0, w, h/2);
                   
                   /* draw inner highlight rectangle */
                   this.graphics.beginFill(highlight, 1);
                   this.graphics.drawRect(0 + bevel, 0 + bevel, w - 2 * bevel, h /2 - bevel);
                   
                   /* draw inner gradient rectangle */
                   bevel = bevel * 3;
                   this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                   this.graphics.drawRect(0 + bevel, 0 + bevel, w - 2 * bevel, h / 2 - bevel);
                   
                   /* draw shine rounded rectangle */      
                   bevel = bevel / 3;
                   this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                   this.graphics.drawRect(0 + bevel, 0 + bevel, w - 2 * bevel, h / 2 - bevel);
                   
                }
                else
                {
                   
                   /* draw shine rounded rectangle */      
                   this.graphics.drawRoundRect(0 + bevel, 0 - 2*bevel + bevel, w - 2 * bevel, h + 4*bevel - 2 * bevel, w/div - 2*bevel, w/div - 2 * bevel);
                   
                }
                   this.graphics.endFill();
                
          }
          
          /* function to process colors */
          /* returns a base color, a lowlight color, and a highlight color for the gradients based on the color passed in */
          public static function GetColours( col:Number):Array {
             var rgb:Number = col; /* decimal value for color */
             var red:Number = (rgb & 16711680) >> 16; /* extacts the red channel */
             var green:Number = (rgb & 65280) >> 8; /* extacts the green channel */
             var blue:Number = rgb & 255; /* extacts the blue channel */
             var shift:Number = 0.15; /* shift factor */
             var loshift:Number = 1.75; /* lowlight shift factor */
             var basecolor:Number = col; /* base color to be returned */
             var lowlight:Number = col; /* lowlight color to be returned */
             var highlight:Number = col; /* highlight color to be returned */
             var bgred:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var bggreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var bgblue:Number = rgb & 255; /* blue channel for highlight */
             var lored:Number = (rgb & 16711680) >> 16; /* red channel for lowlight */
             var logreen:Number = (rgb & 65280) >> 8; /* green channel for lowlight */
             var loblue:Number = rgb & 255; /* blue channel for lowlight */
             var hired:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var higreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var hiblue:Number = rgb & 255; /* blue channel for highlight */
             
             /* set base color components based on ability to shift lighter and darker */   
             if (red + red * shift < 255 && red - loshift * red * shift > 0)
             { /* red can be shifted both lighter and darker */
                bgred = red;
             }
             else
             { /* red can be shifter either lighter or darker */
                if (red + red * shift < 255)
                { /* red can be shifter lighter */
                   bgred = red + red / shift;
                }
                else
                { /* red can be shifted darker */
                   bgred = red - loshift * red * shift;
                }
             }
                
             if (blue + blue * shift < 255 && blue - loshift * blue * shift > 0)
             { /* blue can be shifted both lighter and darker */
                bgblue = blue;
             }
             else
             { /* blue can be shifter either lighter or darker */
                if (blue + blue * shift < 255)
                { /* blue can be shifter lighter */
                   bgblue = blue + blue * shift;
                }
                else
                { /* blue can be shifted darker */
                   bgblue = blue - loshift * blue * shift;
                }
             }
                
             if (green + green * shift < 255 && green - loshift * green * shift > 0)
             { /* green can be shifted both lighter and darker */
                bggreen = green;
             }
             else
             { /* green can be shifted either lighter or darker */
                if (green + green * shift < 255)
                { /* green can be shifter lighter */
                   bggreen = green + green * shift;
                }
                else
                { /* green can be shifted darker */
                   bggreen = green - loshift * green * shift;
                }
             }
             
             /* set highlight and lowlight components based on base colors */   
             hired = bgred + red * shift;
             lored = bgred - loshift * (red * shift);
             hiblue = bgblue + blue * shift;
             loblue = bgblue - loshift * (blue * shift);
             higreen = bggreen + green * shift;
             logreen = bggreen - loshift * (green * shift);
             
             /* reconstruct base and highlight */
             basecolor = bgred << 16 | bggreen << 8 | bgblue;
             highlight = hired << 16 | higreen << 8 | hiblue;
             lowlight = lored << 16 | logreen << 8 | loblue;
                      
             /* return base, lowlight, and highlight */
             return [highlight, basecolor, lowlight];
          }
          
          /* ellipse cos helper function */
          public static function magicTrigFunctionX (pointRatio:Number):Number{
             return Math.cos(pointRatio*2*Math.PI);
          }
          
          /* ellipse sin helper function */
          public static function magicTrigFunctionY (pointRatio:Number):Number{
             return Math.sin(pointRatio*2*Math.PI);
          }
          
          /* ellipse function */
          /* draws an ellipse from passed center coordinates, x and y radii, and number of sides */
          public function Ellipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=0; i<=sides; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
                
       }
    }    
/* AS3JS File */
package charts.series.bars {
       //removeMeIfWant flash.filters.DropShadowFilter;
       //removeMeIfWant flash.geom.Matrix;
	   //removeMeIfWant charts.series.bars.Base;
       
       public class Round3D extends Base
       {
          
          public function Round3D( index:Number, props:Properties, group:Number ) {
             
             super(index, props, group);
             //super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
             
             var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
             dropShadow.blurX = 5;
             dropShadow.blurY = 5;
             dropShadow.distance = 3;
             dropShadow.angle = 45;
             dropShadow.quality = 2;
             dropShadow.alpha = 0.4;
             // apply shadow filter
             this.filters = [dropShadow];
          }
          
          public override function resize( sc:ScreenCoordsBase ):void {
             
             this.graphics.clear();
             var h:Object = this.resize_helper( sc as ScreenCoords );
             
             this.bg( h.width, h.height, h.upside_down );
             this.glass( h.width, h.height, h.upside_down );
          }
          
          private function bg( w:Number, h:Number, upside_down:Boolean ):void {

             var rad:Number = w/3;
             if ( rad > ( w / 2 ) )
                rad = w / 2;
                
             this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);
             
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
             
                if (!upside_down && h > 0)
                { /* draw bar upward */
                
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                      
                      /* draw bottom half ellipse */
                      x = w/2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                                        
                      /* draw connecting rectangle */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                      this.graphics.moveTo(0, w/2);
                      this.graphics.lineTo(0, h);
                      this.graphics.lineTo(w, h);
                      this.graphics.lineTo(w, w / 2);   
                               
                      /* draw top ellipse */
                      //this.graphics.beginFill(this.colour, 1);
                      x = w / 2;
                      y = w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                   
                   else
                   
                   { /* bar is too short for normal draw */
                      
                      /* draw bottom half ellipse */
                      x = w/2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);   
                               
                      /* draw top ellipse */
                      x = w / 2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = h;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                }
                
                else
                
                { /*draw bar downward */
                   
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                
                      /* draw top half ellipse */
                      x = w/2;
                      y = 0;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                         
                      /* draw connecting rectangle */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                      this.graphics.moveTo(0, 0);
                      this.graphics.lineTo(0, h - w / 2);
                      this.graphics.lineTo(w, h - w / 2);
                      this.graphics.lineTo(w, 0);   
                         
                      /* draw bottom ellipse */
                      //this.graphics.beginFill(this.colour, 1);
                      x = w / 2;
                      y = h - w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                   
                   }
                   
                   else
                   
                   { /* bar is too short for normal draw */
                   
                      if (h > 0)
                      
                      { /* bar greater than zero */
                      
                         /* draw top half ellipse */
                         x = w/2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = rad / 2;
                         halfEllipse(x, y, xRadius, yRadius, 100, true);   
                                  
                         /* draw bottom ellipse */
                         x = w / 2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = h;
                         halfEllipse(x, y, xRadius, yRadius, 100, false);
                         
                      }
                      
                      else
                      
                      { /* bar is zero */
                      
                         /* draw top ellipse */
                         x = w/2;
                         y = h;
                         xRadius = w / 2;
                         yRadius = rad / 4;
                         Ellipse(x, y, xRadius, yRadius, 100);         
                         
                      }
                      
                   }
                   
                }
             
             this.graphics.endFill();
          }
          
          private function glass( w:Number, h:Number, upside_down:Boolean ): void {
             
             /* if this section is commented out, the white shine overlay will not be drawn */
             
             this.graphics.lineStyle(0, 0, 0);
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             
             /* set gradient fill */
             var colors:Array = [0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.75];
             var ratios:Array = [100,255];         
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var matrix:Matrix = new Matrix();
             matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
             var rad:Number = w / 3;
                
                if (!upside_down && h > 0)
                { /* draw shine upward */
                
                   if (h >= w / 2)
                   { /* bar is tall enough for normal draw */
                
                      /* draw bottom half ellipse shine */
                      x = w/2;
                      y = h;
                      xRadius = w / 2 - (0.05 * w);
                      yRadius = rad / 2 - (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                      
                      /*draw connecting rectangle shine */
                      this.graphics.moveTo(0 + (0.05 * w), w/2);
                      this.graphics.lineTo(0 + (0.05 * w), h);
                      this.graphics.lineTo(w - (0.05 * w), h);
                      this.graphics.lineTo(w - (0.05 * w), w/2);   
                               
                            
                      /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w / 2;
                      y = w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                      /* draw top ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                   
                   }
                   
                   else
                   
                   { /* bar is not tall enough for normal draw */
                
                      /* draw bottom half ellipse shine */
                      x = w/2;
                      y = h;
                      xRadius = w / 2 - (0.05 * w);
                      yRadius = rad / 2 - (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);      
                      
                      /* draw top ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = h - 2.5*(0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                
                }
                
                else
                
                { /* draw shine downward */
                   
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                      
                      /*draw connecting rectangle shine */
                      this.graphics.moveTo(0 + (0.05 * w), 0);
                      this.graphics.lineTo(0 + (0.05 * w), h - w / 2);
                      this.graphics.lineTo(w - (0.05 * w), h - w / 2);
                      this.graphics.lineTo(w - (0.05 * w), 0);   
                               
                            
                      /* redraw bottom ellipse (to overwrite connecting rectangle shine overlap)*/
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w / 2;
                      y = h - w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                      
                      /* draw bottom ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h - w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                
                      /* redraw top half ellipse (to overwrite connecting rectangle shine overlap */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w/2;
                      y = 0;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      Ellipse(x, y, xRadius, yRadius, 100);
                   
                      /* draw top half ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, [0.1, 0.7], [0,255], matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w/2;
                      y = 0;
                      xRadius = w / 2 - (0.05 * w);
                      yRadius = rad / 2 - (0.05 * w);
                      Ellipse(x, y, xRadius, yRadius, 100);
                   
                   }
                   
                   else
                   
                   { /* bar is not tall enough for normal draw */
                   
                      if (h > 0)
                      { /* bar is greater than zero */
                         
                         /* draw bottom ellipse shine */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                         x = w / 3;
                         y = 0;
                         xRadius = w / 3 - (0.05 * w);
                         yRadius = h - 2.5*(0.05 * w);
                         halfEllipse(x, y, xRadius, yRadius, 100, false);   
                
                         /* redraw top half ellipse (to overwrite connecting rectangle shine overlap */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                         x = w/2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = rad / 2;
                         Ellipse(x, y, xRadius, yRadius, 100);
                         
                         /* draw top half ellipse shine */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, [0.1, 0.67], [0,255], matrix, 'pad'/*SpreadMethod.PAD*/ );
                          x = w/2;
                         y = 0;
                         xRadius = w / 2 - (0.05 * w);
                         yRadius = rad / 2 - (0.05 * w);
                         Ellipse(x, y, xRadius, yRadius, 100);
                         
                      }
                      
                      else
                      
                      { /* bar is zero */
                      
                         /* redraw top half ellipse (to overwrite connecting rectangle shine overlap */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                         x = w/2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = rad / 2;
                         Ellipse(x, y, xRadius, yRadius, 100);
                      
                         /* draw top half ellipse shine */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, [0.1, 0.7], [0,255], matrix, 'pad'/*SpreadMethod.PAD*/ );
                         x = w/2;
                         y = 0;
                         xRadius = w / 2 - (0.05 * w);
                         yRadius = rad / 2 - (0.05 * w);
                         Ellipse(x, y, xRadius, yRadius, 100);
                         
                      }   
                      
                   }
                   
                }
                   
                this.graphics.endFill();
          }
          
          /* function to process colors */
          /* returns a base color and a highlight color for the gradients based on the color passed in */
          public static function GetColours( col:Number ):Array {
             var rgb:Number = col; /* decimal value for color */
             var red:Number = (rgb & 16711680) >> 16; /* extacts the red channel */
             var green:Number = (rgb & 65280) >> 8; /* extacts the green channel */
             var blue:Number = rgb & 255; /* extacts the blue channel */
             var shift:Number = 2; /* shift factor */
             var basecolor:Number = col; /* base color to be returned */
             var highlight:Number = col; /* highlight color to be returned */
             var bgred:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var bggreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var bgblue:Number = rgb & 255; /* blue channel for highlight */
             var hired:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var higreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var hiblue:Number = rgb & 255; /* blue channel for highlight */
             
             /* set base color components based on ability to shift lighter */   
             if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255)
             {
                bgred = red - red / shift;
                bggreen = green - green / shift;
                bgblue = blue - blue / shift;
             }            
                
             /* set highlight components based on base colors */   
             hired = bgred + red / shift;
             hiblue = bgblue + blue / shift;
             higreen = bggreen + green / shift;
             
             /* reconstruct base and highlight */
             basecolor = bgred << 16 | bggreen << 8 | bgblue;
             highlight = hired << 16 | higreen << 8 | hiblue;
                      
             /* return base and highlight */
             return [highlight, basecolor];
          }
          
          /* ellipse cos helper function */
          public static function magicTrigFunctionX (pointRatio:Number):Number{
             return Math.cos(pointRatio*2*Math.PI);
          }
          
          /* ellipse sin helper function */
          public static function magicTrigFunctionY (pointRatio:Number):Number{
             return Math.sin(pointRatio*2*Math.PI);
          }
          
          /* ellipse function */
          /* draws an ellipse from passed center coordinates, x and y radii, and number of sides */
          public function Ellipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=0; i<=sides; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
          /* half ellipse function */
          /* draws half of an ellipse from passed center coordinates, x and y radii, number of sides , and top/bottom */
          public function halfEllipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number, top:Boolean):Number{
             
             var loopStart:Number;
             var loopEnd:Number;
             
             if (top == true)
             {
                loopStart = sides / 2;
                loopEnd = sides;
             }
             else
             {
                loopStart = 0;
                loopEnd = sides / 2;            
             }
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=loopStart; i<=loopEnd; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
       }
    }    
/* AS3JS File */
package charts.series.bars {
       //removeMeIfWant flash.filters.DropShadowFilter;
       //removeMeIfWant flash.geom.Matrix;
       //removeMeIfWant charts.series.bars.Base;
	   
	   
       public class Round extends Base
       {
          
          public function Round( index:Number, props:Properties, group:Number ) {
             
             super(index, props, group);
             //super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
             
             var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
             dropShadow.blurX = 5;
             dropShadow.blurY = 5;
             dropShadow.distance = 3;
             dropShadow.angle = 45;
             dropShadow.quality = 2;
             dropShadow.alpha = 0.4;
             // apply shadow filter
             this.filters = [dropShadow];
          }
          
          public override function resize( sc:ScreenCoordsBase ):void {
             
             this.graphics.clear();
             var h:Object = this.resize_helper( sc as ScreenCoords );
             
             this.bg( h.width, h.height, h.upside_down );
             this.glass( h.width, h.height, h.upside_down );
          }
          
          private function bg( w:Number, h:Number, upside_down:Boolean ):void {

             var rad:Number = w/3;
             if ( rad > ( w / 2 ) )
                rad = w / 2;
                
             this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);
             
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                
                if (h > 0)
                {
                   
                   if ( h >= w)
                   { /* bar is tall enough for normal draw */
                      
                      /* draw bottom half ellipse */
                      x = w/2;
                      y = h - w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                                        
                      /* draw connecting rectangle */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                      this.graphics.moveTo(0, w/2);
                      this.graphics.lineTo(0, h - w/2);
                      this.graphics.lineTo(w, h - w/2);
                      this.graphics.lineTo(w, w / 2);   
                               
                      /* draw top ellipse */
                      //this.graphics.beginFill(this.colour, 1);
                      x = w / 2;
                      y = w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                   
                   else
                   
                   { /* bar is too short for normal draw */               
                      
                      /* draw bottom half ellipse */
                      x = w/2;
                      y = h / 2;
                      xRadius = w / 2;
                      yRadius = h / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);   
                               
                      /* draw top ellipse */
                      x = w / 2;
                      y = h / 2;
                      xRadius = w / 2;
                      yRadius = h / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                }
                
                else
                
                {
                   
                   { /* bar is zero */
                   
                      /* draw top ellipse */
                      x = w/2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = rad / 4;
                      Ellipse(x, y, xRadius, yRadius, 100);         
                      
                   }
                   
                }
             
             this.graphics.endFill();
          }
          
          private function glass( w:Number, h:Number, upside_down:Boolean ): void {
             
             /* if this section is commented out, the white shine overlay will not be drawn */
             
             this.graphics.lineStyle(0, 0, 0);
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             
             /* set gradient fill */
             var colors:Array = [0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.75];
             var ratios:Array = [100,255];         
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var matrix:Matrix = new Matrix();
             matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
             var rad:Number = w / 3;
                
                if (h > 0)
                { /* draw shine upward */
                
                   if (h >= w)
                   { /* bar is tall enough for normal draw */
                
                      /* draw bottom half ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h - w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                      
                      /*draw connecting rectangle shine */
                      this.graphics.moveTo(0 + (0.05 * w), w/2);
                      this.graphics.lineTo(0 + (0.05 * w), h - w/2);
                      this.graphics.lineTo(w - (0.05 * w), h - w/2);
                      this.graphics.lineTo(w - (0.05 * w), w/2);   
                      
                      /* draw top ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                   
                   }
                   
                   else
                   
                   { /* bar is not tall enough for normal draw */   
                   
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = h/2 - 3*(0.05 * w);
                      Ellipse(x, y, xRadius, yRadius, 100);
                      
                   }
                
                }
                
                else
             
                { /* bar is zero */
                   
                   /* draw top ellipse shine*/
                   x = w/2;
                   y = h;
                   xRadius = w / 2 - (0.05 * w);
                   yRadius = rad / 4 - (0.05 * w);
                   Ellipse(x, y, xRadius, yRadius, 100);   
                         
                }
                   
                this.graphics.endFill();
          }
          
          /* function to process colors */
          /* returns a base color and a highlight color for the gradients based on the color passed in */
          public static function GetColours( col:Number ):Array {
             var rgb:Number = col; /* decimal value for color */
             var red:Number = (rgb & 16711680) >> 16; /* extacts the red channel */
             var green:Number = (rgb & 65280) >> 8; /* extacts the green channel */
             var blue:Number = rgb & 255; /* extacts the blue channel */
             var shift:Number = 2; /* shift factor */
             var basecolor:Number = col; /* base color to be returned */
             var highlight:Number = col; /* highlight color to be returned */
             var bgred:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var bggreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var bgblue:Number = rgb & 255; /* blue channel for highlight */
             var hired:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var higreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var hiblue:Number = rgb & 255; /* blue channel for highlight */
             
             /* set base color components based on ability to shift lighter */   
             if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255)
             {
                bgred = red - red / shift;
                bggreen = green - green / shift;
                bgblue = blue - blue / shift;
             }            
                
             /* set highlight components based on base colors */   
             hired = bgred + red / shift;
             hiblue = bgblue + blue / shift;
             higreen = bggreen + green / shift;
             
             /* reconstruct base and highlight */
             basecolor = bgred << 16 | bggreen << 8 | bgblue;
             highlight = hired << 16 | higreen << 8 | hiblue;
                      
             /* return base and highlight */
             return [highlight, basecolor];
          }
          
          /* ellipse cos helper function */
          public static function magicTrigFunctionX (pointRatio:Number):Number{
             return Math.cos(pointRatio*2*Math.PI);
          }
          
          /* ellipse sin helper function */
          public static function magicTrigFunctionY (pointRatio:Number):Number{
             return Math.sin(pointRatio*2*Math.PI);
          }
          
          /* ellipse function */
          /* draws an ellipse from passed center coordinates, x and y radii, and number of sides */
          public function Ellipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=0; i<=sides; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
          /* half ellipse function */
          /* draws half of an ellipse from passed center coordinates, x and y radii, number of sides , and top/bottom */
          public function halfEllipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number, top:Boolean):Number{
             
             var loopStart:Number;
             var loopEnd:Number;
             
             if (top == true)
             {
                loopStart = sides / 2;
                loopEnd = sides;
             }
             else
             {
                loopStart = 0;
                loopEnd = sides / 2;            
             }
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=loopStart; i<=loopEnd; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
       }
    }

/* AS3JS File */
package charts.series.bars {

	//removeMeIfWant flash.filters.DropShadowFilter;
	//removeMeIfWant flash.geom.Matrix;
	//removeMeIfWant charts.series.bars.Base;

	public class RoundGlass extends Base
	{

		public function RoundGlass( index:Number, props:Properties, group:Number ) {

			super(index, props, group);
			//super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

			var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
			dropShadow.blurX = 5;
			dropShadow.blurY = 5;
			dropShadow.distance = 3;
			dropShadow.angle = 45;
			dropShadow.quality = 2;
			dropShadow.alpha = 0.4;
			// apply shadow filter
			this.filters = [dropShadow];
		}

		public override function resize( sc:ScreenCoordsBase ):void {

			this.graphics.clear();
			var h:Object = this.resize_helper( sc as ScreenCoords );

			this.bg( h.width, h.height, h.upside_down );
			this.glass( h.width, h.height, h.upside_down );
		}

          private function bg( w:Number, h:Number, upside_down:Boolean ):void {

             var rad:Number = w/3;
             if ( rad > ( w / 2 ) )
                rad = w / 2;
                
             this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);
             
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
             
                if (!upside_down && h > 0)
                { /* draw bar upward */
                
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                                        
                      /* draw connecting rectangle */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                      this.graphics.moveTo(0, w/2);
                      this.graphics.lineTo(0, h);
                      this.graphics.lineTo(w, h);
                      this.graphics.lineTo(w, w / 2);   
                               
                      /* draw top ellipse */
                      //this.graphics.beginFill(this.colour, 1);
                      x = w / 2;
                      y = w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                   
                   else
                   
                   { /* bar is too short for normal draw */
                               
                      /* draw top ellipse */
                      x = w / 2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = h;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                }
                
                else
                
                { /*draw bar downward */
                   
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                         
                      /* draw connecting rectangle */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                      this.graphics.moveTo(0, 0);
                      this.graphics.lineTo(0, h - w / 2);
                      this.graphics.lineTo(w, h - w / 2);
                      this.graphics.lineTo(w, 0);   
                         
                      /* draw bottom ellipse */
                      //this.graphics.beginFill(this.colour, 1);
                      x = w / 2;
                      y = h - w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                   
                   }
                   
                   else
                   
                   { /* bar is too short for normal draw */
                   
                      if (h > 0)
                      
                      { /* bar greater than zero */
                                  
                         /* draw bottom ellipse */
                         x = w / 2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = h;
                         halfEllipse(x, y, xRadius, yRadius, 100, false);
                         
                      }
                      
                      else
                      
                      { /* bar is zero */
                         
                         /* draw line */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                         this.graphics.moveTo(0, - 0.05*w);
                         this.graphics.lineTo(0, h + 0.05*w);
                         this.graphics.lineTo(w, h + 0.05*w);
                         this.graphics.lineTo(w, - 0.05*w);   
                         
                         
                      }
                      
                   }
                   
                }
             
             this.graphics.endFill();
          }
          
          private function glass( w:Number, h:Number, upside_down:Boolean ): void {
             
             /* if this section is commented out, the white shine overlay will not be drawn */
             
             this.graphics.lineStyle(0, 0, 0);
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             
             /* set gradient fill */
             var colors:Array = [0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.75];
             var ratios:Array = [100,255];         
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var matrix:Matrix = new Matrix();
             matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
             var rad:Number = w / 3;
                
                if (!upside_down && h > 0)
                { /* draw shine upward */
                
                   if (h >= w / 2)
                   { /* bar is tall enough for normal draw */
                      
                      /*draw connecting rectangle shine */
                      this.graphics.moveTo(0 + (0.05 * w), w/2);
                      this.graphics.lineTo(0 + (0.05 * w), h - (0.05 * w));
                      this.graphics.lineTo(w - (0.05 * w), h - (0.05 * w));
                      this.graphics.lineTo(w - (0.05 * w), w/2);   
                               
                            
                      /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w / 2;
                      y = w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                      /* draw top ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                   
                   }
                   
                   else
                   
                   { /* bar is not tall enough for normal draw */      
                      
                      /* draw top ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h - (0.05 * w);
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = h - 2.5*(0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                
                }
                
                else
                
                { /* draw shine downward */
                   
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                      
                      /*draw connecting rectangle shine */
                      this.graphics.moveTo(0 + (0.05 * w), 0 + (0.05 * w));
                      this.graphics.lineTo(0 + (0.05 * w), h - w / 2);
                      this.graphics.lineTo(w - (0.05 * w), h - w / 2);
                      this.graphics.lineTo(w - (0.05 * w), 0 + (0.05 * w));   
                               
                            
                      /* redraw bottom ellipse (to overwrite connecting rectangle shine overlap)*/
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w / 2;
                      y = h - w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                      
                      /* draw bottom ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h - w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                   
                   }
                   
                   else
                   
                   { /* bar is not tall enough for normal draw */
                   
                      if (h > 0)
                      { /* bar is greater than zero */
                         
                         /* draw bottom ellipse shine */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                         x = w / 3;
                         y = 0 + (0.05 * w);
                         xRadius = w / 3 - (0.05 * w);
                         yRadius = h - 2.5*(0.05 * w);
                         halfEllipse(x, y, xRadius, yRadius, 100, false);   
                         
                      }
                      
                      else
                      
                      { /* bar is zero */
                         
                         /* draw line */
                         this.graphics.moveTo(0 + 0.025*w, - 0.025*w);
                         this.graphics.lineTo(0 + 0.025*w, h + 0.025*w);
                         this.graphics.lineTo(w, h + 0.025*w);
                         this.graphics.lineTo(w, - 0.025*w);   
                         
                      }   
                      
                   }
                   
                }
                   
                this.graphics.endFill();
          }
          
          /* function to process colors */
          /* returns a base color and a highlight color for the gradients based on the color passed in */
          public static function GetColours( col:Number ):Array {
             var rgb:Number = col; /* decimal value for color */
             var red:Number = (rgb & 16711680) >> 16; /* extacts the red channel */
             var green:Number = (rgb & 65280) >> 8; /* extacts the green channel */
             var blue:Number = rgb & 255; /* extacts the blue channel */
             var shift:Number = 2; /* shift factor */
             var basecolor:Number = col; /* base color to be returned */
             var highlight:Number = col; /* highlight color to be returned */
             var bgred:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var bggreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var bgblue:Number = rgb & 255; /* blue channel for highlight */
             var hired:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var higreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var hiblue:Number = rgb & 255; /* blue channel for highlight */
             
             /* set base color components based on ability to shift lighter */   
             if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255)
             {
                bgred = red - red / shift;
                bggreen = green - green / shift;
                bgblue = blue - blue / shift;
             }            
                
             /* set highlight components based on base colors */   
             hired = bgred + red / shift;
             hiblue = bgblue + blue / shift;
             higreen = bggreen + green / shift;
             
             /* reconstruct base and highlight */
             basecolor = bgred << 16 | bggreen << 8 | bgblue;
             highlight = hired << 16 | higreen << 8 | hiblue;
                      
             /* return base and highlight */
             return [highlight, basecolor];
          }
          
          /* ellipse cos helper function */
          public static function magicTrigFunctionX (pointRatio:Number):Number{
             return Math.cos(pointRatio*2*Math.PI);
          }
          
          /* ellipse sin helper function */
          public static function magicTrigFunctionY (pointRatio:Number):Number{
             return Math.sin(pointRatio*2*Math.PI);
          }
          
          /* ellipse function */
          /* draws an ellipse from passed center coordinates, x and y radii, and number of sides */
          public function Ellipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=0; i<=sides; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
          /* half ellipse function */
          /* draws half of an ellipse from passed center coordinates, x and y radii, number of sides , and top/bottom */
          public function halfEllipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number, top:Boolean):Number{
             
             var loopStart:Number;
             var loopEnd:Number;
             
             
             if (top == true)
             { /* drawing top half of ellipse */
             
                loopStart = sides / 2;
                loopEnd = sides;
                
             }
             else
             { /* drawing bottom half of ellipse */
                
                loopStart = 0;
                loopEnd = sides / 2;   
                
             }
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=loopStart; i<=loopEnd; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
       }
    }

/* AS3JS File */
package charts.series.bars {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant charts.series.bars.Base;
	
	public class Sketch extends Base {
		private var outline:Number;
		private var offset:Number;
		
		public function Sketch( index:Number, props:Properties, group:Number ) {
			
			super(index, props, group);
			//super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
			this.outline = props.get_colour('outline-colour');
			this.offset = props.get('offset');
		}
		
		
		public override function resize( sc:ScreenCoordsBase ):void {
			
			var h:Object = this.resize_helper( sc as ScreenCoords );
			
			// how sketchy the bar is:
			var offset:Number = this.offset;
			var o2:Number = offset/2;
			
			// fill the bar
			// number of pen strokes:
			var strokes:Number = 6;
			// how wide each pen will need to be:
			var l_width:Number = h.width/strokes;
			
			this.graphics.clear();
			this.graphics.lineStyle( l_width+1, this.colour, 0.85, true, "none", "round", "miter", 0.8 );
			for( var i:Number=0; i<strokes; i++ )
			{
				this.graphics.moveTo( ((l_width*i)+(l_width/2))+(Math.random()*offset-o2), 2+(Math.random()*offset-o2) );
				this.graphics.lineTo( ((l_width*i)+(l_width/2))+(Math.random()*offset-o2), h.height-2+ (Math.random()*offset-o2) );
			}
			
			// outlines:
			this.graphics.lineStyle( 2, this.outline, 1 );
			// left upright
			this.graphics.moveTo( Math.random()*offset-o2, Math.random()*offset-o2 );
			this.graphics.lineTo( Math.random()*offset-o2, h.height+Math.random()*offset-o2 );
			
			// top
			this.graphics.moveTo( Math.random()*offset-o2, Math.random()*offset-o2 );
			this.graphics.lineTo( h.width+ (Math.random()*offset-o2), Math.random()*offset-o2 );
			
			// right upright
			this.graphics.moveTo( h.width+ (Math.random()*offset-o2), Math.random()*offset-o2 );
			this.graphics.lineTo( h.width+ (Math.random()*offset-o2), h.height+ (Math.random()*offset-o2) );
			
			// bottom
			this.graphics.moveTo( Math.random()*offset-o2, h.height+ (Math.random()*offset-o2) );
			this.graphics.lineTo( h.width+ (Math.random()*offset-o2), h.height+ (Math.random()*offset-o2) );
			
		}
	}
}

/* AS3JS File */
package charts.series.bars {
	
	//removeMeIfWant charts.series.bars.Base;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Point;
	
	
	public class Stack extends Base {
		private var total:Number;
		
		public function Stack( index:Number, props:Properties, group:Number ) {
			
			// we are not passed a string value, the value
			// is set by the parent collection later
			this.total =  props.get('total');

			super(index, props, group);
		}

		protected override function replace_magic_values( t:String ): String {
			
			t = super.replace_magic_values(t);
			t = t.replace('#total#', NumberUtils.formatNumber( this.total ));
			
			return t;
		}
		
		public function replace_x_axis_label( t:String ): void {
			
			this.tooltip = this.tooltip.replace('#x_label#', t );
		}
		
		public override function resize( sc:ScreenCoordsBase ):void {
			
			var h:Object = this.resize_helper( sc as ScreenCoords );
			
			this.graphics.clear();
			this.graphics.beginFill( this.colour, 1.0 );
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo( h.width, 0 );
			this.graphics.lineTo( h.width, h.height );
			this.graphics.lineTo( 0, h.height );
			this.graphics.lineTo( 0, 0 );
			this.graphics.endFill();
		}
	}
}

/* AS3JS File */
package charts.series.bars {
	
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant com.serialization.json.JSON;
	//removeMeIfWant string.Utils;
	//removeMeIfWant elements.axis.XAxisLabels;
	
	public class StackCollection extends Element {
		
		protected var tip_pos:flash.geom.Point;
		private var vals:Array;
		public var colours:Array;
		protected var group:Number;
		private var total:Number;
		
		public function StackCollection( index:Number, props:Properties, group:Number ) {
			
			//this.tooltip = this.replace_magic_values( props.get('tip') );
			this.tooltip = props.get('tip');
			
			// this is very similar to a normal
			// PointBarBase but without the mouse
			// over and mouse out events
			this.index = index;
			
			var item:Object;
			
			// a stacked bar has n Y values
			// so this is an array of objects
			this.vals = props.get('values') as Array;
			
			this.total = 0;
			for each( item in this.vals ) {
				if( item != null ) {
					if( item is Number )
						this.total += item;
					else
						this.total += item.val;
				}
			}
		
			//
			// parse our HEX colour strings
			//
			this.colours = new Array();
			for each( var colour:String in props.get('colours') )
				this.colours.push( string.Utils.get_colour( colour ) );
				
			this.group = group;
			this.visible = true;
			
			var prop:String;
			
			var n:Number;	// <-- ugh, leaky variables.
			var bottom:Number = 0;
			var top:Number = 0;
			var colr:Number;
			var count:Number = 0;

			for each( item in this.vals )
			{
				// is this a null stacked bar group?
				if( item != null )
				{
					colr = this.colours[(count % this.colours.length)]
					
					// override bottom, colour and total, leave tooltip, on-click, on-show etc..
					var defaul_stack_props:Properties = new Properties({
							bottom:		bottom,
							colour:		colr,		// <-- colour from list (may be overriden later)
							total:		this.total
						}, props);
						
					//
					// a valid item is one of [ Number, Object, null ]
					//
					if ( item is Number ) {
						item = { val: item };
					}
					
					if ( item == null ) {
						item = { val: null };
					}
					
					// MERGE:
					top += item.val;
					item.top = top;
					// now override on-click, on-show, colour etc...
					var stack_props:Properties = new Properties(item, defaul_stack_props);
					
					var p:Stack = new Stack( index, stack_props, group );
					this.addChild( p );
					
					bottom = top;
					count++;
				}
			}
		}
		

		public override function resize( sc:ScreenCoordsBase ):void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var e:Element = this.getChildAt(i) as Element;
				e.resize( sc );
			}
		}
		
		//
		// for tooltip closest - return the middle point
		// of this stack
		//
		public override function get_mid_point():flash.geom.Point {
			
			// get the first bar in the stack
			var e:Element = this.getChildAt(0) as Element;
				
			return e.get_mid_point();
		}
		
		//
		// called by get_all_at_this_x_pos
		//
		public function get_children(): Array {
			
			var tmp:Array = [];
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				tmp.push( this.getChildAt(i) );
			}
			return tmp;
		}
		
		public override function get_tip_pos():Object {
			//
			// get top item in stack
			//
			var e:Element = this.getChildAt(this.numChildren-1) as Element;
			return e.get_tip_pos();
		}
		
		
		public override function get_tooltip():String {
			//
			// is the mouse over one of the bars in this stack?
			//
			
			// tr.ace( this.numChildren );
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var e:Element = this.getChildAt(i) as Element;
				if ( e.is_tip )
				{
					//tr.ace( 'TIP' );
					return e.get_tooltip();
				}
			}
			//
			// the mouse is *near* our stack, so show the 'total' tooltip
			//
			return this.tooltip;
		}
		
		/**
		 * See Element
		 */
		public override function tooltip_replace_labels( labels:XAxisLabels ):void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				var e:Stack = this.getChildAt(i) as Stack;
				e.replace_x_axis_label( labels.get( this.index ) );
			}
		}
	}
}

/* AS3JS File */
package charts.series.dots {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.Graphics;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.geom.Point;
	
	public class anchor extends PointDotBase {
		
		public function anchor( index:Number, value:Properties ) {
			
			
			var colour:Number = string.Utils.get_colour( value.get('colour') );

			super( index, value );

			this.tooltip = this.replace_magic_values( value.get('tip') );
			this.attach_events();

			// if style.x is null then user wants a gap in the line
			//
			// I don't understand what this is doing...
			//
//			if (style.x == null)
//			{
//				this.visible = false;
//			}
//			else
//			{
				
				if (value.get('hollow'))
				{
					// Hollow - set the fill to the background color/alpha
					if( value.has('background-colour') )
					{
						var bgColor:Number = string.Utils.get_colour( value.get('background-colour') );
					}
					else
					{
						bgColor = colour;
					}
					
					this.graphics.beginFill(bgColor, value.get('background-alpha')); 
				}
				else
				{
					// set the fill to be the same color and alpha as the line
					this.graphics.beginFill( colour, value.get('alpha') );
				}

				this.graphics.lineStyle( value.get('width'), colour, value.get('alpha') );

				this.drawAnchor(this.graphics, this.radius, value.get('sides'), rotation);
				// Check to see if part of the line needs to be erased
				//trace("haloSize = ", haloSize);
				if (value.get('halo-size') > 0)
				{
					var size:Number = value.get('halo-size') + this.radius;
					var s:Sprite = new Sprite();
					s.graphics.lineStyle( 0, 0, 0 );
					s.graphics.beginFill( 0, 1 );
					this.drawAnchor(s.graphics, size, value.get('sides'), rotation);
					s.blendMode = BlendMode.ERASE;
					s.graphics.endFill();
					this.line_mask = s;
				}
//			}
			
		}
		
		
		public override function set_tip( b:Boolean ):void {
			if ( b )
			{
				if ( !this.is_tip )
				{
					Tweener.addTween(this, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
					Tweener.addTween(this, {scaleY:1.3, time:0.4, transition:"easeoutbounce" } );
					if (this.line_mask != null)
					{
						Tweener.addTween(this.line_mask, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
						Tweener.addTween(this.line_mask, {scaleY:1.3, time:0.4, transition:"easeoutbounce" } );
					}
				}
				this.is_tip = true;
			}
			else
			{
				Tweener.removeTweens(this);
				Tweener.removeTweens(this.line_mask);
				this.scaleX = 1;
				this.scaleY = 1;
				if (this.line_mask != null)
				{
					this.line_mask.scaleX = 1;
					this.line_mask.scaleY = 1;
				}
				this.is_tip = false;
			}
		}
		
		

		private function drawAnchor( aGraphics:Graphics, aRadius:Number, 
										aSides:Number, aRotation:Number ):void 
		{
			if (aSides < 3) aSides = 3;
			if (aSides > 360) aSides = 360;
			var angle:Number = 360 / aSides;
			for (var ix:int = 0; ix <= aSides; ix++)
			{
				// Move start point to vertical axis (-90 degrees)
				var degrees:Number = -90 + aRotation + (ix % aSides) * angle;
				var xVal:Number = calcXOnCircle(aRadius, degrees);
				var yVal:Number = calcYOnCircle(aRadius, degrees);
				
				if (ix == 0)
				{
					aGraphics.moveTo(xVal, yVal);
				}
				else
				{
					aGraphics.lineTo(xVal, yVal);
				}
			}
		}
		
	}
}

/* AS3JS File */
package charts.series.dots {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.Graphics;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.geom.Point;
	
	public class bow extends PointDotBase {
		
		public function bow( index:Number, value:Properties ) {
			
			var colour:Number = string.Utils.get_colour( value.get('colour') );
			
			super( index, value );
			
			this.tooltip = this.replace_magic_values( value.get('tip') );
			this.attach_events();

			// if style.x is null then user wants a gap in the line
			//
			// I don't understand what this is doing...
			//
//			if (style.x == null)
//			{
//				this.visible = false;
//			}
//			else
//			{
				
				if (value.get('hollow'))
				{
					// Hollow - set the fill to the background color/alpha
					if (value.get('background-colour') != null)
					{
						var bgColor:Number = string.Utils.get_colour( value.get('background-colour') );
					}
					else
					{
						bgColor = colour;
					}
					
					this.graphics.beginFill(bgColor, value.get('background-alpha')); 
				}
				else
				{
					// set the fill to be the same color and alpha as the line
					this.graphics.beginFill( colour, value.get('alpha') );
				}

				this.graphics.lineStyle( value.get('width'), colour, value.get('alpha') );

				this.draw(this.graphics, this.radius, value.get('rotation'));
				// Check to see if part of the line needs to be erased
				if (value.get('halo-size') > 0)
				{
					var s:Sprite = new Sprite();
					s.graphics.lineStyle( 0, 0, 0 );
					s.graphics.beginFill( 0, 1 );
					this.draw(s.graphics, value.get('halo-size')+this.radius, value.get('rotation'));
					s.blendMode = BlendMode.ERASE;
					s.graphics.endFill();
					this.line_mask = s;
				}
//			}
			
		}
		
		
		public override function set_tip( b:Boolean ):void {
			if ( b )
			{
				if ( !this.is_tip )
				{
					Tweener.addTween(this, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
					Tweener.addTween(this, {scaleY:1.3, time:0.4, transition:"easeoutbounce" } );
					if (this.line_mask != null)
					{
						Tweener.addTween(this.line_mask, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
						Tweener.addTween(this.line_mask, {scaleY:1.3, time:0.4, transition:"easeoutbounce" } );
					}
				}
				this.is_tip = true;
			}
			else
			{
				Tweener.removeTweens(this);
				Tweener.removeTweens(this.line_mask);
				this.scaleX = 1;
				this.scaleY = 1;
				if (this.line_mask != null)
				{
					this.line_mask.scaleX = 1;
					this.line_mask.scaleY = 1;
				}
				this.is_tip = false;
			}
		}
		
		private function draw( aGraphics:Graphics, aRadius:Number, aRotation:Number ):void 
		{
			var angle:Number = 60;

			// Start at center point
			aGraphics.moveTo(0, 0);
			
			// Upper right side point (unrotated)
			var degrees:Number = -90 + aRotation + angle;
			var xVal:Number = calcXOnCircle(aRadius, degrees);
			var yVal:Number = calcYOnCircle(aRadius, degrees);
			aGraphics.lineTo(xVal, yVal);

			// Lower right side point (unrotated)
			degrees += angle;
			xVal = calcXOnCircle(aRadius, degrees);
			yVal = calcYOnCircle(aRadius, degrees);
			aGraphics.lineTo(xVal, yVal);
			
			// Back to the center
			aGraphics.lineTo(xVal, yVal);
			
			// Upper left side point (unrotated)
			degrees = -90 + aRotation - angle;
			xVal = calcXOnCircle(aRadius, degrees);
			yVal = calcYOnCircle(aRadius, degrees);
			aGraphics.lineTo(xVal, yVal);
			
			// Lower Left side point (unrotated)
			degrees -= angle;
			xVal = calcXOnCircle(aRadius, degrees);
			yVal = calcYOnCircle(aRadius, degrees);
			aGraphics.lineTo(xVal, yVal);

			// Back to the center
			aGraphics.lineTo(xVal, yVal);
		}
	}
}

/* AS3JS File */
package charts.series.dots {

	public class DefaultDotProperties extends Properties
	{
		//
		// things that all dots share
		//
		public function DefaultDotProperties(json:Object, colour:String, axis:String) {
			// tr.ace_json(json);
			
			// the user JSON can override any of these:
			var parent:Properties = new Properties( {
				axis:			axis,
				'type':			'dot',
				'dot-size': 	5,
				'halo-size':	2,
				'colour':		colour,
				'tip':			'#val#',
				alpha:			1,
				// this is for anchors:
				rotation:		0,
				sides:			3,
				// this is for hollow dot:
				width:			1
				} );
				
				
				
			super( json, parent );
			
			tr.aces('4', this.get('axis'));
			// tr.aces('4', this.get('colour'));
			// tr.aces('4', this.get('type'));
		}
	}
}

/* AS3JS File */
package charts.series.dots {
	
	public class dot_factory {
		
		public static function make( index:Number, style:Properties ):PointDotBase {
			
			// tr.aces( 'dot factory type', style.get('type'));
			
			switch( style.get('type') )
			{
				case 'star':
					return new star(index, style);
					break;
					
				case 'bow':
					return new bow(index, style);
					break;
				
				case 'anchor':
					return new anchor(index, style);
					break;
				
				case 'dot':
					return new Point(index, style);
					break;
				
				case 'solid-dot':
					return new PointDot(index, style);
					break;
					
				case 'hollow-dot':
					return new Hollow(index, style);
					break;
					
				default:
				//
				// copy out the bow tie and then remove
				//
					return new Point(index, style);
					// return new scat(style);
					break;
			}
		}
	}
}

/* AS3JS File */
package charts.series.dots {
	
	//removeMeIfWant charts.series.dots.PointDotBase;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant string.Utils;
	
	public class Hollow extends PointDotBase {
		
		public function Hollow( index:Number, style:Properties ) {
			// tr.aces('h i', index);
			super( index, style );
			
			var colour:Number = string.Utils.get_colour( style.get('colour') );
			
			this.graphics.clear();
			//
			// fill a big circle
			//
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( colour, 1 );
			this.graphics.drawCircle( 0, 0, style.get('dot-size'));
			//
			// punch out the hollow circle:
			//
			this.graphics.drawCircle( 0, 0, style.get('dot-size')-style.get('width'));
			this.graphics.endFill();	// <-- LOOK
			//
			// HACK: we fill an invisible circle over
			//       the hollow circle so the mouse over
			//       event fires correctly (even when the
			//       mouse is in the hollow part)
			//
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill(0, 0);
			this.graphics.drawCircle( 0, 0, style.get('dot-size') );
			this.graphics.endFill();
			//
			// MASK
			//
			var s:Sprite = new Sprite();
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( 0, 1 );
			s.graphics.drawCircle( 0, 0, style.get('dot-size') + style.get('halo-size') );
			s.blendMode = BlendMode.ERASE;
			
			this.line_mask = s;
			this.attach_events();
			
		}
	}
}


/* AS3JS File */
package charts.series.dots {
	//removeMeIfWant charts.series.dots.PointDotBase;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant string.Utils;
	
	public class Point extends PointDotBase {
		
		public function Point( index:Number, style:Properties )
		{
			super( index, style );

			var colour:Number = string.Utils.get_colour( style.get('colour') );
			
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( colour, 1 );
			this.graphics.drawCircle( 0, 0, style.get('dot-size') );
			this.visible = false;
			this.attach_events();
			
			var s:Sprite = new Sprite();
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( 0, 1 );
			s.graphics.drawCircle( 0, 0, style.get('dot-size')+style.get('halo-size') );
			s.blendMode = BlendMode.ERASE;
			s.visible = false;
			
			this.line_mask = s;
		}
		
		public override function set_tip( b:Boolean ):void {
			
			this.visible = b;
			this.line_mask.visible = b;
		}
	}
}

/* AS3JS File */
package charts.series.dots {
	
	//removeMeIfWant charts.series.dots.PointDotBase;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant string.Utils;
	
	public class PointDot extends PointDotBase {
		
		public function PointDot( index:Number, style:Properties ) {
			
			super( index, style );
			
			var colour:Number = string.Utils.get_colour( style.get('colour') );
			
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( colour, 1 );
			this.graphics.drawCircle( 0, 0, style.get('dot-size') );
			this.graphics.endFill();
			
			var s:Sprite = new Sprite();
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( 0, 1 );
			s.graphics.drawCircle( 0, 0, style.get('dot-size')+style.get('halo-size') );
			s.blendMode = BlendMode.ERASE;
			
			this.line_mask = s;
			
			this.attach_events();
		}
	}
}


/* AS3JS File */
package charts.series.dots {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant string.DateUtils;
	
	public class PointDotBase extends Element {
		
		protected var radius:Number;
		protected var colour:Number;
		private var on_show_animate:Boolean;
		protected var on_show:Properties;
		
		public function PointDotBase( index:Number, props:Properties ) {
			
			super();
			this.is_tip = false;
			this.visible = true;
			this.on_show_animate = true;
			this.on_show = props.get('on-show');
			
			/*
			this.on_show = new Properties( {
				type:		"",
				cascade:	3,
				delay:		0
				});
			*/
			
			// line charts have a value and no X, scatter charts have
			// x, y (not value): radar charts have value, Y does not 
			// make sense.
			if( !props.has('y') )
				props.set('y', props.get('value'));
		
			this._y = props.get('y');
			
			// no X passed in so calculate it from the index
			if( !props.has('x') )
			{
				this.index = this._x = index;
			}
			else
			{
				// tr.aces( 'x', props.get('x') );
				this._x = props.get('x');
				this.index = Number.MIN_VALUE;
			}
			
			this.radius = props.get('dot-size');
			this.tooltip = this.replace_magic_values( props.get('tip') );
			
			if ( props.has('on-click') )
				this.set_on_click( props.get('on-click') );
			
			//
			// TODO: fix this hack
			//
			if ( props.has('axis') )
				if ( props.get('axis') == 'right' )
					this.right_axis = true;

		}
		
		public override function resize( sc:ScreenCoordsBase ): void {
			
			var x:Number;
			var y:Number;
			
			if ( this.index != Number.MIN_VALUE ) {
	
				var p:flash.geom.Point = sc.get_get_x_from_pos_and_y_from_val( this.index, this._y, this.right_axis );
				x = p.x;
				y = p.y;
			}
			else
			{

				//
				// Look: we have a real X value, so get its screen location:
				//
				x = sc.get_x_from_val( this._x );
				y = sc.get_y_from_val( this._y, this.right_axis );
			}
			
			// Move the mask so it is in the proper place also
			// this all needs to be moved into the base class
			if (this.line_mask != null)
			{
				this.line_mask.x = x;
				this.line_mask.y = y;
			}
			
			if ( this.on_show_animate )
				this.first_show(x, y, sc);
			else {
				//
				// move the Sprite to the correct screen location:
				//
				this.y = y;
				this.x = x;
			}
		}
		
		public function is_tweening(): Boolean {
			return Tweener.isTweening(this);
		}
		
		protected function first_show(x:Number, y:Number, sc:ScreenCoordsBase): void {
			
			this.on_show_animate = false;
			Tweener.removeTweens(this);
			
			// tr.aces('base.as', this.on_show.get('type') );
			var d:Number = x / this.stage.stageWidth;
			d *= this.on_show.get('cascade');
			d += this.on_show.get('delay');
		
			switch( this.on_show.get('type') ) {
				
				case 'pop-up':
					this.x = x;
					this.y = sc.get_y_bottom(this.right_axis);
					Tweener.addTween(this, { y:y, time:1.4, delay:d, transition:Equations.easeOutQuad } );
					
					if ( this.line_mask != null )
					{
						this.line_mask.x = x;
						this.line_mask.y = sc.get_y_bottom(this.right_axis);
						Tweener.addTween(this.line_mask, { y:y, time:1.4, delay:d, transition:Equations.easeOutQuad });
					}
					
					break;
					
				case 'explode':
					this.x = this.stage.stageWidth/2;
					this.y = this.stage.stageHeight/2;
					Tweener.addTween(this, { y:y, x:x, time:1.4, delay:d, transition:Equations.easeOutQuad } );
					
					if ( this.line_mask != null )
					{
						this.line_mask.x = this.stage.stageWidth/2;
						this.line_mask.y = this.stage.stageHeight/2;
						Tweener.addTween(this.line_mask, { y:y, x:x, time:1.4, delay:d, transition:Equations.easeOutQuad });
					}
					
					break;
				
				case 'mid-slide':
					this.x = x;
					this.y = this.stage.stageHeight / 2;
					this.alpha = 0.2;
					Tweener.addTween(this, { alpha:1, y:y, time:1.4, delay:d, transition:Equations.easeOutQuad });
					
					if ( this.line_mask != null )
					{
						this.line_mask.x = x;
						this.line_mask.y = this.stage.stageHeight / 2;
						Tweener.addTween(this.line_mask, { y:y, time:1.4, delay:d, transition:Equations.easeOutQuad });
					}
						
					break;
				
				/*
				 * the tooltips go a bit funny with this one
				 * TODO: investigate if this will work with area charts - need to move the bottom anchors
				case 'slide-in-up':
					this.x = 20;	// <-- left
					this.y = this.stage.stageHeight / 2;
					Tweener.addTween(
						this, 
						{ x:x, time:1.4, delay:d, transition:Equations.easeOutQuad, 
						onComplete:function():void {
							Tweener.addTween(this, 
							{ y:y, time:1.4, transition:Equations.easeOutQuad } ) }
						} );
					break;
				*/
				
				case 'drop':
					this.x = x;
					this.y = -height - 10;
					Tweener.addTween(this, { y:y, time:1.4, delay:d, transition:Equations.easeOutBounce } );
					
					if ( this.line_mask != null )
					{
						this.line_mask.x = x;
						this.line_mask.y = -height - 10;
						Tweener.addTween(this.line_mask, { y:y, time:1.4, delay:d, transition:Equations.easeOutQuad });
					}
					
					break;

				case 'fade-in':
					this.x = x;
					this.y = y;
					this.alpha = 0;
					Tweener.addTween(this, { alpha:1, time:1.2, delay:d, transition:Equations.easeOutQuad } );
					break;
				
				case 'shrink-in':
					this.x = x;
					this.y = y;
					this.scaleX = this.scaleY = 5;
					this.alpha = 0;
					Tweener.addTween(
						this,
						{
							scaleX:1, scaleY:1, alpha:1, time:1.2,
							delay:d, transition:Equations.easeOutQuad, 
							onComplete:function():void { tr.ace('Fin'); }
						} );
					
					break;
					
				default:
					this.y = y;
					this.x = x;
			}
		}
		
		public override function set_tip( b:Boolean ):void {
			//this.visible = b;
			if( b ) {
				this.scaleY = this.scaleX = 1.3;
				this.line_mask.scaleY = this.line_mask.scaleX = 1.3;
			}
			else {
				this.scaleY = this.scaleX = 1;
				this.line_mask.scaleY = this.line_mask.scaleX = 1;
			}
		}
		
		//
		// Dirty hack. Takes tooltip text, and replaces the #val# with the
		// tool_tip text, so noew you can do: "My Val = $#val#%", which turns into:
		// "My Val = $12.00%"
		//
		protected function replace_magic_values( t:String ): String {
			
			t = t.replace('#val#', NumberUtils.formatNumber( this._y ));
			
			// for scatter charts
			t = t.replace('#x#', NumberUtils.formatNumber(this._x));
			t = t.replace('#y#', NumberUtils.formatNumber(this._y));
			
			// debug the dots sizes
			t = t.replace('#size#', NumberUtils.formatNumber(this.radius));
			
			t = DateUtils.replace_magic_values(t, this._x);
			return t;
		}
		
		protected function calcXOnCircle(aRadius:Number, aDegrees:Number):Number
		{
			return aRadius * Math.cos(aDegrees / 180 * Math.PI);
		}
		
		protected function calcYOnCircle(aRadius:Number, aDegrees:Number):Number
		{
			return aRadius * Math.sin(aDegrees / 180 * Math.PI);
		}
		
	}
}


/* AS3JS File */
package charts.series.dots {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.Graphics;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant string.Utils;
	
	public class scat extends PointDotBase {
		
		public function scat( style:Object ) {
			
			// scatter charts have x, y (not value):
			style.value = style.y;

			super( -99, new Properties({}) );// style );

			// override the basics in PointDotBase:
			this._x = style.x;
			this._y = style.y;
			this.visible = true;

			if (style.alpha == null)
				style.alpha = 1;

			this.tooltip = this.replace_magic_values( style.tip );
			this.attach_events();
			
			// if style.x is null then user wants a gap in the line
			if (style.x == null)
			{
				this.visible = false;
			}
			else
			{
				var haloSize:Number = isNaN(style['halo-size']) ? 0 : style['halo-size'];
				var isHollow:Boolean = style['hollow'];
				
				if (isHollow)
				{
					// Hollow - set the fill to the background color/alpha
					if (style['background-colour'] != null)
					{
						var bgColor:Number = string.Utils.get_colour( style['background-colour'] );
					}
					else
					{
						bgColor = style.colour;
					}
					var bgAlpha:Number = isNaN(style['background-alpha']) ? 0 : style['background-alpha'];
					
					this.graphics.beginFill(bgColor, bgAlpha); 
				}
				else
				{
					// set the fill to be the same color and alpha as the line
					this.graphics.beginFill( style.colour, style.alpha );
				}

				switch (style['type'])
				{
					case 'dot':
						this.graphics.lineStyle( 0, 0, 0 );
						this.graphics.beginFill( style.colour, style.alpha );
						this.graphics.drawCircle( 0, 0, style['dot-size'] );
						this.graphics.endFill();
						
						var s:Sprite = new Sprite();
						s.graphics.lineStyle( 0, 0, 0 );
						s.graphics.beginFill( 0, 1 );
						s.graphics.drawCircle( 0, 0, style['dot-size'] + haloSize );
						s.blendMode = BlendMode.ERASE;
						
						this.line_mask = s;
						break;

					case 'anchor':
						this.graphics.lineStyle( style.width, style.colour, style.alpha );
						var rotation:Number = isNaN(style['rotation']) ? 0 : style['rotation'];
						var sides:Number = Math.max(3, isNaN(style['sides']) ? 3 : style['sides']);
						this.drawAnchor(this.graphics, this.radius, sides, rotation);
						// Check to see if part of the line needs to be erased
						//trace("haloSize = ", haloSize);
						if (haloSize > 0)
						{
							haloSize += this.radius;
							s = new Sprite();
							s.graphics.lineStyle( 0, 0, 0 );
							s.graphics.beginFill( 0, 1 );
							this.drawAnchor(s.graphics, haloSize, sides, rotation);
							s.blendMode = BlendMode.ERASE;
							s.graphics.endFill();
							this.line_mask = s;
						}
						break;
					
					case 'bow':
						this.graphics.lineStyle( style.width, style.colour, style.alpha );
						rotation = isNaN(style['rotation']) ? 0 : style['rotation'];
						
						this.drawBow(this.graphics, this.radius, rotation);
						// Check to see if part of the line needs to be erased
						if (haloSize > 0)
						{
							haloSize += this.radius;
							s = new Sprite();
							s.graphics.lineStyle( 0, 0, 0 );
							s.graphics.beginFill( 0, 1 );
							this.drawBow(s.graphics, haloSize, rotation);
							s.blendMode = BlendMode.ERASE;
							s.graphics.endFill();
							this.line_mask = s;
						}
						break;

					case 'star':
						this.graphics.lineStyle( style.width, style.colour, style.alpha );
						rotation = isNaN(style['rotation']) ? 0 : style['rotation'];
						
						this.drawStar_2(this.graphics, this.radius, rotation);
						// Check to see if part of the line needs to be erased
						if (haloSize > 0)
						{
							haloSize += this.radius;
							s = new Sprite();
							s.graphics.lineStyle( 0, 0, 0 );
							s.graphics.beginFill( 0, 1 );
							this.drawStar_2(s.graphics, haloSize, rotation);
							s.blendMode = BlendMode.ERASE;
							s.graphics.endFill();
							this.line_mask = s;
						}
						break;
						
					default:
						this.graphics.drawCircle( 0, 0, this.radius );
						this.graphics.drawCircle( 0, 0, this.radius - 1 );
						this.graphics.endFill();
				}
			}
			
		}
		/*
		protected function replace_magic_values( t:String ): String {
			
			t = t.replace('#x#', NumberUtils.formatNumber(this._x));
			t = t.replace('#y#', NumberUtils.formatNumber(this._y));
			t = t.replace('#size#', NumberUtils.formatNumber(this.radius));
			return t;
		}
		*/
		public override function set_tip( b:Boolean ):void {
			if ( b )
			{
				if ( !this.is_tip )
				{
					Tweener.addTween(this, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
					Tweener.addTween(this, {scaleY:1.3, time:0.4, transition:"easeoutbounce" } );
					if (this.line_mask != null)
					{
						Tweener.addTween(this.line_mask, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
						Tweener.addTween(this.line_mask, {scaleY:1.3, time:0.4, transition:"easeoutbounce" } );
					}
				}
				this.is_tip = true;
			}
			else
			{
				Tweener.removeTweens(this);
				Tweener.removeTweens(this.line_mask);
				this.scaleX = 1;
				this.scaleY = 1;
				if (this.line_mask != null)
				{
					this.line_mask.scaleX = 1;
					this.line_mask.scaleY = 1;
				}
				this.is_tip = false;
			}
		}
		
		public override function resize( sc:ScreenCoordsBase ): void {
			
			//
			// Look: we have a real X value, so get its screen location:
			//
			this.x = sc.get_x_from_val( this._x );
			this.y = sc.get_y_from_val( this._y, this.right_axis );
			
			// Move the mask so it is in the proper place also
			// this all needs to be moved into the base class
			if (this.line_mask != null)
			{
				this.line_mask.x = this.x;
				this.line_mask.y = this.y;
			}
		}

		
		private function drawAnchor( aGraphics:Graphics, aRadius:Number, 
										aSides:Number, aRotation:Number ):void 
		{
			if (aSides < 3) aSides = 3;
			if (aSides > 360) aSides = 360;
			var angle:Number = 360 / aSides;
			for (var ix:int = 0; ix <= aSides; ix++)
			{
				// Move start point to vertical axis (-90 degrees)
				var degrees:Number = -90 + aRotation + (ix % aSides) * angle;
				var xVal:Number = calcXOnCircle(aRadius, degrees);
				var yVal:Number = calcYOnCircle(aRadius, degrees);
				
				if (ix == 0)
				{
					aGraphics.moveTo(xVal, yVal);
				}
				else
				{
					aGraphics.lineTo(xVal, yVal);
				}
			}
		}
		
		private function drawBow( aGraphics:Graphics, aRadius:Number, 
									aRotation:Number ):void 
		{
			var angle:Number = 60;

			// Start at center point
			aGraphics.moveTo(0, 0);
			
			// Upper right side point (unrotated)
			var degrees:Number = -90 + aRotation + angle;
			var xVal:Number = calcXOnCircle(aRadius, degrees);
			var yVal:Number = calcYOnCircle(aRadius, degrees);
			aGraphics.lineTo(xVal, yVal);

			// Lower right side point (unrotated)
			degrees += angle;
			xVal = calcXOnCircle(aRadius, degrees);
			yVal = calcYOnCircle(aRadius, degrees);
			aGraphics.lineTo(xVal, yVal);
			
			// Back to the center
			aGraphics.lineTo(xVal, yVal);
			
			// Upper left side point (unrotated)
			degrees = -90 + aRotation - angle;
			xVal = calcXOnCircle(aRadius, degrees);
			yVal = calcYOnCircle(aRadius, degrees);
			aGraphics.lineTo(xVal, yVal);
			
			// Lower Left side point (unrotated)
			degrees -= angle;
			xVal = calcXOnCircle(aRadius, degrees);
			yVal = calcYOnCircle(aRadius, degrees);
			aGraphics.lineTo(xVal, yVal);

			// Back to the center
			aGraphics.lineTo(xVal, yVal);
		}

		private function drawStar_2( aGraphics:Graphics, aRadius:Number, 
									aRotation:Number ):void 
		{
			var angle:Number = 360 / 10;

			// Start at top point (unrotated)
			var degrees:Number = -90 + aRotation;
			for (var ix:int = 0; ix < 11; ix++)
			{
				var rad:Number;
				rad = (ix % 2 == 0) ? aRadius : aRadius/2;
				var xVal:Number = calcXOnCircle(rad, degrees);
				var yVal:Number = calcYOnCircle(rad, degrees);
				if(ix == 0)
				{
					aGraphics.moveTo(xVal, yVal);
				}
				else
				{
					aGraphics.lineTo(xVal, yVal);
				}
				degrees += angle;
			}
		}
		
		private function drawStar( aGraphics:Graphics, aRadius:Number, 
									aRotation:Number ):void 
		{
			var angle:Number = 360 / 5;

			// Start at top point (unrotated)
			var degrees:Number = -90 + aRotation;
			for (var ix:int = 0; ix <= 5; ix++)
			{
				var xVal:Number = calcXOnCircle(aRadius, degrees);
				var yVal:Number = calcYOnCircle(aRadius, degrees);
				if (ix == 0)
				{
					aGraphics.moveTo(xVal, yVal);
				}
				else
				{
					aGraphics.lineTo(xVal, yVal);
				}
				// Move 2 points clockwise
				degrees += (2 * angle);
			}
		}
	}
}

/* AS3JS File */
package charts.series.dots {
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.Graphics;
	//removeMeIfWant flash.display.BlendMode;
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant string.Utils;
	//removeMeIfWant flash.geom.Point;
	
	public class star extends PointDotBase {
		
		public function star( index:Number, value:Properties ) {
			
			var colour:Number = string.Utils.get_colour( value.get('colour') );
			
			super( index, value );
			
			this.tooltip = this.replace_magic_values( value.get('tip') );
			this.attach_events();

			// if style.x is null then user wants a gap in the line
			//
			// I don't understand what this is doing...
			//
//			if (style.x == null)
//			{
//				this.visible = false;
//			}
//			else
//			{
				
				if (value.get('hollow'))
				{
					// Hollow - set the fill to the background color/alpha
					if (value.get('background-colour') != null)
					{
						var bgColor:Number = string.Utils.get_colour( value.get('background-colour') );
					}
					else
					{
						bgColor = colour;
					}
					
					this.graphics.beginFill(bgColor, value.get('background-alpha')); 
				}
				else
				{
					// set the fill to be the same color and alpha as the line
					this.graphics.beginFill( colour, value.get('alpha') );
				}

				this.graphics.lineStyle( value.get('width'), colour, value.get('alpha') );

				this.drawStar_2(this.graphics, this.radius, value.get('rotation'));
				// Check to see if part of the line needs to be erased
				if (value.get('halo-size') > 0)
				{
					var s:Sprite = new Sprite();
					s.graphics.lineStyle( 0, 0, 0 );
					s.graphics.beginFill( 0, 1 );
					this.drawStar_2(s.graphics, value.get('halo-size')+this.radius, value.get('rotation'));
					s.blendMode = BlendMode.ERASE;
					s.graphics.endFill();
					this.line_mask = s;
				}
//			}
			
		}
		
		
		public override function set_tip( b:Boolean ):void {
			if ( b )
			{
				if ( !this.is_tip )
				{
					Tweener.addTween(this, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
					Tweener.addTween(this, {scaleY:1.3, time:0.4, transition:"easeoutbounce" } );
					if (this.line_mask != null)
					{
						Tweener.addTween(this.line_mask, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
						Tweener.addTween(this.line_mask, {scaleY:1.3, time:0.4, transition:"easeoutbounce" } );
					}
				}
				this.is_tip = true;
			}
			else
			{
				Tweener.removeTweens(this);
				Tweener.removeTweens(this.line_mask);
				this.scaleX = 1;
				this.scaleY = 1;
				if (this.line_mask != null)
				{
					this.line_mask.scaleX = 1;
					this.line_mask.scaleY = 1;
				}
				this.is_tip = false;
			}
		}
		
		private function drawStar_2( aGraphics:Graphics, aRadius:Number, 
									aRotation:Number ):void 
		{
			var angle:Number = 360 / 10;
			
			// Start at top point (unrotated)
			var degrees:Number = -90 + aRotation;
			for (var ix:int = 0; ix < 11; ix++)
			{
				var rad:Number;
				rad = (ix % 2 == 0) ? aRadius : aRadius/2;
				var xVal:Number = calcXOnCircle(rad, degrees);
				var yVal:Number = calcYOnCircle(rad, degrees);
				if(ix == 0)
				{
					aGraphics.moveTo(xVal, yVal);
				}
				else
				{
					aGraphics.lineTo(xVal, yVal);
				}
				degrees += angle;
			}
		}
		
	}
}

/* AS3JS File */
package charts.series.pies {

	public class DefaultPieProperties extends Properties
	{
	
		public function DefaultPieProperties(json:Object) {
			// tr.ace_json(json);
			
			// the user JSON can override any of these:
			var parent:Properties = new Properties( {
				alpha:				0.5,
				'start-angle':		90,
				'label-colour':		null,  // null means use colour of the slice
				'font-size':		10,
				'gradient-fill':	false,
				stroke:				1,
				colours:			["#900000", "#009000"],	// slices colours
				animate:			[{"type":"fade-in"}],
				tip:				'#val# of #total#',	// #percent#, #label#
				'no-labels':		false,
				'on-click':			null
				} );
				
				
				
			super( json, parent );
			
			tr.aces('4', this.get('start-angle'));
			// tr.aces('4', this.get('colour'));
			// tr.aces('4', this.get('type'));
		}
	}
}

/* AS3JS File */
package charts.series.pies {
	
	//removeMeIfWant string.Utils;
	//removeMeIfWant charts.series.has_tooltip;
	//removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.text.TextFormat;
	
	public class PieLabel extends TextField implements has_tooltip{
		public var is_over:Boolean;
		private static var TO_RADIANS:Number = Math.PI / 180;
		
		public function PieLabel( style:Object )
		{
			
			this.text = style.label;
			// legend_tf._rotation = 3.6*value.bar_bottom;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = string.Utils.get_colour( style.colour );
			fmt.font = "Verdana";
			fmt.size = style['font-size'];
			fmt.align = "center";
			this.setTextFormat(fmt);
			this.autoSize = "left";
			
			this.mouseEnabled = false;
		}
		
		public function move_label( rad:Number, x:Number, y:Number, ang:Number ):Boolean {
			
			//text field position
			var legend_x:Number = x+rad*Math.cos((ang)*TO_RADIANS);
			var legend_y:Number = y+rad*Math.sin((ang)*TO_RADIANS);
			
			//if legend stands to the right side of the pie
			if(legend_x<x)
				legend_x -= this.width;
					
			//if legend stands on upper half of the pie
			if(legend_y<y)
				legend_y -= this.height;
			
			this.x = legend_x;
			this.y = legend_y;
			
			// does the label fit onto the stage?
			if( (this.x > 0) &&
			    (this.y > 0) &&
				(this.y + this.height < this.stage.stageHeight ) &&
				(this.x+this.width<this.stage.stageWidth) )
				return true;
			else
				return false;
		}
		
		public function get_tooltip():String {
			tr.ace(( this.parent as has_tooltip ).get_tooltip());
			return ( this.parent as has_tooltip ).get_tooltip();
		}
		
		public function get_tip_pos():Object {
			return ( this.parent as has_tooltip ).get_tip_pos();
		}
		
		public function set_tip( b:Boolean ):void {
			return ( this.parent as has_tooltip ).set_tip(b);
		}
		
		public function resize( sc:ScreenCoords ): void {
			
		}
	}
}

/* AS3JS File */
package charts.series.pies {
	
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant charts.Pie;
	
	//removeMeIfWant flash.display.Sprite;
	//removeMeIfWant flash.display.GradientType;
	//removeMeIfWant flash.geom.Matrix;
	//removeMeIfWant flash.geom.Point;
	//removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	
	public class PieSlice extends Element {
		
		private var TO_RADIANS:Number = Math.PI / 180;
		private var colour:Number;
		public var slice_angle:Number;
		private var border_width:Number;
		public var angle:Number;
		public var is_over:Boolean;
		public var nolabels:Boolean;
		private var animate:Boolean;
		private var finished_animating:Boolean;
		public var value:Number;
		private var gradientFill:Boolean;
		private var label:String;
		private var pieRadius:Number;
		private var rawToolTip:String;
		
		public var position_original:flash.geom.Point;
		public var position_animate_to:flash.geom.Point;
		
		public function PieSlice( index:Number, value:Properties ) {
		
			this.colour = value.get_colour('colour');
			this.slice_angle = value.get('angle');
			this.border_width = 1;
			this.angle = value.get('start');
			this.animate = value.get('animate');
			this.nolabels = value.get('no-labels');
			this.value = value.get('value');
			this.gradientFill = value.get('gradient-fill');
			
			this.index = index;
			this.rawToolTip = value.get('tip');
			
			this.label = this.replace_magic_values( value.get('label') );
			this.tooltip = this.replace_magic_values( value.get('tip') );
			
			// TODO: why is this commented out in the patch file?
			// this.attach_events();
			
			if ( value.has('on-click') )
				this.set_on_click( value.get('on-click') );
			
			this.finished_animating = false;
		}
		
		//
		// This is called by the tooltip when it is finished with us,
		// it is only used in modes the pie does not support
		//
		public override function set_tip( b:Boolean ):void {}
		
		//
		// for most objects this is handled in Element,
		// and this tip is displayed just above that object,
		// but for PieSlice we want the tooltip to follow
		// the mouse:
		//
		public override function get_tip_pos():Object {
			var p:flash.geom.Point = this.localToGlobal( new flash.geom.Point(this.mouseX, this.mouseY) );
			return {x:p.x,y:p.y};
		}

		private function replace_magic_values( t:String ): String {
			
			t = t.replace('#label#', this.label );
			t = t.replace('#val#', NumberUtils.formatNumber( this.value ));
			t = t.replace('#radius#', NumberUtils.formatNumber( this.pieRadius ));
			return t;
		}
		
		public override function get_tooltip():String {
			this.tooltip = this.replace_magic_values( this.rawToolTip );
			return this.tooltip;
		}
		
		//
		// the axis makes no sense here, let's override with null and write our own.
		//
		public override function resize( sc:ScreenCoordsBase ): void { }
		public function pie_resize( sc:ScreenCoordsBase, radius:Number): void {
			
			this.pieRadius = radius;
			this.x = sc.get_center_x();
			this.y = sc.get_center_y();
			
			var label_line_length:Number = 10;
			
			this.graphics.clear();
			
			//line from center to edge
			this.graphics.lineStyle( this.border_width, this.colour, 1 );
			//this.graphics.lineStyle( 0, 0, 0 );

			//if the user selected the charts to be gradient filled do gradients
			if( this.gradientFill )
			{
				//set gradient fill
				var colors:Array = [this.colour, this.colour];// this.colour];
				var alphas:Array = [1, 0.5];
				var ratios:Array = [100,255];
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(radius*2, radius*2, 0, -radius, -radius);
				
				//matrix.createGradientBox(this.stage.stageWidth, this.stage.stageHeight, (3 * Math.PI / 2), -150, 10);
				
				this.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			}
			else
				this.graphics.beginFill(this.colour, 1);
			
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(radius, 0);
			
			var angle:Number = 4;
			var a:Number = Math.tan((angle/2)*TO_RADIANS);
			
			var i:Number = 0;
			var endx:Number;
			var endy:Number;
			var ax:Number;
			var ay:Number;
				
			//draw curve segments spaced by angle
			for ( i = 0; i + angle < this.slice_angle; i += angle) {
				endx = radius*Math.cos((i+angle)*TO_RADIANS);
				endy = radius*Math.sin((i+angle)*TO_RADIANS);
				ax = endx+radius*a*Math.cos(((i+angle)-90)*TO_RADIANS);
				ay = endy+radius*a*Math.sin(((i+angle)-90)*TO_RADIANS);
				this.graphics.curveTo(ax, ay, endx, endy);
			}
			
	
			//when aproaching end of slice, refine angle interval
			angle = 0.08;
			a = Math.tan((angle/2)*TO_RADIANS);
			
			for ( ; i+angle < slice_angle; i+=angle) {
				endx = radius*Math.cos((i+angle)*TO_RADIANS);
				endy = radius*Math.sin((i+angle)*TO_RADIANS);
				ax = endx+radius*a*Math.cos(((i+angle)-90)*TO_RADIANS);
				ay = endy+radius*a*Math.sin(((i+angle)-90)*TO_RADIANS);
				this.graphics.curveTo(ax, ay, endx, endy);
			}
	
			//close slice
			this.graphics.endFill();
			this.graphics.lineTo(0, 0);
			
			if (!this.nolabels) this.draw_label_line( radius, label_line_length, this.slice_angle );
			// return;
			
			
			if( this.animate )
			{
				if ( !this.finished_animating ) {
					this.finished_animating = true;
					// have we already rotated this slice?
					Tweener.addTween(this, { rotation:this.angle, time:1.4, transition:Equations.easeOutCirc, onComplete:this.done_animating } );
				}
			}
			else
			{
				this.done_animating();
			}
		}
		
		private function done_animating():void {
			this.rotation = this.angle;
			this.finished_animating = true;
		}
		
		
		// draw the line from the pie slice to the label
		private function draw_label_line( rad:Number, tick_size:Number, slice_angle:Number ):void {
			//draw line
			
			// TODO: why is this commented out?
			//this.graphics.lineStyle( 1, this.colour, 100 );
			//move to center of arc
			
			// TODO: need this?
			//this.graphics.moveTo(rad*Math.cos(slice_angle/2*TO_RADIANS), rad*Math.sin(slice_angle/2*TO_RADIANS));
//
			//final line positions
			//var lineEnd_x:Number = (rad+tick_size)*Math.cos(slice_angle/2*TO_RADIANS);
			//var lineEnd_y:Number = (rad+tick_size)*Math.sin(slice_angle/2*TO_RADIANS);
			//this.graphics.lineTo(lineEnd_x, lineEnd_y);
		}
		
		
		public override function toString():String {
			return "PieSlice: "+ this.get_tooltip();
		}
		
		public function getTicAngle():Number {
			return this.angle + (this.slice_angle / 2);
		}

		public function isRightSide():Boolean
		{
			return (this.getTicAngle() >= 270) || (this.getTicAngle() <= 90);
		}
		
		public function get_colour(): Number {
			return this.colour;
		}
	}
}

/* AS3JS File */
package charts.series.pies {
	
	//removeMeIfWant charts.series.Element;
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant caurina.transitions.Tweener;
	//removeMeIfWant caurina.transitions.Equations;
	//removeMeIfWant flash.geom.Point;
	////removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	
	public class PieSliceContainer extends Element {
		
		private var TO_RADIANS:Number = Math.PI / 180;
		
		private var animating:Boolean;
		private var pieSlice:PieSlice;
		private var pieLabel:PieLabel;
		private var pieRadius:Number;
		private var tick_size:Number = 10;
		private var tick_extension_size:Number = 4;
		private var label_margin:Number = 2;
		private var animationOffset:Number = 30;
		
		private var saveX:Number;
		private var saveY:Number;
		private var moveToX:Number;
		private var moveToY:Number;
		
		private var original_alpha:Number;
		
		

		//
		// this holds the slice and the text.
		// we want to rotate the slice, but not the text, so
		// this container holds both
		//
		public function PieSliceContainer( index:Number, value:Properties )
		{
			//
			// replace magic in the label:
			//
			// value.set('label', this.replace_magic_values( value.get('label') ) );
			
			
			tr.aces( 'pie', value.get('animate') );
			
			this.pieSlice = new PieSlice( index, value );
			this.addChild( this.pieSlice );
			var textlabel:String = value.get('label');
			
			//
			// we set the alpha of the parent container
			//
			this.alpha = this.original_alpha = value.get('alpha');
			//
			if ( !value.has('label-colour') )
				value.set('label-colour', value.get('colour'));
			
			var l:String = value.get('no-labels') ? '' : value.get('label');
			
			this.pieLabel = new PieLabel(
				{
					label:			l,
					colour:			value.get('label-colour'),
					'font-size':	value.get('font-size'),
					'on-click':		value.get('on-click') } )
			this.addChild( this.pieLabel );
			
			this.attach_events__(value);
			this.animating = false;
		}
		
		public function is_over():Boolean {
			return this.pieSlice.is_over;
		}
		
		public function get_slice():Element {
			return this.pieSlice;
		}
		
		public function get_label():PieLabel {
			return this.pieLabel;
		}
		
		
		//
		// the axis makes no sense here, let's override with null and write our own.
		//
		public override function resize( sc:ScreenCoordsBase ): void {}
		
		public function is_label_on_screen( sc:ScreenCoordsBase, slice_radius:Number ): Boolean {
			
			return this.pieLabel.move_label(
				slice_radius + 10,
				sc.get_center_x(),
				sc.get_center_y(),
				this.pieSlice.angle+(this.pieSlice.slice_angle/2) );
		}
		
		public function pie_resize( sc:ScreenCoordsBase, slice_radius:Number ): void {
			
			this.pieRadius = slice_radius;  // save off value for later use
			this.pieSlice.pie_resize(sc, slice_radius);

			var ticAngle:Number = this.getTicAngle();

			this.saveX = this.x;
			this.saveY = this.y;
			this.moveToX = this.x + (animationOffset * Math.cos(ticAngle * TO_RADIANS));
			this.moveToY = this.y + (animationOffset * Math.sin(ticAngle * TO_RADIANS));

			if (this.pieLabel.visible)
			{
				var lblRadius:Number = slice_radius + this.tick_size;
				var lblAngle:Number = ticAngle * TO_RADIANS;

				this.pieLabel.x = this.pieSlice.x + lblRadius * Math.cos(lblAngle);
				this.pieLabel.y = this.pieSlice.y + lblRadius * Math.sin(lblAngle);

				if (this.isRightSide())
				{
					this.pieLabel.x += this.tick_extension_size + this.label_margin;
				}
				else
				{
					//if legend stands to the left side of the pie
					this.pieLabel.x =
						this.pieLabel.x -
						this.pieLabel.width -
						this.tick_extension_size -
						this.label_margin -
						4;
				}
				this.pieLabel.y -= this.pieLabel.height / 2;

				this.drawTicLines();
			}
		}
		
		public override function get_tooltip():String {
			return this.pieSlice.get_tooltip();
		}
		
		public override function get_tip_pos():Object {
			var p:flash.geom.Point = this.localToGlobal( new flash.geom.Point(this.mouseX, this.mouseY) );
			return {x:p.x,y:p.y};
		}
		
		//
		// override this. I think this needs to be moved into an
		// animation manager?
		//
		// BTW this is called attach_events__ because Element has an
		//     attach_events already. I guess we need to fix one of them
		//
		protected function attach_events__(value:Properties):void {
			
			//
			// TODO: either move this into properties
			//       props.as(Array).get('moo');
			//       or get rid of type checking
			//
			
			var animate:Object = value.get('animate');
			if (!(animate is Array)) {
				if ((animate == null) || (animate)) {
					animate = [{"type":"bounce","distance":5}];
				}
				else {
					animate = new Array();
				}
			}
			
			var anims:Array = animate as Array;
			//
			// end to do
			//
			
			this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver_first, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut_first, false, 0, true);
						
			for each( var a:Object in anims ) {
				switch( a.type ) {
					
					case "bounce":
						// weak references so the garbage collector will kill them:
						this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver_bounce_out, false, 0, true);
						this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut_bounce_out, false, 0, true);
						this.animationOffset = a.distance;
						break;
						
					default:
						// weak references so the garbage collector will kill them:
						this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver_alpha, false, 0, true);
						this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut_alpha, false, 0, true);
						break;
				}
			}
		}
		
		//
		// stop multiple tweens from running
		//
		public function mouseOver_first(event:Event):void {
			
			if ( this.animating ) return;
			
			this.animating = true;
			Tweener.removeTweens(this);
		}
		
		public function mouseOut_first(event:Event):void {
			Tweener.removeTweens(this);
			this.animating = false;
		}
		
		public function mouseOver_bounce_out(event:Event):void {
			Tweener.addTween(this, {x:this.moveToX, y:this.moveToY, time:0.4, transition:"easeOutBounce"} );
		}
		
		public function mouseOut_bounce_out(event:Event):void {
			Tweener.addTween(this, {x:this.saveX, y:this.saveY, time:0.4, transition:"easeOutBounce"} );
		}
		
		public function mouseOver_alpha(event:Event):void {
			Tweener.addTween(this, { alpha:1, time:0.6, transition:Equations.easeOutCirc } );
		}

		public function mouseOut_alpha(event:Event):void {
			Tweener.addTween(this, { alpha:this.original_alpha, time:0.8, transition:Equations.easeOutElastic } );
		}

		public function getLabelTopY():Number
		{
			return this.pieLabel.y;
		}

		public function getLabelBottomY():Number
		{
			return this.pieLabel.y + this.pieLabel.height;
		}
		
		// Y value is from 0 to sc.Height from top to bottom
		public function moveLabelDown( sc:ScreenCoordsBase, minY:Number ):Number
		{
			if (this.pieLabel.visible)
			{
				var bAdjustToBottom:Boolean = false;
				var lblTop:Number = this.getLabelTopY();
				
				if (lblTop < minY)
				{
					// adjustment is positive
					var adjust:Number = minY - lblTop;
					if ((this.pieLabel.height + minY) > (sc.bottom - 1))
					{
						// calc adjust so label bottom is at bottom of screen
						adjust = sc.bottom - this.pieLabel.height - lblTop;
						bAdjustToBottom = true;
					}
					// Adjust the Y value
					this.pieLabel.y += adjust;

					if (!bAdjustToBottom)
					{
						var lblRadius:Number = this.pieRadius + this.tick_size;
						var calcSin:Number = ((this.pieLabel.y + this.pieLabel.height / 2) - this.pieSlice.y) / lblRadius;
						calcSin = Math.max( -1, Math.min(1, calcSin));
						var newAngle:Number = Math.asin(calcSin) / TO_RADIANS;

						if ((this.getTicAngle() > 90) && (this.getTicAngle() < 270))
						{
							newAngle = 180 - newAngle;
						}
						else if (this.getTicAngle() >= 270) 
						{
							newAngle = 360 + newAngle;
						}
						
						var newX:Number = this.pieSlice.x + lblRadius * Math.cos(newAngle * TO_RADIANS);
						if (this.isRightSide())
						{
							this.pieLabel.x = newX + this.tick_extension_size + this.label_margin;
						}
						else
						{
							//if legend stands to the left side of the pie
							this.pieLabel.x = newX - this.pieLabel.width -
												this.tick_extension_size - this.label_margin - 4;
						}
					}
				}
				this.drawTicLines();
				
				return this.pieLabel.y + this.pieLabel.height; 
			}
			else
			{
				return minY;
			}
		}
		
		// Y value is from 0 to sc.Height from top to bottom
		public function moveLabelUp( sc:ScreenCoordsBase, maxY:Number ):Number
		{
			if (this.pieLabel.visible)
			{
				var sign:Number = 1;
				var bAdjustToTop:Boolean = false;
				var lblBottom:Number = this.getLabelBottomY();
				if (lblBottom > maxY)
				{
					// adjustment is negative here
					var adjust:Number = maxY - lblBottom;
					if ((maxY - this.pieLabel.height) < (sc.top + 1))
					{
						// calc adjust so label top is at top of screen
						adjust = sc.top - this.getLabelTopY();
						bAdjustToTop = true;
					}
					// Adjust the Y value
					this.pieLabel.y += adjust;

					if (!bAdjustToTop)
					{
						var lblRadius:Number = this.pieRadius + this.tick_size;
						var calcSin:Number = ((this.pieLabel.y + this.pieLabel.height / 2) - this.pieSlice.y) / lblRadius;
						calcSin = Math.max( -1, Math.min(1, calcSin));
						var newAngle:Number = Math.asin(calcSin) / TO_RADIANS;

						if ((this.getTicAngle() > 90) && (this.getTicAngle() < 270))
						{
							newAngle = 180 - newAngle;
							sign = -1;
						}
						else if (this.getTicAngle() >= 270) 
						{
							newAngle = 360 + newAngle;
						}
						
						var newX:Number = this.pieSlice.x + lblRadius * Math.cos(newAngle * TO_RADIANS);
						if (this.isRightSide())
						{
							this.pieLabel.x = newX + this.tick_extension_size + this.label_margin;
						}
						else
						{
							//if legend stands to the left side of the pie
							this.pieLabel.x = newX - this.pieLabel.width -
										this.tick_extension_size - this.label_margin - 4;
						}
					}
				}
				this.drawTicLines();
				
				return this.pieLabel.y; 
			}
			else
			{
				return maxY;
			}
		}

		public function get_radius_offsets() :Object {
			// Update the label text here in case pie slices change dynamically
			//var lblText:String = this.getText();
			//this.myPieLabel.setText(lblText);
			
			var offset:Object = { top:animationOffset, right:animationOffset, 
									bottom:animationOffset, left:animationOffset };
			if (this.pieLabel.visible)
			{
				var ticAngle:Number = this.getTicAngle();
				var offset_threshold:Number = 20;
				var ticLength:Number = this.tick_size;
				
				if ((ticAngle >= 0) && (ticAngle <= 90)) 
				{
					offset.bottom = (ticAngle / 90) * ticLength + this.pieLabel.height / 2 + 1;
					offset.right = ((90 - ticAngle) / 90) * ticLength + this.tick_extension_size + this.label_margin + this.pieLabel.width;
				}
				else if ((ticAngle > 90) && (ticAngle <= 180)) 
				{
					offset.bottom = ((180 - ticAngle) / 90) * ticLength + this.pieLabel.height / 2 + 1;
					offset.left = ((ticAngle - 90) / 90) * ticLength + this.tick_extension_size + this.label_margin + this.pieLabel.width + 4;
				}
				else if ((ticAngle > 180) && (ticAngle < 270)) 
				{
					offset.top = ((ticAngle - 180) / 90) * ticLength + this.pieLabel.height / 2 + 1;
					offset.left = ((270 - ticAngle) / 90) * ticLength + this.tick_extension_size + this.label_margin + this.pieLabel.width + 4;
				}
				else // if ((ticAngle >= 270) && (ticAngle <= 360)) 
				{
					offset.top = ((360 - ticAngle) / 90) * ticLength + this.pieLabel.height / 2 + 1;
					offset.right = ((ticAngle - 270) / 90) * ticLength + this.tick_extension_size + this.label_margin + this.pieLabel.width;
				}
			}
			return offset;
		}
		protected function drawTicLines():void
		{
			if ((this.pieLabel.text != '') && (this.pieLabel.visible))
			{
				var ticAngle:Number = this.getTicAngle();
				
				var lblRadius:Number = this.pieRadius + this.tick_size;
				var lblAngle:Number = ticAngle * TO_RADIANS;

				var ticLblX:Number;
				var ticLblY:Number;
				if (this.pieSlice.isRightSide())
				{
					ticLblX = this.pieLabel.x - this.label_margin;
				}
				else
				{
					//if legend stands to the left side of the pie
					ticLblX = this.pieLabel.x + this.pieLabel.width + this.label_margin + 4;
				}
				ticLblY = this.pieLabel.y + this.pieLabel.height / 2;

				var ticArcX:Number = this.pieSlice.x + this.pieRadius * Math.cos(lblAngle);
				var ticArcY:Number = this.pieSlice.y + this.pieRadius * Math.sin(lblAngle);
				
				// Draw the line from the slice to the label
				this.graphics.clear();
				this.graphics.lineStyle( 1, this.pieSlice.get_colour(), 1 );
				
				// move to the end of the tic closest to the label
				this.graphics.moveTo(ticLblX, ticLblY);
				// draw a line the length of the tic extender
				if (this.pieSlice.isRightSide())
				{
					this.graphics.lineTo(ticLblX - this.tick_extension_size, ticLblY);
				}
				else
				{
					this.graphics.lineTo(ticLblX + this.tick_extension_size, ticLblY);
				}
				// Draw a line from the end of the tic extender to the arc
				this.graphics.lineTo(ticArcX, ticArcY);
			}
		}

		public function getTicAngle():Number
		{
			return this.pieSlice.getTicAngle();
		}

		public function isRightSide():Boolean
		{
			return this.pieSlice.isRightSide();
		}
	}
}

/* AS3JS File */
package charts.series.tags {
	
	//removeMeIfWant flash.text.TextField;
	//removeMeIfWant flash.text.TextFormat;
	//removeMeIfWant mx.states.SetProperty
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.MouseEvent;
	//removeMeIfWant flash.external.ExternalInterface;
	//removeMeIfWant flash.net.URLRequest;
	//removeMeIfWant flash.net.navigateToURL;
	//removeMeIfWant string.Utils;
	////removeMeIfWant mx.managers.CursorManager;
	////removeMeIfWant mx.controls.Label;
	
	public class Tag extends TextField {
		
		public var _x:Number;
		public var _y:Number;
		public var xAdj:Number = 0;
		public var yAdj:Number = 0;
		
		private var link:String;
		private var index:Number;
		protected var right_axis:Boolean;
		
		//[Embed(source = "HandCursor.jpg")]
		//private var HandCursor:Class;
		
		public function Tag( style:Object ) {

			this._x = style.x;
			this._y = style.y;
			this.right_axis = (style.axis == 'right');

			if ( style['on-click'] )
				this.set_on_click( style['on-click'] );
				
			//this.text = this.replace_magic_values(style.text);
			this.htmlText = this.replace_magic_values(style.text);
			this.autoSize = "left";
			this.alpha = style.alpha;
			this.border = style.border;
		
			if (style.background != null) {
				this.background = true;
				this.backgroundColor = Utils.get_colour(style.background);
			}

			var fmt:TextFormat = new TextFormat();
			if (style.rotate != 0) {
				fmt.font = "spArial";
				this.embedFonts = true;
			}
			else {
				fmt.font = style.font;
			}
			fmt.color = style.colour;
			fmt.size = style['font-size'];
			fmt.bold = style.bold;
			fmt.underline = style.underline;
			fmt.align = "center";
			this.setTextFormat(fmt);
			
			
			
			//CursorManager.setCursor(HandCursor);
			
			// prevents bar cursor but still clickable 
			// Hoping to figure out how to change the cursor
			this.selectable = false; 
			this.rotate_and_align(style.rotate, style['align-x'], style['align-y'], style['pad-x'], style['pad-y']);
			
		}
		
		public function rotate_and_align( rotation:Number, xAlign:String, yAlign:String, 
										  xPad:Number, yPad:Number ): void
		{ 
			rotation = rotation % 360;
			if (rotation < 0) rotation += 360;
			this.rotation = rotation;
			
			// NOTE: Calculations only work for 0, 90, 180, 270 and 360 at the moment
			//       Hopefully I can figure out the calculations for the other angles :(
			
			var myright:Number = this.width * Math.cos(rotation * Math.PI / 180);
			var myleft:Number = this.height * Math.cos((90 - rotation) * Math.PI / 180);
			var mytop:Number = this.height * Math.sin((90 - rotation) * Math.PI / 180);
			var mybottom:Number = this.width * Math.sin(rotation * Math.PI / 180);
			
			trace("rotation=", rotation, "width=", this.width, "left=", myleft, "right=", myright);
			trace("rotation=", rotation, "height=", this.height, "top=", mytop, "bottom=", mybottom);

			if (xAlign == "right")
			{
				switch (rotation)
				{
					case 0: 	this.xAdj = 0; 
								break;
					case 90: 	this.xAdj = this.width; 
								break;
					case 180: 	this.xAdj = this.width; 
								break;
					case 270: 	this.xAdj = 0; 
								break;
				}
				this.xAdj = this.xAdj + xPad;
			}
			else if (xAlign == "left")
			{
				switch (rotation)
				{
					case 0: 	this.xAdj = -this.width; 
								break;
					case 90: 	this.xAdj = 0; 
								break;
					case 180: 	this.xAdj = 0; 
								break;
					case 270: 	this.xAdj = -this.width; 
								break;
				}
				this.xAdj = this.xAdj - xPad;
			}
			else
			{
				// default to align center
				switch (rotation)
				{
					case 0: 	this.xAdj = -this.width / 2; 
								break;
					case 90: 	this.xAdj = this.width / 2; 
								break;
					case 180: 	this.xAdj = this.width / 2; 
								break;
					case 270: 	this.xAdj = -this.width / 2; 
								break;
				}
			}

			if (yAlign == "center")
			{
				switch (rotation)
				{
					case 0: 	this.yAdj = - this.height / 2; 
								break;
					case 90: 	this.yAdj = - this.height / 2; 
								break;
					case 180: 	this.yAdj = this.height / 2; 
								break;
					case 270: 	this.yAdj = this.height / 2; 
								break;
				}
			}
			else if (yAlign == "below") 
			{
				switch (rotation)
				{
					case 0: 	this.yAdj = 0; 
								break;
					case 90: 	this.yAdj = 0; 
								break;
					case 180: 	this.yAdj = this.height; 
								break;
					case 270: 	this.yAdj = this.height; 
								break;
				}
				this.yAdj = this.yAdj + yPad;
			}
			else
			{
				// default to align above
				switch (rotation)
				{
					case 0: 	this.yAdj = - this.height; 
								break;
					case 90: 	this.yAdj = - this.height; 
								break;
					case 180: 	this.yAdj = 0; 
								break;
					case 270: 	this.yAdj = 0; 
								break;
				}
				this.yAdj = this.yAdj - yPad;
			}
		}

		private function replace_magic_values( t:String ): String {
			var regex:RegExp = /#x#/g;
			t = t.replace(regex, NumberUtils.formatNumber(this._x));
			regex = /#y#/g;
			t = t.replace('#y#', NumberUtils.formatNumber(this._y));
			t = string.DateUtils.replace_magic_values(t, this._x);
			regex = /#ygmdate/g;
			t = t.replace(regex, '#gmdate');
			regex = /#ydate/g;
			t = t.replace('#ydate', '#date');
			t = string.DateUtils.replace_magic_values(t, this._y);
			return t;
		}
		
		public function set_on_click( s:String ):void {
			this.link = s;
			// this.buttonMode = true;
			// this.useHandCursor = true;
			
			// weak references so the garbage collector will kill it:
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp, false, 0, true);
		}
		
		private function mouseUp(event:Event):void {
			
			if ( this.link.substring(0, 6) == 'trace:' ) {
				// for the test JSON files:
				tr.ace( this.link );
			}
			else if ( this.link.substring(0, 5) == 'http:' )
				this.browse_url( this.link );
			else
				ExternalInterface.call( this.link, this._x );
		}
			
		private function browse_url( url:String ):void {
			var req:URLRequest = new URLRequest(this.link);
			try
			{
				navigateToURL(req);
			}
			catch (e:Error)
			{
				trace("Error opening link: " + this.link);
			}
		}

		public function resize( sc:ScreenCoordsBase ): void {
			// adjust by 2 for the offset between the textfield border and 
			// where text actually is
			this.x = sc.get_x_from_val( this._x ) + this.xAdj;
			this.y = sc.get_y_from_val( this._y, this.right_axis ) + this.yAdj;
		}
	}
}
/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.crypto {
	
	//removeMeIfWant com.adobe.utils.IntUtil;
	
	/**
	 * The MD5 Message-Digest Algorithm
	 *
	 * Implementation based on algorithm description at 
	 * http://www.faqs.org/rfcs/rfc1321.html
	 */
	public class MD5 {
		
		/**
		 * Performs the MD5 hash algorithm on a string.
		 *
		 * @param s The string to hash
		 * @return A string containing the hash value of s
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function hash( s:String ):String {
			// initialize the md buffers
			var a:int = 1732584193;
			var b:int = -271733879;
			var c:int = -1732584194;
			var d:int = 271733878;
			
			// variables to store previous values
			var aa:int;
			var bb:int;
			var cc:int;
			var dd:int;
			
			// create the blocks from the string and
			// save the length as a local var to reduce
			// lookup in the loop below
			var x:Array = createBlocks( s );
			var len:int = x.length;
			
			// loop over all of the blocks
			for ( var i:int = 0; i < len; i += 16) {
				// save previous values
				aa = a;
				bb = b;
				cc = c;
				dd = d;				
				
				// Round 1
				a = ff( a, b, c, d, x[i+ 0],  7, -680876936 ); 	// 1
				d = ff( d, a, b, c, x[i+ 1], 12, -389564586 );	// 2
				c = ff( c, d, a, b, x[i+ 2], 17, 606105819 ); 	// 3
				b = ff( b, c, d, a, x[i+ 3], 22, -1044525330 );	// 4
				a = ff( a, b, c, d, x[i+ 4],  7, -176418897 ); 	// 5
				d = ff( d, a, b, c, x[i+ 5], 12, 1200080426 ); 	// 6
				c = ff( c, d, a, b, x[i+ 6], 17, -1473231341 );	// 7
				b = ff( b, c, d, a, x[i+ 7], 22, -45705983 ); 	// 8
				a = ff( a, b, c, d, x[i+ 8],  7, 1770035416 ); 	// 9
				d = ff( d, a, b, c, x[i+ 9], 12, -1958414417 );	// 10
				c = ff( c, d, a, b, x[i+10], 17, -42063 ); 		// 11
				b = ff( b, c, d, a, x[i+11], 22, -1990404162 );	// 12
				a = ff( a, b, c, d, x[i+12],  7, 1804603682 ); 	// 13
				d = ff( d, a, b, c, x[i+13], 12, -40341101 ); 	// 14
				c = ff( c, d, a, b, x[i+14], 17, -1502002290 );	// 15
				b = ff( b, c, d, a, x[i+15], 22, 1236535329 ); 	// 16
				
				// Round 2
				a = gg( a, b, c, d, x[i+ 1],  5, -165796510 ); 	// 17
				d = gg( d, a, b, c, x[i+ 6],  9, -1069501632 );	// 18
				c = gg( c, d, a, b, x[i+11], 14, 643717713 ); 	// 19
				b = gg( b, c, d, a, x[i+ 0], 20, -373897302 ); 	// 20
				a = gg( a, b, c, d, x[i+ 5],  5, -701558691 ); 	// 21
				d = gg( d, a, b, c, x[i+10],  9, 38016083 ); 	// 22
				c = gg( c, d, a, b, x[i+15], 14, -660478335 ); 	// 23
				b = gg( b, c, d, a, x[i+ 4], 20, -405537848 ); 	// 24
				a = gg( a, b, c, d, x[i+ 9],  5, 568446438 ); 	// 25
				d = gg( d, a, b, c, x[i+14],  9, -1019803690 );	// 26
				c = gg( c, d, a, b, x[i+ 3], 14, -187363961 ); 	// 27
				b = gg( b, c, d, a, x[i+ 8], 20, 1163531501 ); 	// 28
				a = gg( a, b, c, d, x[i+13],  5, -1444681467 );	// 29
				d = gg( d, a, b, c, x[i+ 2],  9, -51403784 ); 	// 30
				c = gg( c, d, a, b, x[i+ 7], 14, 1735328473 ); 	// 31
				b = gg( b, c, d, a, x[i+12], 20, -1926607734 );	// 32
				
				// Round 3
				a = hh( a, b, c, d, x[i+ 5],  4, -378558 ); 	// 33
				d = hh( d, a, b, c, x[i+ 8], 11, -2022574463 );	// 34
				c = hh( c, d, a, b, x[i+11], 16, 1839030562 ); 	// 35
				b = hh( b, c, d, a, x[i+14], 23, -35309556 ); 	// 36
				a = hh( a, b, c, d, x[i+ 1],  4, -1530992060 );	// 37
				d = hh( d, a, b, c, x[i+ 4], 11, 1272893353 ); 	// 38
				c = hh( c, d, a, b, x[i+ 7], 16, -155497632 ); 	// 39
				b = hh( b, c, d, a, x[i+10], 23, -1094730640 );	// 40
				a = hh( a, b, c, d, x[i+13],  4, 681279174 ); 	// 41
				d = hh( d, a, b, c, x[i+ 0], 11, -358537222 ); 	// 42
				c = hh( c, d, a, b, x[i+ 3], 16, -722521979 ); 	// 43
				b = hh( b, c, d, a, x[i+ 6], 23, 76029189 ); 	// 44
				a = hh( a, b, c, d, x[i+ 9],  4, -640364487 ); 	// 45
				d = hh( d, a, b, c, x[i+12], 11, -421815835 ); 	// 46
				c = hh( c, d, a, b, x[i+15], 16, 530742520 ); 	// 47
				b = hh( b, c, d, a, x[i+ 2], 23, -995338651 ); 	// 48
				
				// Round 4
				a = ii( a, b, c, d, x[i+ 0],  6, -198630844 ); 	// 49
				d = ii( d, a, b, c, x[i+ 7], 10, 1126891415 ); 	// 50
				c = ii( c, d, a, b, x[i+14], 15, -1416354905 );	// 51
				b = ii( b, c, d, a, x[i+ 5], 21, -57434055 ); 	// 52
				a = ii( a, b, c, d, x[i+12],  6, 1700485571 ); 	// 53
				d = ii( d, a, b, c, x[i+ 3], 10, -1894986606 );	// 54
				c = ii( c, d, a, b, x[i+10], 15, -1051523 ); 	// 55
				b = ii( b, c, d, a, x[i+ 1], 21, -2054922799 );	// 56
				a = ii( a, b, c, d, x[i+ 8],  6, 1873313359 ); 	// 57
				d = ii( d, a, b, c, x[i+15], 10, -30611744 ); 	// 58
				c = ii( c, d, a, b, x[i+ 6], 15, -1560198380 );	// 59
				b = ii( b, c, d, a, x[i+13], 21, 1309151649 ); 	// 60
				a = ii( a, b, c, d, x[i+ 4],  6, -145523070 ); 	// 61
				d = ii( d, a, b, c, x[i+11], 10, -1120210379 );	// 62
				c = ii( c, d, a, b, x[i+ 2], 15, 718787259 ); 	// 63
				b = ii( b, c, d, a, x[i+ 9], 21, -343485551 ); 	// 64

				a += aa;
				b += bb;
				c += cc;
				d += dd;
			}

			// Finish up by concatening the buffers with their hex output
			return IntUtil.toHex( a ) + IntUtil.toHex( b ) + IntUtil.toHex( c ) + IntUtil.toHex( d );
		}
		
		/**
		 * Auxiliary function f as defined in RFC
		 */
		private static function f( x:int, y:int, z:int ):int {
			return ( x & y ) | ( (~x) & z );
		}
		
		/**
		 * Auxiliary function g as defined in RFC
		 */
		private static function g( x:int, y:int, z:int ):int {
			return ( x & z ) | ( y & (~z) );
		}
		
		/**
		 * Auxiliary function h as defined in RFC
		 */
		private static function h( x:int, y:int, z:int ):int {
			return x ^ y ^ z;
		}
		
		/**
		 * Auxiliary function i as defined in RFC
		 */
		private static function i( x:int, y:int, z:int ):int {
			return y ^ ( x | (~z) );
		}
		
		/**
		 * A generic transformation function.  The logic of ff, gg, hh, and
		 * ii are all the same, minus the function used, so pull that logic
		 * out and simplify the method bodies for the transoformation functions.
		 */
		private static function transform( func:Function, a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			var tmp:int = a + int( func( b, c, d ) ) + x + t;
			return IntUtil.rol( tmp, s ) +  b;
		}
		
		/**
		 * ff transformation function
		 */
		private static function ff ( a:int, b:int, c:int, d:int, x:int, s:int, t:int ):int {
			return transform( f, a, b, c, d, x, s, t );
		}
		
		/**
		 * gg transformation function
		 */
		private static function gg ( a:int, b:int, c:int, d:int, x:int, s:int, t:int ):int {
			return transform( g, a, b, c, d, x, s, t );
		}
		
		/**
		 * hh transformation function
		 */
		private static function hh ( a:int, b:int, c:int, d:int, x:int, s:int, t:int ):int {
			return transform( h, a, b, c, d, x, s, t );
		}
		
		/**
		 * ii transformation function
		 */
		private static function ii ( a:int, b:int, c:int, d:int, x:int, s:int, t:int ):int {
			return transform( i, a, b, c, d, x, s, t );
		}
		
		/**
		 * Converts a string to a sequence of 16-word blocks
		 * that we'll do the processing on.  Appends padding
		 * and length in the process.
		 *
		 * @param s The string to split into blocks
		 * @return An array containing the blocks that s was
		 *			split into.
		 */
		private static function createBlocks( s:String ):Array {
			var blocks:Array = new Array();
			var len:int = s.length * 8;
			var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
			for( var i:int = 0; i < len; i += 8 ) {
				blocks[ i >> 5 ] |= ( s.charCodeAt( i / 8 ) & mask ) << ( i % 32 );
			}
			
			// append padding and length
			blocks[ len >> 5 ] |= 0x80 << ( len % 32 );
			blocks[ ( ( ( len + 64 ) >>> 9 ) << 4 ) + 14 ] = len;
			return blocks;
		}
		
	}
}/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.crypto
{
	//removeMeIfWant com.adobe.utils.IntUtil;
	//removeMeIfWant flash.utils.ByteArray;
	//removeMeIfWant mx.utils.Base64Encoder;
	
	/**
	 *  US Secure Hash Algorithm 1 (SHA1)
	 *
	 *  Implementation based on algorithm description at 
	 *  http://www.faqs.org/rfcs/rfc3174.html
	 */
	public class SHA1
	{
		/**
		 *  Performs the SHA1 hash algorithm on a string.
		 *
		 *  @param s		The string to hash
		 *  @return			A string containing the hash value of s
		 *  @langversion	ActionScript 3.0
		 *  @playerversion	9.0
		 *  @tiptext
		 */
		public static function hash( s:String ):String
		{
			var blocks:Array = createBlocksFromString( s );
			var byteArray:ByteArray = hashBlocks( blocks );
			
			return IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true );
		}
		
		/**
		 *  Performs the SHA1 hash algorithm on a ByteArray.
		 *
		 *  @param data		The ByteArray data to hash
		 *  @return			A string containing the hash value of data
		 *  @langversion	ActionScript 3.0
		 *  @playerversion	9.0
		 */
		public static function hashBytes( data:ByteArray ):String
		{
			var blocks:Array = SHA1.createBlocksFromByteArray( data );
			var byteArray:ByteArray = hashBlocks(blocks);
			
			return IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true );
		}
		
		/**
		 *  Performs the SHA1 hash algorithm on a string, then does
		 *  Base64 encoding on the result.
		 *
		 *  @param s		The string to hash
		 *  @return			The base64 encoded hash value of s
		 *  @langversion	ActionScript 3.0
		 *  @playerversion	9.0
		 *  @tiptext
		 */
		public static function hashToBase64( s:String ):String
		{
			var blocks:Array = SHA1.createBlocksFromString( s );
			var byteArray:ByteArray = hashBlocks(blocks);

			// ByteArray.toString() returns the contents as a UTF-8 string,
			// which we can't use because certain byte sequences might trigger
			// a UTF-8 conversion.  Instead, we convert the bytes to characters
			// one by one.
			var charsInByteArray:String = "";
			byteArray.position = 0;
			for (var j:int = 0; j < byteArray.length; j++)
			{
				var byte:uint = byteArray.readUnsignedByte();
				charsInByteArray += String.fromCharCode(byte);
			}

			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(charsInByteArray);
			return encoder.flush();
		}
		
		private static function hashBlocks( blocks:Array ):ByteArray
		{
			// initialize the h's
			var h0:int = 0x67452301;
			var h1:int = 0xefcdab89;
			var h2:int = 0x98badcfe;
			var h3:int = 0x10325476;
			var h4:int = 0xc3d2e1f0;
			
			var len:int = blocks.length;
			var w:Array = new Array( 80 );
			
			// loop over all of the blocks
			for ( var i:int = 0; i < len; i += 16 ) {
			
				// 6.1.c
				var a:int = h0;
				var b:int = h1;
				var c:int = h2;
				var d:int = h3;
				var e:int = h4;
				
				// 80 steps to process each block
				// TODO: unroll for faster execution, or 4 loops of
				// 20 each to avoid the k and f function calls
				for ( var t:int = 0; t < 80; t++ ) {
					
					if ( t < 16 ) {
						// 6.1.a
						w[ t ] = blocks[ i + t ];
					} else {
						// 6.1.b
						w[ t ] = IntUtil.rol( w[ t - 3 ] ^ w[ t - 8 ] ^ w[ t - 14 ] ^ w[ t - 16 ], 1 );
					}
					
					// 6.1.d
					var temp:int = IntUtil.rol( a, 5 ) + f( t, b, c, d ) + e + int( w[ t ] ) + k( t );
					
					e = d;
					d = c;
					c = IntUtil.rol( b, 30 );
					b = a;
					a = temp;
				}
				
				// 6.1.e
				h0 += a;
				h1 += b;
				h2 += c;
				h3 += d;
				h4 += e;		
			}
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeInt(h0);
			byteArray.writeInt(h1);
			byteArray.writeInt(h2);
			byteArray.writeInt(h3);
			byteArray.writeInt(h4);
			byteArray.position = 0;
			return byteArray;
		}

		/**
		 *  Performs the logical function based on t
		 */
		private static function f( t:int, b:int, c:int, d:int ):int {
			if ( t < 20 ) {
				return ( b & c ) | ( ~b & d );
			} else if ( t < 40 ) {
				return b ^ c ^ d;
			} else if ( t < 60 ) {
				return ( b & c ) | ( b & d ) | ( c & d );
			}
			return b ^ c ^ d;
		}
		
		/**
		 *  Determines the constant value based on t
		 */
		private static function k( t:int ):int {
			if ( t < 20 ) {
				return 0x5a827999;
			} else if ( t < 40 ) {
				return 0x6ed9eba1;
			} else if ( t < 60 ) {
				return 0x8f1bbcdc;
			}
			return 0xca62c1d6;
		}
					
		/**
		 *  Converts a ByteArray to a sequence of 16-word blocks
		 *  that we'll do the processing on.  Appends padding
		 *  and length in the process.
		 *
		 *  @param data		The data to split into blocks
		 *  @return			An array containing the blocks into which data was split
		 */
		private static function createBlocksFromByteArray( data:ByteArray ):Array
		{
			var oldPosition:int = data.position;
			data.position = 0;
			
			var blocks:Array = new Array();
			var len:int = data.length * 8;
			var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
			for( var i:int = 0; i < len; i += 8 )
			{
				blocks[ i >> 5 ] |= ( data.readByte() & mask ) << ( 24 - i % 32 );
			}
			
			// append padding and length
			blocks[ len >> 5 ] |= 0x80 << ( 24 - len % 32 );
			blocks[ ( ( ( len + 64 ) >> 9 ) << 4 ) + 15 ] = len;
			
			data.position = oldPosition;
			
			return blocks;
		}
					
		/**
		 *  Converts a string to a sequence of 16-word blocks
		 *  that we'll do the processing on.  Appends padding
		 *  and length in the process.
		 *
		 *  @param s	The string to split into blocks
		 *  @return		An array containing the blocks that s was split into.
		 */
		private static function createBlocksFromString( s:String ):Array
		{
			var blocks:Array = new Array();
			var len:int = s.length * 8;
			var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
			for( var i:int = 0; i < len; i += 8 ) {
				blocks[ i >> 5 ] |= ( s.charCodeAt( i / 8 ) & mask ) << ( 24 - i % 32 );
			}
			
			// append padding and length
			blocks[ len >> 5 ] |= 0x80 << ( 24 - len % 32 );
			blocks[ ( ( ( len + 64 ) >> 9 ) << 4 ) + 15 ] = len;
			return blocks;
		}
		
	}
}/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.crypto
{
	//removeMeIfWant com.adobe.utils.IntUtil;
	//removeMeIfWant flash.utils.ByteArray;
	//removeMeIfWant mx.utils.Base64Encoder;
	
	/**
	 * The SHA-224 algorithm
	 * 
	 * @see http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf
	 */
	public class SHA224
	{
		
		/**
		 *  Performs the SHA224 hash algorithm on a string.
		 *
		 *  @param s		The string to hash
		 *  @return			A string containing the hash value of s
		 *  @langversion	ActionScript 3.0
		 *  @playerversion	9.0
		 *  @tiptext
		 */
		public static function hash( s:String ):String {
			var blocks:Array = createBlocksFromString( s );
			var byteArray:ByteArray = hashBlocks( blocks );
			return IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true );
		}
		
		/**
		 *  Performs the SHA224 hash algorithm on a ByteArray.
		 *
		 *  @param data		The ByteArray data to hash
		 *  @return			A string containing the hash value of data
		 *  @langversion	ActionScript 3.0
		 *  @playerversion	9.0
		 */
		public static function hashBytes( data:ByteArray ):String
		{
			var blocks:Array = createBlocksFromByteArray( data );
			var byteArray:ByteArray = hashBlocks(blocks);
			return IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true );
		}
		
		/**
		 *  Performs the SHA224 hash algorithm on a string, then does
		 *  Base64 encoding on the result.
		 *
		 *  @param s		The string to hash
		 *  @return			The base64 encoded hash value of s
		 *  @langversion	ActionScript 3.0
		 *  @playerversion	9.0
		 *  @tiptext
		 */
		public static function hashToBase64( s:String ):String
		{
			var blocks:Array = createBlocksFromString( s );
			var byteArray:ByteArray = hashBlocks(blocks);

			// ByteArray.toString() returns the contents as a UTF-8 string,
			// which we can't use because certain byte sequences might trigger
			// a UTF-8 conversion.  Instead, we convert the bytes to characters
			// one by one.
			var charsInByteArray:String = "";
			byteArray.position = 0;
			for (var j:int = 0; j < byteArray.length; j++)
			{
				var byte:uint = byteArray.readUnsignedByte();
				charsInByteArray += String.fromCharCode(byte);
			}

			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(charsInByteArray);
			return encoder.flush();
		}
		
		private static function hashBlocks( blocks:Array ):ByteArray {
			var h0:int = 0xc1059ed8;
			var h1:int = 0x367cd507;
			var h2:int = 0x3070dd17;
			var h3:int = 0xf70e5939;
			var h4:int = 0xffc00b31;
			var h5:int = 0x68581511;
			var h6:int = 0x64f98fa7;
			var h7:int = 0xbefa4fa4;
			
			var k:Array = new Array(0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2);
			
			var len:int = blocks.length;
			var w:Array = new Array();
			
			// loop over all of the blocks
			for ( var i:int = 0; i < len; i += 16 ) {
				
				var a:int = h0;
				var b:int = h1;
				var c:int = h2;
				var d:int = h3;
				var e:int = h4;
				var f:int = h5;
				var g:int = h6;
				var h:int = h7;
				
				for(var t:int = 0; t < 64; t++) {
					
					if ( t < 16 ) {
						w[t] = blocks[ i + t ];
						if(isNaN(w[t])) { w[t] = 0; }
					} else {
						var ws0:int = IntUtil.ror(w[t-15], 7) ^ IntUtil.ror(w[t-15], 18) ^ (w[t-15] >>> 3);
						var ws1:int = IntUtil.ror(w[t-2], 17) ^ IntUtil.ror(w[t-2], 19) ^ (w[t-2] >>> 10);
						w[t] = w[t-16] + ws0 + w[t-7] + ws1;
					}
					
					var s0:int = IntUtil.ror(a, 2) ^ IntUtil.ror(a, 13) ^ IntUtil.ror(a, 22);
					var maj:int = (a & b) ^ (a & c) ^ (b & c);
					var t2:int = s0 + maj;
					var s1:int = IntUtil.ror(e, 6) ^ IntUtil.ror(e, 11) ^ IntUtil.ror(e, 25);
					var ch:int = (e & f) ^ ((~e) & g);
					var t1:int = h + s1 + ch + k[t] + w[t];
					
					h = g;
					g = f;
					f = e;
					e = d + t1;
					d = c;
					c = b;
					b = a;
					a = t1 + t2;
				}
					
				//Add this chunk's hash to result so far:
				h0 += a;
				h1 += b;
				h2 += c;
				h3 += d;
				h4 += e;
				h5 += f;
				h6 += g;
				h7 += h;
			}
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeInt(h0);
			byteArray.writeInt(h1);
			byteArray.writeInt(h2);
			byteArray.writeInt(h3);
			byteArray.writeInt(h4);
			byteArray.writeInt(h5);
			byteArray.writeInt(h6);
			byteArray.position = 0;
			return byteArray;
		}
		
		/**
		 *  Converts a ByteArray to a sequence of 16-word blocks
		 *  that we'll do the processing on.  Appends padding
		 *  and length in the process.
		 *
		 *  @param data		The data to split into blocks
		 *  @return			An array containing the blocks into which data was split
		 */
		private static function createBlocksFromByteArray( data:ByteArray ):Array
		{
			var oldPosition:int = data.position;
			data.position = 0;
			
			var blocks:Array = new Array();
			var len:int = data.length * 8;
			var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
			for( var i:int = 0; i < len; i += 8 )
			{
				blocks[ i >> 5 ] |= ( data.readByte() & mask ) << ( 24 - i % 32 );
			}
			
			// append padding and length
			blocks[ len >> 5 ] |= 0x80 << ( 24 - len % 32 );
			blocks[ ( ( ( len + 64 ) >> 9 ) << 4 ) + 15 ] = len;
			
			data.position = oldPosition;
			
			return blocks;
		}
					
		/**
		 *  Converts a string to a sequence of 16-word blocks
		 *  that we'll do the processing on.  Appends padding
		 *  and length in the process.
		 *
		 *  @param s	The string to split into blocks
		 *  @return		An array containing the blocks that s was split into.
		 */
		private static function createBlocksFromString( s:String ):Array
		{
			var blocks:Array = new Array();
			var len:int = s.length * 8;
			var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
			for( var i:int = 0; i < len; i += 8 ) {
				blocks[ i >> 5 ] |= ( s.charCodeAt( i / 8 ) & mask ) << ( 24 - i % 32 );
			}
			
			// append padding and length
			blocks[ len >> 5 ] |= 0x80 << ( 24 - len % 32 );
			blocks[ ( ( ( len + 64 ) >> 9 ) << 4 ) + 15 ] = len;
			return blocks;
		}
	}
}/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.crypto
{
	//removeMeIfWant com.adobe.utils.IntUtil;
	//removeMeIfWant flash.utils.ByteArray;
	//removeMeIfWant mx.utils.Base64Encoder;
	
	/**
	 * The SHA-256 algorithm
	 * 
	 * @see http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf
	 */
	public class SHA256
	{
		
		/**
		 *  Performs the SHA256 hash algorithm on a string.
		 *
		 *  @param s		The string to hash
		 *  @return			A string containing the hash value of s
		 *  @langversion	ActionScript 3.0
		 *  @playerversion	9.0
		 *  @tiptext
		 */
		public static function hash( s:String ):String {
			var blocks:Array = createBlocksFromString( s );
			var byteArray:ByteArray = hashBlocks( blocks );
			
			return IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true );
		}
		
		/**
		 *  Performs the SHA256 hash algorithm on a ByteArray.
		 *
		 *  @param data		The ByteArray data to hash
		 *  @return			A string containing the hash value of data
		 *  @langversion	ActionScript 3.0
		 *  @playerversion	9.0
		 */
		public static function hashBytes( data:ByteArray ):String
		{
			var blocks:Array = createBlocksFromByteArray( data );
			var byteArray:ByteArray = hashBlocks(blocks);
			
			return IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true )
					+ IntUtil.toHex( byteArray.readInt(), true );
		}
		
		/**
		 *  Performs the SHA256 hash algorithm on a string, then does
		 *  Base64 encoding on the result.
		 *
		 *  @param s		The string to hash
		 *  @return			The base64 encoded hash value of s
		 *  @langversion	ActionScript 3.0
		 *  @playerversion	9.0
		 *  @tiptext
		 */
		public static function hashToBase64( s:String ):String
		{
			var blocks:Array = createBlocksFromString( s );
			var byteArray:ByteArray = hashBlocks(blocks);

			// ByteArray.toString() returns the contents as a UTF-8 string,
			// which we can't use because certain byte sequences might trigger
			// a UTF-8 conversion.  Instead, we convert the bytes to characters
			// one by one.
			var charsInByteArray:String = "";
			byteArray.position = 0;
			for (var j:int = 0; j < byteArray.length; j++)
			{
				var byte:uint = byteArray.readUnsignedByte();
				charsInByteArray += String.fromCharCode(byte);
			}

			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(charsInByteArray);
			return encoder.flush();
		}
		
		private static function hashBlocks( blocks:Array ):ByteArray {
			var h0:int = 0x6a09e667;
			var h1:int = 0xbb67ae85;
			var h2:int = 0x3c6ef372;
			var h3:int = 0xa54ff53a;
			var h4:int = 0x510e527f;
			var h5:int = 0x9b05688c;
			var h6:int = 0x1f83d9ab;
			var h7:int = 0x5be0cd19;
			
			var k:Array = new Array(0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2);
			
			var len:int = blocks.length;
			var w:Array = new Array( 64 );
			
			// loop over all of the blocks
			for ( var i:int = 0; i < len; i += 16 ) {
				
				var a:int = h0;
				var b:int = h1;
				var c:int = h2;
				var d:int = h3;
				var e:int = h4;
				var f:int = h5;
				var g:int = h6;
				var h:int = h7;
				
				for(var t:int = 0; t < 64; t++) {
					
					if ( t < 16 ) {
						w[t] = blocks[ i + t ];
						if(isNaN(w[t])) { w[t] = 0; }
					} else {
						var ws0:int = IntUtil.ror(w[t-15], 7) ^ IntUtil.ror(w[t-15], 18) ^ (w[t-15] >>> 3);
						var ws1:int = IntUtil.ror(w[t-2], 17) ^ IntUtil.ror(w[t-2], 19) ^ (w[t-2] >>> 10);
						w[t] = w[t-16] + ws0 + w[t-7] + ws1;
					}
					
					var s0:int = IntUtil.ror(a, 2) ^ IntUtil.ror(a, 13) ^ IntUtil.ror(a, 22);
					var maj:int = (a & b) ^ (a & c) ^ (b & c);
					var t2:int = s0 + maj;
					var s1:int = IntUtil.ror(e, 6) ^ IntUtil.ror(e, 11) ^ IntUtil.ror(e, 25);
					var ch:int = (e & f) ^ ((~e) & g);
					var t1:int = h + s1 + ch + k[t] + w[t];
					
					h = g;
					g = f;
					f = e;
					e = d + t1;
					d = c;
					c = b;
					b = a;
					a = t1 + t2;
				}
					
				//Add this chunk's hash to result so far:
				h0 += a;
				h1 += b;
				h2 += c;
				h3 += d;
				h4 += e;
				h5 += f;
				h6 += g;
				h7 += h;
			}
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeInt(h0);
			byteArray.writeInt(h1);
			byteArray.writeInt(h2);
			byteArray.writeInt(h3);
			byteArray.writeInt(h4);
			byteArray.writeInt(h5);
			byteArray.writeInt(h6);
			byteArray.writeInt(h7);
			byteArray.position = 0;
			return byteArray;
		}
		
		/**
		 *  Converts a ByteArray to a sequence of 16-word blocks
		 *  that we'll do the processing on.  Appends padding
		 *  and length in the process.
		 *
		 *  @param data		The data to split into blocks
		 *  @return			An array containing the blocks into which data was split
		 */
		private static function createBlocksFromByteArray( data:ByteArray ):Array
		{
			var oldPosition:int = data.position;
			data.position = 0;
			
			var blocks:Array = new Array();
			var len:int = data.length * 8;
			var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
			for( var i:int = 0; i < len; i += 8 )
			{
				blocks[ i >> 5 ] |= ( data.readByte() & mask ) << ( 24 - i % 32 );
			}
			
			// append padding and length
			blocks[ len >> 5 ] |= 0x80 << ( 24 - len % 32 );
			blocks[ ( ( ( len + 64 ) >> 9 ) << 4 ) + 15 ] = len;
			
			data.position = oldPosition;
			
			return blocks;
		}
					
		/**
		 *  Converts a string to a sequence of 16-word blocks
		 *  that we'll do the processing on.  Appends padding
		 *  and length in the process.
		 *
		 *  @param s	The string to split into blocks
		 *  @return		An array containing the blocks that s was split into.
		 */
		private static function createBlocksFromString( s:String ):Array
		{
			var blocks:Array = new Array();
			var len:int = s.length * 8;
			var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
			for( var i:int = 0; i < len; i += 8 ) {
				blocks[ i >> 5 ] |= ( s.charCodeAt( i / 8 ) & mask ) << ( 24 - i % 32 );
			}
			
			// append padding and length
			blocks[ len >> 5 ] |= 0x80 << ( 24 - len % 32 );
			blocks[ ( ( ( len + 64 ) >> 9 ) << 4 ) + 15 ] = len;
			return blocks;
		}
	}
}/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.crypto
{
	//removeMeIfWant mx.formatters.DateFormatter;
	//removeMeIfWant mx.utils.Base64Encoder;
	
	/**
	 * Web Services Security Username Token
	 *
	 * Implementation based on algorithm description at 
	 * http://www.oasis-open.org/committees/wss/documents/WSS-Username-02-0223-merged.pdf
	 */
	public class WSSEUsernameToken
	{
		/**
		 * Generates a WSSE Username Token.
		 *
		 * @param username The username
		 * @param password The password
		 * @param nonce A cryptographically random nonce (if null, the nonce
		 * will be generated)
		 * @param timestamp The time at which the token is generated (if null,
		 * the time will be set to the moment of execution)
		 * @return The generated token
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function getUsernameToken(username:String, password:String, nonce:String=null, timestamp:Date=null):String
		{
			if (nonce == null)
			{
				nonce = generateNonce();
			}
			nonce = base64Encode(nonce);
		
			var created:String = generateTimestamp(timestamp);
		
			var password64:String = getBase64Digest(nonce,
				created,
				password);
		
			var token:String = new String("UsernameToken Username=\"");
			token += username + "\", " +
					 "PasswordDigest=\"" + password64 + "\", " +
					 "Nonce=\"" + nonce + "\", " +
					 "Created=\"" + created + "\"";
			return token;
		}
		
		private static function generateNonce():String
		{
			// Math.random returns a Number between 0 and 1.  We don't want our
			// nonce to contain invalid characters (e.g. the period) so we
			// strip them out before returning the result.
			var s:String =  Math.random().toString();
			return s.replace(".", "");
		}
		
		internal static function base64Encode(s:String):String
		{
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(s);
			return encoder.flush();
		}
		
		internal static function generateTimestamp(timestamp:Date):String
		{
			if (timestamp == null)
			{
				timestamp = new Date();
			}
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DDTJJ:NN:SS"
			return dateFormatter.format(timestamp) + "Z";
		}
		
		internal static function getBase64Digest(nonce:String, created:String, password:String):String
		{
			return SHA1.hashToBase64(nonce + created + password);
		}
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.errors
{
	/**
	* This class represents an Error that is thrown when a method is called when
	* the receiving instance is in an invalid state.
	*
	* For example, this may occur if a method has been called, and other properties
	* in the instance have not been initialized properly.
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class IllegalStateError extends Error
	{
		/**
		*	Constructor
		*
		*	@param message A message describing the error in detail.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public function IllegalStateError(message:String)
		{
			super(message);
		}
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/* AS3JS File */
package com.adobe.images
{
	public class BitString
	{
		public var len:int = 0;
		public var val:int = 0;
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/* AS3JS File */
package com.adobe.images
{
	//removeMeIfWant flash.geom.*;
	//removeMeIfWant flash.display.*;
	//removeMeIfWant flash.utils.*;
	
	/**
	 * Class that converts BitmapData into a valid JPEG
	 */		
	public class JPGEncoder
	{

		// Static table initialization
	
		private var ZigZag:Array = [
			 0, 1, 5, 6,14,15,27,28,
			 2, 4, 7,13,16,26,29,42,
			 3, 8,12,17,25,30,41,43,
			 9,11,18,24,31,40,44,53,
			10,19,23,32,39,45,52,54,
			20,22,33,38,46,51,55,60,
			21,34,37,47,50,56,59,61,
			35,36,48,49,57,58,62,63
		];
	
		private var YTable:Array = new Array(64);
		private var UVTable:Array = new Array(64);
		private var fdtbl_Y:Array = new Array(64);
		private var fdtbl_UV:Array = new Array(64);
	
		private function initQuantTables(sf:int):void
		{
			var i:int;
			var t:Number;
			var YQT:Array = [
				16, 11, 10, 16, 24, 40, 51, 61,
				12, 12, 14, 19, 26, 58, 60, 55,
				14, 13, 16, 24, 40, 57, 69, 56,
				14, 17, 22, 29, 51, 87, 80, 62,
				18, 22, 37, 56, 68,109,103, 77,
				24, 35, 55, 64, 81,104,113, 92,
				49, 64, 78, 87,103,121,120,101,
				72, 92, 95, 98,112,100,103, 99
			];
			for (i = 0; i < 64; i++) {
				t = Math.floor((YQT[i]*sf+50)/100);
				if (t < 1) {
					t = 1;
				} else if (t > 255) {
					t = 255;
				}
				YTable[ZigZag[i]] = t;
			}
			var UVQT:Array = [
				17, 18, 24, 47, 99, 99, 99, 99,
				18, 21, 26, 66, 99, 99, 99, 99,
				24, 26, 56, 99, 99, 99, 99, 99,
				47, 66, 99, 99, 99, 99, 99, 99,
				99, 99, 99, 99, 99, 99, 99, 99,
				99, 99, 99, 99, 99, 99, 99, 99,
				99, 99, 99, 99, 99, 99, 99, 99,
				99, 99, 99, 99, 99, 99, 99, 99
			];
			for (i = 0; i < 64; i++) {
				t = Math.floor((UVQT[i]*sf+50)/100);
				if (t < 1) {
					t = 1;
				} else if (t > 255) {
					t = 255;
				}
				UVTable[ZigZag[i]] = t;
			}
			var aasf:Array = [
				1.0, 1.387039845, 1.306562965, 1.175875602,
				1.0, 0.785694958, 0.541196100, 0.275899379
			];
			i = 0;
			for (var row:int = 0; row < 8; row++)
			{
				for (var col:int = 0; col < 8; col++)
				{
					fdtbl_Y[i]  = (1.0 / (YTable [ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
					fdtbl_UV[i] = (1.0 / (UVTable[ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
					i++;
				}
			}
		}
	
		private var YDC_HT:Array;
		private var UVDC_HT:Array;
		private var YAC_HT:Array;
		private var UVAC_HT:Array;
	
		private function computeHuffmanTbl(nrcodes:Array, std_table:Array):Array
		{
			var codevalue:int = 0;
			var pos_in_table:int = 0;
			var HT:Array = new Array();
			for (var k:int=1; k<=16; k++) {
				for (var j:int=1; j<=nrcodes[k]; j++) {
					HT[std_table[pos_in_table]] = new BitString();
					HT[std_table[pos_in_table]].val = codevalue;
					HT[std_table[pos_in_table]].len = k;
					pos_in_table++;
					codevalue++;
				}
				codevalue*=2;
			}
			return HT;
		}
	
		private var std_dc_luminance_nrcodes:Array = [0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0];
		private var std_dc_luminance_values:Array = [0,1,2,3,4,5,6,7,8,9,10,11];
		private var std_ac_luminance_nrcodes:Array = [0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,0x7d];
		private var std_ac_luminance_values:Array = [
			0x01,0x02,0x03,0x00,0x04,0x11,0x05,0x12,
			0x21,0x31,0x41,0x06,0x13,0x51,0x61,0x07,
			0x22,0x71,0x14,0x32,0x81,0x91,0xa1,0x08,
			0x23,0x42,0xb1,0xc1,0x15,0x52,0xd1,0xf0,
			0x24,0x33,0x62,0x72,0x82,0x09,0x0a,0x16,
			0x17,0x18,0x19,0x1a,0x25,0x26,0x27,0x28,
			0x29,0x2a,0x34,0x35,0x36,0x37,0x38,0x39,
			0x3a,0x43,0x44,0x45,0x46,0x47,0x48,0x49,
			0x4a,0x53,0x54,0x55,0x56,0x57,0x58,0x59,
			0x5a,0x63,0x64,0x65,0x66,0x67,0x68,0x69,
			0x6a,0x73,0x74,0x75,0x76,0x77,0x78,0x79,
			0x7a,0x83,0x84,0x85,0x86,0x87,0x88,0x89,
			0x8a,0x92,0x93,0x94,0x95,0x96,0x97,0x98,
			0x99,0x9a,0xa2,0xa3,0xa4,0xa5,0xa6,0xa7,
			0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,0xb5,0xb6,
			0xb7,0xb8,0xb9,0xba,0xc2,0xc3,0xc4,0xc5,
			0xc6,0xc7,0xc8,0xc9,0xca,0xd2,0xd3,0xd4,
			0xd5,0xd6,0xd7,0xd8,0xd9,0xda,0xe1,0xe2,
			0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,
			0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
			0xf9,0xfa
		];
	
		private var std_dc_chrominance_nrcodes:Array = [0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
		private var std_dc_chrominance_values:Array = [0,1,2,3,4,5,6,7,8,9,10,11];
		private var std_ac_chrominance_nrcodes:Array = [0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,0x77];
		private var std_ac_chrominance_values:Array = [
			0x00,0x01,0x02,0x03,0x11,0x04,0x05,0x21,
			0x31,0x06,0x12,0x41,0x51,0x07,0x61,0x71,
			0x13,0x22,0x32,0x81,0x08,0x14,0x42,0x91,
			0xa1,0xb1,0xc1,0x09,0x23,0x33,0x52,0xf0,
			0x15,0x62,0x72,0xd1,0x0a,0x16,0x24,0x34,
			0xe1,0x25,0xf1,0x17,0x18,0x19,0x1a,0x26,
			0x27,0x28,0x29,0x2a,0x35,0x36,0x37,0x38,
			0x39,0x3a,0x43,0x44,0x45,0x46,0x47,0x48,
			0x49,0x4a,0x53,0x54,0x55,0x56,0x57,0x58,
			0x59,0x5a,0x63,0x64,0x65,0x66,0x67,0x68,
			0x69,0x6a,0x73,0x74,0x75,0x76,0x77,0x78,
			0x79,0x7a,0x82,0x83,0x84,0x85,0x86,0x87,
			0x88,0x89,0x8a,0x92,0x93,0x94,0x95,0x96,
			0x97,0x98,0x99,0x9a,0xa2,0xa3,0xa4,0xa5,
			0xa6,0xa7,0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,
			0xb5,0xb6,0xb7,0xb8,0xb9,0xba,0xc2,0xc3,
			0xc4,0xc5,0xc6,0xc7,0xc8,0xc9,0xca,0xd2,
			0xd3,0xd4,0xd5,0xd6,0xd7,0xd8,0xd9,0xda,
			0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,
			0xea,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
			0xf9,0xfa
		];
	
		private function initHuffmanTbl():void
		{
			YDC_HT = computeHuffmanTbl(std_dc_luminance_nrcodes,std_dc_luminance_values);
			UVDC_HT = computeHuffmanTbl(std_dc_chrominance_nrcodes,std_dc_chrominance_values);
			YAC_HT = computeHuffmanTbl(std_ac_luminance_nrcodes,std_ac_luminance_values);
			UVAC_HT = computeHuffmanTbl(std_ac_chrominance_nrcodes,std_ac_chrominance_values);
		}
	
		private var bitcode:Array = new Array(65535);
		private var category:Array = new Array(65535);
	
		private function initCategoryNumber():void
		{
			var nrlower:int = 1;
			var nrupper:int = 2;
			var nr:int;
			for (var cat:int=1; cat<=15; cat++) {
				//Positive numbers
				for (nr=nrlower; nr<nrupper; nr++) {
					category[32767+nr] = cat;
					bitcode[32767+nr] = new BitString();
					bitcode[32767+nr].len = cat;
					bitcode[32767+nr].val = nr;
				}
				//Negative numbers
				for (nr=-(nrupper-1); nr<=-nrlower; nr++) {
					category[32767+nr] = cat;
					bitcode[32767+nr] = new BitString();
					bitcode[32767+nr].len = cat;
					bitcode[32767+nr].val = nrupper-1+nr;
				}
				nrlower <<= 1;
				nrupper <<= 1;
			}
		}
	
		// IO functions
	
		private var byteout:ByteArray;
		private var bytenew:int = 0;
		private var bytepos:int = 7;
	
		private function writeBits(bs:BitString):void
		{
			var value:int = bs.val;
			var posval:int = bs.len-1;
			while ( posval >= 0 ) {
				if (value & uint(1 << posval) ) {
					bytenew |= uint(1 << bytepos);
				}
				posval--;
				bytepos--;
				if (bytepos < 0) {
					if (bytenew == 0xFF) {
						writeByte(0xFF);
						writeByte(0);
					}
					else {
						writeByte(bytenew);
					}
					bytepos=7;
					bytenew=0;
				}
			}
		}
	
		private function writeByte(value:int):void
		{
			byteout.writeByte(value);
		}
	
		private function writeWord(value:int):void
		{
			writeByte((value>>8)&0xFF);
			writeByte((value   )&0xFF);
		}
	
		// DCT & quantization core
	
		private function fDCTQuant(data:Array, fdtbl:Array):Array
		{
			var tmp0:Number, tmp1:Number, tmp2:Number, tmp3:Number, tmp4:Number, tmp5:Number, tmp6:Number, tmp7:Number;
			var tmp10:Number, tmp11:Number, tmp12:Number, tmp13:Number;
			var z1:Number, z2:Number, z3:Number, z4:Number, z5:Number, z11:Number, z13:Number;
			var i:int;
			/* Pass 1: process rows. */
			var dataOff:int=0;
			for (i=0; i<8; i++) {
				tmp0 = data[dataOff+0] + data[dataOff+7];
				tmp7 = data[dataOff+0] - data[dataOff+7];
				tmp1 = data[dataOff+1] + data[dataOff+6];
				tmp6 = data[dataOff+1] - data[dataOff+6];
				tmp2 = data[dataOff+2] + data[dataOff+5];
				tmp5 = data[dataOff+2] - data[dataOff+5];
				tmp3 = data[dataOff+3] + data[dataOff+4];
				tmp4 = data[dataOff+3] - data[dataOff+4];
	
				/* Even part */
				tmp10 = tmp0 + tmp3;	/* phase 2 */
				tmp13 = tmp0 - tmp3;
				tmp11 = tmp1 + tmp2;
				tmp12 = tmp1 - tmp2;
	
				data[dataOff+0] = tmp10 + tmp11; /* phase 3 */
				data[dataOff+4] = tmp10 - tmp11;
	
				z1 = (tmp12 + tmp13) * 0.707106781; /* c4 */
				data[dataOff+2] = tmp13 + z1; /* phase 5 */
				data[dataOff+6] = tmp13 - z1;
	
				/* Odd part */
				tmp10 = tmp4 + tmp5; /* phase 2 */
				tmp11 = tmp5 + tmp6;
				tmp12 = tmp6 + tmp7;
	
				/* The rotator is modified from fig 4-8 to avoid extra negations. */
				z5 = (tmp10 - tmp12) * 0.382683433; /* c6 */
				z2 = 0.541196100 * tmp10 + z5; /* c2-c6 */
				z4 = 1.306562965 * tmp12 + z5; /* c2+c6 */
				z3 = tmp11 * 0.707106781; /* c4 */
	
				z11 = tmp7 + z3;	/* phase 5 */
				z13 = tmp7 - z3;
	
				data[dataOff+5] = z13 + z2;	/* phase 6 */
				data[dataOff+3] = z13 - z2;
				data[dataOff+1] = z11 + z4;
				data[dataOff+7] = z11 - z4;
	
				dataOff += 8; /* advance pointer to next row */
			}
	
			/* Pass 2: process columns. */
			dataOff = 0;
			for (i=0; i<8; i++) {
				tmp0 = data[dataOff+ 0] + data[dataOff+56];
				tmp7 = data[dataOff+ 0] - data[dataOff+56];
				tmp1 = data[dataOff+ 8] + data[dataOff+48];
				tmp6 = data[dataOff+ 8] - data[dataOff+48];
				tmp2 = data[dataOff+16] + data[dataOff+40];
				tmp5 = data[dataOff+16] - data[dataOff+40];
				tmp3 = data[dataOff+24] + data[dataOff+32];
				tmp4 = data[dataOff+24] - data[dataOff+32];
	
				/* Even part */
				tmp10 = tmp0 + tmp3;	/* phase 2 */
				tmp13 = tmp0 - tmp3;
				tmp11 = tmp1 + tmp2;
				tmp12 = tmp1 - tmp2;
	
				data[dataOff+ 0] = tmp10 + tmp11; /* phase 3 */
				data[dataOff+32] = tmp10 - tmp11;
	
				z1 = (tmp12 + tmp13) * 0.707106781; /* c4 */
				data[dataOff+16] = tmp13 + z1; /* phase 5 */
				data[dataOff+48] = tmp13 - z1;
	
				/* Odd part */
				tmp10 = tmp4 + tmp5; /* phase 2 */
				tmp11 = tmp5 + tmp6;
				tmp12 = tmp6 + tmp7;
	
				/* The rotator is modified from fig 4-8 to avoid extra negations. */
				z5 = (tmp10 - tmp12) * 0.382683433; /* c6 */
				z2 = 0.541196100 * tmp10 + z5; /* c2-c6 */
				z4 = 1.306562965 * tmp12 + z5; /* c2+c6 */
				z3 = tmp11 * 0.707106781; /* c4 */
	
				z11 = tmp7 + z3;	/* phase 5 */
				z13 = tmp7 - z3;
	
				data[dataOff+40] = z13 + z2; /* phase 6 */
				data[dataOff+24] = z13 - z2;
				data[dataOff+ 8] = z11 + z4;
				data[dataOff+56] = z11 - z4;
	
				dataOff++; /* advance pointer to next column */
			}
	
			// Quantize/descale the coefficients
			for (i=0; i<64; i++) {
				// Apply the quantization and scaling factor & Round to nearest integer
				data[i] = Math.round((data[i]*fdtbl[i]));
			}
			return data;
		}
	
		// Chunk writing
	
		private function writeAPP0():void
		{
			writeWord(0xFFE0); // marker
			writeWord(16); // length
			writeByte(0x4A); // J
			writeByte(0x46); // F
			writeByte(0x49); // I
			writeByte(0x46); // F
			writeByte(0); // = "JFIF",'\0'
			writeByte(1); // versionhi
			writeByte(1); // versionlo
			writeByte(0); // xyunits
			writeWord(1); // xdensity
			writeWord(1); // ydensity
			writeByte(0); // thumbnwidth
			writeByte(0); // thumbnheight
		}
	
		private function writeSOF0(width:int, height:int):void
		{
			writeWord(0xFFC0); // marker
			writeWord(17);   // length, truecolor YUV JPG
			writeByte(8);    // precision
			writeWord(height);
			writeWord(width);
			writeByte(3);    // nrofcomponents
			writeByte(1);    // IdY
			writeByte(0x11); // HVY
			writeByte(0);    // QTY
			writeByte(2);    // IdU
			writeByte(0x11); // HVU
			writeByte(1);    // QTU
			writeByte(3);    // IdV
			writeByte(0x11); // HVV
			writeByte(1);    // QTV
		}
	
		private function writeDQT():void
		{
			writeWord(0xFFDB); // marker
			writeWord(132);	   // length
			writeByte(0);
			var i:int;
			for (i=0; i<64; i++) {
				writeByte(YTable[i]);
			}
			writeByte(1);
			for (i=0; i<64; i++) {
				writeByte(UVTable[i]);
			}
		}
	
		private function writeDHT():void
		{
			writeWord(0xFFC4); // marker
			writeWord(0x01A2); // length
			var i:int;
	
			writeByte(0); // HTYDCinfo
			for (i=0; i<16; i++) {
				writeByte(std_dc_luminance_nrcodes[i+1]);
			}
			for (i=0; i<=11; i++) {
				writeByte(std_dc_luminance_values[i]);
			}
	
			writeByte(0x10); // HTYACinfo
			for (i=0; i<16; i++) {
				writeByte(std_ac_luminance_nrcodes[i+1]);
			}
			for (i=0; i<=161; i++) {
				writeByte(std_ac_luminance_values[i]);
			}
	
			writeByte(1); // HTUDCinfo
			for (i=0; i<16; i++) {
				writeByte(std_dc_chrominance_nrcodes[i+1]);
			}
			for (i=0; i<=11; i++) {
				writeByte(std_dc_chrominance_values[i]);
			}
	
			writeByte(0x11); // HTUACinfo
			for (i=0; i<16; i++) {
				writeByte(std_ac_chrominance_nrcodes[i+1]);
			}
			for (i=0; i<=161; i++) {
				writeByte(std_ac_chrominance_values[i]);
			}
		}
	
		private function writeSOS():void
		{
			writeWord(0xFFDA); // marker
			writeWord(12); // length
			writeByte(3); // nrofcomponents
			writeByte(1); // IdY
			writeByte(0); // HTY
			writeByte(2); // IdU
			writeByte(0x11); // HTU
			writeByte(3); // IdV
			writeByte(0x11); // HTV
			writeByte(0); // Ss
			writeByte(0x3f); // Se
			writeByte(0); // Bf
		}
	
		// Core processing
		private var DU:Array = new Array(64);
	
		private function processDU(CDU:Array, fdtbl:Array, DC:Number, HTDC:Array, HTAC:Array):Number
		{
			var EOB:BitString = HTAC[0x00];
			var M16zeroes:BitString = HTAC[0xF0];
			var i:int;
	
			var DU_DCT:Array = fDCTQuant(CDU, fdtbl);
			//ZigZag reorder
			for (i=0;i<64;i++) {
				DU[ZigZag[i]]=DU_DCT[i];
			}
			var Diff:int = DU[0] - DC; DC = DU[0];
			//Encode DC
			if (Diff==0) {
				writeBits(HTDC[0]); // Diff might be 0
			} else {
				writeBits(HTDC[category[32767+Diff]]);
				writeBits(bitcode[32767+Diff]);
			}
			//Encode ACs
			var end0pos:int = 63;
			for (; (end0pos>0)&&(DU[end0pos]==0); end0pos--) {
			};
			//end0pos = first element in reverse order !=0
			if ( end0pos == 0) {
				writeBits(EOB);
				return DC;
			}
			i = 1;
			while ( i <= end0pos ) {
				var startpos:int = i;
				for (; (DU[i]==0) && (i<=end0pos); i++) {
				}
				var nrzeroes:int = i-startpos;
				if ( nrzeroes >= 16 ) {
					for (var nrmarker:int=1; nrmarker <= nrzeroes/16; nrmarker++) {
						writeBits(M16zeroes);
					}
					nrzeroes = int(nrzeroes&0xF);
				}
				writeBits(HTAC[nrzeroes*16+category[32767+DU[i]]]);
				writeBits(bitcode[32767+DU[i]]);
				i++;
			}
			if ( end0pos != 63 ) {
				writeBits(EOB);
			}
			return DC;
		}
	
		private var YDU:Array = new Array(64);
		private var UDU:Array = new Array(64);
		private var VDU:Array = new Array(64);
	
		private function RGB2YUV(img:BitmapData, xpos:int, ypos:int):void
		{
			var pos:int=0;
			for (var y:int=0; y<8; y++) {
				for (var x:int=0; x<8; x++) {
					var P:uint = img.getPixel32(xpos+x,ypos+y);
					var R:Number = Number((P>>16)&0xFF);
					var G:Number = Number((P>> 8)&0xFF);
					var B:Number = Number((P    )&0xFF);
					YDU[pos]=((( 0.29900)*R+( 0.58700)*G+( 0.11400)*B))-128;
					UDU[pos]=(((-0.16874)*R+(-0.33126)*G+( 0.50000)*B));
					VDU[pos]=((( 0.50000)*R+(-0.41869)*G+(-0.08131)*B));
					pos++;
				}
			}
		}
	
		/**
		 * Constructor for JPEGEncoder class
		 *
		 * @param quality The quality level between 1 and 100 that detrmines the
		 * level of compression used in the generated JPEG
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */		
		public function JPGEncoder(quality:Number = 50)
		{
			if (quality <= 0) {
				quality = 1;
			}
			if (quality > 100) {
				quality = 100;
			}
			var sf:int = 0;
			if (quality < 50) {
				sf = int(5000 / quality);
			} else {
				sf = int(200 - quality*2);
			}
			// Create tables
			initHuffmanTbl();
			initCategoryNumber();
			initQuantTables(sf);
		}
	
		/**
		 * Created a JPEG image from the specified BitmapData
		 *
		 * @param image The BitmapData that will be converted into the JPEG format.
		 * @return a ByteArray representing the JPEG encoded image data.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */	
		public function encode(image:BitmapData):ByteArray
		{
			// Initialize bit writer
			byteout = new ByteArray();
			bytenew=0;
			bytepos=7;
	
			// Add JPEG headers
			writeWord(0xFFD8); // SOI
			writeAPP0();
			writeDQT();
			writeSOF0(image.width,image.height);
			writeDHT();
			writeSOS();

	
			// Encode 8x8 macroblocks
			var DCY:Number=0;
			var DCU:Number=0;
			var DCV:Number=0;
			bytenew=0;
			bytepos=7;
			for (var ypos:int=0; ypos<image.height; ypos+=8) {
				for (var xpos:int=0; xpos<image.width; xpos+=8) {
					RGB2YUV(image, xpos, ypos);
					DCY = processDU(YDU, fdtbl_Y, DCY, YDC_HT, YAC_HT);
					DCU = processDU(UDU, fdtbl_UV, DCU, UVDC_HT, UVAC_HT);
					DCV = processDU(VDU, fdtbl_UV, DCV, UVDC_HT, UVAC_HT);
				}
			}
	
			// Do the bit alignment of the EOI marker
			if ( bytepos >= 0 ) {
				var fillbits:BitString = new BitString();
				fillbits.len = bytepos+1;
				fillbits.val = (1<<(bytepos+1))-1;
				writeBits(fillbits);
			}
	
			writeWord(0xFFD9); //EOI
			return byteout;
		}
	}
}
/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/* AS3JS File */
package com.adobe.images
{
	//removeMeIfWant flash.geom.*;
	//removeMeIfWant flash.display.Bitmap;
	//removeMeIfWant flash.display.BitmapData;
	//removeMeIfWant flash.utils.ByteArray;

	/**
	 * Class that converts BitmapData into a valid PNG
	 */	
	public class PNGEncoder
	{
		/**
		 * Created a PNG image from the specified BitmapData
		 *
		 * @param image The BitmapData that will be converted into the PNG format.
		 * @return a ByteArray representing the PNG encoded image data.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */			
	    public static function encode(img:BitmapData):ByteArray {
	        // Create output byte array
	        var png:ByteArray = new ByteArray();
	        // Write PNG signature
	        png.writeUnsignedInt(0x89504e47);
	        png.writeUnsignedInt(0x0D0A1A0A);
	        // Build IHDR chunk
	        var IHDR:ByteArray = new ByteArray();
	        IHDR.writeInt(img.width);
	        IHDR.writeInt(img.height);
	        IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
	        IHDR.writeByte(0);
	        writeChunk(png,0x49484452,IHDR);
	        // Build IDAT chunk
	        var IDAT:ByteArray= new ByteArray();
	        for(var i:int=0;i < img.height;i++) {
	            // no filter
	            IDAT.writeByte(0);
	            var p:uint;
	            var j:int;
	            if ( !img.transparent ) {
	                for(j=0;j < img.width;j++) {
	                    p = img.getPixel(j,i);
	                    IDAT.writeUnsignedInt(
	                        uint(((p&0xFFFFFF) << 8)|0xFF));
	                }
	            } else {
	                for(j=0;j < img.width;j++) {
	                    p = img.getPixel32(j,i);
	                    IDAT.writeUnsignedInt(
	                        uint(((p&0xFFFFFF) << 8)|
	                        (p>>>24)));
	                }
	            }
	        }
	        IDAT.compress();
	        writeChunk(png,0x49444154,IDAT);
	        // Build IEND chunk
	        writeChunk(png,0x49454E44,null);
	        // return PNG
	        return png;
	    }
	
	    private static var crcTable:Array;
	    private static var crcTableComputed:Boolean = false;
	
	    private static function writeChunk(png:ByteArray, 
	            type:uint, data:ByteArray):void {
	        if (!crcTableComputed) {
	            crcTableComputed = true;
	            crcTable = [];
	            var c:uint;
	            for (var n:uint = 0; n < 256; n++) {
	                c = n;
	                for (var k:uint = 0; k < 8; k++) {
	                    if (c & 1) {
	                        c = uint(uint(0xedb88320) ^ 
	                            uint(c >>> 1));
	                    } else {
	                        c = uint(c >>> 1);
	                    }
	                }
	                crcTable[n] = c;
	            }
	        }
	        var len:uint = 0;
	        if (data != null) {
	            len = data.length;
	        }
	        png.writeUnsignedInt(len);
	        var p:uint = png.position;
	        png.writeUnsignedInt(type);
	        if ( data != null ) {
	            png.writeBytes(data);
	        }
	        var e:uint = png.position;
	        png.position = p;
	        c = 0xffffffff;
	        for (var i:int = 0; i < (e-p); i++) {
	            c = uint(crcTable[
	                (c ^ png.readUnsignedByte()) & 
	                uint(0xff)] ^ uint(c >>> 8));
	        }
	        c = uint(c^uint(0xffffffff));
	        png.position = e;
	        png.writeUnsignedInt(c);
	    }
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.net
{
	//removeMeIfWant flash.net.URLLoader;

	/**
	* 	Class that provides a dynamic implimentation of the URLLoader class.
	* 
	* 	This class provides no API implimentations. However, since the class is
	* 	declared as dynamic, it can be used in place of URLLoader, and allow
	* 	you to dynamically attach properties to it (which URLLoader does not allow).
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/	
	public dynamic class DynamicURLLoader extends URLLoader 
	{
		public function DynamicURLLoader()
		{
			super();
		}
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.net
{
	/**
	 * The URI class cannot know about DNS aliases, virtual hosts, or
	 * symbolic links that may be involved.  The application can provide
	 * an implementation of this interface to resolve the URI before the
	 * URI class makes any comparisons.  For example, a web host has
	 * two aliases:
	 * 
	 * <p><code>
	 *    http://www.site.com/
	 *    http://www.site.net/
	 * </code></p>
	 * 
	 * <p>The application can provide an implementation that automatically
	 * resolves site.net to site.com before URI compares two URI objects.
	 * Only the application can know and understand the context in which
	 * the URI's are being used.</p>
	 * 
	 * <p>Use the URI.resolver accessor to assign a custom resolver to
	 * the URI class.  Any resolver specified is global to all instances
	 * of URI.</p>
	 * 
	 * <p>URI will call this before performing URI comparisons in the
	 * URI.getRelation() and URI.getCommonParent() functions.
	 * 
	 * @see URI.getRelation
	 * @see URI.getCommonParent
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	public interface IURIResolver
	{
		/**
		 * Implement this method to provide custom URI resolution for
		 * your application.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		function resolve(uri:URI) : URI;
	}
}/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.net
{
	//removeMeIfWant flash.utils.ByteArray;
	
	/**
	 * This class implements functions and utilities for working with URI's
	 * (Universal Resource Identifiers).  For technical description of the
	 * URI syntax, please see RFC 3986 at http://www.ietf.org/rfc/rfc3986.txt
	 * or do a web search for "rfc 3986".
	 * 
	 * <p>The most //removeMeIfWantant aspect of URI's to understand is that URI's
	 * and URL's are not strings.  URI's are complex data structures that
	 * encapsulate many pieces of information.  The string version of a
	 * URI is the serialized representation of that data structure.  This
	 * string serialization is used to provide a human readable
	 * representation and a means to transport the data over the network
	 * where it can then be parsed back into its' component parts.</p>
	 * 
	 * <p>URI's fall into one of three categories:
	 * <ul>
	 *  <li>&lt;scheme&gt;:&lt;scheme-specific-part&gt;#&lt;fragment&gt;		(non-hierarchical)</li>
	 *  <li>&lt;scheme&gt;:<authority&gt;&lt;path&gt;?&lt;query&gt;#&lt;fragment&gt;	(hierarchical)</li>
	 *  <li>&lt;path&gt;?&lt;query&gt;#&lt;fragment&gt;						(relative hierarchical)</li>
	 * </ul></p>
	 * 
	 * <p>The query and fragment parts are optional.</p>
	 * 
	 * <p>This class supports both non-hierarchical and hierarchical URI's</p>
	 * 
	 * <p>This class is intended to be used "as-is" for the vast majority
	 * of common URI's.  However, if your application requires a custom
	 * URI syntax (e.g. custom query syntax or special handling of
	 * non-hierarchical URI's), this class can be fully subclassed.  If you
	 * intended to subclass URI, please see the source code for complete
	 * documation on protected members and protected fuctions.</p>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0 
	 */
	public class URI
	{	
		// Here we define which characters must be escaped for each
		// URI part.  The characters that must be escaped for each
		// part differ depending on what would cause ambiguous parsing.
		// RFC 3986 sec. 2.4 states that characters should only be
		// encoded when they would conflict with subcomponent delimiters.
		// We don't want to over-do the escaping.  We only want to escape
		// the minimum needed to prevent parsing problems.
		
		// space and % must be escaped in all cases.  '%' is the delimiter
		// for escaped characters.
		public static const URImustEscape:String =	" %";
		
		// Baseline of what characters must be escaped
		public static const URIbaselineEscape:String = URImustEscape + ":?#/@";
		
		// Characters that must be escaped in the part part.
		public static const URIpathEscape:String = URImustEscape + "?#";
		
		// Characters that must be escaped in the query part, if setting
		// the query as a whole string.  If the query is set by
		// name/value, URIqueryPartEscape is used instead.
		public static const URIqueryEscape:String = URImustEscape + "#";
		
		// This is what each name/value pair must escape "&=" as well
		// so they don't conflict with the "param=value&param2=value2"
		// syntax.
		public static const URIqueryPartEscape:String = URImustEscape + "#&=";
		
		// Non-hierarchical URI's can have query and fragment parts, but
		// we also want to prevent '/' otherwise it might end up looking
		// like a hierarchical URI to the parser.
		public static const URInonHierEscape:String = 	URImustEscape + "?#/";
		
		// Baseline uninitialized setting for the URI scheme.
		public static const UNKNOWN_SCHEME:String = "unknown";
		
		// The following bitmaps are used for performance enhanced
		// character escaping.
		
		// Baseline characters that need to be escaped.  Many parts use
		// this.
		protected static const URIbaselineExcludedBitmap:URIEncodingBitmap =
			new URIEncodingBitmap(URIbaselineEscape);
		
		// Scheme escaping bitmap
		protected static const URIschemeExcludedBitmap:URIEncodingBitmap = 
			URIbaselineExcludedBitmap;
		
		// User/pass escaping bitmap
		protected static const URIuserpassExcludedBitmap:URIEncodingBitmap =
			URIbaselineExcludedBitmap;
		
		// Authority escaping bitmap
		protected static const URIauthorityExcludedBitmap:URIEncodingBitmap =
			URIbaselineExcludedBitmap;
			
		// Port escaping bitmap
		protected static const URIportExludedBitmap:URIEncodingBitmap = 
			URIbaselineExcludedBitmap;
		
		// Path escaping bitmap
		protected static const URIpathExcludedBitmap:URIEncodingBitmap =
		 	new URIEncodingBitmap(URIpathEscape);
			
		// Query (whole) escaping bitmap
		protected static const URIqueryExcludedBitmap:URIEncodingBitmap =
			new URIEncodingBitmap(URIqueryEscape);
			
		// Query (individual parts) escaping bitmap
		protected static const URIqueryPartExcludedBitmap:URIEncodingBitmap =
			new URIEncodingBitmap(URIqueryPartEscape);
			
		// Fragments are the last part in the URI.  They only need to
		// escape space, '#', and '%'.  Turns out that is what query
		// uses too.
		protected static const URIfragmentExcludedBitmap:URIEncodingBitmap =
			URIqueryExcludedBitmap;
			
		// Characters that need to be escaped in the non-hierarchical part
		protected static const URInonHierexcludedBitmap:URIEncodingBitmap =
			new URIEncodingBitmap(URInonHierEscape);
			
		// Values used by getRelation()
		public static const NOT_RELATED:int = 0;
		public static const CHILD:int = 1;
		public static const EQUAL:int = 2;
		public static const PARENT:int = 3;

		//-------------------------------------------------------------------
		// protected class members
		//-------------------------------------------------------------------
		protected var _valid:Boolean = false;
		protected var _relative:Boolean = false;
		protected var _scheme:String = "";
		protected var _authority:String = "";
		protected var _username:String = "";
		protected var _password:String = "";
		protected var _port:String = "";
		protected var _path:String = "";
		protected var _query:String = "";
		protected var _fragment:String = "";
		protected var _nonHierarchical:String = "";
		protected static var _resolver:IURIResolver = null;


		/**
		 *  URI Constructor.  If no string is given, this will initialize
		 *  this URI object to a blank URI.
		 */
		public function URI(uri:String = null) : void	
		{
			if (uri == null)
				initialize();
			else
				constructURI(uri);
		}

		
		/**
		 * @private
		 * Method that loads the URI from the given string.
		 */
		protected function constructURI(uri:String) : Boolean
		{
			if (!parseURI(uri))
				_valid = false;
				
			return isValid();
		}
		
		
		/**
		 * @private Private initializiation.
		 */
		protected function initialize() : void
		{
			_valid = false;
			_relative = false;
		
			_scheme = UNKNOWN_SCHEME;
			_authority = "";
			_username = "";
			_password = "";
			_port = "";
			_path = "";
			_query = "";
			_fragment = "";
		
			_nonHierarchical = "";
		}	
		
		/**
		 * @private Accessor to explicitly set/get the hierarchical
		 * state of the URI.
		 */
		protected function set hierState(state:Boolean) : void
		{
			if (state)
			{
				// Clear the non-hierarchical data
				_nonHierarchical = "";
		
				// Also set the state vars while we are at it
				if (_scheme == "" || _scheme == UNKNOWN_SCHEME)
					_relative = true;
				else
					_relative = false;
		
				if (_authority.length == 0 && _path.length == 0)
					_valid = false;
				else
					_valid = true;
			}
			else
			{
				// Clear the hierarchical data
				_authority = "";
				_username = "";
				_password = "";
				_port = "";
				_path = "";
		
				_relative = false;
		
				if (_scheme == "" || _scheme == UNKNOWN_SCHEME)
					_valid = false;
				else
					_valid = true;
			}
		}
		protected function get hierState() : Boolean
		{
			return (_nonHierarchical.length == 0);
		}
		
		
		/**
		 * @private Functions that performs some basic consistency validation.
		 */
		protected function validateURI() : Boolean
		{
			// Check the scheme
			if (isAbsolute())
			{
				if (_scheme.length <= 1 || _scheme == UNKNOWN_SCHEME)
				{
					// we probably parsed a C:\ type path or no scheme
					return false;
				}
				else if (verifyAlpha(_scheme) == false)
					return false;  // Scheme contains bad characters
			}
			
			if (hierState)
			{
				if (_path.search('\\') != -1)
					return false;  // local path
				else if (isRelative() == false && _scheme == UNKNOWN_SCHEME)
					return false;  // It's an absolute URI, but it has a bad scheme
			}
			else
			{
				if (_nonHierarchical.search('\\') != -1)
					return false;  // some kind of local path
			}
		
			// Looks like it's ok.
			return true;
		}
		
		
		/**
		 * @private
		 *
		 * Given a URI in string format, parse that sucker into its basic
		 * components and assign them to this object.  A URI is of the form:
		 *    <scheme>:<authority><path>?<query>#<fragment>
		 *
		 * For simplicity, we parse the URI in the following order:
		 * 		
		 *		1. Fragment (anchors)
		 * 		2. Query	(CGI stuff)
		 * 		3. Scheme	("http")
		 * 		4. Authority (host name)
		 * 		5. Username/Password (if any)
		 * 		6. Port		(server port if any)
		 *		7. Path		(/homepages/mypage.html)
		 *
		 * The reason for this order is to minimize any parsing ambiguities.
		 * Fragments and queries can contain almost anything (they are parts
		 * that can contain custom data with their own syntax).  Parsing
		 * them out first removes a large chance of parsing errors.  This
		 * method expects well formed URI's, but performing the parse in
		 * this order makes us a little more tolerant of user error.
		 * 
		 * REGEXP
		 * Why doesn't this use regular expressions to parse the URI?  We
		 * have found that in a real world scenario, URI's are not always
		 * well formed.  Sometimes characters that should have been escaped
		 * are not, and those situations would break a regexp pattern.  This
		 * function attempts to be smart about what it is parsing based on
		 * location of characters relative to eachother.  This function has
		 * been proven through real-world use to parse the vast majority
		 * of URI's correctly.
		 *
		 * NOTE
		 * It is assumed that the string in URI form is escaped.  This function
		 * does not escape anything.  If you constructed the URI string by
		 * hand, and used this to parse in the URI and still need it escaped,
		 * call forceEscape() on your URI object.
		 *
		 * Parsing Assumptions
		 * This routine assumes that the URI being passed is well formed.
		 * Passing things like local paths, malformed URI's, and the such
		 * will result in parsing errors.  This function can handle
		 * 	 - absolute hierarchical (e.g. "http://something.com/index.html),
		 *   - relative hierarchical (e.g. "../images/flower.gif"), or
		 *   - non-hierarchical URIs (e.g. "mailto:jsmith@fungoo.com").
		 * 
		 * Anything else will probably result in a parsing error, or a bogus
		 * URI object.
		 * 
		 * Note that non-hierarchical URIs *MUST* have a scheme, otherwise
		 * they will be mistaken for relative URI's.
		 * 
		 * If you are not sure what is being passed to you (like manually
		 * entered text from UI), you can construct a blank URI object and
		 * call unknownToURI() passing in the unknown string.
		 * 
		 * @return	true if successful, false if there was some kind of
		 * parsing error
		 */
		protected function parseURI(uri:String) : Boolean
		{
			var baseURI:String = uri;
			var index:int, index2:int;
		
			// Make sure this object is clean before we start.  If it was used
			// before and we are now parsing a new URI, we don't want any stale
			// info lying around.
			initialize();
		
			// Remove any fragments (anchors) from the URI
			index = baseURI.indexOf("#");
			if (index != -1)
			{
				// Store the fragment piece if any
				if (baseURI.length > (index + 1)) // +1 is to skip the '#'
					_fragment = baseURI.substr(index + 1, baseURI.length - (index + 1)); 
		
				// Trim off the fragment
				baseURI = baseURI.substr(0, index);
			}
		
			// We need to strip off any CGI parameters (eg '?param=bob')
			index = baseURI.indexOf("?");
			if (index != -1)
			{
				if (baseURI.length > (index + 1))
					_query = baseURI.substr(index + 1, baseURI.length - (index + 1)); // +1 is to skip the '?'
		
				// Trim off the query
				baseURI = baseURI.substr(0, index);
			}
		
			// Now try to find the scheme part
			index = baseURI.search(':');
			index2 = baseURI.search('/');
		
			var containsColon:Boolean = (index != -1);
			var containsSlash:Boolean = (index2 != -1);
		
			// This value is indeterminate if "containsColon" is false.
			// (if there is no colon, does the slash come before or
			// after said non-existing colon?)
			var colonBeforeSlash:Boolean = (!containsSlash || index < index2);
		
			// If it has a colon and it's before the first slash, we will treat
			// it as a scheme.  If a slash is before a colon, there must be a
			// stray colon in a path or something.  In which case, the colon is
			// not the separator for the scheme.  Technically, we could consider
			// this an error, but since this is not an ambiguous state (we know
			// 100% that this has no scheme), we will keep going.
			if (containsColon && colonBeforeSlash)
			{
				// We found a scheme
				_scheme = baseURI.substr(0, index);
				
				// Normalize the scheme
				_scheme = _scheme.toLowerCase();
		
				baseURI = baseURI.substr(index + 1);
		
				if (baseURI.substr(0, 2) == "//")
				{
					// This is a hierarchical URI
					_nonHierarchical = "";
		
					// Trim off the "//"
					baseURI = baseURI.substr(2, baseURI.length - 2);
				}
				else
				{
					// This is a non-hierarchical URI like "mailto:bob@mail.com"
					_nonHierarchical = baseURI;
		
					if ((_valid = validateURI()) == false)
						initialize();  // Bad URI.  Clear it.
		
					// No more parsing to do for this case
					return isValid();
				}
			}
			else
			{
				// No scheme.  We will consider this a relative URI
				_scheme = "";
				_relative = true;
				_nonHierarchical = "";
			}
		
			// Ok, what we have left is everything after the <scheme>://
		
			// Now that we have stripped off any query and fragment parts, we
			// need to split the authority from the path
		
			if (isRelative())
			{
				// Don't bother looking for the authority.  It's a relative URI
				_authority = "";
				_port = "";
				_path = baseURI;
			}
			else
			{
				// Check for malformed UNC style file://///server/type/path/
				// By the time we get here, we have already trimmed the "file://"
				// so baseURI will be ///server/type/path.  If baseURI only
				// has one slash, we leave it alone because that is valid (that
				// is the case of "file:///path/to/file.txt" where there is no
				// server - implicit "localhost").
				if (baseURI.substr(0, 2) == "//")
				{
					// Trim all leading slashes
					while(baseURI.charAt(0) == "/")
						baseURI = baseURI.substr(1, baseURI.length - 1);
				}
		
				index = baseURI.search('/');
				if (index == -1)
				{
					// No path.  We must have passed something like "http://something.com"
					_authority = baseURI;
					_path = "";
				}
				else
				{
					_authority = baseURI.substr(0, index);
					_path = baseURI.substr(index, baseURI.length - index);
				}
		
				// Check to see if the URI has any username or password information.
				// For example:  ftp://username:password@server.com
				index = _authority.search('@');
				if (index != -1)
				{
					// We have a username and possibly a password
					_username = _authority.substr(0, index);
		
					// Remove the username/password from the authority
					_authority = _authority.substr(index + 1);  // Skip the '@'
		
					// Now check to see if the username also has a password
					index = _username.search(':');
					if (index != -1)
					{
						_password = _username.substring(index + 1, _username.length);
						_username = _username.substr(0, index);
					}
					else
						_password = "";
				}
				else
				{
					_username = "";
					_password = "";
				}
		
				// Lastly, check to see if the authorty has a port number.
				// This is parsed after the username/password to avoid conflicting
				// with the ':' in the 'username:password' if one exists.
				index = _authority.search(':');
				if (index != -1)
				{
					_port = _authority.substring(index + 1, _authority.length);  // skip the ':'
					_authority = _authority.substr(0, index);
				}
				else
				{
					_port = "";
				}
				
				// Lastly, normalize the authority.  Domain names
				// are case insensitive.
				_authority = _authority.toLowerCase();
			}
		
			if ((_valid = validateURI()) == false)
				initialize();  // Bad URI.  Clear it
		
			return isValid();
		}
		
		
		/********************************************************************
		 * Copy function.
		 */
		public function copyURI(uri:URI) : void
		{
			this._scheme = uri._scheme;
			this._authority = uri._authority;
			this._username = uri._username;
			this._password = uri._password;
			this._port = uri._port;
			this._path = uri._path;
			this._query = uri._query;
			this._fragment = uri._fragment;
			this._nonHierarchical = uri._nonHierarchical;
		
			this._valid = uri._valid;
			this._relative = uri._relative;
		}
		
		
		/**
		 * @private
		 * Checks if the given string only contains a-z or A-Z.
		 */
		protected function verifyAlpha(str:String) : Boolean
		{
			var pattern:RegExp = /[^a-z]/;
			var index:int;
			
			str = str.toLowerCase();
			index = str.search(pattern);
			
			if (index == -1)
				return true;
			else
				return false;
		}
		
		/**
		 * Is this a valid URI?
		 * 
		 * @return true if this object represents a valid URI, false
		 * otherwise.
		 */
		public function isValid() : Boolean
		{ 
			return this._valid;
		}
		
		
		/**
		 * Is this URI an absolute URI?  An absolute URI is a complete, fully
		 * qualified reference to a resource.  e.g. http://site.com/index.htm
		 * Non-hierarchical URI's are always absolute.
		 */
		public function isAbsolute() : Boolean
		{ 
			return !this._relative;
		}
		
		
		/**
		 * Is this URI a relative URI?  Relative URI's do not have a scheme
		 * and only contain a relative path with optional anchor and query
		 * parts.  e.g. "../reports/index.htm".  Non-hierarchical URI's
		 * will never be relative.
		 */
		public function isRelative() : Boolean
		{ 
			return this._relative;
		}
		
		
		/**
		 * Does this URI point to a resource that is a directory/folder?
		 * The URI specification dictates that any path that ends in a slash
		 * is a directory.  This is needed to be able to perform correct path
		 * logic when combining relative URI's with absolute URI's to
		 * obtain the correct absolute URI to a resource.
		 * 
		 * @see URI.chdir
		 * 
		 * @return true if this URI represents a directory resource, false
		 * if this URI represents a file resource.
		 */
		public function isDirectory() : Boolean
		{
			if (_path.length == 0)
				return false;
		
			return (_path.charAt(path.length - 1) == '/');
		}
		
		
		/**
		 * Is this URI a hierarchical URI? URI's can be  
		 */
		public function isHierarchical() : Boolean
		{ 
			return hierState;
		}
				
		
		/**
		 * The scheme of the URI.
		 */
		public function get scheme() : String
		{ 
			return URI.unescapeChars(_scheme);
		}
		public function set scheme(schemeStr:String) : void
		{
			// Normalize the scheme
			var normalized:String = schemeStr.toLowerCase();
			_scheme = URI.fastEscapeChars(normalized, URI.URIschemeExcludedBitmap);
		}
		
		
		/**
		 * The authority (host) of the URI.  Only valid for
		 * hierarchical URI's.  If the URI is relative, this will
		 * be an empty string. When setting this value, the string
		 * given is assumed to be unescaped.  When retrieving this
		 * value, the resulting string is unescaped.
		 */
		public function get authority() : String
		{ 
			return URI.unescapeChars(_authority);
		}
		public function set authority(authorityStr:String) : void
		{
			// Normalize the authority
			authorityStr = authorityStr.toLowerCase();
			
			_authority = URI.fastEscapeChars(authorityStr,
				URI.URIauthorityExcludedBitmap);
			
			// Only hierarchical URI's can have an authority, make
			// sure this URI is of the proper format.
			this.hierState = true;
		}
		
		
		/**
		 * The username of the URI.  Only valid for hierarchical
		 * URI's.  If the URI is relative, this will be an empty
		 * string.
		 * 
		 * <p>The URI specification allows for authentication
		 * credentials to be embedded in the URI as such:</p>
		 * 
		 * <p>http://user:passwd@host/path/to/file.htm</p>
		 * 
		 * <p>When setting this value, the string
		 * given is assumed to be unescaped.  When retrieving this
		 * value, the resulting string is unescaped.</p>
		 */
		public function get username() : String
		{
			return URI.unescapeChars(_username);
		}
		public function set username(usernameStr:String) : void
		{
			_username = URI.fastEscapeChars(usernameStr, URI.URIuserpassExcludedBitmap);
			
			// Only hierarchical URI's can have a username.
			this.hierState = true;
		}
		
		
		/**
		 * The password of the URI.  Similar to username.
		 * @see URI.username
		 */
		public function get password() : String
		{
			return URI.unescapeChars(_password);
		}
		public function set password(passwordStr:String) : void
		{
			_password = URI.fastEscapeChars(passwordStr,
				URI.URIuserpassExcludedBitmap);
			
			// Only hierarchical URI's can have a password.
			this.hierState = true;
		}
		
		
		/**
		 * The host port number.  Only valid for hierarchical URI's.  If
		 * the URI is relative, this will be an empty string. URI's can
		 * contain the port number of the remote host:
		 * 
		 * <p>http://site.com:8080/index.htm</p>
		 */
		public function get port() : String
		{ 
			return URI.unescapeChars(_port);
		}
		public function set port(portStr:String) : void
		{
			_port = URI.escapeChars(portStr);
			
			// Only hierarchical URI's can have a port.
			this.hierState = true;
		}
		
		
		/**
		 * The path portion of the URI.  Only valid for hierarchical
		 * URI's.  When setting this value, the string
		 * given is assumed to be unescaped.  When retrieving this
		 * value, the resulting string is unescaped.
		 * 
		 * <p>The path portion can be in one of two formats. 1) an absolute
		 * path, or 2) a relative path.  An absolute path starts with a
		 * slash ('/'), a relative path does not.</p>
		 * 
		 * <p>An absolute path may look like:</p>
		 * <listing>/full/path/to/my/file.htm</listing>
		 * 
		 * <p>A relative path may look like:</p>
		 * <listing>
		 * path/to/my/file.htm
		 * ../images/logo.gif
		 * ../../reports/index.htm
		 * </listing>
		 * 
		 * <p>Paths can be absolute or relative.  Note that this not the same as
		 * an absolute or relative URI.  An absolute URI can only have absolute
		 * paths.  For example:</p>
		 * 
		 * <listing>http:/site.com/path/to/file.htm</listing>
		 * 
		 * <p>This absolute URI has an absolute path of "/path/to/file.htm".</p>
		 * 
		 * <p>Relative URI's can have either absolute paths or relative paths.
		 * All of the following relative URI's are valid:</p>
		 * 
		 * <listing>
		 * /absolute/path/to/file.htm
		 * path/to/file.htm
		 * ../path/to/file.htm
		 * </listing>
		 */
		public function get path() : String
		{ 
			return URI.unescapeChars(_path);
		}
		public function set path(pathStr:String) : void
		{	
			this._path = URI.fastEscapeChars(pathStr, URI.URIpathExcludedBitmap);
		
			if (this._scheme == UNKNOWN_SCHEME)
			{
				// We set the path.  This is a valid URI now.
				this._scheme = "";
			}
		
			// Only hierarchical URI's can have a path.
			hierState = true;
		}
		
		
		/**
		 * The query (CGI) portion of the URI.  This part is valid for
		 * both hierarchical and non-hierarchical URI's.
		 * 
		 * <p>This accessor should only be used if a custom query syntax
		 * is used.  This URI class supports the common "param=value"
		 * style query syntax via the get/setQueryValue() and
		 * get/setQueryByMap() functions.  Those functions should be used
		 * instead if the common syntax is being used.
		 * 
		 * <p>The URI RFC does not specify any particular
		 * syntax for the query part of a URI.  It is intended to allow
		 * any format that can be agreed upon by the two communicating hosts.
		 * However, most systems have standardized on the typical CGI
		 * format:</p>
		 * 
		 * <listing>http://site.com/script.php?param1=value1&param2=value2</listing>
		 * 
		 * <p>This class has specific support for this query syntax</p>
		 * 
		 * <p>This common query format is an array of name/value
		 * pairs with its own syntax that is different from the overall URI
		 * syntax.  The query has its own escaping logic.  For a query part
		 * to be properly escaped and unescaped, it must be split into its
		 * component parts.  This accessor escapes/unescapes the entire query
		 * part without regard for it's component parts.  This has the
		 * possibliity of leaving the query string in an ambiguious state in
		 * regards to its syntax.  If the contents of the query part are
		 * //removeMeIfWantant, it is recommended that get/setQueryValue() or
		 * get/setQueryByMap() are used instead.</p>
		 * 
		 * If a different query syntax is being used, a subclass of URI
		 * can be created to handle that specific syntax.
		 *  
		 * @see URI.getQueryValue, URI.getQueryByMap
		 */
		public function get query() : String
		{ 
			return URI.unescapeChars(_query);
		}
		public function set query(queryStr:String) : void
		{
			_query = URI.fastEscapeChars(queryStr, URI.URIqueryExcludedBitmap);
			
			// both hierarchical and non-hierarchical URI's can
			// have a query.  Do not set the hierState.
		}
		
		/**
		 * Accessor to the raw query data.  If you are using a custom query
		 * syntax, this accessor can be used to get and set the query part
		 * directly with no escaping/unescaping.  This should ONLY be used
		 * if your application logic is handling custom query logic and
		 * handling the proper escaping of the query part.
		 */
		public function get queryRaw() : String
		{
			return _query;
		}
		public function set queryRaw(queryStr:String) : void
		{
			_query = queryStr;
		}


		/**
		 * The fragment (anchor) portion of the URI.  This is valid for
		 * both hierarchical and non-hierarchical URI's.
		 */
		public function get fragment() : String
		{ 
			return URI.unescapeChars(_fragment);
		}
		public function set fragment(fragmentStr:String) : void
		{
			_fragment = URI.fastEscapeChars(fragmentStr, URIfragmentExcludedBitmap);

			// both hierarchical and non-hierarchical URI's can
			// have a fragment.  Do not set the hierState.
		}
		
		
		/**
		 * The non-hierarchical part of the URI.  For example, if
		 * this URI object represents "mailto:somebody@company.com",
		 * this will contain "somebody@company.com".  This is valid only
		 * for non-hierarchical URI's.  
		 */
		public function get nonHierarchical() : String
		{ 
			return URI.unescapeChars(_nonHierarchical);
		}
		public function set nonHierarchical(nonHier:String) : void
		{
			_nonHierarchical = URI.fastEscapeChars(nonHier, URInonHierexcludedBitmap);
			
			// This is a non-hierarchical URI.
			this.hierState = false;
		}
		
		
		/**
		 * Quick shorthand accessor to set the parts of this URI.
		 * The given parts are assumed to be in unescaped form.  If
		 * the URI is non-hierarchical (e.g. mailto:) you will need
		 * to call SetScheme() and SetNonHierarchical().
		 */
		public function setParts(schemeStr:String, authorityStr:String,
				portStr:String, pathStr:String, queryStr:String,
				fragmentStr:String) : void
		{
			this.scheme = schemeStr;
			this.authority = authorityStr;
			this.port = portStr;
			this.path = pathStr;
			this.query = queryStr;
			this.fragment = fragmentStr;

			hierState = true;
		}
		
		
		/**
		 * URI escapes the given character string.  This is similar in function
		 * to the global encodeURIComponent() function in ActionScript, but is
		 * slightly different in regards to which characters get escaped.  This
		 * escapes the characters specified in the URIbaselineExluded set (see class
		 * static members).  This is needed for this class to work properly.
		 * 
		 * <p>If a different set of characters need to be used for the escaping,
		 * you may use fastEscapeChars() and specify a custom URIEncodingBitmap
		 * that contains the characters your application needs escaped.</p>
		 * 
		 * <p>Never pass a full URI to this function.  A URI can only be properly
		 * escaped/unescaped when split into its component parts (see RFC 3986
		 * section 2.4).  This is due to the fact that the URI component separators
		 * could be characters that would normally need to be escaped.</p>
		 * 
		 * @param unescaped character string to be escaped.
		 * 
		 * @return	escaped character string
		 * 
		 * @see encodeURIComponent
		 * @see fastEscapeChars
		 */
		static public function escapeChars(unescaped:String) : String
		{
			// This uses the excluded set by default.
			return fastEscapeChars(unescaped, URI.URIbaselineExcludedBitmap);
		}
		

		/**
		 * Unescape any URI escaped characters in the given character
		 * string.
		 * 
		 * <p>Never pass a full URI to this function.  A URI can only be properly
		 * escaped/unescaped when split into its component parts (see RFC 3986
		 * section 2.4).  This is due to the fact that the URI component separators
		 * could be characters that would normally need to be escaped.</p>
		 * 
		 * @param escaped the escaped string to be unescaped.
		 * 
		 * @return	unescaped string.
		 */
		static public function unescapeChars(escaped:String /*, onlyHighASCII:Boolean = false*/) : String
		{
			// We can just use the default AS function.  It seems to
			// decode everything correctly
			var unescaped:String;
			unescaped = decodeURIComponent(escaped);
			return unescaped;
		}
		
		/**
		 * Performance focused function that escapes the given character
		 * string using the given URIEncodingBitmap as the rule for what
		 * characters need to be escaped.  This function is used by this
		 * class and can be used externally to this class to perform
		 * escaping on custom character sets.
		 * 
		 * <p>Never pass a full URI to this function.  A URI can only be properly
		 * escaped/unescaped when split into its component parts (see RFC 3986
		 * section 2.4).  This is due to the fact that the URI component separators
		 * could be characters that would normally need to be escaped.</p>
		 * 
		 * @param unescaped		the unescaped string to be escaped
		 * @param bitmap		the set of characters that need to be escaped
		 * 
		 * @return	the escaped string.
		 */
		static public function fastEscapeChars(unescaped:String, bitmap:URIEncodingBitmap) : String
		{
			var escaped:String = "";
			var c:String;
			var x:int, i:int;
			
			for (i = 0; i < unescaped.length; i++)
			{
				c = unescaped.charAt(i);
				
				x = bitmap.ShouldEscape(c);
				if (x)
				{
					c = x.toString(16);
					if (c.length == 1)
						c = "0" + c;
						
					c = "%" + c;
					c = c.toUpperCase();
				}
				
				escaped += c;
			}
			
			return escaped;
		}

		
		/**
		 * Is this URI of a particular scheme type?  For example,
		 * passing "http" to a URI object that represents the URI
		 * "http://site.com/" would return true.
		 * 
		 * @param scheme	scheme to check for
		 * 
		 * @return true if this URI object is of the given type, false
		 * otherwise.
		 */
		public function isOfType(scheme:String) : Boolean
		{
			// Schemes are never case sensitive.  Ignore case.
			scheme = scheme.toLowerCase();
			return (this._scheme == scheme);
		}


		/**
		 * Get the value for the specified named in the query part.  This
		 * assumes the query part of the URI is in the common
		 * "name1=value1&name2=value2" syntax.  Do not call this function
		 * if you are using a custom query syntax.
		 * 
		 * @param name	name of the query value to get.
		 * 
		 * @return the value of the query name, empty string if the
		 * query name does not exist.
		 */
		public function getQueryValue(name:String) : String
		{
			var map:Object;
			var item:String;
			var value:String;
		
			map = getQueryByMap();
		
			for (item in map)
			{
				if (item == name)
				{
					value = map[item];
					return value;
				}
			}
		
			// Didn't find the specified key
			return new String("");
		}
		

		/**
		 * Set the given value on the given query name.  If the given name
		 * does not exist, it will automatically add this name/value pair
		 * to the query.  If null is passed as the value, it will remove
		 * the given item from the query.
		 * 
		 * <p>This automatically escapes any characters that may conflict with
		 * the query syntax so that they are "safe" within the query.  The
		 * strings passed are assumed to be literal unescaped name and value.</p>
		 * 
		 * @param name	name of the query value to set
		 * @param value	value of the query item to set.  If null, this will
		 * force the removal of this item from the query.
		 */
		public function setQueryValue(name:String, value:String) : void
		{
			var map:Object;

			map = getQueryByMap();
		
			// If the key doesn't exist yet, this will create a new pair in
			// the map.  If it does exist, this will overwrite the previous
			// value, which is what we want.
			map[name] = value;
		
			setQueryByMap(map);
		}

		
		/**
		 * Get the query of the URI in an Object class that allows for easy
		 * access to the query data via Object accessors.  For example:
		 * 
		 * <listing>
		 * var query:Object = uri.getQueryByMap();
		 * var value:String = query["param"];    // get a value
		 * query["param2"] = "foo";   // set a new value
		 * </listing>
		 * 
		 * @return Object that contains the name/value pairs of the query.
		 * 
		 * @see #setQueryByMap
		 * @see #getQueryValue
		 * @see #setQueryValue
		 */
		public function getQueryByMap() : Object
		{
			var queryStr:String;
			var pair:String;
			var pairs:Array;
			var item:Array;
			var name:String, value:String;
			var index:int;
			var map:Object = new Object();
		
		
			// We need the raw query string, no unescaping.
			queryStr = this._query;
			
			pairs = queryStr.split('&');
			for each (pair in pairs)
			{
				if (pair.length == 0)
				  continue;
				  
				item = pair.split('=');
				
				if (item.length > 0)
					name = item[0];
				else
					continue;  // empty array
				
				if (item.length > 1)
					value = item[1];
				else
					value = "";
					
				name = queryPartUnescape(name);
				value = queryPartUnescape(value);
				
				map[name] = value;
			}
	
			return map;
		}
		

		/**
		 * Set the query part of this URI using the given object as the
		 * content source.  Any member of the object that has a value of
		 * null will not be in the resulting query.
		 * 
		 * @param map	object that contains the name/value pairs as
		 *    members of that object.
		 * 
		 * @see #getQueryByMap
		 * @see #getQueryValue
		 * @see #setQueryValue
		 */
		public function setQueryByMap(map:Object) : void
		{
			var item:String;
			var name:String, value:String;
			var queryStr:String = "";
			var tmpPair:String;
			var foo:String;
		
			for (item in map)
			{
				name = item;
				value = map[item];
		
				if (value == null)
					value = "";
				
				// Need to escape the name/value pair so that they
				// don't conflict with the query syntax (specifically
				// '=', '&', and <whitespace>).
				name = queryPartEscape(name);
				value = queryPartEscape(value);
				
				tmpPair = name;
				
				if (value.length > 0)
				{
					tmpPair += "=";
					tmpPair += value;
				}

				if (queryStr.length != 0)
					queryStr += '&';  // Add the separator
		
				queryStr += tmpPair;
			}
		
			// We don't want to escape.  We already escaped the
			// individual name/value pairs.  If we escaped the
			// query string again by assigning it to "query",
			// we would have double escaping.
			_query = queryStr;
		}
		
		
		/**
		 * Similar to Escape(), except this also escapes characters that
		 * would conflict with the name/value pair query syntax.  This is
		 * intended to be called on each individual "name" and "value"
		 * in the query making sure that nothing in the name or value
		 * strings contain characters that would conflict with the query
		 * syntax (e.g. '=' and '&').
		 * 
		 * @param unescaped		unescaped string that is to be escaped.
		 * 
		 * @return escaped string.
		 * 
		 * @see #queryUnescape
		 */
		static public function queryPartEscape(unescaped:String) : String
		{
			var escaped:String = unescaped;
			escaped = URI.fastEscapeChars(unescaped, URI.URIqueryPartExcludedBitmap);
			return escaped;
		}
		

		/**
		 * Unescape the individual name/value string pairs.
		 * 
		 * @param escaped	escaped string to be unescaped
		 * 
		 * @return unescaped string
		 * 
		 * @see #queryEscape
		 */
		static public function queryPartUnescape(escaped:String) : String
		{
			var unescaped:String = escaped;
			unescaped = unescapeChars(unescaped);
			return unescaped;
		}
		
		/**
		 * Output this URI as a string.  The resulting string is properly
		 * escaped and well formed for machine processing.
		 */
		public function toString() : String
		{
			if (this == null)
				return "";
			else
				return toStringInternal(false);
		}
		
		/**
		 * Output the URI as a string that is easily readable by a human.
		 * This outputs the URI with all escape sequences unescaped to
		 * their character representation.  This makes the URI easier for
		 * a human to read, but the URI could be completely invalid
		 * because some unescaped characters may now cause ambiguous parsing.
		 * This function should only be used if you want to display a URI to
		 * a user.  This function should never be used outside that specific
		 * case.
		 * 
		 * @return the URI in string format with all escape sequences
		 * unescaped.
		 * 
		 * @see #toString
		 */
		public function toDisplayString() : String
		{
			return toStringInternal(true);
		}
		
		
		/**
		 * @private
		 * 
		 * The guts of toString()
		 */
		protected function toStringInternal(forDisplay:Boolean) : String
		{
			var uri:String = "";
			var part:String = "";
		
			if (isHierarchical() == false)
			{
				// non-hierarchical URI
		
				uri += (forDisplay ? this.scheme : _scheme);
				uri += ":";
				uri += (forDisplay ? this.nonHierarchical : _nonHierarchical);
			}
			else
			{
				// Hierarchical URI
		
				if (isRelative() == false)
				{
					// If it is not a relative URI, then we want the scheme and
					// authority parts in the string.  If it is relative, we
					// do NOT want this stuff.
		
					if (_scheme.length != 0)
					{
						part = (forDisplay ? this.scheme : _scheme);
						uri += part + ":";
					}
		
					if (_authority.length != 0 || isOfType("file"))
					{
						uri += "//";
		
						// Add on any username/password associated with this
						// authority
						if (_username.length != 0)
						{
							part = (forDisplay ? this.username : _username);
							uri += part;
		
							if (_password.length != 0)
							{
								part = (forDisplay ? this.password : _password);
								uri += ":" + part;
							}
		
							uri += "@";
						}
		
						// add the authority
						part = (forDisplay ? this.authority : _authority);
						uri += part;
		
						// Tack on the port number, if any
						if (port.length != 0)
							uri += ":" + port;
					}
				}
		
				// Tack on the path
				part = (forDisplay ? this.path : _path);
				uri += part;
		
			} // end hierarchical part
		
			// Both non-hier and hierarchical have query and fragment parts
		
			// Add on the query and fragment parts
			if (_query.length != 0)
			{
				part = (forDisplay ? this.query : _query);
				uri += "?" + part;
			}
		
			if (fragment.length != 0)
			{
				part = (forDisplay ? this.fragment : _fragment);
				uri += "#" + part;
			}
		
			return uri;
		}
	
		/**
		 * Forcefully ensure that this URI is properly escaped.
		 * 
		 * <p>Sometimes URI's are constructed by hand using strings outside
		 * this class.  In those cases, it is unlikely the URI has been
		 * properly escaped.  This function forcefully escapes this URI
		 * by unescaping each part and then re-escaping it.  If the URI
		 * did not have any escaping, the first unescape will do nothing
		 * and then the re-escape will properly escape everything.  If
		 * the URI was already escaped, the unescape and re-escape will
		 * essentally be a no-op.  This provides a safe way to make sure
		 * a URI is in the proper escaped form.</p>
		 */
		public function forceEscape() : void
		{
			// The accessors for each of the members will unescape
			// and then re-escape as we get and assign them.
			
			// Handle the parts that are common for both hierarchical
			// and non-hierarchical URI's
			this.scheme = this.scheme;
			this.setQueryByMap(this.getQueryByMap());
			this.fragment = this.fragment;
			
			if (isHierarchical())
			{
				this.authority = this.authority;
				this.path = this.path;
				this.port = this.port;
				this.username = this.username;
				this.password = this.password;
			}
			else
			{
				this.nonHierarchical = this.nonHierarchical;
			}
		}
		
		
		/**
		 * Does this URI point to a resource of the given file type?
		 * Given a file extension (or just a file name, this will strip the
		 * extension), check to see if this URI points to a file of that
		 * type.
		 * 
		 * @param extension 	string that contains a file extension with or
		 * without a dot ("html" and ".html" are both valid), or a file
		 * name with an extension (e.g. "index.html").
		 * 
		 * @return true if this URI points to a resource with the same file
		 * file extension as the extension provided, false otherwise.
		 */
		public function isOfFileType(extension:String) : Boolean
		{
			var thisExtension:String;
			var index:int;
		
			index = extension.lastIndexOf(".");
			if (index != -1)
			{
				// Strip the extension
				extension = extension.substr(index + 1);
			}
			else
			{
				// The caller passed something without a dot in it.  We
				// will assume that it is just a plain extension (e.g. "html").
				// What they passed is exactly what we want
			}
		
			thisExtension = getExtension(true);
		
			if (thisExtension == "")
				return false;
		
			// Compare the extensions ignoring case
			if (compareStr(thisExtension, extension, false) == 0)
				return true;
			else
				return false;
		}
		
		
		/**
		 * Get the ".xyz" file extension from the filename in the URI.
		 * For example, if we have the following URI:
		 * 
		 * <listing>http://something.com/path/to/my/page.html?form=yes&name=bob#anchor</listing>
		 * 
		 * <p>This will return ".html".</p>
		 * 
		 * @param minusDot   If true, this will strip the dot from the extension.
		 * If true, the above example would have returned "html".
		 * 
		 * @return  the file extension
		 */
		public function getExtension(minusDot:Boolean = false) : String
		{
			var filename:String = getFilename();
			var extension:String;
			var index:int;
		
			if (filename == "")
				return String("");
		
			index = filename.lastIndexOf(".");
		
			// If it doesn't have an extension, or if it is a "hidden" file,
			// it doesn't have an extension.  Hidden files on unix start with
			// a dot (e.g. ".login").
			if (index == -1 || index == 0)
				return String("");
		
			extension = filename.substr(index);
		
			// If the caller does not want the dot, remove it.
			if (minusDot && extension.charAt(0) == ".")
				extension = extension.substr(1);
		
			return extension;
		}
		
		/**
		 * Quick function to retrieve the file name off the end of a URI.
		 * 
		 * <p>For example, if the URI is:</p>
		 * <listing>http://something.com/some/path/to/my/file.html</listing>
		 * <p>this function will return "file.html".</p>
		 * 
		 * @param minusExtension true if the file extension should be stripped
		 * 
		 * @return the file name.  If this URI is a directory, the return
		 * value will be empty string.
		 */
		public function getFilename(minusExtension:Boolean = false) : String
		{
			if (isDirectory())
				return String("");
		
			var pathStr:String = this.path;
			var filename:String;
			var index:int;
		
			// Find the last path separator.
			index = pathStr.lastIndexOf("/");
		
			if (index != -1)
				filename = pathStr.substr(index + 1);
			else
				filename = pathStr;
		
			if (minusExtension)
			{
				// The caller has requested that the extension be removed
				index = filename.lastIndexOf(".");
		
				if (index != -1)
					filename = filename.substr(0, index);
			}
		
			return filename;
		}
		
		
		/**
		 * @private
		 * Helper function to compare strings.
		 * 
		 * @return true if the two strings are identical, false otherwise.
		 */
		static protected function compareStr(str1:String, str2:String,
			sensitive:Boolean = true) : Boolean
		{
			if (sensitive == false)
			{
				str1 = str1.toLowerCase();
				str2 = str2.toLowerCase();
			}
			
			return (str1 == str2)
		}
		
		/**
		 * Based on the type of this URI (http, ftp, etc.) get
		 * the default port used for that protocol.  This is
		 * just intended to be a helper function for the most
		 * common cases.
		 */
		public function getDefaultPort() : String
		{
			if (_scheme == "http")
				return String("80");
			else if (_scheme == "ftp")
				return String("21");
			else if (_scheme == "file")
				return String("");
			else if (_scheme == "sftp")
				return String("22"); // ssh standard port
			else
			{
				// Don't know the port for this URI type
				return String("");
			}
		}
		
		/**
		 * @private
		 * 
		 * This resolves the given URI if the application has a
		 * resolver interface defined.  This function does not
		 * modify the passed in URI and returns a new URI.
		 */
		static protected function resolve(uri:URI) : URI
		{
			var copy:URI = new URI();
			copy.copyURI(uri);
			
			if (_resolver != null)
			{
				// A resolver class has been registered.  Call it.
				return _resolver.resolve(copy);
			}
			else
			{
				// No resolver.  Nothing to do, but we don't
				// want to reuse the one passed in.
				return copy;
			}
		}
		
		/**
		 * Accessor to set and get the resolver object used by all URI
		 * objects to dynamically resolve URI's before comparison.
		 */
		static public function set resolver(resolver:IURIResolver) : void
		{
			_resolver = resolver;
		}
		static public function get resolver() : IURIResolver
		{
			return _resolver;
		}
		
		/**
		 * Given another URI, return this URI object's relation to the one given.
		 * URI's can have 1 of 4 possible relationships.  They can be unrelated,
		 * equal, parent, or a child of the given URI.
		 * 
		 * @param uri	URI to compare this URI object to.
		 * @param caseSensitive  true if the URI comparison should be done
		 * taking case into account, false if the comparison should be
		 * performed case insensitive.
		 * 
		 * @return URI.NOT_RELATED, URI.CHILD, URI.PARENT, or URI.EQUAL
		 */
		public function getRelation(uri:URI, caseSensitive:Boolean = true) : int
		{
			// Give the app a chance to resolve these URI's before we compare them.
			var thisURI:URI = URI.resolve(this);
			var thatURI:URI = URI.resolve(uri);
			
			if (thisURI.isRelative() || thatURI.isRelative())
			{
				// You cannot compare relative URI's due to their lack of context.
				// You could have two relative URI's that look like:
				//		../../images/
				//		../../images/marketing/logo.gif
				// These may appear related, but you have no overall context
				// from which to make the comparison.  The first URI could be
				// from one site and the other URI could be from another site.
				return URI.NOT_RELATED;
			}
			else if (thisURI.isHierarchical() == false || thatURI.isHierarchical() == false)
			{
				// One or both of the URI's are non-hierarchical.
				if (((thisURI.isHierarchical() == false) && (thatURI.isHierarchical() == true)) ||
					((thisURI.isHierarchical() == true) && (thatURI.isHierarchical() == false)))
				{
					// XOR.  One is hierarchical and the other is
					// non-hierarchical.  They cannot be compared.
					return URI.NOT_RELATED;
				}
				else
				{
					// They are both non-hierarchical
					if (thisURI.scheme != thatURI.scheme)
						return URI.NOT_RELATED;
		
					if (thisURI.nonHierarchical != thatURI.nonHierarchical)
						return URI.NOT_RELATED;
						
					// The two non-hierarcical URI's are equal.
					return URI.EQUAL;
				}
			}
			
			// Ok, this URI and the one we are being compared to are both
			// absolute hierarchical URI's.
		
			if (thisURI.scheme != thatURI.scheme)
				return URI.NOT_RELATED;
		
			if (thisURI.authority != thatURI.authority)
				return URI.NOT_RELATED;
		
			var thisPort:String = thisURI.port;
			var thatPort:String = thatURI.port;
			
			// Different ports are considered completely different servers.
			if (thisPort == "")
				thisPort = thisURI.getDefaultPort();
			if (thatPort == "")
				thatPort = thatURI.getDefaultPort();
		
			// Check to see if the port is the default port.
			if (thisPort != thatPort)
				return URI.NOT_RELATED;
		
			if (compareStr(thisURI.path, thatURI.path, caseSensitive))
				return URI.EQUAL;
		
			// Special case check.  If we are here, the scheme, authority,
			// and port match, and it is not a relative path, but the
			// paths did not match.  There is a special case where we
			// could have:
			//		http://something.com/
			//		http://something.com
			// Technically, these are equal.  So lets, check for this case.
			var thisPath:String = thisURI.path;
			var thatPath:String = thatURI.path;
		
			if ( (thisPath == "/" || thatPath == "/") &&
				 (thisPath == "" || thatPath == "") )
			{
				// We hit the special case.  These two are equal.
				return URI.EQUAL;
			}
		
			// Ok, the paths do not match, but one path may be a parent/child
			// of the other.  For example, we may have:
			//		http://something.com/path/to/homepage/
			//		http://something.com/path/to/homepage/images/logo.gif
			// In this case, the first is a parent of the second (or the second
			// is a child of the first, depending on which you compare to the
			// other).  To make this comparison, we must split the path into
			// its component parts (split the string on the '/' path delimiter).
			// We then compare the 
			var thisParts:Array, thatParts:Array;
			var thisPart:String, thatPart:String;
			var i:int;
		
			thisParts = thisPath.split("/");
			thatParts = thatPath.split("/");
		
			if (thisParts.length > thatParts.length)
			{
				thatPart = thatParts[thatParts.length - 1];
				if (thatPart.length > 0)
				{
					// if the last part is not empty, the passed URI is
					// not a directory.  There is no way the passed URI
					// can be a parent.
					return URI.NOT_RELATED;
				}
				else
				{
					// Remove the empty trailing part
					thatParts.pop();
				}
				
				// This may be a child of the one passed in
				for (i = 0; i < thatParts.length; i++)
				{
					thisPart = thisParts[i];
					thatPart = thatParts[i];
						
					if (compareStr(thisPart, thatPart, caseSensitive) == false)
						return URI.NOT_RELATED;
				}
		
				return URI.CHILD;
			}
			else if (thisParts.length < thatParts.length)
			{
				thisPart = thisParts[thisParts.length - 1];
				if (thisPart.length > 0)
				{
					// if the last part is not empty, this URI is not a
					// directory.  There is no way this object can be
					// a parent.
					return URI.NOT_RELATED;
				}
				else
				{
					// Remove the empty trailing part
					thisParts.pop();
				}
				
				// This may be the parent of the one passed in
				for (i = 0; i < thisParts.length; i++)
				{
					thisPart = thisParts[i];
					thatPart = thatParts[i];
		
					if (compareStr(thisPart, thatPart, caseSensitive) == false)
						return URI.NOT_RELATED;
				}
				
				return URI.PARENT;
			}
			else
			{
				// Both URI's have the same number of path components, but
				// it failed the equivelence check above.  This means that
				// the two URI's are not related.
				return URI.NOT_RELATED;
			}
			
			// If we got here, the scheme and authority are the same,
			// but the paths pointed to two different locations that
			// were in different parts of the file system tree
			return URI.NOT_RELATED;
		}
		
		/**
		 * Given another URI, return the common parent between this one
		 * and the provided URI.
		 * 
		 * @param uri the other URI from which to find a common parent
		 * @para caseSensitive true if this operation should be done
		 * with case sensitive comparisons.
		 * 
		 * @return the parent URI if successful, null otherwise.
		 */
		public function getCommonParent(uri:URI, caseSensitive:Boolean = true) : URI
		{
			var thisURI:URI = URI.resolve(this);
			var thatURI:URI = URI.resolve(uri);
		
			if(!thisURI.isAbsolute() || !thatURI.isAbsolute() ||
				thisURI.isHierarchical() == false ||
				thatURI.isHierarchical() == false)
			{
				// Both URI's must be absolute hierarchical for this to
				// make sense.
				return null;
			}
			
			var relation:int = thisURI.getRelation(thatURI);
			if (relation == URI.NOT_RELATED)
			{
				// The given URI is not related to this one.  No
				// common parent.
				return null;
			}
		
			thisURI.chdir(".");
			thatURI.chdir(".");
			
			var strBefore:String, strAfter:String;
			do
			{
				relation = thisURI.getRelation(thatURI, caseSensitive);
				if(relation == URI.EQUAL || relation == URI.PARENT)
					break;
		
				// If strBefore and strAfter end up being the same,
				// we know we are at the root of the path because
				// chdir("..") is doing nothing.
				strBefore = thisURI.toString();
				thisURI.chdir("..");
				strAfter = thisURI.toString();
			}
			while(strBefore != strAfter);
		
			return thisURI;
		}
		
		
		/**
		 * This function is used to move around in a URI in a way similar
		 * to the 'cd' or 'chdir' commands on Unix.  These operations are
		 * completely string based, using the context of the URI to
		 * determine the position within the path.  The heuristics used
		 * to determine the action are based off Appendix C in RFC 2396.
		 * 
		 * <p>URI paths that end in '/' are considered paths that point to
		 * directories, while paths that do not end in '/' are files.  For
		 * example, if you execute chdir("d") on the following URI's:<br/>
		 *    1.  http://something.com/a/b/c/  (directory)<br/>
		 *    2.  http://something.com/a/b/c  (not directory)<br/>
		 * you will get:<br/>
		 *    1.  http://something.com/a/b/c/d<br/>
		 *    2.  http://something.com/a/b/d<br/></p>
		 * 
		 * <p>See RFC 2396, Appendix C for more info.</p>
		 * 
		 * @param reference	the URI or path to "cd" to.
		 * @param escape true if the passed reference string should be URI
		 * escaped before using it.
		 * 
		 * @return true if the chdir was successful, false otherwise.
		 */
		public function chdir(reference:String, escape:Boolean = false) : Boolean
		{
			var uriReference:URI;
			var ref:String = reference;
		
			if (escape)
				ref = URI.escapeChars(reference);
		
			if (ref == "")
			{
				// NOOP
				return true;
			}
			else if (ref.substr(0, 2) == "//")
			{
				// Special case.  This is an absolute URI but without the scheme.
				// Take the scheme from this URI and tack it on.  This is
				// intended to make working with chdir() a little more
				// tolerant.
				var final:String = this.scheme + ":" + ref;
				
				return constructURI(final);
			}
			else if (ref.charAt(0) == "?")
			{
				// A relative URI that is just a query part is essentially
				// a "./?query".  We tack on the "./" here to make the rest
				// of our logic work.
				ref = "./" + ref;
			}
		
			// Parse the reference passed in as a URI.  This way we
			// get any query and fragments parsed out as well.
			uriReference = new URI(ref);
		
			if (uriReference.isAbsolute() ||
				uriReference.isHierarchical() == false)
			{
				// If the URI given is a full URI, it replaces this one.
				copyURI(uriReference);
				return true;
			}
		
		
			var thisPath:String, thatPath:String;
			var thisParts:Array, thatParts:Array;
			var thisIsDir:Boolean = false, thatIsDir:Boolean = false;
			var thisIsAbs:Boolean = false, thatIsAbs:Boolean = false;
			var lastIsDotOperation:Boolean = false;
			var curDir:String;
			var i:int;
		
			thisPath = this.path;
			thatPath = uriReference.path;
		
			if (thisPath.length > 0)
				thisParts = thisPath.split("/");
			else
				thisParts = new Array();
				
			if (thatPath.length > 0)
				thatParts = thatPath.split("/");
			else
				thatParts = new Array();
			
			if (thisParts.length > 0 && thisParts[0] == "")
			{
				thisIsAbs = true;
				thisParts.shift(); // pop the first one off the array
			}
			if (thisParts.length > 0 && thisParts[thisParts.length - 1] == "")
			{
				thisIsDir = true;
				thisParts.pop();  // pop the last one off the array
			}
				
			if (thatParts.length > 0 && thatParts[0] == "")
			{
				thatIsAbs = true;
				thatParts.shift(); // pop the first one off the array
			}
			if (thatParts.length > 0 && thatParts[thatParts.length - 1] == "")
			{
				thatIsDir = true;
				thatParts.pop();  // pop the last one off the array
			}
				
			if (thatIsAbs)
			{
				// The reference is an absolute path (starts with a slash).
				// It replaces this path wholesale.
				this.path = uriReference.path;
		
				// And it inherits the query and fragment
				this.queryRaw = uriReference.queryRaw;
				this.fragment = uriReference.fragment;
		
				return true;
			}
			else if (thatParts.length == 0 && uriReference.query == "")
			{
				// The reference must have only been a fragment.  Fragments just
				// get appended to whatever the current path is.  We don't want
				// to overwrite any query that may already exist, so this case
				// only takes on the new fragment.
				this.fragment = uriReference.fragment;
				return true;
			}
			else if (thisIsDir == false && thisParts.length > 0)
			{
				// This path ends in a file.  It goes away no matter what.
				thisParts.pop();
			}
		
			// By default, this assumes the query and fragment of the reference
			this.queryRaw = uriReference.queryRaw;
			this.fragment = uriReference.fragment;
		
			// Append the parts of the path from the passed in reference
			// to this object's path.
			thisParts = thisParts.concat(thatParts);
					
			for(i = 0; i < thisParts.length; i++)
			{
				curDir = thisParts[i];
				lastIsDotOperation = false;
		
				if (curDir == ".")
				{
					thisParts.splice(i, 1);
					i = i - 1;  // account for removing this item
					lastIsDotOperation = true;
				}
				else if (curDir == "..")
				{
					if (i >= 1)
					{
						if (thisParts[i - 1] == "..")
						{
							// If the previous is a "..", we must have skipped
							// it due to this URI being relative.  We can't
							// collapse leading ".."s in a relative URI, so
							// do nothing.
						}
						else
						{
							thisParts.splice(i - 1, 2);
							i = i - 2;  // move back to account for the 2 we removed
						}
					}
					else
					{
						// This is the first thing in the path.
		
						if (isRelative())
						{
							// We can't collapse leading ".."s in a relative
							// path.  Do noting.
						}
						else
						{
							// This is an abnormal case.  We have dot-dotted up
							// past the base of our "file system".  This is a
							// case where we had a /path/like/this.htm and were
							// given a path to chdir to like this:
							// ../../../../../../mydir
							// Obviously, it has too many ".." and will take us
							// up beyond the top of the URI.  However, according
							// RFC 2396 Appendix C.2, we should try to handle
							// these abnormal cases appropriately.  In this case,
							// we will do what UNIX command lines do if you are
							// at the root (/) of the filesystem and execute:
							// # cd ../../../../../bin
							// Which will put you in /bin.  Essentially, the extra
							// ".."'s will just get eaten.
		
							thisParts.splice(i, 1);
							i = i - 1;  // account for the ".." we just removed
						}
					}
		
					lastIsDotOperation = true;
				}
			}
			
			var finalPath:String = "";
		
			// If the last thing in the path was a "." or "..", then this thing is a
			// directory.  If the last thing isn't a dot-op, then we don't want to 
			// blow away any information about the directory (hence the "|=" binary
			// assignment).
			thatIsDir = thatIsDir || lastIsDotOperation;
		
			// Reconstruct the path with the abs/dir info we have
			finalPath = joinPath(thisParts, thisIsAbs, thatIsDir);
		
			// Set the path (automatically escaping it)
			this.path = finalPath;
		
			return true;
		}
		
		/**
		 * @private
		 * Join an array of path parts back into a URI style path string.
		 * This is used by the various path logic functions to recombine
		 * a path.  This is different than the standard Array.join()
		 * function because we need to take into account the starting and
		 * ending path delimiters if this is an absolute path or a
		 * directory.
		 * 
		 * @param parts	the Array that contains strings of each path part.
		 * @param isAbs		true if the given path is absolute
		 * @param isDir		true if the given path is a directory
		 * 
		 * @return the combined path string.
		 */
		protected function joinPath(parts:Array, isAbs:Boolean, isDir:Boolean) : String
		{
			var pathStr:String = "";
			var i:int;
		
			for (i = 0; i < parts.length; i++)
			{
				if (pathStr.length > 0)
					pathStr += "/";
		
				pathStr += parts[i];
			}
		
			// If this path is a directory, tack on the directory delimiter,
			// but only if the path contains something.  Adding this to an
			// empty path would make it "/", which is an absolute path that
			// starts at the root.
			if (isDir && pathStr.length > 0)
				pathStr += "/";
		
			if (isAbs)
				pathStr = "/" + pathStr;
		
			return pathStr;
		}
		
		/**
		 * Given an absolute URI, make this relative URI absolute using
		 * the given URI as a base.  This URI instance must be relative
		 * and the base_uri must be absolute.
		 * 
		 * @param base_uri	URI to use as the base from which to make
		 * this relative URI into an absolute URI.
		 * 
		 * @return true if successful, false otherwise.
		 */
		public function makeAbsoluteURI(base_uri:URI) : Boolean
		{
			if (isAbsolute() || base_uri.isRelative())
			{
				// This URI needs to be relative, and the base needs to be
				// absolute otherwise we won't know what to do!
				return false;
			}
		
			// Make a copy of the base URI.  We don't want to modify
			// the passed URI.
			var base:URI = new URI();
			base.copyURI(base_uri);
		
			// ChDir on the base URI.  This will preserve any query
			// and fragment we have.
			if (base.chdir(toString()) == false)
				return false;
		
			// It worked, so copy the base into this one
			copyURI(base);
		
			return true;
		}
		
		
		/**
		 * Given a URI to use as a base from which this object should be
		 * relative to, convert this object into a relative URI.  For example,
		 * if you have:
		 * 
		 * <listing>
		 * var uri1:URI = new URI("http://something.com/path/to/some/file.html");
		 * var uri2:URI = new URI("http://something.com/path/to/another/file.html");
		 * 
		 * uri1.MakeRelativePath(uri2);</listing>
		 * 
		 * <p>uri1 will have a final value of "../some/file.html"</p>
		 * 
		 * <p>Note! This function is brute force.  If you have two URI's
		 * that are completely unrelated, this will still attempt to make
		 * the relative URI.  In that case, you will most likely get a
		 * relative path that looks something like:</p>
		 * 
		 * <p>../../../../../../some/path/to/my/file.html</p>
		 * 
		 * @param base_uri the URI from which to make this URI relative
		 * 
		 * @return true if successful, false if the base_uri and this URI
		 * are not related, of if error.
		 */
		public function makeRelativeURI(base_uri:URI, caseSensitive:Boolean = true) : Boolean
		{
			var base:URI = new URI();
			base.copyURI(base_uri);
			
			var thisParts:Array, thatParts:Array;
			var finalParts:Array = new Array();
			var thisPart:String, thatPart:String, finalPath:String;
			var pathStr:String = this.path;
			var queryStr:String = this.queryRaw;
			var fragmentStr:String = this.fragment;
			var i:int;
			var diff:Boolean = false;
			var isDir:Boolean = false;
		
			if (isRelative())
			{
				// We're already relative.
				return true;
			}
		
			if (base.isRelative())
			{
				// The base is relative.  A relative base doesn't make sense.
				return false;
			}
		
		
			if ( (isOfType(base_uri.scheme) == false) ||
				(this.authority != base_uri.authority) )
			{
				// The schemes and/or authorities are different.  We can't
				// make a relative path to something that is completely
				// unrelated.
				return false;
			}
		
			// Record the state of this URI
			isDir = isDirectory();
		
			// We are based of the directory of the given URI.  We need to
			// make sure the URI is pointing to a directory.  Changing
			// directory to "." will remove any file name if the base is
			// not a directory.
			base.chdir(".");
		
			thisParts = pathStr.split("/");
			thatParts = base.path.split("/");
			
			if (thisParts.length > 0 && thisParts[0] == "")
				thisParts.shift();
			
			if (thisParts.length > 0 && thisParts[thisParts.length - 1] == "")
			{
				isDir = true;
				thisParts.pop();
			}
			
			if (thatParts.length > 0 && thatParts[0] == "")
				thatParts.shift();
			if (thatParts.length > 0 && thatParts[thatParts.length - 1] == "")
				thatParts.pop();
		
		
			// Now that we have the paths split into an array of directories,
			// we can compare the two paths.  We start from the left of side
			// of the path and start comparing.  When we either run out of
			// directories (one path is longer than the other), or we find
			// a directory that is different, we stop.  The remaining parts
			// of each path is then used to determine the relative path.  For
			// example, lets say we have:
			//    path we want to make relative: /a/b/c/d/e.txt
			//    path to use as base for relative: /a/b/f/
			//
			// This loop will start at the left, and remove directories
			// until we get a mismatch or run off the end of one of them.
			// In this example, the result will be:
			//    c/d/e.txt
			//    f
			//
			// For every part left over in the base path, we prepend a ".."
			// to the relative to get the final path:
			//   ../c/d/e.txt
			while(thatParts.length > 0)
			{
				if (thisParts.length == 0)
				{
					// we matched all there is to match, we are done.
					// This is the case where "this" object is a parent
					// path of the given URI.  eg:
					//   this.path = /a/b/				(thisParts)
					//   base.path = /a/b/c/d/e/		(thatParts)
					break;
				}
		
				thisPart = thisParts[0];
				thatPart = thatParts[0];
		
				if (compareStr(thisPart, thatPart, caseSensitive))
				{
					thisParts.shift();
					thatParts.shift();
				}
				else
					break;
			}
		
			// If there are any path info left from the base URI, that means
			// **this** object is above the given URI in the file tree.  For
			// each part left over in the given URI, we need to move up one
			// directory to get where we are.
			var dotdot:String = "..";
			for (i = 0; i < thatParts.length; i++)
			{
				finalParts.push(dotdot);
			}
		
			// Append the parts of this URI to any dot-dot's we have
			finalParts = finalParts.concat(thisParts);
		
			// Join the parts back into a path
			finalPath = joinPath(finalParts, false /* not absolute */, isDir);
		
			if (finalPath.length == 0)
			{
				// The two URI's are exactly the same.  The proper relative
				// path is:
				finalPath = "./";
			}
		
			// Set the parts of the URI, preserving the original query and
			// fragment parts.
			setParts("", "", "", finalPath, queryStr, fragmentStr);
		
			return true;
		}
		
		/**
		 * Given a string, convert it to a URI.  The string could be a
		 * full URI that is improperly escaped, a malformed URI (e.g.
		 * missing a protocol like "www.something.com"), a relative URI,
		 * or any variation there of.
		 * 
		 * <p>The intention of this function is to take anything that a
		 * user might manually enter as a URI/URL and try to determine what
		 * they mean.  This function differs from the URI constructor in
		 * that it makes some assumptions to make it easy to //removeMeIfWant user
		 * entered URI data.</p>
		 * 
		 * <p>This function is intended to be a helper function.
		 * It is not all-knowning and will probably make mistakes
		 * when attempting to parse a string of unknown origin.  If
		 * your applicaiton is receiving input from the user, your
		 * application should already have a good idea what the user
		 * should  be entering, and your application should be
		 * pre-processing the user's input to make sure it is well formed
		 * before passing it to this function.</p>
		 * 
		 * <p>It is assumed that the string given to this function is
		 * something the user may have manually entered.  Given this,
		 * the URI string is probably unescaped or improperly escaped.
		 * This function will attempt to properly escape the URI by
		 * using forceEscape().  The result is that a toString() call
		 * on a URI that was created from unknownToURI() may not match
		 * the input string due to the difference in escaping.</p>
		 *
		 * @param unknown	a potental URI string that should be parsed
		 * and loaded into this object.
		 * @param defaultScheme	if it is determined that the passed string
		 * looks like a URI, but it is missing the scheme part, this
		 * string will be used as the missing scheme.
		 * 
		 * @return	true if the given string was successfully parsed into
		 * a valid URI object, false otherwise.
		 */
		public function unknownToURI(unknown:String, defaultScheme:String = "http") : Boolean
		{
			var temp:String;
			
			if (unknown.length == 0)
			{
				this.initialize();
				return false;
			}
			
			// Some users love the backslash key.  Fix it.
			unknown = unknown.replace(/\\/g, "/");
			
			// Check for any obviously missing scheme.
			if (unknown.length >= 2)
			{
				temp = unknown.substr(0, 2);
				if (temp == "//")
					unknown = defaultScheme + ":" + unknown;
			}
			
			if (unknown.length >= 3)
			{
				temp = unknown.substr(0, 3);
				if (temp == "://")
					unknown = defaultScheme + unknown;
			}

			// Try parsing it as a normal URI
			var uri:URI = new URI(unknown);
		
			if (uri.isHierarchical() == false)
			{
				if (uri.scheme == UNKNOWN_SCHEME)
				{
					this.initialize();
					return false;
				}
		
				// It's a non-hierarchical URI
				copyURI(uri);
				forceEscape();
				return true;
			}
			else if ((uri.scheme != UNKNOWN_SCHEME) &&
				(uri.scheme.length > 0))
			{
				if ( (uri.authority.length > 0) ||
					(uri.scheme == "file") )
				{
					// file://... URI
					copyURI(uri);
					forceEscape();  // ensure proper escaping
					return true;
				}
				else if (uri.authority.length == 0 && uri.path.length == 0)
				{
					// It's is an incomplete URI (eg "http://")
					
					setParts(uri.scheme, "", "", "", "", "");
					return false;
				}
			}
			else
			{
				// Possible relative URI.  We can only detect relative URI's
				// that start with "." or "..".  If it starts with something
				// else, the parsing is ambiguous.
				var path:String = uri.path;
		
				if (path == ".." || path == "." || 
					(path.length >= 3 && path.substr(0, 3) == "../") ||
					(path.length >= 2 && path.substr(0, 2) == "./") )
				{
					// This is a relative URI.
					copyURI(uri);
					forceEscape();
					return true;
				}
			}
		
			// Ok, it looks like we are just a normal URI missing the scheme.  Tack
			// on the scheme.
			uri = new URI(defaultScheme + "://" + unknown);
		
			// Check to see if we are good now
			if (uri.scheme.length > 0 && uri.authority.length > 0)
			{
				// It was just missing the scheme.
				copyURI(uri);
				forceEscape();  // Make sure we are properly encoded.
				return true;
			}
		
			// don't know what this is
			this.initialize();
			return false;
		}
		
	} // end URI class
} // end 
/* AS3JS File */
package
/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.net
{
	//removeMeIfWant flash.utils.ByteArray;
	
	/**
	 * This class implements an efficient lookup table for URI
	 * character escaping.  This class is only needed if you
	 * create a derived class of URI to handle custom URI
	 * syntax.  This class is used internally by URI.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0* 
	 */
	public class URIEncodingBitmap extends ByteArray
	{
		/**
		 * Constructor.  Creates an encoding bitmap using the given
		 * string of characters as the set of characters that need
		 * to be URI escaped.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public function URIEncodingBitmap(charsToEscape:String) : void
		{
			var i:int;
			var data:ByteArray = new ByteArray();
			
			// Initialize our 128 bits (16 bytes) to zero
			for (i = 0; i < 16; i++)
				this.writeByte(0);
				
			data.writeUTFBytes(charsToEscape);
			data.position = 0;
			
			while (data.bytesAvailable)
			{
				var c:int = data.readByte();
				
				if (c > 0x7f)
					continue;  // only escape low bytes
					
				var enc:int;
				this.position = (c >> 3);
				enc = this.readByte();
				enc |= 1 << (c & 0x7);
				this.position = (c >> 3);
				this.writeByte(enc);
			}
		}
		
		/**
		 * Based on the data table contained in this object, check
		 * if the given character should be escaped.
		 * 
		 * @param char	the character to be escaped.  Only the first
		 * character in the string is used.  Any other characters
		 * are ignored.
		 * 
		 * @return	the integer value of the raw UTF8 character.  For
		 * example, if '%' is given, the return value is 37 (0x25).
		 * If the character given does not need to be escaped, the
		 * return value is zero.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0 
		 */
		public function ShouldEscape(char:String) : int
		{
			var data:ByteArray = new ByteArray();
			var c:int, mask:int;
			
			// write the character into a ByteArray so
			// we can pull it out as a raw byte value.
			data.writeUTFBytes(char);
			data.position = 0;
			c = data.readByte();
			
			if (c & 0x80)
			{
				// don't escape high byte characters.  It can make international
				// URI's unreadable.  We just want to escape characters that would
				// make URI syntax ambiguous.
				return 0;
			}
			else if ((c < 0x1f) || (c == 0x7f))
			{
				// control characters must be escaped.
				return c;
			}
			
			this.position = (c >> 3);
			mask = this.readByte();
			
			if (mask & (1 << (c & 0x7)))
			{
				// we need to escape this, return the numeric value
				// of the character
				return c;
			}
			else
			{
				return 0;
			}
		}
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/* AS3JS File */
package com.adobe.net.proxies
{
	//removeMeIfWant flash.events.Event;
	//removeMeIfWant flash.events.IOErrorEvent;
	//removeMeIfWant flash.events.ProgressEvent;
	//removeMeIfWant flash.net.Socket;

	/**
	 * This class allows TCP socket connections through HTTP proxies in accordance with
	 * RFC 2817:
	 * 
	 * ftp://ftp.rfc-editor.org/in-notes/rfc2817.txt
	 * 
	 * It can also be used to make direct connections to a destination, as well. If you
	 * pass the host and port into the constructor, no proxy will be used. You can also
	 * call connect, passing in the host and the port, and if you didn't set the proxy
	 * info, a direct connection will be made. A proxy is only used after you have called
	 * the setProxyInfo function.
	 * 
	 * The connection to and negotiation with the proxy is completely hidden. All the
	 * same events are thrown whether you are using a proxy or not, and the data you
	 * receive from the target server will look exact as it would if you were connected
	 * to it directly rather than through a proxy.
	 * 
	 * @author Christian Cantrell
	 * 
	 **/
	public class RFC2817Socket
		extends Socket
	{
		private var proxyHost:String = null;
		private var host:String = null;
		private var proxyPort:int = 0;
		private var port:int = 0;
		private var deferredEventHandlers:Object = new Object();
		private var buffer:String = new String();

		/**
		 * Construct a new RFC2817Socket object. If you pass in the host and the port,
		 * no proxy will be used. If you want to use a proxy, instantiate with no
		 * arguments, call setProxyInfo, then call connect.
		 **/
		public function RFC2817Socket(host:String = null, port:int = 0)
		{
			if (host != null && port != 0)
			{
				super(host, port);
			}
		}
		
		/**
		 * Set the proxy host and port number. Your connection will only proxied if
		 * this function has been called.
		 **/
		public function setProxyInfo(host:String, port:int):void
		{
			this.proxyHost = host;
			this.proxyPort = port;

			var deferredSocketDataHandler:Object = this.deferredEventHandlers[ProgressEvent.SOCKET_DATA];
			var deferredConnectHandler:Object = this.deferredEventHandlers[Event.CONNECT];

			if (deferredSocketDataHandler != null)
			{
				super.removeEventListener(ProgressEvent.SOCKET_DATA, deferredSocketDataHandler.listener, deferredSocketDataHandler.useCapture);
			}

			if (deferredConnectHandler != null)
			{
				super.removeEventListener(Event.CONNECT, deferredConnectHandler.listener, deferredConnectHandler.useCapture);
			}
		}
		
		/**
		 * Connect to the specified host over the specified port. If you want your
		 * connection proxied, call the setProxyInfo function first.
		 **/
		public override function connect(host:String, port:int):void
		{
			if (this.proxyHost == null)
			{
				this.redirectConnectEvent();
				this.redirectSocketDataEvent();
				super.connect(host, port);
			}
			else
			{
				this.host = host;
				this.port = port;
				super.addEventListener(Event.CONNECT, this.onConnect);
				super.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
				super.connect(this.proxyHost, this.proxyPort);
			}
		}

		private function onConnect(event:Event):void
		{
			this.writeUTFBytes("CONNECT "+this.host+":"+this.port+" HTTP/1.1\n\n");
			this.flush();
			this.redirectConnectEvent();
		}
		
		private function onSocketData(event:ProgressEvent):void
		{
			while (this.bytesAvailable != 0)
			{
				this.buffer += this.readUTFBytes(1);
				if (this.buffer.search(/\r?\n\r?\n$/) != -1)
				{
					this.checkResponse(event);
					break;
				}
			}
		}
		
		private function checkResponse(event:ProgressEvent):void
		{
			var responseCode:String = this.buffer.substr(this.buffer.indexOf(" ")+1, 3);

			if (responseCode.search(/^2/) == -1)
			{
				var ioError:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
				ioError.text = "Error connecting to the proxy ["+this.proxyHost+"] on port ["+this.proxyPort+"]: " + this.buffer;
				this.dispatchEvent(ioError);
			}
			else
			{
				this.redirectSocketDataEvent();
				this.dispatchEvent(new Event(Event.CONNECT));
				if (this.bytesAvailable > 0)
				{
					this.dispatchEvent(event);
				}
			}
			this.buffer = null;
		}
		
		private function redirectConnectEvent():void
		{
			super.removeEventListener(Event.CONNECT, onConnect);
			var deferredEventHandler:Object = this.deferredEventHandlers[Event.CONNECT];
			if (deferredEventHandler != null)
			{
				super.addEventListener(Event.CONNECT, deferredEventHandler.listener, deferredEventHandler.useCapture, deferredEventHandler.priority, deferredEventHandler.useWeakReference);			
			}
		}
		
		private function redirectSocketDataEvent():void
		{
			super.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			var deferredEventHandler:Object = this.deferredEventHandlers[ProgressEvent.SOCKET_DATA];
			if (deferredEventHandler != null)
			{
				super.addEventListener(ProgressEvent.SOCKET_DATA, deferredEventHandler.listener, deferredEventHandler.useCapture, deferredEventHandler.priority, deferredEventHandler.useWeakReference);			
			}
		}
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int=0.0, useWeakReference:Boolean=false):void
		{
			if (type == Event.CONNECT || type == ProgressEvent.SOCKET_DATA)
			{
				this.deferredEventHandlers[type] = {listener:listener,useCapture:useCapture, priority:priority, useWeakReference:useWeakReference};
			}
			else
			{
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
	}
}/*

	Licence
	
		Copyright (c) 2005 JSON.org

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
	
		The Software shall be used for Good, not Evil.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
	
	Contributor(s) :
	
		- Ported to Actionscript May 2005 by Trannie Carter <tranniec@designvox.com>, wwww.designvox.com
		
		- Alcaraz Marc (aka eKameleon) 2006-01-24 <vegas@ekameleon.net>
		
			- Refactoring AS2 and MTASC Compatibilty
			
			- Add Hexa Digits in 'deserialize' method -
			
			NOTE : EDEN Hexa digits code inspiration -> http://www.burrrn.com/projects/eden.html

*/

/* JSON

	AUTHOR
	
		Name : JSON
		Package : vegas.string
		Version : 1.0.0.0
		Date :  2006-07-09
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	DESCRIPTION

		JSON (JavaScript object Notation) is a lightweight data-interchange format.
			
		Serializer & deserializer in AS2.
		
		MORE INFORMATION IN : http://www.json.org/
	
		ADD HEXA DIGITS in deserialize method - EDEN inspiration : http://www.burrrn.com/projects/eden.html
	
	METHOD SUMMARY
	
		- static deserialize(source:String):*
		
		- static serialize(o:*):String
	
	EXAMPLE

		//removeMeIfWant vegas.string.JSON ;
				
		// --- Init
		var a:Array = [2, true, "hello"] ;
		var o:Object = { prop1 : 1 , prop2 : 2 } ;
		var s:String = "hello world" ;
		var n:Number = 4 ;
		var b:Boolean = true ;
					
		trace ("*** Serialize") ;
		trace("* a : " + JSON.serialize( a ) )  ;
		trace("* o : " + JSON.serialize( o ) )  ;
		trace("* s : " + JSON.serialize( s ) )  ;
		trace("* n : " + JSON.serialize( n ) )  ;
		trace("* b : " + JSON.serialize( b ) )  ;
				
		trace ("*** Deserialize") ;
		
		var source:String = '[ {"prop1":0xFF0000, "prop2":2, "prop3":"hello", "prop4":true} , 2, true,	3, [3, 2] ]' ;
		
		//removeMeIfWant vegas.util.ClassUtil ;
		
		var result:* = JSON.deserialize(source) ;
		for (var prop:String in result)
		{
			trace(prop + " : " + result[prop] + " -> " + ClassUtil.getPath(result[prop])) ;
		}
		
		trace ("*** JSONError") ;
		
		var source:String = "[3, 2," ; // test1
		//var source:String = '{"prop1":coucou"}' ; // test2
		var o = JSON.deserialize(source) ;
		for (var prop:String in o) {
			trace(prop + " : " + o[prop]) ;
		}
	
		
	Revision: 2008-07-24 DZ - Added allowing numbers with scientific notation
	Revision: 2008-09-05 DZ - Allow comma before final brace/bracket of objects/arrays
	
**/

// TODO REFACTORING PLEASE - type and co... !!!!!!


/* AS3JS File */
package com.serialization.json
{
	
	public class JSON
	{
		
	// ----o Public Methods

	static public function deserialize(source:String):* {
		
		source = new String(source) ; // Speed
		var at:Number = 0 ;
        var ch:String = ' ';
		
		var _isDigit:Function ;
		var _isHexDigit:Function ;
		var _white:Function ;
		var _string:Function ;
		var _next:Function ;
		var _array:Function ;
		var _object:Function ;
		var _number:Function ;
		var _word:Function ;
		var _value:Function ;
		var _error:Function ;
		
		_isDigit = function( /*Char*/ c:String ):* {
    		return( ("0" <= c) && (c <= "9") );
    	} ;
			
		_isHexDigit = function( /*Char*/ c:String ):* {
    		return( _isDigit( c ) || (("A" <= c) && (c <= "F")) || (("a" <= c) && (c <= "f")) );
    	} ;
				
        _error = function(m:String):void {
            //throw new JSONError( m, at - 1 , source) ;
            throw new Error(m, at-1);
        } ;
		
        _next = function():* {
            ch = source.charAt(at);
            at += 1;
            return ch;
        } ;
		
        _white = function ():void {
           while (ch) {
                if (ch <= ' ') {
                    _next();
                } else if (ch == '/') {
                    switch (_next()) {
                        case '/':
                            while (_next() && ch != '\n' && ch != '\r') {}
                            break;
                        case '*':
                            _next();
                            for (;;) {
                                if (ch) {
                                    if (ch == '*') {
                                        if (_next() == '/') {
                                            _next();
                                            break;
                                        }
                                    } else {
                                        _next();
                                    }
                                } else {
                                    _error("Unterminated Comment");
                                }
                            }
                            break;
                        default:
                            _error("Syntax Error");
                    }
                } else {
                    break;
                }
            }
        };
		
        _string = function ():* {

            var i:* = '' ;
            var s:* = '' ;
            var t:* ;
            var u:* ;
			var outer:Boolean = false;
			
            if (ch == '"') {
				
				while (_next()) {
                    if (ch == '"')
                    {
                        _next();
                        return s;
                    }
                    else if (ch == '\\')
                    {
                        switch (_next()) {
                        case 'b':
                            s += '\b';
                            break;
                        case 'f':
                            s += '\f';
                            break;
                        case 'n':
                            s += '\n';
                            break;
                        case 'r':
                            s += '\r';
                            break;
                        case 't':
                            s += '\t';
                            break;
                        case 'u':
                            u = 0;
                            for (i = 0; i < 4; i += 1) {
                                t = parseInt(_next(), 16);
                                if (!isFinite(t)) {
                                    outer = true;
									break;
                                }
                                u = u * 16 + t;
                            }
							if(outer) {
								outer = false;
								break;
							}
                            s += String.fromCharCode(u);
                            break;
                        default:
                            s += ch;
                        }
                    } else {
                        s += ch;
                    }
                }
            }
            _error("Bad String");
            return null ;
        } ;
		
        _array = function():* {
            var a:Array = [];
            if (ch == '[') {
                _next();
                _white();
                if (ch == ']') {
                    _next();
                    return a;
                }
                while (ch) {
                    a.push(_value());
                    _white();
                    if (ch == ']') {
                        _next();
                        return a;
                    } else if (ch != ',') {
                        break;
                    }
                    _next();
                    _white();
					// Allow for an extra comma before ending bracket
                    if (ch == ']') {
                        _next();
                        return a;
					}
                }
            }
            _error("Bad Array");
            return null ;
        };
		
        _object = function ():* {
            var k:* = {} ;
            var o:* = {} ;
            if (ch == '{') {

                _next();

                _white();

                if (ch == '}')
                {
                    _next() ;
                    return o ;
                }

                while (ch)
                {
                    k = _string();
                    _white();
                    if (ch != ':')
                    {
                        break;
                    }
                    _next();
                    o[k] = _value();
                    _white();
                    if (ch == '}') {
                        _next();
                        return o;
                    } else if (ch != ',') {
                        break;
                    }
                    _next();
                    _white();
					// Allow for an extra comma before ending brace
                    if (ch == '}') {
                        _next();
                        return o;
					}
                }
            }
            _error("Bad Object") ;
        };
		
        _number = function ():* {

            var n:* = '' ;
            var e:* = '' ;
            var v:* ;
			var exp:* ;
			var hex:String = '' ;
			var sign:String = '' ;
			
            if (ch == '-') {
                n = '-';
                sign = n ;
                _next();
            }

            if( ch == "0" ) {
        		_next() ;
				if( ( ch == "x") || ( ch == "X") ) {
            		_next();
            		while( _isHexDigit( ch ) ) {
                		hex += ch ;
                		_next();
                	}
            		if( hex == "" ) {
            			_error("mal formed Hexadecimal") ;
					} else {
						return Number( sign + "0x" + hex ) ;
					}
            	} else {
	            	n += "0" ;
            	}
			}
				
            while ( _isDigit(ch) ) {
                n += ch;
                _next();
            }
            if (ch == '.') {
                n += '.';
                while (_next() && ch >= '0' && ch <= '9') {
                    n += ch;
                }
            }
            v = 1 * n ;
            if (!isFinite(v)) {
                _error("Bad Number");
            } else {
				if ((ch == 'e') || (ch == 'E'))
				{
					// Continue processing exponent
					_next();
					var expSign:int = (ch == '-') ? -1 : 1;
					// allow for a digit without a + sign
					if ((ch == '+') || (ch == '-'))
					{
						_next();
					}
					if (_isDigit(ch))
					{
						e += ch;
					}
					else
					{
						_error("Bad Exponent");
					}
					while (_next() && ch >= '0' && ch <= '9') 
					{
						e += ch;
					}
					exp = expSign * e;
					if (!isFinite(v)) 
					{
						_error("Bad Exponent");
					}
					else 
					{
						v = v * Math.pow(10, exp);
						//trace("JSON._number - have exponent: n=" + n + "  e=" + e + "  v=" + v);
					}
				}
                return v;
            }

            return NaN ;

        };
		
        _word = function ():* {
            switch (ch) {
                case 't':
                    if (_next() == 'r' && _next() == 'u' && _next() == 'e') {
                        _next();
                        return true;
                    }
                    break;
                case 'f':
                    if (_next() == 'a' && _next() == 'l' && _next() == 's' && _next() == 'e') {
                        _next();
                        return false;
                    }
                    break;
                case 'n':
                    if (_next() == 'u' && _next() == 'l' && _next() == 'l') {
                        _next();
                        return null;
                    }
                    break;
            }
            _error("Syntax Error");
            return null ;
        };
		
        _value = function ():* {
            _white();
            switch (ch) {
                case '{':
                    return _object();
                case '[':
                    return _array();
                case '"':
                    return _string();
                case '-':
                    return _number();
                default:
                    return ch >= '0' && ch <= '9' ? _number() : _word();
            }
        };
		
        return _value() ;
		
    }
	
		static public function serialize(o:*):String {

    	    var c:String ; // char
	        var i:Number ;
        	var l:Number ;
			var s:String = '' ;
			var v:* ;
		
	        switch (typeof o)
    	    {

				case 'object' :
			
					if (o)
					{
						if (o is Array)
						{
						
							l = o.length ;
						
							for (i = 0 ; i < l ; ++i)
							{
								v = serialize(o[i]);
								if (s) s += ',' ;
								s += v ;
							}
							return '[' + s + ']';
						
						}
						else if (typeof(o.toString) != 'undefined')
						{
							
							for (var prop:String in o)
							{
								v = o[prop];
								if ( (typeof(v) != 'undefined') && (typeof(v) != 'function') )
								{
									v = serialize(v);
									if (s) s += ',';
									s += serialize(prop) + ':' + v ;
								}
							}
							return "{" + s + "}";
						}
					}
					return 'null';
			
				case 'number':
				
					return isFinite(o) ? String(o) : 'null' ;
				
				case 'string' :
				
					l = o.length ;
					s = '"';
					for (i = 0 ; i < l ; i += 1) {
						c = o.charAt(i);
						if (c >= ' ') {
							if (c == '\\' || c == '"')
							{
								s += '\\';
							}
							s += c;
						}
						else
						{
							switch (c)
							{
								
								case '\b':
									s += '\\b';
									break;
								case '\f':
									s += '\\f';
									break;
								case '\n':
									s += '\\n';
									break;
								case '\r':
									s += '\\r';
									break;
								case '\t':
									s += '\\t';
									break;
								default:
									var code:Number = c.charCodeAt() ;
									s += '\\u00' + (Math.floor(code / 16).toString(16)) + ((code % 16).toString(16)) ;
							}
						}
					}
					return s + '"';
				
				case 'boolean':
					return String(o);
				
				default:
					return 'null';
				
        	}
   		}
	}
}/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.serialization.json {

	public class JSONDecoder {
		
		/** The value that will get parsed from the JSON string */
		private var value:*;
		
		/** The tokenizer designated to read the JSON string */
		private var tokenizer:JSONTokenizer;
		
		/** The current token from the tokenizer */
		private var token:JSONToken;
		
		/**
		 * Constructs a new JSONDecoder to parse a JSON string 
		 * into a native object.
		 *
		 * @param s The JSON string to be converted
		 *		into a native object
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function JSONDecoder( s:String ) {
			
			tokenizer = new JSONTokenizer( s );
			
			nextToken();
			value = parseValue();
		}
		
		/**
		 * Gets the internal object that was created by parsing
		 * the JSON string passed to the constructor.
		 *
		 * @return The internal object representation of the JSON
		 * 		string that was passed to the constructor
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function getValue():* {
			return value;
		}
		
		/**
		 * Returns the next token from the tokenzier reading
		 * the JSON string
		 */
		private function nextToken():JSONToken {
			return token = tokenizer.getNextToken();
		}
		
		/**
		 * Attempt to parse an array
		 */
		private function parseArray():Array {
			// create an array internally that we're going to attempt
			// to parse from the tokenizer
			var a:Array = new Array();
			
			// grab the next token from the tokenizer to move
			// past the opening [
			nextToken();
			
			// check to see if we have an empty array
			if ( token.type == JSONTokenType.RIGHT_BRACKET ) {
				// we're done reading the array, so return it
				return a;
			}
			
			// deal with elements of the array, and use an "infinite"
			// loop because we could have any amount of elements
			while ( true ) {
				// read in the value and add it to the array
				a.push ( parseValue() );
			
				// after the value there should be a ] or a ,
				nextToken();
				
				if ( token.type == JSONTokenType.RIGHT_BRACKET ) {
					// we're done reading the array, so return it
					return a;
				} else if ( token.type == JSONTokenType.COMMA ) {
					// move past the comma and read another value
					nextToken();
				} else {
					tokenizer.parseError( "Expecting ] or , but found " + token.value );
				}
			}
            return null;
		}
		
		/**
		 * Attempt to parse an object
		 */
		private function parseObject():Object {
			// create the object internally that we're going to
			// attempt to parse from the tokenizer
			var o:Object = new Object();
						
			// store the string part of an object member so
			// that we can assign it a value in the object
			var key:String
			
			// grab the next token from the tokenizer
			nextToken();
			
			// check to see if we have an empty object
			if ( token.type == JSONTokenType.RIGHT_BRACE ) {
				// we're done reading the object, so return it
				return o;
			}
			
			// deal with members of the object, and use an "infinite"
			// loop because we could have any amount of members
			while ( true ) {
			
				if ( token.type == JSONTokenType.STRING ) {
					// the string value we read is the key for the object
					key = String( token.value );
					
					// move past the string to see what's next
					nextToken();
					
					// after the string there should be a :
					if ( token.type == JSONTokenType.COLON ) {
						
						// move past the : and read/assign a value for the key
						nextToken();
						o[key] = parseValue();	
						
						// move past the value to see what's next
						nextToken();
						
						// after the value there's either a } or a ,
						if ( token.type == JSONTokenType.RIGHT_BRACE ) {
							// // we're done reading the object, so return it
							return o;
							
						} else if ( token.type == JSONTokenType.COMMA ) {
							// skip past the comma and read another member
							nextToken();
						} else {
							tokenizer.parseError( "Expecting } or , but found " + token.value );
						}
					} else {
						tokenizer.parseError( "Expecting : but found " + token.value );
					}
				} else {
					tokenizer.parseError( "Expecting string but found " + token.value );
				}
			}
            return null;
		}
		
		/**
		 * Attempt to parse a value
		 */
		private function parseValue():Object {
					
			switch ( token.type ) {
				case JSONTokenType.LEFT_BRACE:
					return parseObject();
					
				case JSONTokenType.LEFT_BRACKET:
					return parseArray();
					
				case JSONTokenType.STRING:
				case JSONTokenType.NUMBER:
				case JSONTokenType.TRUE:
				case JSONTokenType.FALSE:
				case JSONTokenType.NULL:
					return token.value;

				default:
					tokenizer.parseError( "Unexpected " + token.value );
					
			}
            return null;
		}
	}
}
/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.serialization.json 
{

	//removeMeIfWant flash.utils.describeType;

	public class JSONEncoder {
	
		/** The string that is going to represent the object we're encoding */
		private var jsonString:String;
		
		/**
		 * Creates a new JSONEncoder.
		 *
		 * @param o The object to encode as a JSON string
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function JSONEncoder( value:* ) {
			jsonString = convertToString( value );
		
		}
		
		/**
		 * Gets the JSON string from the encoder.
		 *
		 * @return The JSON string representation of the object
		 * 		that was passed to the constructor
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function getString():String {
			return jsonString;
		}
		
		/**
		 * Converts a value to it's JSON string equivalent.
		 *
		 * @param value The value to convert.  Could be any 
		 *		type (object, number, array, etc)
		 */
		private function convertToString( value:* ):String {
			
			// determine what value is and convert it based on it's type
			if ( value is String ) {
				
				// escape the string so it's formatted correctly
				return escapeString( value as String );
				
			} else if ( value is Number ) {
				
				// only encode numbers that finate
				return isFinite( value as Number) ? value.toString() : "null";

			} else if ( value is Boolean ) {
				
				// convert boolean to string easily
				return value ? "true" : "false";

			} else if ( value is Array ) {
			
				// call the helper method to convert an array
				return arrayToString( value as Array );
			
			} else if ( value is Object && value != null ) {
			
				// call the helper method to convert an object
				return objectToString( value );
			}
            return "null";
		}
		
		/**
		 * Escapes a string accoding to the JSON specification.
		 *
		 * @param str The string to be escaped
		 * @return The string with escaped special characters
		 * 		according to the JSON specification
		 */
		private function escapeString( str:String ):String {
			// create a string to store the string's jsonstring value
			var s:String = "";
			// current character in the string we're processing
			var ch:String;
			// store the length in a local variable to reduce lookups
			var len:Number = str.length;
			
			// loop over all of the characters in the string
			for ( var i:int = 0; i < len; i++ ) {
			
				// examine the character to determine if we have to escape it
				ch = str.charAt( i );
				switch ( ch ) {
				
					case '"':	// quotation mark
						s += "\\\"";
						break;
						
					//case '/':	// solidus
					//	s += "\\/";
					//	break;
						
					case '\\':	// reverse solidus
						s += "\\\\";
						break;
						
					case '\b':	// bell
						s += "\\b";
						break;
						
					case '\f':	// form feed
						s += "\\f";
						break;
						
					case '\n':	// newline
						s += "\\n";
						break;
						
					case '\r':	// carriage return
						s += "\\r";
						break;
						
					case '\t':	// horizontal tab
						s += "\\t";
						break;
						
					default:	// everything else
						
						// check for a control character and escape as unicode
						if ( ch < ' ' ) {
							// get the hex digit(s) of the character (either 1 or 2 digits)
							var hexCode:String = ch.charCodeAt( 0 ).toString( 16 );
							
							// ensure that there are 4 digits by adjusting
							// the # of zeros accordingly.
							var zeroPad:String = hexCode.length == 2 ? "00" : "000";
							
							// create the unicode escape sequence with 4 hex digits
							s += "\\u" + zeroPad + hexCode;
						} else {
						
							// no need to do any special encoding, just pass-through
							s += ch;
							
						}
				}	// end switch
				
			}	// end for loop
						
			return "\"" + s + "\"";
		}
		
		/**
		 * Converts an array to it's JSON string equivalent
		 *
		 * @param a The array to convert
		 * @return The JSON string representation of <code>a</code>
		 */
		private function arrayToString( a:Array ):String {
			// create a string to store the array's jsonstring value
			var s:String = "";
			
			// loop over the elements in the array and add their converted
			// values to the string
			for ( var i:int = 0; i < a.length; i++ ) {
				// when the length is 0 we're adding the first element so
				// no comma is necessary
				if ( s.length > 0 ) {
					// we've already added an element, so add the comma separator
					s += ","
				}
				
				// convert the value to a string
				s += convertToString( a[i] );	
			}
			
			// KNOWN ISSUE:  In ActionScript, Arrays can also be associative
			// objects and you can put anything in them, ie:
			//		myArray["foo"] = "bar";
			//
			// These properties aren't picked up in the for loop above because
			// the properties don't correspond to indexes.  However, we're
			// sort of out luck because the JSON specification doesn't allow
			// these types of array properties.
			//
			// So, if the array was also used as an associative object, there
			// may be some values in the array that don't get properly encoded.
			//
			// A possible solution is to instead encode the Array as an Object
			// but then it won't get decoded correctly (and won't be an
			// Array instance)
						
			// close the array and return it's string value
			return "[" + s + "]";
		}
		
		/**
		 * Converts an object to it's JSON string equivalent
		 *
		 * @param o The object to convert
		 * @return The JSON string representation of <code>o</code>
		 */
		private function objectToString( o:Object ):String
		{
			// create a string to store the object's jsonstring value
			var s:String = "";
			
			// determine if o is a class instance or a plain object
			var classInfo:XML = describeType( o );
			if ( classInfo.@name.toString() == "Object" )
			{
				// the value of o[key] in the loop below - store this 
				// as a variable so we don't have to keep looking up o[key]
				// when testing for valid values to convert
				var value:Object;
				
				// loop over the keys in the object and add their converted
				// values to the string
				for ( var key:String in o )
				{
					// assign value to a variable for quick lookup
					value = o[key];
					
					// don't add function's to the JSON string
					if ( value is Function )
					{
						// skip this key and try another
						continue;
					}
					
					// when the length is 0 we're adding the first item so
					// no comma is necessary
					if ( s.length > 0 ) {
						// we've already added an item, so add the comma separator
						s += ","
					}
					
					s += escapeString( key ) + ":" + convertToString( value );
				}
			}
			else // o is a class instance
			{
				// Loop over all of the variables and accessors in the class and 
				// serialize them along with their values.
				for each ( var v:XML in classInfo..*.( name() == "variable" || name() == "accessor" ) )
				{
					// When the length is 0 we're adding the first item so
					// no comma is necessary
					if ( s.length > 0 ) {
						// We've already added an item, so add the comma separator
						s += ","
					}
					
					s += escapeString( v.@name.toString() ) + ":" 
							+ convertToString( o[ v.@name ] );
				}
				
			}
			
			return "{" + s + "}";
		}

		
	}
	
}
/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.serialization.json {

	/**
	 *
	 *
	 */
	public class JSONParseError extends Error 	{
	
		/** The location in the string where the error occurred */
		private var _location:int;
		
		/** The string in which the parse error occurred */
		private var _text:String;
	
		/**
		 * Constructs a new JSONParseError.
		 *
		 * @param message The error message that occured during parsing
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function JSONParseError( message:String = "", location:int = 0, text:String = "") {
			super( message );
			//name = "JSONParseError";
			_location = location;
			_text = text;
		}

		/**
		 * Provides read-only access to the location variable.
		 *
		 * @return The location in the string where the error occurred
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function get location():int {
			return _location;
		}
		
		/**
		 * Provides read-only access to the text variable.
		 *
		 * @return The string in which the error occurred
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function get text():String {
			return _text;
		}
	}
	
}/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.serialization.json {

	public class JSONToken {
	
		private var _type:int;
		private var _value:Object;
		
		/**
		 * Creates a new JSONToken with a specific token type and value.
		 *
		 * @param type The JSONTokenType of the token
		 * @param value The value of the token
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function JSONToken( type:int = -1 /* JSONTokenType.UNKNOWN */, value:Object = null ) {
			_type = type;
			_value = value;
		}
		
		/**
		 * Returns the type of the token.
		 *
		 * @see com.adobe.serialization.json.JSONTokenType
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function get type():int {
			return _type;	
		}
		
		/**
		 * Sets the type of the token.
		 *
		 * @see com.adobe.serialization.json.JSONTokenType
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function set type( value:int ):void {
			_type = value;	
		}
		
		/**
		 * Gets the value of the token
		 *
		 * @see com.adobe.serialization.json.JSONTokenType
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function get value():Object {
			return _value;	
		}
		
		/**
		 * Sets the value of the token
		 *
		 * @see com.adobe.serialization.json.JSONTokenType
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function set value ( v:Object ):void {
			_value = v;	
		}

	}
	
}/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.serialization.json {

	public class JSONTokenizer {
	
		/** The object that will get parsed from the JSON string */
		private var obj:Object;
		
		/** The JSON string to be parsed */
		private var jsonString:String;
		
		/** The current parsing location in the JSON string */
		private var loc:int;
		
		/** The current character in the JSON string during parsing */
		private var ch:String;
		
		/**
		 * Constructs a new JSONDecoder to parse a JSON string 
		 * into a native object.
		 *
		 * @param s The JSON string to be converted
		 *		into a native object
		 */
		public function JSONTokenizer( s:String ) {
			jsonString = s;
			loc = 0;
			
			// prime the pump by getting the first character
			nextChar();
		}
		
		/**
		 * Gets the next token in the input sting and advances
		* the character to the next character after the token
		 */
		public function getNextToken():JSONToken {
			var token:JSONToken = new JSONToken();
			
			// skip any whitespace / comments since the last 
			// token was read
			skipIgnored();
						
			// examine the new character and see what we have...
			switch ( ch ) {
				
				case '{':
					token.type = JSONTokenType.LEFT_BRACE;
					token.value = '{';
					nextChar();
					break
					
				case '}':
					token.type = JSONTokenType.RIGHT_BRACE;
					token.value = '}';
					nextChar();
					break
					
				case '[':
					token.type = JSONTokenType.LEFT_BRACKET;
					token.value = '[';
					nextChar();
					break
					
				case ']':
					token.type = JSONTokenType.RIGHT_BRACKET;
					token.value = ']';
					nextChar();
					break
				
				case ',':
					token.type = JSONTokenType.COMMA;
					token.value = ',';
					nextChar();
					break
					
				case ':':
					token.type = JSONTokenType.COLON;
					token.value = ':';
					nextChar();
					break;
					
				case 't': // attempt to read true
					var possibleTrue:String = "t" + nextChar() + nextChar() + nextChar();
					
					if ( possibleTrue == "true" ) {
						token.type = JSONTokenType.TRUE;
						token.value = true;
						nextChar();
					} else {
						parseError( "Expecting 'true' but found " + possibleTrue );
					}
					
					break;
					
				case 'f': // attempt to read false
					var possibleFalse:String = "f" + nextChar() + nextChar() + nextChar() + nextChar();
					
					if ( possibleFalse == "false" ) {
						token.type = JSONTokenType.FALSE;
						token.value = false;
						nextChar();
					} else {
						parseError( "Expecting 'false' but found " + possibleFalse );
					}
					
					break;
					
				case 'n': // attempt to read null
				
					var possibleNull:String = "n" + nextChar() + nextChar() + nextChar();
					
					if ( possibleNull == "null" ) {
						token.type = JSONTokenType.NULL;
						token.value = null;
						nextChar();
					} else {
						parseError( "Expecting 'null' but found " + possibleNull );
					}
					
					break;
					
				case '"': // the start of a string
					token = readString();
					break;
					
				default: 
					// see if we can read a number
					if ( isDigit( ch ) || ch == '-' ) {
						token = readNumber();
					} else if ( ch == '' ) {
						// check for reading past the end of the string
						return null;
					} else {						
						// not sure what was in the input string - it's not
						// anything we expected
						parseError( "Unexpected " + ch + " encountered" );
					}
			}
			
			return token;
		}
		
		/**
		 * Attempts to read a string from the input string.  Places
		 * the character location at the first character after the
		 * string.  It is assumed that ch is " before this method is called.
		 *
		 * @return the JSONToken with the string value if a string could
		 *		be read.  Throws an error otherwise.
		 */
		private function readString():JSONToken {
			// the token for the string we'll try to read
			var token:JSONToken = new JSONToken();
			token.type = JSONTokenType.STRING;
			
			// the string to store the string we'll try to read
			var string:String = "";
			
			// advance past the first "
			nextChar();
			
			while ( ch != '"' && ch != '' ) {
								
				// unescape the escape sequences in the string
				if ( ch == '\\' ) {
					
					// get the next character so we know what
					// to unescape
					nextChar();
					
					switch ( ch ) {
						
						case '"': // quotation mark
							string += '"';
							break;
						
						case '/':	// solidus
							string += "/";
							break;
							
						case '\\':	// reverse solidus
							string += '\\';
							break;
							
						case 'b':	// bell
							string += '\b';
							break;
							
						case 'f':	// form feed
							string += '\f';
							break;
							
						case 'n':	// newline
							string += '\n';
							break;
							
						case 'r':	// carriage return
							string += '\r';
							break;
							
						case 't':	// horizontal tab
							string += '\t'
							break;
						
						case 'u':
							// convert a unicode escape sequence
							// to it's character value - expecting
							// 4 hex digits
							
							// save the characters as a string we'll convert to an int
							var hexValue:String = "";
							
							// try to find 4 hex characters
							for ( var i:int = 0; i < 4; i++ ) {
								// get the next character and determine
								// if it's a valid hex digit or not
								if ( !isHexDigit( nextChar() ) ) {
									parseError( " Excepted a hex digit, but found: " + ch );
								}
								// valid, add it to the value
								hexValue += ch;
							}
							
							// convert hexValue to an integer, and use that
							// integrer value to create a character to add
							// to our string.
							string += String.fromCharCode( parseInt( hexValue, 16 ) );
							
							break;
					
						default:
							// couldn't unescape the sequence, so just
							// pass it through
							string += '\\' + ch;
						
					}
					
				} else {
					// didn't have to unescape, so add the character to the string
					string += ch;
					
				}
				
				// move to the next character
				nextChar();
				
			}
			
			// we read past the end of the string without closing it, which
			// is a parse error
			if ( ch == '' ) {
				parseError( "Unterminated string literal" );
			}
			
			// move past the closing " in the input string
			nextChar();
			
			// attach to the string to the token so we can return it
			token.value = string;
			
			return token;
		}
		
		/**
		 * Attempts to read a number from the input string.  Places
		 * the character location at the first character after the
		 * number.
		 * 
		 * @return The JSONToken with the number value if a number could
		 * 		be read.  Throws an error otherwise.
		 */
		private function readNumber():JSONToken {
			// the token for the number we'll try to read
			var token:JSONToken = new JSONToken();
			token.type = JSONTokenType.NUMBER;
			
			// the string to accumulate the number characters
			// into that we'll convert to a number at the end
			var input:String = "";
			
			// check for a negative number
			if ( ch == '-' ) {
				input += '-';
				nextChar();
			}
			
			// the number must start with a digit
			if ( !isDigit( ch ) )
			{
				parseError( "Expecting a digit" );
			}
			
			// 0 can only be the first digit if it
			// is followed by a decimal point
			if ( ch == '0' )
			{
				input += ch;
				nextChar();
				
				// make sure no other digits come after 0
				if ( isDigit( ch ) )
				{
					parseError( "A digit cannot immediately follow 0" );
				}
			}
			else
			{
				// read numbers while we can
				while ( isDigit( ch ) ) {
					input += ch;
					nextChar();
				}
			}
			
			// check for a decimal value
			if ( ch == '.' ) {
				input += '.';
				nextChar();
				
				// after the decimal there has to be a digit
				if ( !isDigit( ch ) )
				{
					parseError( "Expecting a digit" );
				}
				
				// read more numbers to get the decimal value
				while ( isDigit( ch ) ) {
					input += ch;
					nextChar();
				}
			}
			
			// check for scientific notation
			if ( ch == 'e' || ch == 'E' )
			{
				input += "e"
				nextChar();
				// check for sign
				if ( ch == '+' || ch == '-' )
				{
					input += ch;
					nextChar();
				}
				
				// require at least one number for the exponent
				// in this case
				if ( !isDigit( ch ) )
				{
					parseError( "Scientific notation number needs exponent value" );
				}
							
				// read in the exponent
				while ( isDigit( ch ) )
				{
					input += ch;
					nextChar();
				}
			}
			
			// convert the string to a number value
			var num:Number = Number( input );
			
			if ( isFinite( num ) && !isNaN( num ) ) {
				token.value = num;
				return token;
			} else {
				parseError( "Number " + num + " is not valid!" );
			}
            return null;
		}

		/**
		 * Reads the next character in the input
		 * string and advances the character location.
		 *
		 * @return The next character in the input string, or
		 *		null if we've read past the end.
		 */
		private function nextChar():String {
			return ch = jsonString.charAt( loc++ );
		}
		
		/**
		 * Advances the character location past any
		 * sort of white space and comments
		 */
		private function skipIgnored():void {
			skipWhite();
			skipComments();
			skipWhite();
		}
		
		/**
		 * Skips comments in the input string, either
		 * single-line or multi-line.  Advances the character
		 * to the first position after the end of the comment.
		 */
		private function skipComments():void {
			if ( ch == '/' ) {
				// Advance past the first / to find out what type of comment
				nextChar();
				switch ( ch ) {
					case '/': // single-line comment, read through end of line
						
						// Loop over the characters until we find
						// a newline or until there's no more characters left
						do {
							nextChar();
						} while ( ch != '\n' && ch != '' )
						
						// move past the \n
						nextChar();
						
						break;
					
					case '*': // multi-line comment, read until closing */

						// move past the opening *
						nextChar();
						
						// try to find a trailing */
						while ( true ) {
							if ( ch == '*' ) {
								// check to see if we have a closing /
								nextChar();
								if ( ch == '/') {
									// move past the end of the closing */
									nextChar();
									break;
								}
							} else {
								// move along, looking if the next character is a *
								nextChar();
							}
							
							// when we're here we've read past the end of 
							// the string without finding a closing */, so error
							if ( ch == '' ) {
								parseError( "Multi-line comment not closed" );
							}
						}

						break;
					
					// Can't match a comment after a /, so it's a parsing error
					default:
						parseError( "Unexpected " + ch + " encountered (expecting '/' or '*' )" );
				}
			}
			
		}
		
		
		/**
		 * Skip any whitespace in the input string and advances
		 * the character to the first character after any possible
		 * whitespace.
		 */
		private function skipWhite():void {
			
			// As long as there are spaces in the input 
			// stream, advance the current location pointer
			// past them
			while ( isWhiteSpace( ch ) ) {
				nextChar();
			}
			
		}
		
		/**
		 * Determines if a character is whitespace or not.
		 *
		 * @return True if the character passed in is a whitespace
		 *	character
		 */
		private function isWhiteSpace( ch:String ):Boolean {
			return ( ch == ' ' || ch == '\t' || ch == '\n' );
		}
		
		/**
		 * Determines if a character is a digit [0-9].
		 *
		 * @return True if the character passed in is a digit
		 */
		private function isDigit( ch:String ):Boolean {
			return ( ch >= '0' && ch <= '9' );
		}
		
		/**
		 * Determines if a character is a digit [0-9].
		 *
		 * @return True if the character passed in is a digit
		 */
		private function isHexDigit( ch:String ):Boolean {
			// get the uppercase value of ch so we only have
			// to compare the value between 'A' and 'F'
			var uc:String = ch.toUpperCase();
			
			// a hex digit is a digit of A-F, inclusive ( using
			// our uppercase constraint )
			return ( isDigit( ch ) || ( uc >= 'A' && uc <= 'F' ) );
		}
	
		/**
		 * Raises a parsing error with a specified message, tacking
		 * on the error location and the original string.
		 *
		 * @param message The message indicating why the error occurred
		 */
		public function parseError( message:String ):void {
			throw new JSONParseError( message, loc, jsonString );
		}
	}
	
}
/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.serialization.json {

	/**
	 * Class containing constant values for the different types
	 * of tokens in a JSON encoded string.
	 */
	public class JSONTokenType {
	
		public static const UNKNOWN:int = -1;
		
		public static const COMMA:int = 0;
		
		public static const LEFT_BRACE:int = 1;
		
		public static const RIGHT_BRACE:int = 2;
		
		public static const LEFT_BRACKET:int = 3;
		
		public static const RIGHT_BRACKET:int = 4;
		
		public static const COLON:int = 6;
		
		public static const TRUE:int = 7;
		
		public static const FALSE:int = 8;
		
		public static const NULL:int = 9;
		
		public static const STRING:int = 10;
		
		public static const NUMBER:int = 11;
		
	}
	
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.utils
{
	
	/**
	* 	Class that contains static utility methods for manipulating and working
	*	with Arrays.
	* 
	*	Note that all APIs assume that they are working with well formed arrays.
	*	i.e. they will only manipulate indexed values.  
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/		
	public class ArrayUtil
	{
				
		/**
		*	Determines whether the specified array contains the specified value.	
		* 
		* 	@param arr The array that will be checked for the specified value.
		*
		*	@param value The object which will be searched for within the array
		* 
		* 	@return True if the array contains the value, False if it does not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function arrayContainsValue(arr:Array, value:Object):Boolean
		{
			return (arr.indexOf(value) != -1);
		}	
		
		/**
		*	Remove all instances of the specified value from the array,
		* 
		* 	@param arr The array from which the value will be removed
		*
		*	@param value The object that will be removed from the array.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function removeValueFromArray(arr:Array, value:Object):void
		{
			var len:uint = arr.length;
			
			for(var i:Number = len; i > -1; i--)
			{
				if(arr[i] === value)
				{
					arr.splice(i, 1);
				}
			}					
		}

		/**
		*	Create a new array that only contains unique instances of objects
		*	in the specified array.
		*
		*	Basically, this can be used to remove duplication object instances
		*	from an array
		* 
		* 	@param arr The array which contains the values that will be used to
		*	create the new array that contains no duplicate values.
		*
		*	@return A new array which only contains unique items from the specified
		*	array.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function createUniqueCopy(a:Array):Array
		{
			var newArray:Array = new Array();
			
			var len:Number = a.length;
			var item:Object;
			
			for (var i:uint = 0; i < len; ++i)
			{
				item = a[i];
				
				if(ArrayUtil.arrayContainsValue(newArray, item))
				{
					continue;
				}
				
				newArray.push(item);
			}
			
			return newArray;
		}
		
		/**
		*	Creates a copy of the specified array.
		*
		*	Note that the array returned is a new array but the items within the
		*	array are not copies of the items in the original array (but rather 
		*	references to the same items)
		* 
		* 	@param arr The array that will be copies
		*
		*	@return A new array which contains the same items as the array passed
		*	in.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function copyArray(arr:Array):Array
		{	
			return arr.slice();
		}
		
		/**
		*	Compares two arrays and returns a boolean indicating whether the arrays
		*	contain the same values at the same indexes.
		* 
		* 	@param arr1 The first array that will be compared to the second.
		*
		* 	@param arr2 The second array that will be compared to the first.
		*
		*	@return True if the arrays contains the same values at the same indexes.
			False if they do not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean
		{
			if(arr1.length != arr2.length)
			{
				return false;
			}
			
			var len:Number = arr1.length;
			
			for(var i:Number = 0; i < len; i++)
			{
				if(arr1[i] !== arr2[i])
				{
					return false;
				}
			}
			
			return true;
		}
	}
}
/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.utils
{
	//removeMeIfWant com.adobe.utils.ArrayUtil;
	//removeMeIfWant mx.formatters.DateBase;

	/**
	* 	Class that contains static utility methods for manipulating and working
	*	with Dates.
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/	
	public class DateUtil
	{
	
		/**
		*	Returns the English Short Month name (3 letters) for the Month that
		*	the Date represents.  	
		* 
		* 	@param d The Date instance whose month will be used to retrieve the
		*	short month name.
		* 
		* 	@return An English 3 Letter Month abbreviation.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*
		*	@see SHORT_MONTH
		*/	
		public static function getShortMonthName(d:Date):String
		{
			return DateBase.monthNamesShort[d.getMonth()];
		}

		/**
		*	Returns the index of the month that the short month name string
		*	represents. 	
		* 
		* 	@param m The 3 letter abbreviation representing a short month name.
		*
		*	@param Optional parameter indicating whether the search should be case
		*	sensitive
		* 
		* 	@return A int that represents that month represented by the specifed
		*	short name.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*
		*	@see SHORT_MONTH
		*/	
		public static function getShortMonthIndex(m:String):int
		{
			return DateBase.monthNamesShort.indexOf(m);
		}
		
		/**
		*	Returns the English full Month name for the Month that
		*	the Date represents.  	
		* 
		* 	@param d The Date instance whose month will be used to retrieve the
		*	full month name.
		* 
		* 	@return An English full month name.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*
		*	@see FULL_MONTH
		*/	
		public static function getFullMonthName(d:Date):String
		{
			return DateBase.monthNamesLong[d.getMonth()];	
		}

		/**
		*	Returns the index of the month that the full month name string
		*	represents. 	
		* 
		* 	@param m A full month name.
		* 
		* 	@return A int that represents that month represented by the specifed
		*	full month name.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*
		*	@see FULL_MONTH
		*/	
		public static function getFullMonthIndex(m:String):int
		{
			return DateBase.monthNamesLong.indexOf(m);
		}

		/**
		*	Returns the English Short Day name (3 letters) for the day that
		*	the Date represents.  	
		* 
		* 	@param d The Date instance whose day will be used to retrieve the
		*	short day name.
		* 
		* 	@return An English 3 Letter day abbreviation.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*
		*	@see SHORT_DAY
		*/	
		public static function getShortDayName(d:Date):String
		{
			return DateBase.dayNamesShort[d.getDay()];	
		}
		
		/**
		*	Returns the index of the day that the short day name string
		*	represents. 	
		* 
		* 	@param m A short day name.
		* 
		* 	@return A int that represents that short day represented by the specifed
		*	full month name.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*
		*	@see SHORT_DAY
		*/			
		public static function getShortDayIndex(d:String):int
		{
			return DateBase.dayNamesShort.indexOf(d);
		}

		/**
		*	Returns the English full day name for the day that
		*	the Date represents.  	
		* 
		* 	@param d The Date instance whose day will be used to retrieve the
		*	full day name.
		* 
		* 	@return An English full day name.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*
		*	@see FULL_DAY
		*/	
		public static function getFullDayName(d:Date):String
		{
			return DateBase.dayNamesLong[d.getDay()];	
		}		

		/**
		*	Returns the index of the day that the full day name string
		*	represents. 	
		* 
		* 	@param m A full day name.
		* 
		* 	@return A int that represents that full day represented by the specifed
		*	full month name.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*
		*	@see FULL_DAY
		*/		
		public static function getFullDayIndex(d:String):int
		{
			return DateBase.dayNamesLong.indexOf(d);
		}

		/**
		*	Returns a two digit representation of the year represented by the 
		*	specified date.
		* 
		* 	@param d The Date instance whose year will be used to generate a two
		*	digit string representation of the year.
		* 
		* 	@return A string that contains a 2 digit representation of the year.
		*	Single digits will be padded with 0.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function getShortYear(d:Date):String
		{
			var dStr:String = String(d.getFullYear());
			
			if(dStr.length < 3)
			{
				return dStr;
			}

			return (dStr.substr(dStr.length - 2));
		}

		/**
		*	Compares two dates and returns an integer depending on their relationship.
		*
		*	Returns -1 if d1 is greater than d2.
		*	Returns 1 if d2 is greater than d1.
		*	Returns 0 if both dates are equal.
		* 
		* 	@param d1 The date that will be compared to the second date.
		*	@param d2 The date that will be compared to the first date.
		* 
		* 	@return An int indicating how the two dates compare.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function compareDates(d1:Date, d2:Date):int
		{
			var d1ms:Number = d1.getTime();
			var d2ms:Number = d2.getTime();
			
			if(d1ms > d2ms)
			{
				return -1;
			}
			else if(d1ms < d2ms)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}

		/**
		*	Returns a short hour (0 - 12) represented by the specified date.
		*
		*	If the hour is less than 12 (0 - 11 AM) then the hour will be returned.
		*
		*	If the hour is greater than 12 (12 - 23 PM) then the hour minus 12
		*	will be returned.
		* 
		* 	@param d1 The Date from which to generate the short hour
		* 
		* 	@return An int between 0 and 13 ( 1 - 12 ) representing the short hour.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function getShortHour(d:Date):int
		{
			var h:int = d.hours;
			
			if(h == 0 || h == 12)
			{
				return 12;
			}
			else if(h > 12)
			{
				return h - 12;
			}
			else
			{
				return h;
			}
		}
		
		/**
		*	Returns a string indicating whether the date represents a time in the
		*	ante meridiem (AM) or post meridiem (PM).
		*
		*	If the hour is less than 12 then "AM" will be returned.
		*
		*	If the hour is greater than 12 then "PM" will be returned.
		* 
		* 	@param d1 The Date from which to generate the 12 hour clock indicator.
		* 
		* 	@return A String ("AM" or "PM") indicating which half of the day the 
		*	hour represents.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function getAMPM(d:Date):String
		{
			return (d.hours > 11)? "PM" : "AM";
		}

		/**
		* Parses dates that conform to RFC822 into Date objects. This method also
		* supports four-digit years (not supported in RFC822), but two-digit years
		* (referring to the 20th century) are fine, too.
		*
		* This function is useful for parsing RSS .91, .92, and 2.0 dates.
		*
		* @param str
		*
		* @returns
		*
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		* @tiptext
		*
		* @see http://asg.web.cmu.edu/rfc/rfc822.html
		*/		
		public static function parseRFC822(str:String):Date
		{
            var finalDate:Date;
			try
			{
				var dateParts:Array = str.split(" ");
				var day:String = null;
				
				if (dateParts[0].search(/\d/) == -1)
				{
					day = dateParts.shift().replace(/\W/, "");
				}
				
				var date:Number = Number(dateParts.shift());
				var month:Number = Number(DateUtil.getShortMonthIndex(dateParts.shift()));
				var year:Number = Number(dateParts.shift());
				var timeParts:Array = dateParts.shift().split(":");
				var hour:Number = int(timeParts.shift());
				var minute:Number = int(timeParts.shift());
				var second:Number = (timeParts.length > 0) ? int(timeParts.shift()): 0;
	
				var milliseconds:Number = Date.UTC(year, month, date, hour, minute, second, 0);
	
				var timezone:String = dateParts.shift();
				var offset:Number = 0;

				if (timezone.search(/\d/) == -1)
				{
					switch(timezone)
					{
						case "UT":
							offset = 0;
							break;
						case "UTC":
							offset = 0;
							break;
						case "GMT":
							offset = 0;
							break;
						case "EST":
							offset = (-5 * 3600000);
							break;
						case "EDT":
							offset = (-4 * 3600000);
							break;
						case "CST":
							offset = (-6 * 3600000);
							break;
						case "CDT":
							offset = (-5 * 3600000);
							break;
						case "MST":
							offset = (-7 * 3600000);
							break;
						case "MDT":
							offset = (-6 * 3600000);
							break;
						case "PST":
							offset = (-8 * 3600000);
							break;
						case "PDT":
							offset = (-7 * 3600000);
							break;
						case "Z":
							offset = 0;
							break;
						case "A":
							offset = (-1 * 3600000);
							break;
						case "M":
							offset = (-12 * 3600000);
							break;
						case "N":
							offset = (1 * 3600000);
							break;
						case "Y":
							offset = (12 * 3600000);
							break;
						default:
							offset = 0;
					}
				}
				else
				{
					var multiplier:Number = 1;
					var oHours:Number = 0;
					var oMinutes:Number = 0;
					if (timezone.length != 4)
					{
						if (timezone.charAt(0) == "-")
						{
							multiplier = -1;
						}
						timezone = timezone.substr(1, 4);
					}
					oHours = Number(timezone.substr(0, 2));
					oMinutes = Number(timezone.substr(2, 2));
					offset = (((oHours * 3600000) + (oMinutes * 60000)) * multiplier);
				}

				finalDate = new Date(milliseconds - offset);

				if (finalDate.toString() == "Invalid Date")
				{
					throw new Error("This date does not conform to RFC822.");
				}
			}
			catch (e:Error)
			{
				var eStr:String = "Unable to parse the string [" +str+ "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				throw new Error(eStr);
			}
            return finalDate;
		}
	     
		/**
		* Returns a date string formatted according to RFC822.
		*
		* @param d
		*
		* @returns
		*
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		* @tiptext
		*
		* @see http://asg.web.cmu.edu/rfc/rfc822.html
		*/	
		public static function toRFC822(d:Date):String
		{
			var date:Number = d.getUTCDate();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var sb:String = new String();
			sb += DateBase.dayNamesShort[d.getUTCDay()];
			sb += ", ";
			
			if (date < 10)
			{
				sb += "0";
			}
			sb += date;
			sb += " ";
			//sb += DateUtil.SHORT_MONTH[d.getUTCMonth()];
			sb += DateBase.monthNamesShort[d.getUTCMonth()];
			sb += " ";
			sb += d.getUTCFullYear();
			sb += " ";
			if (hours < 10)
			{			
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{			
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10)
			{			
				sb += "0";
			}
			sb += seconds;
			sb += " GMT";
			return sb;
		}
	     
		/**
		* Parses dates that conform to the W3C Date-time Format into Date objects.
		*
		* This function is useful for parsing RSS 1.0 and Atom 1.0 dates.
		*
		* @param str
		*
		* @returns
		*
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		* @tiptext
		*
		* @see http://www.w3.org/TR/NOTE-datetime
		*/		     
		public static function parseW3CDTF(str:String):Date
		{
            var finalDate:Date;
			try
			{
				var dateStr:String = str.substring(0, str.indexOf("T"));
				var timeStr:String = str.substring(str.indexOf("T")+1, str.length);
				var dateArr:Array = dateStr.split("-");
				var year:Number = Number(dateArr.shift());
				var month:Number = Number(dateArr.shift());
				var date:Number = Number(dateArr.shift());
				
				var multiplier:Number;
				var offsetHours:Number;
				var offsetMinutes:Number;
				var offsetStr:String;
				
				if (timeStr.indexOf("Z") != -1)
				{
					multiplier = 1;
					offsetHours = 0;
					offsetMinutes = 0;
					timeStr = timeStr.replace("Z", "");
				}
				else if (timeStr.indexOf("+") != -1)
				{
					multiplier = 1;
					offsetStr = timeStr.substring(timeStr.indexOf("+")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("+"));
				}
				else // offset is -
				{
					multiplier = -1;
					offsetStr = timeStr.substring(timeStr.indexOf("-")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("-"));
				}
				var timeArr:Array = timeStr.split(":");
				var hour:Number = Number(timeArr.shift());
				var minutes:Number = Number(timeArr.shift());
				var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
				var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var utc:Number = Date.UTC(year, month-1, date, hour, minutes, seconds, milliseconds);
				var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
				finalDate = new Date(utc - offset);
	
				if (finalDate.toString() == "Invalid Date")
				{
					throw new Error("This date does not conform to W3CDTF.");
				}
			}
			catch (e:Error)
			{
				var eStr:String = "Unable to parse the string [" +str+ "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				throw new Error(eStr);
			}
            return finalDate;
		}
	     
		/**
		* Returns a date string formatted according to W3CDTF.
		*
		* @param d
		* @param includeMilliseconds Determines whether to include the
		* milliseconds value (if any) in the formatted string.
		*
		* @returns
		*
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		* @tiptext
		*
		* @see http://www.w3.org/TR/NOTE-datetime
		*/		     
		public static function toW3CDTF(d:Date,includeMilliseconds:Boolean=false):String
		{
			var date:Number = d.getUTCDate();
			var month:Number = d.getUTCMonth();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var milliseconds:Number = d.getUTCMilliseconds();
			var sb:String = new String();
			
			sb += d.getUTCFullYear();
			sb += "-";
			
			//thanks to "dom" who sent in a fix for the line below
			if (month + 1 < 10)
			{
				sb += "0";
			}
			sb += month + 1;
			sb += "-";
			if (date < 10)
			{
				sb += "0";
			}
			sb += date;
			sb += "T";
			if (hours < 10)
			{
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10)
			{
				sb += "0";
			}
			sb += seconds;
			if (includeMilliseconds && milliseconds > 0)
			{
				sb += ".";
				sb += milliseconds;
			}
			sb += "-00:00";
			return sb;
		}
	}
}
/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.utils
{
	//removeMeIfWant flash.utils.Dictionary;
	
	public class DictionaryUtil
	{
		
		/**
		*	Returns an Array of all keys within the specified dictionary.	
		* 
		* 	@param d The Dictionary instance whose keys will be returned.
		* 
		* 	@return Array of keys contained within the Dictionary
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/					
		public static function getKeys(d:Dictionary):Array
		{
			var a:Array = new Array();
			
			for (var key:Object in d)
			{
				a.push(key);
			}
			
			return a;
		}
		
		/**
		*	Returns an Array of all values within the specified dictionary.		
		* 
		* 	@param d The Dictionary instance whose values will be returned.
		* 
		* 	@return Array of values contained within the Dictionary
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/					
		public static function getValues(d:Dictionary):Array
		{
			var a:Array = new Array();
			
			for each (var value:Object in d)
			{
				a.push(value);
			}
			
			return a;
		}
		
	}
}

/* AS3JS File */
package com.adobe.utils {
	
	//removeMeIfWant flash.utils.Endian;
	
	/**
	 * Contains reusable methods for operations pertaining 
	 * to int values.
	 */
	public class IntUtil {
		
		/**
		 * Rotates x left n bits
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function rol ( x:int, n:int ):int {
			return ( x << n ) | ( x >>> ( 32 - n ) );
		}
		
		/**
		 * Rotates x right n bits
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function ror ( x:int, n:int ):uint {
			var nn:int = 32 - n;
			return ( x << nn ) | ( x >>> ( 32 - nn ) );
		}
		
		/** String for quick lookup of a hex character based on index */
		private static var hexChars:String = "0123456789abcdef";
		
		/**
		 * Outputs the hex value of a int, allowing the developer to specify
		 * the endinaness in the process.  Hex output is lowercase.
		 *
		 * @param n The int value to output as hex
		 * @param bigEndian Flag to output the int as big or little endian
		 * @return A string of length 8 corresponding to the 
		 *		hex representation of n ( minus the leading "0x" )
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function toHex( n:int, bigEndian:Boolean = false ):String {
			var s:String = "";
			
			if ( bigEndian ) {
				for ( var i:int = 0; i < 4; i++ ) {
					s += hexChars.charAt( ( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF ) 
						+ hexChars.charAt( ( n >> ( ( 3 - i ) * 8 ) ) & 0xF );
				}
			} else {
				for ( var x:int = 0; x < 4; x++ ) {
					s += hexChars.charAt( ( n >> ( x * 8 + 4 ) ) & 0xF )
						+ hexChars.charAt( ( n >> ( x * 8 ) ) & 0xF );
				}
			}
			
			return s;
		}
	}
		
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.utils
{

	/**
	* 	Class that contains static utility methods for formatting Numbers
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*
	*	@see #mx.formatters.NumberFormatter
	*/		
	public class NumberFormatter
	{
	
		/**
		*	Formats a number to include a leading zero if it is a single digit
		*	between -1 and 10. 	
		* 
		* 	@param n The number that will be formatted
		*
		*	@return A string with single digits between -1 and 10 padded with a 
		*	leading zero.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function addLeadingZero(n:Number):String
		{
			var out:String = String(n);
			
			if(n < 10 && n > -1)
			{
				out = "0" + out;
			}
			
			return out;
		}	
	
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.utils
{
	
	/**
	* 	Class that contains static utility methods for manipulating Strings.
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/		
	public class StringUtil
	{

		
		/**
		*	Does a case insensitive compare or two strings and returns true if
		*	they are equal.
		* 
		*	@param s1 The first string to compare.
		*
		*	@param s2 The second string to compare.
		*
		*	@returns A boolean value indicating whether the strings' values are 
		*	equal in a case sensitive compare.	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function stringsAreEqual(s1:String, s2:String, 
											caseSensitive:Boolean):Boolean
		{
			if(caseSensitive)
			{
				return (s1 == s2);
			}
			else
			{
				return (s1.toUpperCase() == s2.toUpperCase());
			}
		}
		
		/**
		*	Removes whitespace from the front and the end of the specified
		*	string.
		* 
		*	@param input The String whose beginning and ending whitespace will
		*	will be removed.
		*
		*	@returns A String with whitespace removed from the begining and end	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function trim(input:String):String
		{
			return StringUtil.ltrim(StringUtil.rtrim(input));
		}

		/**
		*	Removes whitespace from the front of the specified string.
		* 
		*	@param input The String whose beginning whitespace will will be removed.
		*
		*	@returns A String with whitespace removed from the begining	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function ltrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = 0; i < size; i++)
			{
				if(input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}

		/**
		*	Removes whitespace from the end of the specified string.
		* 
		*	@param input The String whose ending whitespace will will be removed.
		*
		*	@returns A String with whitespace removed from the end	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function rtrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = size; i > 0; i--)
			{
				if(input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}

			return "";
		}

		/**
		*	Determines whether the specified string begins with the spcified prefix.
		* 
		*	@param input The string that the prefix will be checked against.
		*
		*	@param prefix The prefix that will be tested against the string.
		*
		*	@returns True if the string starts with the prefix, false if it does not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function beginsWith(input:String, prefix:String):Boolean
		{			
			return (prefix == input.substring(0, prefix.length));
		}	

		/**
		*	Determines whether the specified string ends with the spcified suffix.
		* 
		*	@param input The string that the suffic will be checked against.
		*
		*	@param prefix The suffic that will be tested against the string.
		*
		*	@returns True if the string ends with the suffix, false if it does not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (suffix == input.substring(input.length - suffix.length));
		}	

		/**
		*	Removes all instances of the remove string in the input string.
		* 
		*	@param input The string that will be checked for instances of remove
		*	string
		*
		*	@param remove The string that will be removed from the input string.
		*
		*	@returns A String with the remove string removed.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function remove(input:String, remove:String):String
		{
			return StringUtil.replace(input, remove, "");
		}

		/**
		*	Replaces all instances of the replace string in the input string
		*	with the replaceWith string.
		* 
		*	@param input The string that instances of replace string will be 
		*	replaces with removeWith string.
		*
		*	@param replace The string that will be replaced by instances of 
		*	the replaceWith string.
		*
		*	@param replaceWith The string that will replace instances of replace
		*	string.
		*
		*	@returns A new String with the replace string replaced with the 
		*	replaceWith string.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			//change to StringBuilder
			var sb:String = new String();
			var found:Boolean = false;

			var sLen:Number = input.length;
			var rLen:Number = replace.length;

			for (var i:Number = 0; i < sLen; i++)
			{
				if(input.charAt(i) == replace.charAt(0))
				{   
					found = true;
					for(var j:Number = 0; j < rLen; j++)
					{
						if(!(input.charAt(i + j) == replace.charAt(j)))
						{
							found = false;
							break;
						}
					}

					if(found)
					{
						sb += replaceWith;
						i = i + (rLen - 1);
						continue;
					}
				}
				sb += input.charAt(i);
			}
			//TODO : if the string is not found, should we return the original
			//string?
			return sb;
		}
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.utils
{

	public class XMLUtil
	{
		/**
		 * Constant representing a text node type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static const TEXT:String = "text";
		
		/**
		 * Constant representing a comment node type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const COMMENT:String = "comment";
		
		/**
		 * Constant representing a processing instruction type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const PROCESSING_INSTRUCTION:String = "processing-instruction";
		
		/**
		 * Constant representing an attribute type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const ATTRIBUTE:String = "attribute";
		
		/**
		 * Constant representing a element type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const ELEMENT:String = "element";
		
		/**
		 * Checks whether the specified string is valid and well formed XML.
		 * 
		 * @param data The string that is being checked to see if it is valid XML.
		 * 
		 * @return A Boolean value indicating whether the specified string is
		 * valid XML.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function isValidXML(data:String):Boolean
		{
			var xml:XML;
			
			try
			{
				xml = new XML(data);
			}
			catch(e:Error)
			{
				return false;
			}
			
			if(xml.nodeKind() != XMLUtil.ELEMENT)
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * Returns the next sibling of the specified node relative to the node's parent.
		 * 
		 * @param x The node whose next sibling will be returned.
		 * 
		 * @return The next sibling of the node. null if the node does not have 
		 * a sibling after it, or if the node has no parent.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static function getNextSibling(x:XML):XML
		{	
			return XMLUtil.getSiblingByIndex(x, 1);
		}
		
		/**
		 * Returns the sibling before the specified node relative to the node's parent.
		 * 
		 * @param x The node whose sibling before it will be returned.
		 * 
		 * @return The sibling before the node. null if the node does not have 
		 * a sibling before it, or if the node has no parent.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */			
		public static function getPreviousSibling(x:XML):XML
		{	
			return XMLUtil.getSiblingByIndex(x, -1);
		}		
		
		protected static function getSiblingByIndex(x:XML, count:int):XML	
		{
			var out:XML;
			
			try
			{
				out = x.parent().children()[x.childIndex() + count];	
			} 		
			catch(e:Error)
			{
				return null;
			}
			
			return out;			
		}
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/



/* AS3JS File */
package com.adobe.webapis 
{
	//removeMeIfWant flash.events.EventDispatcher;

	/**
	* Base class for remote service classes.
	*/
	public class ServiceBase extends EventDispatcher
	{
		public function ServiceBase()
		{
		}
		
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/* AS3JS File */
package com.adobe.webapis
{
	//removeMeIfWant flash.events.IOErrorEvent;
	//removeMeIfWant flash.events.SecurityErrorEvent;
	//removeMeIfWant flash.events.ProgressEvent;
	
	//removeMeIfWant com.adobe.net.DynamicURLLoader;
	
		/**
		*  	Dispatched when data is 
		*  	received as the download operation progresses.
		*	 
		* 	@eventType flash.events.ProgressEvent.PROGRESS
		* 
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		*/
		[Event(name="progress", type="flash.events.ProgressEvent")]		
	
		/**
		*	Dispatched if a call to the server results in a fatal 
		*	error that terminates the download.
		* 
		* 	@eventType flash.events.IOErrorEvent.IO_ERROR
		* 
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		*/
		[Event(name="ioError", type="flash.events.IOErrorEvent")]		
		
		/**
		*	A securityError event occurs if a call attempts to
		*	load data from a server outside the security sandbox.
		* 
		* 	@eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
		* 
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		*/
		[Event(name="securityError", type="flash.events.SecurityErrorEvent")]	
	
	/**
	*	Base class for services that utilize URLLoader
	*	to communicate with remote APIs / Services.
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	*/
	public class URLLoaderBase extends ServiceBase
	{	
		protected function getURLLoader():DynamicURLLoader
		{
			var loader:DynamicURLLoader = new DynamicURLLoader();
				loader.addEventListener("progress", onProgress);
				loader.addEventListener("ioError", onIOError);
				loader.addEventListener("securityError", onSecurityError);
			
			return loader;			
		}		
		
		private function onIOError(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}			
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}	
		
		private function onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}	
	}
}/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/



/* AS3JS File */
package com.adobe.webapis.events
{

	//removeMeIfWant flash.events.Event;

	/**
	* Event class that contains data loaded from remote services.
	*
	* @author Mike Chambers
	*/
	public class ServiceEvent extends Event
	{
		private var _data:Object = new Object();;

		/**
		* Constructor for ServiceEvent class.
		*
		* @param type The type of event that the instance represents.
		*/
		public function ServiceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		/**
		* 	This object contains data loaded in response
		* 	to remote service calls, and properties associated with that call.
		*/
		public function get data():Object
		{
			return _data;
		}

		public function set data(d:Object):void
		{
			_data = d;
		}
		

	}
}
