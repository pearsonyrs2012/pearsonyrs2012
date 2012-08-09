$(document).ready( function() {

//
// Enabling miniColors
//

$(".color-picker").miniColors({
letterCase: 'uppercase',
change: function(hex, rgb) {
logData('change', hex, rgb);
},
open: function(hex, rgb) {
logData('open', hex, rgb);
},
close: function(hex, rgb) {
logData('close', hex, rgb);
}
});

});
	function logData(type, hex, rgb) {
$("#console").prepend(type + ': HEX = ' + hex + ', RGB = (' + rgb.r + ', ' + rgb.g + ', ' + rgb.b + ')<br />');
}