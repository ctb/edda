$(document).ready(function() {
	$("input#commentary-save").click(function() {
		alert("fiz!");
		return false;
	    });

	$("input#commentary-cancel").click(function() {
		alert("fiz!");
		return false;
	    });

	$("div").dblclick(function(event) {
		newform = $("form#commentary-form").clone().addClass('commentary-comment');
		newform.id = 'bar';

		$("div#" + this.id).append(newform);
		$("div#bar").show();
      
		return false;
	    });

	$.getJSON('/comments/get', { page: commentary_this_page },
		  function(data) {
		$.each(data, function(i, item) {
			var form = $("#commentary-display");
			var newform = form.clone();

			comment_id = 'comment-' + item.num;
			newform.attr("id", comment_id);
			newform.addClass('commentary-inline');
			newform.addClass('commentary-comment');
			newform.text(item.comment);
			$('div#' + item.position).children(':first').before(newform);
		    });
	    });
});
