﻿package {

	import flash.utils.Dictionary;

	
	public class Properties extends Object
	{
		private var _props:Dictionary;
		private var _parent:Properties;
		
		public function Properties( json:Object, parent:Properties=null ) {
		
			this._props = new Dictionary();
			this._parent = parent;
			
			// tr.ace(json);
			
			for (var prop:String in json ) {
				
				// tr.ace( prop +' = ' + json[prop]);
				this._props[prop] = json[prop];
			}
		}
		
		public function get(name:String):* {
			
			if ( this.has(name) )
				return this._props[name];
			
			if ( this._parent != null )
				return this._parent.get( name );
				
			
			tr.aces( 'ERROR: property not found', name);
			return Number.NEGATIVE_INFINITY;
		}
		
		// set does not recurse down, we don't want to set
		// our parents property
		public function set(name:String, value:Object):void {
			this._props[name] = value;
		}
		
		public function has(name:String):Boolean {
			return this._props[name]!=null;
		}
	}
}