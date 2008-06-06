<?php

class y_axis
{
	function y_axis(){}
	
	function set_stroke( $s )
	{
		$this->stroke = $s;
	}
	
	function set_tick_length( $val )
	{
		$this->tick_length = $val;
	}
	
	function set_colour( $colour )
	{
		$this->clour = $clour;
	}
	
	function set_grid_colour( $colour )
	{
		$this->grid_colour = $colour;
	}
	
	function set_range( $min, $max, $steps=1 )
	{
		$this->min = $min;
		$this->max = $max;
		$this->steps = $steps;
	}
	
	function set_offset( $off )
	{
		$this->offset = $off?1:0;
	}
	
	function set_labels( $labels )
	{
		$this->labels = $labels;	
	}
}