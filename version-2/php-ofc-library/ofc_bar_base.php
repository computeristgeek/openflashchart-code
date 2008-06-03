<?php

/* this is a base class */

class bar_base
{
	function bar_base()
	{
		$this->alpha     = 0.5;
		$this->colour    = "#9933CC";
		$this->text      = "Page views";;
		$tmp = 'font-size';
		$this->$tmp = 10;
		$this->values    = array();
	}
	
	function set_values( $v )
	{
		$this->values = $v;		
	}
	
	function append_value( $v )
	{
		$this->values[] = $v;		
	}
}

