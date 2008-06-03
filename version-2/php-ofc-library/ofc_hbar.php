<?php

class hbar_value
{
	function hbar_value( $right, $left=null )
	{
		$this->right = $right;
		if( isset( $left ) )
			$this->left = $left;
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

