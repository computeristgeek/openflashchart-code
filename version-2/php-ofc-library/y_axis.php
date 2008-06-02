<?php

class y_axis
{
	function y_axis()
	{
		$this->stroke      		= 2;
		$this->tick_length      = 5;
		$this->colour      		= "#d09090";
		$this->grid_colour      = "#00ff00";
		//$this->offset           = 1;
		//$this->labels      		= array( "slashdot.org","digg.com","reddit.com" );
	}
	
	function set_range( $min, $max )
	{
		$this->min = $min;
		$this->max = $max;
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