<?php

class pie_value
{
	function pie_value( $value, $text )
	{
		$this->value = $value;
		$this->text = $text;
	}
}

class pie
{
	function pie()
	{
		$this->type      		= 'pie';
		$this->colours     		= array("#d01f3c","#356aa0","#C79810");
		$this->alpha			= 0.6;
		$this->border			= 2;
		$this->animate			= 0;
		$this->values			= array(2,3,new pie_value(6.5, "hello (6.5)"));
		
		$tmp = 'start-angle';
		$this->$tmp				= 45;
	}
}
