<?php

/**
 * A private class. All the other line-dots inherit from this.
 * Gives them all some common methods.
 */ 
class dot_base
{
	/**
	 * @param $type string
	 * @param $value integer
	 */
	function dot_base($type, $value=null)
	{
		$this->type = $type;
		if( isset( $value ) )
			$this->value( $value );
	}
	
	/**
	 * The value (Y position)
	 */
	function value( $value )
	{
		$this->value = $value;
	}
	
	/**
	 * @param $colour is a string, HEX colour, e.g. '#FF0000' red
	 */
	function colour($colour)
	{
		$this->colour = $colour;
		return $this;
	}
	
	/**
	 * The tooltip for this dot.
	 */
	function tooltip( $tip )
	{
		$this->tip = $tip;
		return $this;
	}
	
	/**
	 * @param $size is an integer. Size of the dot.
	 */
	function size($size)
	{
		$tmp = 'dot-size';
		$this->$tmp = $size;
		return $this;
	}
	
	/**
	 * a private method
	 */
	function type( $type )
	{
		$this->type = $type;
		return $this;
	}
	
	/**
	 * @param $size is an integer. The size of the hollow 'halo' around the dot that masks the line.
	 */
	function halo_size( $size )
	{
		$tmp = 'halo-size';
		$this->$tmp = $size;
		return $this;
	}
}

/**
 * Draw a hollow dot
 */
class hollow_dot extends dot_base
{	
	function hollow_dot($value=null)
	{
		parent::dot_base( 'hollow-dot', $value );
	}
}

/**
 * Draw a star
 */
class star extends dot_base
{
	/**
	 * The constructor, takes an optional $value
	 */
	function star($value=null)
	{
		parent::dot_base( 'star', $value );
	}
	
	/**
	 * @param $angle is an integer.
	 */
	function rotation($angle)
	{
		$this->rotation = $angle;
		return $this;
	}
	
	/**
	 * @param $is_hollow is a boolean.
	 */
	function hollow($is_hollow)
	{
		$this->hollow = $is_hollow;
	}
}

/**
 * Draw a 'bow tie' shape.
 */
class bow extends dot_base
{
	/**
	 * The constructor, takes an optional $value
	 */
	function bow($value=null)
	{
		parent::dot_base( 'bow', $value );
	}
	
	/**
	 * Rotate the anchor object.
	 * @param $angle is an integer.
	 */
	function rotation($angle)
	{
		$this->rotation = $angle;
		return $this;
	}
}

/**
 * An <i><b>n</b></i> sided shape.
 */
class anchor extends dot_base
{
	/**
	 * The constructor, takes an optional $value
	 */
	function anchor($value=null)
	{
		parent::dot_base( 'anchor', $value );
	}
	
	/**
	 * Rotate the anchor object.
	 * @param $angle is an integer.
	 */
	function rotation($angle)
	{
		$this->rotation = $angle;
		return $this;
	}
	
	/**
	 * @param $sides is an integer. Number of sides this shape has.
	 */
	function sides($sides)
	{
		$this->sides = $sides;
		return $this;
	}
}

/**
 * A simple dot
 */
class dot extends dot_base
{
	/**
	 * The constructor, takes an optional $value
	 */
	function dot($value=null)
	{
		parent::dot_base( 'dot', $value );
	}
}

/**
 * A simple dot
 */
class solid_dot extends dot_base
{
	/**
	 * The constructor, takes an optional $value
	 */
	function solid_dot($value=null)
	{
		parent::dot_base( 'solid-dot', $value );
	}
}