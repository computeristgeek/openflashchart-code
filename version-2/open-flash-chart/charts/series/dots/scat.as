package charts.series.dots {
	
	import flash.display.Sprite;
	import charts.series.Element;
	import caurina.transitions.Tweener;
	import caurina.transitions.Equations;
	
	public class scat extends Hollow {
		
		public function scat( style:Object ) {
			
			// scatter charts have x, y (not value):
			style.value = style.y;
			
			super( -99, style );
			
			// override the basics in PointDotBase:
			this._x = style.x;
			this._y = style.y;
			this.tooltip = this.replace_magic_values( style.tip );
			//
		}
		
		private function replace_magic_values( t:String ): String {
			
			t = t.replace('#x#', NumberUtils.formatNumber(this._x));
			t = t.replace('#y#', NumberUtils.formatNumber(this._y));
			t = t.replace('#size#', NumberUtils.formatNumber(this.radius));
			return t;
		}
		
		public override function set_tip( b:Boolean ):void {
			if ( b )
			{
				if ( !this.is_tip )
				{
					Tweener.addTween(this, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
					Tweener.addTween(this, {scaleY:1.3, time:0.4, transition:"easeoutbounce"} );
					Tweener.addTween(this.line_mask, {scaleX:1.3, time:0.4, transition:"easeoutbounce"} );
					Tweener.addTween(this.line_mask, {scaleY:1.3, time:0.4, transition:"easeoutbounce"} );
				}
				this.is_tip = true;
			}
			else
			{
				Tweener.removeTweens(this);
				Tweener.removeTweens(this.line_mask);
				this.scaleX = 1;
				this.scaleY = 1;
				this.line_mask.scaleX = 1;
				this.line_mask.scaleY = 1;
				this.is_tip = false;
			}
		}
		
		public override function resize( sc:ScreenCoordsBase ): void {
			
			//
			// Look: we have a real X value, so get its screen location:
			//
			this.x = sc.get_x_from_val( this._x );
			this.y = sc.get_y_from_val( this._y, this.right_axis );
			
			this.line_mask.x = this.x;
			this.line_mask.y = this.y;
		}
		
	}
}