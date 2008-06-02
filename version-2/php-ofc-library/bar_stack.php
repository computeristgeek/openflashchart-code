<?php

include_once 'bar_base.php';

class bar_stack extends bar_base
{
	function bar_stack()
	{
		$this->type      = "bar_stack";
		parent::bar_base();
	}
	
	function append_stack( $v )
	{
		$this->append_value( $v );
	}
}

class bar_stack_value
{
	function bar_stack_value( $val, $colour )
	{
		$this->val = $val;
		$this->colour = $colour;
	}
}