<?php

class ofc_menu_item_camera
{
	function ofc_menu_item_camera($text)
	{
		$this->type = "camera-icon";
		$this->text = $text;
	}
}

class ofc_menu
{
	function ofc_menu($colour, $outline_colour)
	{
		$this->colour = $colour;
		$this->outline_colour = $outline_colour;
	}
	
	function values($values)
	{
		$this->values = $values;
	}
}