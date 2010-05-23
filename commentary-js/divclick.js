$(document).ready(function() {

	$("div.body").find('div').dblclick(function(event) {
		var newform = $("form#commentary-form").clone(true);
		newform.addClass('commentary-comment');

		var section_id = this.id;

		newform.find("input#commentary-save").click(function() {
			var username = newform.find('input#username').val();
			var email = newform.find('input#email').val();
			var comment = newform.find('textarea#comment').val();

			newform.hide();

			$.ajax({ url: '/comments/add',
				    type: 'POST',
				    data: {
				    page: commentary_this_page,
					comment: comment,
					email: email,
					username: username,
					position: section_id } });

			add_comment(5, section_id, comment);

			return false;
		    });

		newform.find("input#commentary-cancel").click(function() {
			newform.hide();
			return false;
		    });
      
		div = $("div#" + this.id);
		div.children(':first').before(newform);

		return false;
	    });

	function add_comment(n, position, comment) {
	    var form = $("#commentary-display");
	    var newform = form.clone();

	    comment_id = 'comment-' + n;
	    newform.attr("id", comment_id);
	    newform.addClass('commentary-inline');
	    newform.addClass('commentary-comment');
	    newform.text(comment);
	    $('div#' + position).children(':first').before(newform);
	    
	};

	
	$.getJSON('/comments/get', { page: commentary_this_page },
		  function(data) {
		$.each(data, function(i, item) {
			add_comment(item.num, item.position, item.comment);
		    });
	    });
});
