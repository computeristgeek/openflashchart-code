<?php

class line_dot
{
	function line_dot()
	{
		$this->type      = "line_dot";
		$this->colour    = "#736AFF";
		$this->text      = "Page views";
		$this->width     = 2;
		$tmp = 'font-size';
		$this->$tmp = 10;
		
		$tmp = 'dot-size';
		$this->$tmp = 4;
		$this->values    = array(9,6,7,9,5,7,6,9,7);
	}
	
	function set_values( $v )
	{
		$this->values = $v;		
	}
}