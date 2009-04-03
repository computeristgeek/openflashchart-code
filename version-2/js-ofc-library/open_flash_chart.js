function ofc_chart() {
	this.set_title = function(title) {
		this.title = title;
	}

	this.elements = new Array();
	this.add_element = function(new_element) {
		this.elements.push(new_element);
	}

	this.set_x_axis = function(axis) {
		this.x_axis = axis;
	}

	this.set_y_axis = function(axis) {
		this.y_axis = axis;
	}
}

function ofc_title(text, style) {
	this.text = text;
	this.style = style;
}

function ofc_element(type) {
	this.type = type;

	this.values = new Array();
	this.set_values = function(values) {
		this.values = values;
	}

	this.set_key = function(text, size) {
		this.text = text;
		this['font-size'] = size;
	}

	this.set_colour = function(colour) {
		this.colour = colour;
	}
}

ofc_line.prototype = new ofc_element();
function ofc_line() {
	ofc_element.apply(this, ["line"]);
}

ofc_bar.prototype = new ofc_element();
function ofc_bar() {
	ofc_element.apply(this, ["bar"]);
}

function ofc_axis() {
	this.set_range = function(min, max) {
		this.min = min;
		this.max = max;
	}

	this.set_steps = function(steps) {
		this.steps = steps;
	}

	this.set_stroke = function(stroke) {
		this.stroke = stroke;
	}

	this.set_colour = function(colour) {
		this.colour = colour;
	}

	this.set_grid_colour = function(grid_colour) {
		this['grid-colour'] = grid_colour;
	}

	this.set_offset = function(offset) {
		this.offset = offset;
	}
}

ofc_x_axis.prototype = new ofc_axis();
function ofc_x_axis() {
	this.set_tick_height = function(tick_height) {
		this['tick-height'] = tick_height;
	}

	this.set_3d = function(threeD) {
		this['3d'] = threeD;
	}
}

ofc_y_axis.prototype = new ofc_axis();
function ofc_y_axis() {
	this.set_tick_length = function(tick_length) {
		this['tick-length'] = tick_length;
	}

	this.set_grid_visible = function(grid_visible) {
		this['grid-visible'] = grid_visible;
	}
}
