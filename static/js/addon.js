$(function() {
	
	/* Ensure optimal width of content */
	content_resize();
	username_bak = $('.username').html();
	trail_bak = $('#ds-trail').html();
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
	
	/* Corrent margins in forms with invisible elements */
	$('form p:hidden + p').css('margin-top', 0);
	
	/* Remove empty elements */
	/*
	$('p, h2, span').each( function() {
		if ( $(this).html() == '&nbsp;' ) $(this).remove();
	});
	*/
	
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
	
	/* Style file input for submission upload */
	$('#aspect_submission_StepTransformer_div_submit-upload .ds-file-field').customFileInput();
	
	/* Loading icon for file upload */
	$('<img/>')[0].src = '/ediss/themes/Mirage/images/white-80.png';
	$('<img/>')[0].src = '/ediss/themes/Mirage/images/loader.gif';
	$('#aspect_submission_StepTransformer_div_submit-upload').submit( function() {
		$('#aspect_submission_StepTransformer_div_submit-upload').append('<div id="overlay"><img src="/ediss/themes/Mirage/images/loader.gif" alt="Loading..." /></div>');
	});
	
});

content_resize = function() {

	var width = $(document).width();
	if ( width < 640 ) {
		$('#content, table').width( 'auto' );
	} else if ( width < 1000 ) {
		$('#content').width( width - 279 );
		$('table').width( width - 239 );
	} else {
		$('#content').width( 720 );
		$('table').width( 740 );
	}
	
	// Restore profile and trail before truncation
	if ( typeof username_bak !== 'undefined' ) { $('.username').html( username_bak ); }
	if ( typeof trail_bak !== 'undefined' ) { $('#ds-trail').html( trail_bak ); }
	$('#ds-trail').height('auto');
	
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
	// If still too long, remove items completely
	i = 0;
	while ( $('#ds-trail').height() > 28 && i++ < 5) items.eq(i).text('…');
	// Still too long? Truncate second-to-last li, then last li; exit after 10 iterations each
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
	// Make sure trail is never too big
	$('#ds-trail').height(28);
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
	$('#userbox').removeClass('hover');
	$('#userbox').has('.profile').click( function() {
		$(this).toggleClass('open')
		$('#userbox ul').toggle();
	});
	
	/* Nav: truncate items */
	$('#nav a').each( function() {
		i = 0;
		while ( $(this).height() > 28 && i++ < 99 ) {
			$(this).text( $(this).text().replace(/\.*.…*\s(\(\d+\))$/, '… $1') );
		}
	});
	
}

/**
 * --------------------------------------------------------------------
 * jQuery customfileinput plugin
 * Author: Scott Jehl, scott@filamentgroup.com
 * Copyright (c) 2009 Filament Group 
 * licensed under MIT (filamentgroup.com/examples/mit-license.txt)
 * --------------------------------------------------------------------
 */
$.fn.customFileInput = function(){
	//apply events and styles for file input element
	var fileInput = $(this)
		.addClass('customfile-input') //add class for CSS
		.focus(function(){
			upload.addClass('customfile-focus'); 
			fileInput.data('val', fileInput.val());
		})
		.blur(function(){ 
			upload.removeClass('customfile-focus');
			$(this).trigger('checkChange');
		 })
		.bind('disable',function(){
			fileInput.attr('disabled',true);
			upload.addClass('customfile-disabled');
		})
		.bind('enable',function(){
			fileInput.removeAttr('disabled');
			upload.removeClass('customfile-disabled');
		})
		.bind('checkChange', function(){
			if(fileInput.val() && fileInput.val() != fileInput.data('val')){
				fileInput.trigger('change');
			}
		})
		.bind('change',function(){
			//get file name
			var fileName = $(this).val().split(/\\/).pop();
			//get file extension
			var fileExt = 'customfile-ext-' + fileName.split('.').pop().toLowerCase();
			//update the feedback
			uploadFeedback
				.text(fileName) //set feedback text to filename
				.removeClass(uploadFeedback.data('fileExt') || '') //remove any existing file extension class
				.addClass(fileExt) //add file extension class
				.data('fileExt', fileExt) //store file extension for class removal on next change
				.addClass('customfile-feedback-populated'); //add class to show populated state
			//change text of button	
			uploadButton.text('Ändern');	
		})
		.click(function(){ //for IE and Opera, make sure change fires after choosing a file, using an async callback
			fileInput.data('val', fileInput.val());
			setTimeout(function(){
				fileInput.trigger('checkChange');
			},100);
		});
		
	//create custom control container
	var upload = $('<div class="customfile"></div>');
	//create custom control button
	var uploadButton = $('<span class="customfile-button" aria-hidden="true">' + $('.browse-text.hidden').text() + '</span>').appendTo(upload);
	//create custom control feedback
	var uploadFeedback = $('<span class="customfile-feedback" aria-hidden="true">' + $('.none-selected-text.hidden').text() + '</span>').appendTo(upload);
	
	//match disabled state
	if (fileInput.is('[disabled]')) {
		fileInput.trigger('disable');
	}
	
	//on mousemove, keep file input under the cursor to steal click
	upload
		.mousemove(function(e){
			fileInput.css({
				'left': e.pageX - upload.offset().left - fileInput.outerWidth() + 20, //position right side 20px right of cursor X)
				'top': e.pageY - upload.offset().top - $(window).scrollTop() - 3
			});	
		})
		.insertAfter(fileInput); //insert after the input
	
	fileInput.appendTo(upload);
		
	//return jQuery
	return $(this);
};
