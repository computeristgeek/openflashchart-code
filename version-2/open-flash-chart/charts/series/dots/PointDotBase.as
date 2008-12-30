package charts.series.dots {
	
	import flash.display.Sprite;
	import charts.series.Element;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PointDotBase extends Element {
		
		protected var radius:Number;
		protected var colour:Number;
		
		public function PointDotBase( index:Number, style:Object ) {
			
			super();
			this.is_tip = false;
			this.index = this._x = index;
			this._y = Number( style.value );
			
			this.radius = style['dot-size'];
			this.tooltip = this.replace_magic_values( style.tip );
			
			if ( style['on-click'] )
				this.set_on_click( style['on-click'] );
			
			//
			// TODO: fix this hack
			//
			if ( style.axis )
				if ( style.axis == 'right' )
					this.right_axis = true;

		}
		
		//
		// all dot share the same resize code:
		//
		public override function resize( sc:ScreenCoordsBase ):void {

			var p:flash.geom.Point = sc.get_get_x_from_pos_and_y_from_val( this.index, this._y, this.right_axis );
			//
			// Haha! This is the worst code in the world,
			// but it is kinda kooky and cool at the same time :-)
			//
			this.x = this.line_mask.x = p.x;
			this.y = this.line_mask.y = p.y;
			
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

