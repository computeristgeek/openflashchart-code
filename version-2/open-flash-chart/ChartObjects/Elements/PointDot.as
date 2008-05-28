package ChartObjects.Elements {
	import ChartObjects.Elements.PointDotBase;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	
	public class PointDot extends PointDotBase {
		
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
			
			var s:Sprite = new Sprite();
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( 0, 1 );
			s.graphics.drawCircle( 0, 0, this.radius+2 );
			s.blendMode = BlendMode.ERASE;
			
			this.line_mask = s;
			
			this.attach_events();
		}
	}
}

