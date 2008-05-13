package ChartObjects.Elements {
	import flash.display.Sprite;
	
	public class Point extends Element {
		public var radius:Number;
		
		public function Point( x:Number, y:Number, colour:Number, size:Number )
		{
			this._x = x;
			this._y = y;
			this.is_tip = false;
			this.visible = false;
			
			this.radius = size;
			
			this.graphics.beginFill( colour, 1 );
			this.graphics.drawCircle( 0, 0, size );
			this.attach_events();
		}
		
		public override function set_tip( b:Boolean ):void {
			this.visible = b;
		}
		
		public override function make_tooltip( key:String ):void
		{
			super.make_tooltip( key );
			
			var tmp:String = this.tooltip.replace('#val#',NumberUtils.formatNumber( this._y ));
			this.tooltip = tmp;
		}
		
		public function mask_parent( s:Sprite ):void {
		}
		
		//
		// is the mouse above, inside or below this point?
		//
		public override function inside( x:Number ):Boolean {
			return (x > (this.x-(this.radius/2))) && (x < (this.x+(this.radius/2)));
		}
	}
}