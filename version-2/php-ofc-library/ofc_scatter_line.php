<?php

class scatter_line
{
	function scatter_line( $colour, $dot_size )
	{
		$this->type      = "scatter_line";
		$this->set_colour( $colour );
		$this->set_dot_size( $dot_size );
	}
	
	function set_colour( $colour )
	{
		$this->colour = $colour;
	}

	function set_dot_size( $dot_size )
	{
		$tmp = 'dot-size';
		$this->$tmp = $dot_size;
	}
	
	function set_values( $values )
	{
		$this->values = $values;
	}
	
	function set_step_horizontal()
	{
		$this->stepgraph = 'horizontal';
	}
	
	function set_step_vertical()
	{
		$this->stepgraph = 'vertical';
	}
	
	function set_key( $text, $font_size )
	{
		$this->text      = $text;
		$tmp = 'font-size';
		$this->$tmp = $font_size;
	}
}