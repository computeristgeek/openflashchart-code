<?php

class x_axis
{
	function x_axis()
	{
		$this->stroke      		= 1;
		$this->tick_height      = 10;
		$this->colour      		= "#d000d0";
		$this->grid_colour      = "#00ff00";
		$this->labels      		= array( "January","February","March","April","May","June","July","August","Spetember" );
		
	}
	
	function set_offset( $o )
	{
		$this->offset = $o?1:0;	
	}
	
	function set_step( $step )
	{
		$this->step = $step;
	}
	
	function set_3d( $val )
	{
		$tmp = '3d';
		$this->$tmp				= $val;		
	}
	
	function set_labels( $v )
	{
		$this->labels = $v;		
	}
}