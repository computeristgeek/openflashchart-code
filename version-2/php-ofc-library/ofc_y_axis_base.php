<?php

class y_axis_base
{
	function y_axis_base(){}
	
	/**
	 * @param $s as integer, thickness of the Y axis line
	 */
	function set_stroke( $s )
	{
		$this->stroke = $s;
	}
	
	/**
	 * @param $val as integer. The length of the ticks in pixels
	 */
	function set_tick_length( $val )
	{
		$tmp = 'tick-length';
		$this->$tmp = $val;
	}
	
	function set_colours( $colour, $grid_colour )
	{
		$this->set_colour( $colour );
		$this->set_grid_colour( $grid_colour );
	}
	
	function set_colour( $colour )
	{
		$this->colour = $colour;
	}
	
	function set_grid_colour( $colour )
	{
		$tmp = 'grid-colour';
		$this->$tmp = $colour;
	}
	
	/**
	 * Set min and max values, also (optionally) set the steps value.
	 * You can reverse the chart by setting min larger than max, e.g. min = 10
	 * and max = 0.
	 * 
	 * @param $min as integer
	 * @param $max as integer
	 * @param $steps as integer.
	 */
	function set_range( $min, $max, $steps=1 )
	{
		$this->min = $min;
		$this->max = $max;
		$this->set_steps( $steps );
	}
	
	/**
	 * @param $off as Boolean. If true the Y axis is nudged up half a step.
	 */
	function set_offset( $off )
	{
		$this->offset = $off?1:0;
	}
	
	/**
	 * @param $labels as an array of string values.
	 *
	 * By default the Y axis will show from min to max, but you can override this
	 * by passing in your own labels. Remember the Y axis min is at the bottom, so
	 * the labels will go from bottom to top.
	 */
	function set_labels( $labels )
	{
		$this->labels = $labels;	
	}
	
	/**
	 * @param $steps as integer.
	 *
	 * Only show every $steps label, e.g. every 10th
	 */
	function set_steps( $steps )
	{
		$this->steps = $steps;	
	}
}