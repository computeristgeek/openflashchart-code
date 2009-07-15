<?php

class ofc_arrow
{
	function ofc_arrow($x, $y, $a, $b, $colour, $barb_length=10)
	{
		$this->type     = "arrow";
		$this->start	= array("x"=>$x, "y"=>$y);
		$this->end		= array("x"=>$a, "y"=>$b);
		$this->colour($colour);
		$this->{"barb-length"} = $barb_length;
	}
	
	function colour( $colour )
	{
		$this->colour = $colour;
		return $this;
	}
}
