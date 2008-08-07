package ChartObjects {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Shape extends Base {
		
		private var style:Object;
		private var points:Array;
		
		public function Shape( json:Object )
		{
			this.points = new Array();
			
			for each ( var val:Object in json.values )
				this.points.push( new flash.geom.Point( val.x, val.y ) );
		}
		
		public override function resize( sc:ScreenCoords ): void {
			
			this.graphics.clear();
			//this.graphics.lineStyle( this.style.width, this.style.colour );
			this.graphics.lineStyle( 2, 0 );
			this.graphics.beginFill( 0xddd0d0, 1 );
			
			var moved:Boolean = false;
			
			for each( var p:flash.geom.Point in this.points ) {
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