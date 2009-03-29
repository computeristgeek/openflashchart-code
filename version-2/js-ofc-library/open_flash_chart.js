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
}

ofc_x_axis.prototype = new ofc_axis();
function ofc_x_axis() {

}

ofc_y_axis.prototype = new ofc_axis();
function ofc_y_axis() {

}
