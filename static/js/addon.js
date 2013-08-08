$(function() {
	
	/* Ensure optimal width of content */
	username_bak = $('.username').html();
	trail_bak = $('#ds-trail').html();
	content_resize();
	$(window).resize( function() { content_resize() } );
	
	/* Search form (top) */
	var searchtext = $('#searchbox .ds-text-field').val();
	$('.search-scope').click(function() {
		$('#searchbox .ds-text-field').focus();
	});
	$('#searchbox .ds-text-field').focus(function() {
		if ( $(this).val() == searchtext ) $(this).val('');
	}).blur(function() {
		if ( $(this).val() == '' ) $(this).val(searchtext);
	});
	
	/* User box (top) */
	$('#userbox').removeClass('hover');
	$('#userbox').has('.profile').click( function() {
		$(this).toggleClass('open')
		$('#userbox ul').toggle();
	});
	
	/* Corrent margins in forms with invisible elements */
	$('form p:hidden + p').css('margin-top', 0);
	
	/* Submission form */
	// If selected language is english, hide fields that are only needed for non-english publications
	$('#aspect_submission_StepTransformer_field_dc_language_iso').change(function() {
		var elements = [
			'#aspect_submission_StepTransformer_field_dc_title_translated',
			'#aspect_submission_StepTransformer_field_dc_title_alternativeTranslated'
			//'#aspect_submission_StepTransformer_field_dc_description_abstract',
			//'#aspect_submission_StepTransformer_field_dc_subject'
		];
		if ( $(this).val() == 'eng' ) {
			$.each(elements, function(key, value) { $('.ds-form-item').has(value).hide(); });
		} else {
			$.each(elements, function(key, value) { $('.ds-form-item').has(value).show(); });
		}
	});
	$('#aspect_submission_StepTransformer_field_dc_language_iso').change();
	
	/* Community/collection search form */
	$('#aspect_artifactbrowser_ConfigurableBrowse_div_browse-controls select').change(function() {
		$('#aspect_artifactbrowser_ConfigurableBrowse_field_update').click();
	});
	$('#aspect_artifactbrowser_ConfigurableBrowse_field_update').hide();
	
	/* Loading icon for file upload */
	$('<img/>')[0].src = '/themes/Mirage/images/white-80.png';
	$('<img/>')[0].src = '/themes/Mirage/images/loader.gif';
	$('#aspect_submission_StepTransformer_div_submit-upload').submit( function() {
		$('#aspect_submission_StepTransformer_div_submit-upload').append('<div id="overlay"><div>&nbsp;</div></div>');
	});
	
	$('.bookmark').click( function(e) {
		e.stopPropagation();
		var width = $(this).width();
		$(this).hide().after('<input class="bookmark-input" type="text" value="' + $(this).text() + '" />');
		$('.bookmark-input').width( width + 2 ).select();
		$('body').click( function(e) {
			$('.bookmark-input').remove();
			$('.bookmark').show();
			$('body').unbind('click');
		});
	});
	
	/* Scroll to top button */
	$('body').append('<button id="totop">&uarr;</button>');
	$(window).scroll( function() {
		console.log($(window).scrollTop());
		if ( $(window).scrollTop() > 300 ) {
			$('#totop:hidden').fadeIn();
			$('#totop').css('top', $(window).scrollTop() + $(window).height() - 85);
		} else {
			$('#totop:visible').fadeOut();
		}
	});
	$('#totop').click( function() {
		$('html, body').animate({scrollTop: 0});
	});
	
});

content_resize = function() {

	// Restore profile and trail before truncation
	if ( typeof username_bak !== 'undefined' ) { $('.username').html( username_bak ); }
	if ( typeof trail_bak !== 'undefined' ) { $('#ds-trail').html( trail_bak ); }
	
	/* Trail */
	// Cut trail if too long and if there are still untruncated items
	var i = 1;
	var items = $('#ds-trail a');
	var cut_items = [];
	while ( $('#ds-trail').height() > 28 && i < items.length) {
		var item = items.eq(i);
		// If current item contains more than one word, replace last word with … (&hellip;). Otherwise, move to next item.
		if ( item.text().indexOf(' ') >= 0 ) {
			if ( !cut_items[i] ) cut_items[i] = item.text();
			item.text( item.text().replace(/[\s,-\.\/]+[^\s]+…*$/, '…') );
		} else {
			i++;
		}
	}
	// If still too long, remove items completely; truncate second-to-last li, then last li; exit after 10 iterations each
	i = 0;
	while ( $('#ds-trail').height() > 28 && i++ < 5) items.eq(i).text('…');
	i = -20;
	while ( $('#ds-trail').height() > 28 && ++i < 0) {
		// Negative key: -2 or -1
		key = parseInt(i / 10 - 1);
		items = $('#ds-trail .ds-trail-link').not(':has(a)');
		item_text = items.eq(key).text();
		if ( !cut_items[key] ) cut_items[key] = item_text;
		items.eq(key).text( items.eq(key).text().replace(/[\s,-\.\/]+[^\s]+…*$/, '…') );
		if ( item_text != items.eq(key).text() && !cut_items[key] ) cut_items[key] = item_text;
	}
	// Add hint div for truncated/removed elements, fade in on hover
	for (i = -2; i < cut_items.length; i++) {
		if (cut_items[i]) $('#ds-trail .ds-trail-link').eq(i).append('<div class="hint"><span>' + cut_items[i] + '</span></div>');
	}
	$('#ds-trail li').hover( function() {
		$(this).find('.hint').css('opacity', 1).delay(200).stop().fadeIn();
	}, function() {
		$(this).find('.hint').clearQueue().stop().fadeOut();
	});
	
	/* Userbox */
	while ( $('#userbox').height() > 28 && ++i < 99) {
		$('.username').text( $('.username').text().replace(/.…*$/, '…') );
	};
	
	/* Nav: truncate items */
	$('#nav a').each( function() {
		i = 0;
		while ( $(this).height() > 28 && i++ < 99 ) {
			$(this).text( $(this).text().replace(/\.*.…*\s(\(\d+\))$/, '… $1') );
		}
	});
	
}
