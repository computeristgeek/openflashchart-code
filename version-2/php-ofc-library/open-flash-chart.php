<?php

include_once 'JSON.php';
include_once 'json_format.php';

// ofc classes
include_once 'title.php';
include_once 'y_axis.php';
include_once 'x_axis.php';
include_once 'area_hollow.php';

class bar
{
	function bar()
	{
		$this->type      = "bar";
		$this->alpha     = 0.5;
		$this->colour    = "#9933CC";
		$this->text      = "Page views";;
		$tmp = 'font-size';
		$this->$tmp = 10;
		$this->values    = array(9,6,7,9,5,7,6,9,7);
	}
	
	function set_values( $v )
	{
		$this->values = $v;		
	}
}

class hbar
{
	function hbar()
	{
		$this->type      = "hbar";
		$this->colour    = "#9933CC";
		$this->text      = "Page views";;
		$tmp = 'font-size';
		$this->$tmp = 10;
		$this->values    = array();
	}
	
	function append_value( $v )
	{
		$this->values[] = $v;		
	}
}

class hbar_value
{
	function hbar_value( $right, $left=null )
	{
		$this->right = $right;
		if( isset( $left ) )
			$this->left = $left;
	}
}

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

class open_flash_chart
{
	function open_flash_chart()
	{
		$this->title = new title( "Many data lines" );
		$this->elements = array();
		$this->x_axis = new x_axis();
	}
	
	function set_title( $t )
	{
		$this->title = $t;
	}
	
	function add_y_axis( $y )
	{
		$this->y_axis = $y;
	}
	
	function add_element( $e )
	{
		$this->elements[] = $e;
	}
	
	function toString()
	{
		$json = new Services_JSON();
		return $json->encode( $this );
	}
	
	function toPrettyString()
	{
		return json_format( $this->toString() );
	}
}



//
// there is no PHP end tag so we don't mess the headers up!
//