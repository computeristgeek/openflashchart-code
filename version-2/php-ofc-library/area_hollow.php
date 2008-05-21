<?php

class area_hollow
{
	function area_hollow()
	{
		$this->type      = "area_hollow";
		$this->colour    = "#CC3399";
		$this->text      = "Page views";;
		$tmp = 'font-size';
		$this->$tmp = 10;
		
		$this->width     = 2;
		
		$tmp = 'dot-size';
		$this->$tmp = 4;
		
		$tmp = 'fill-alpha';
		$this->$tmp = 0.35;
		
		$this->values    = array();
	}
	
	function set_values( $v )
	{
		$this->values = $v;		
	}
}
