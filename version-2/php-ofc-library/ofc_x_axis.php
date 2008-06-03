<?php

class x_axis
{
	function x_axis()
	{
		$this->labels = array();
	}

	function set_stroke( $stroke )
	{
		$this->stroke = $stroke;	
	}
	
	function set_colour( $colour )
	{
		$this->colour = $colour;	
	}
	
	function set_tick_height( $height )
	{
		$tmp = 'tick-height';
		$this->$tmp      		= $height;
	}
	
	function set_grid_colour( $colour )
	{
		$tmp = 'grid-colour';
		$this->$tmp = $colour;
	}
	
	function set_offset( $o )
	{
		$this->offset = $o?1:0;	
	}
	
	function set_steps( $steps )
	{
		$this->steps = $steps;
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