function set_image_size(view_size, img) {
	view_size = parseInt(view_size);
	var width = img.naturalWidth;
	var $img = $(img);
	$img.parents(".image_container").width((width * view_size) + "px");
}

function apply_options(view_size, dl_size) {
	view_size = parseInt(view_size);
	$('#images img').each(function(i, img) {
		set_image_size(view_size, img);
	});
	$('#images a').each(function(i, a) {
		var $a = $(a);
		var link=$a.attr('href');
		var newlink=link.replace(/(-+[0-9]+x)?\.gif$/, "-" + dl_size + ".gif");
		$a.attr('href', newlink);
	});
}

var view_size = 0;
var dl_size = 0;

$(document).ready(function() {
	view_size = $('#view_size').val();
	dl_size = $('#download_size').val();

	$('select').change(function() {
		view_size = $('#view_size').val();
		dl_size = $('#download_size').val();
		apply_options(view_size, dl_size);
	});

	$('#images img').each(function(i, img) {
		if (!this.complete) {
			$(this).on('load', function() {
				set_image_size(view_size, this);
				$(this).off('load');
			});
		} else {
			set_image_size(view_size, this);
		}
	});
});
