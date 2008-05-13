package {
	
	public class MinMax
	{
		public var y_min:Number;
		public var y_max:Number;
		public var y2_min:Number;
		public var y2_max:Number;
		public var x_min:Number;
		public var x_max:Number;
		
		// have we been given x_min and x_max?
		public var has_x_range:Boolean;
		
		public function MinMax( json:Object )
		{
			this.y_max = 10;
			if( json.y_axis != null )
				if( json.y_axis.max != null )
					this.y_max = json.y_axis.max;
			
			this.y_min = 0;
			if( json.y_axis != null )
				if( json.y_axis.min != null )
					this.y_min = json.y_axis.min;
				
			
			// y 2
			if( json.y2_max == undefined )
				this.y2_max = 10;
			else
				this.y2_max = json.y2_max;
				
			if( json.y2_min == undefined )
				this.y2_min = 0;
			else
				this.y2_min = json.y2_min;
				
			//
			// what do you do if Y min=0 and Y max = 0?
			//
			if( this.y_min == this.y_max )
				this.y_max+=1;
			
			if( this.y2_min == this.y2_max )
				this.y2_max+=1;
			
			this.has_x_range = false;
			this.x_max = 10;

			if( json.x_axis != null )
				if( json.x_axis.max != null )
				{
					this.has_x_range = true;
					this.x_max = json.x_axis.max;
				}
				
			this.x_min = 0;
			if( json.x_axis != null )
				if( json.x_axis.min != null )
				{
					this.has_x_range = true;
					this.x_min = json.x_axis.min;
				}
			
		}
		
		// may be called be Y Xaxis Labels
		public function set_y_max( m:Number ):void {
			this.y_max = m;
		}
		
		// may be called be X Xaxis Labels
		public function set_x_max( m:Number ):void {
			this.x_max = m;
		}
		
		public function y_range( right:Boolean ) : Number {
			if( right )
				return this.y2_max-this.y2_min;
			else
				return this.y_max-this.y_min;
		}
		
		public function x_range() : Number {
			return this.x_max-this.x_min;
		}
		
		public function get_y_min( right:Boolean ) :Number {
			if( right )
				return this.y2_min;
			else
				return this.y_min;
		}
		
		public function get_y_max( right:Boolean ) :Number {
			if( right )
				return this.y2_max;
			else
				return this.y_max;
		}

	}
}