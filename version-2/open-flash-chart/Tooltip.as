package {
//	import mx.effects.Tween;
//	import mx.effects.easing.*;

	import caurina.transitions.Tweener;
	import caurina.transitions.Equations;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	import ChartObjects.Elements.Element;
	import com.serialization.json.JSON;
	import string.Utils;
	import string.Css;
	import object_helper;
	
	public class Tooltip extends Sprite {
		private var title:TextField;
		private var text:TextField;
		// JSON style:
		private var style:Object;
		
		private var tip_style:Number;
		private var cached_element:Element;
		private var tip_showing:Boolean;
		
		public var tip_text:String;
		
		public static const CLOSEST:Number = 0;
		public static const FOLLOW:Number = 1;
		public static const NORMAL:Number = 2;		// normal tooltip (ugh -- boring!!)
		
		public function Tooltip( json:Object )
		{
			//
			// we don't want mouseOver events for the
			// tooltip or any children (the text fields)
			//
			this.mouseEnabled = false;
			
			this.title = new TextField();
			this.title.x = 5,
			this.title.y = 5;
			this.title.mouseEnabled = false;
			
			this.text = new TextField();
			this.text.x = 5;
			this.text.y = 5;
			this.text.mouseEnabled = false;
			
			this.tip_showing = false;
			
			this.addChild( this.title );
			this.addChild( this.text );
			
			this.style = {
				shadow:		true,
				rounded:	1,
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
		
		public function make_tip( e:Element ):void {
			tr.ace( 'make tip') ;
			this.graphics.clear();
			
			var tt:String = e.get_tooltip();
			var lines:Array = tt.split( '<br>' );
			
			if( lines.length > 1 )
				this.title.htmlText = lines.shift();
			else
				this.title.htmlText = '';

				
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
			this.title.setTextFormat(fmt);
			this.title.autoSize="left";
		
			this.text.y = this.title.height;
			
			this.text.htmlText = lines.join( '\n' );
			var fmt2:TextFormat = new TextFormat();
			fmt2.color = this.style.body.color;
			fmt2.font = "Verdana";
			fmt2.bold = (this.style.body.font_weight=="bold");
			fmt2.size = this.style.body.font_size;
			fmt2.align = "left";
			this.text.setTextFormat(fmt2);
			this.text.autoSize="left";
			
			this.graphics.lineStyle(this.style.stroke, this.style.colour, 1);
			this.graphics.beginFill(this.style.background, 1);
		
			var max_width:Number = Math.max( this.title.width, this.text.width );
			
			this.graphics.drawRoundRect(
				0,0,
				max_width+10, this.title.height + this.text.height + 5,
				6,6 );
		}
		
		private function get_pos( e:Element ):flash.geom.Point {

			var pos:Object = e.get_tip_pos();
			var max_width:Number = Math.max( this.title.width, this.text.width );
			
			var x:Number = (pos.x + max_width + 16) > this.stage.stageWidth ? (this.stage.stageWidth - max_width - 16) : pos.x;
			
			var y:Number = pos.y;
			y -= 4;
			y -= (this.text.height + this.title.height + 10 ); // 10 == border size
			
			if( y < 0 )
			{
				// the tooltip has drifted off the top of the screen, move it down:
				y = 0;
			}
			return new flash.geom.Point(x, y);
		}
		
		private function show_tip( e:Element ):void {
			
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
		
		public function draw( e:Element ):void {

			if ( this.cached_element == e )
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
				this.cached_element.set_tip( false );
				tr.ace( this.cached_element );
				
				// get the new text and recreate it
				this.cached_element = e;
				
				this.make_tip( e );
				this.show_tip(e);
			}
		}
		
		public function closest( e:Element ):void {

			if( e == null )
				return;
				
			if ( this.cached_element == e )
				return;
			
			if( this.cached_element != null )
				this.cached_element.set_tip( false );
				
			this.cached_element = e;
			this.make_tip( e );

			var p:flash.geom.Point = this.get_pos( e );
			
			this.visible = true;
			
			Tweener.addTween(this, { x:p.x, time:0.3, transition:Equations.easeOutExpo } );
			Tweener.addTween(this, { y:p.y, time:0.3, transition:Equations.easeOutExpo } );
		}
		
		private function hideAway() : void {
			this.visible = false;
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
	}
}