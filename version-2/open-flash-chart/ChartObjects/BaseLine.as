package ChartObjects {
	import ChartObjects.Elements.Element;
	
	import flash.display.Sprite;
	
	public class BaseLine extends Base
	{
		public function BaseLine() {}
		
		// Draw lines...
		public override function resize( sc:ScreenCoords ): void {
			this.x = this.y = 0;

			this.graphics.clear();
			this.graphics.lineStyle( this.line_width, this.colour );
			
			var first:Boolean = true;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				var e:Element = this.getChildAt(i) as Element;
							
				// tell the point where it is on the screen
				// we will use this info to place the tooltip
				e.resize( sc, 0 );
				if( first )
				{
					this.graphics.moveTo(e.screen_x,e.screen_y);
					first = false;
				}
				else
					this.graphics.lineTo(e.screen_x,e.screen_y);
			}
			
			return;
			
			
			// the mask erases parts of the line so the dots look sexy:
			var s:Sprite = new Sprite();
			s.x = s.y = 0;
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( 0, 0.4 );
			s.graphics.drawRect(sc.left, sc.top, sc.width, sc.height);
			
			for ( var x:Number = 0; x < this.numChildren; x++ ) {
				var ee:Element = this.getChildAt(x) as Element;
				
				s.graphics.beginFill( 0xffffff, 0 );
				s.graphics.drawCircle(ee.screen_x, ee.screen_y, 7);
				s.graphics.endFill();
			}
			
			this.mask = s;
			this.addChild( s );

		}
	}
}