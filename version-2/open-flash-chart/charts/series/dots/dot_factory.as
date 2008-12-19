package charts.series.dots {
	import charts.series.dots.scat;
	
	public class dot_factory {
		
		public static function make( default_style:Object ):PointDotBase {
			return new scat(default_style);
		}
	}
}