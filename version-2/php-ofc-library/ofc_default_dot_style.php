<?php

class default_dot_style
{
	function default_dot_style()
	{
		$this->type = 'dot';
	}

	function set_colour($colour)
	{
		$this->colour = $colour;
		return $this;
	}
	
	function set_tooltip( $tip )
	{
		$this->tip = $tip;
	}
	
	function set_dot_size($size)
	{
		$tmp = 'dot-size';
		$this->$tmp = $size;
		return $this;
	}
	
	function set_type( $type )
	{
		$this->type = $type;
		return $this;
	}
	
	function set_hollow_dot()
	{
		$this->set_type( 'hollow-dot' );
		return $this;
	}
	
	function set_star()
	{
		$this->set_type( 'star' );
		return $this;
	}
	
	function set_bow()
	{
		$this->set_type( 'bow' );
		return $this;
	}
	
	function set_anchor()
	{
		$this->set_type( 'anchor' );
		return $this;
	}
	
	function set_dot()
	{
		$this->set_type( 'dot' );
		return $this;
	}

}