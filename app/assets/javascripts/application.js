// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
function search(what, where)
{
	what = what || $('#what').val();
	where = where || $('#where').val();
	var string = '/search/?what=' + what;
	if (where != '')
	{
		string += '&where=' + where;
	}
	window.location.href = string;
}
function update(param, id, isValue)
{

	var value = isValue == true ? id : $('#' + id).val();
	var url = $.url.decode(document.URL);
	var parsed = $.url.parse(url);
	parsed['query'] = '';
	parsed['relative'] = '';
	parsed['source'] = '';
	parsed['params'][param] = value;
	url = $.url.build(parsed);

	window.location.href = url;
}
jQuery(function(){
	$("#what").keypress(function(e) {
	    if(e.which == 13) {
	       search();
	    }
	});

	$("#where").keypress(function(e) {
	    if(e.which == 13) {
	       search();
	    }
	});
});