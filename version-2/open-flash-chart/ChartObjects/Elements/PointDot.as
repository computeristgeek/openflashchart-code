package ChartObjects.Elements {
	import flash.display.Sprite;
	import ChartObjects.Elements.Element;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PointDot extends Element {
		
		private var radius:Number;
		private var colour:Number;
		
		public function PointDot( x:Number, value:Object, size:Number, colour:Number ) {
			this._x = x;
			this._y = Number(value);
			this.is_tip = false;
			this.visible = true;
			
			this.radius = size;
			this.colour = colour;
			
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( this.colour, 1 );
			this.graphics.drawCircle( 0, 0, this.radius );
			this.graphics.endFill();
			
			this.attach_events();
		}
		
		public override function set_tip( b:Boolean ):void {
			//this.visible = b;
			if( b )
				this.scaleX = this.scaleY = 1.3;
			else
				this.scaleX = this.scaleY = 1;
		}
		
		public override function make_tooltip( key:String ):void
		{
			super.make_tooltip( key );
			
			var tmp:String = this.tooltip.replace('#val#',NumberUtils.formatNumber( this._y ));
			this.tooltip = tmp;
		}
		
		//
		// is the mouse above, inside or below this point?
		//
		public override function inside( x:Number ):Boolean {
			return (x > (this.x-(this.radius/2))) && (x < (this.x+(this.radius/2)));
		}
	}
}

