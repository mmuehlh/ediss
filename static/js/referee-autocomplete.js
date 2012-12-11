/*
 * Autocomplete referer for eDiss submission form
 */

$(function () {

	/* DSpace JSON response:
	{
		"responseHeader":{
			"status":0,
			"QTime":3,
			"params":{
				"q":"*:*",
				"facet.field":"author_ac",
				"json.nl":"map",
				"f.author_ac.facet.limit":"10",
				"facet.mincount":"1",
				"f.author_ac.facet.sort":"count",
				"json.wrf":"jQuery",
				"facet":"true",
				"rows":"0",
				"wt":"json"
			}
		},
		"response":{
			"numFound":3121,
			"start":0,
			"docs":[]
		},
		"facet_counts":{
			"facet_queries":{},
			"facet_fields":{
				"author_ac":{
					"mÃ¼hlhÃ¶lzer, marianna":10,
					"muehlhoelzer, marianna":6,
					"mÃ¼ller, matthias":3,
					"feuerstein, patrick":2,
					"garbe, ulf":2,
					"jahn, gabriele":2,
					"lange, claudia":2,
					"mÃ¼ller, christian":2,
					"streng, christoph":2,
					"zilly, felipe emilio":2
				}
			},
			"facet_dates":{},
			"facet_ranges":{}
		}
	}
	*/
	
	var url = "/ediss/JSON/discovery/search?q=";
	var params = "&facet=true&facet.limit=-1&facet.sort=count&facet.mincount=1&json.nl=map&facet.field=author&wt=&json.wrf=";
	
	/*
	$( "#aspect_submission_StepTransformer_field_dc_contributor_referee_last" ).autocomplete({
		source: function(request, response) {
			$.getJSON(url + request.term + params, function(json) {
				var items = new Array();
				$.each(json.facet_counts.facet_fields.author_ac, function(name, count) { 
					items.push(name);
				});
				response(items);
			});
		}
	});
	*/
	
	$.getJSON(url + '*:*' + params, function(json) {
		var items = new Array();
		$.each(json.facet_counts.facet_fields.author_ac, function(name, count) { 
			items.push(name.replace(/[^\s]+/g, function(str){ return str.substr(0,1).toUpperCase()+str.substr(1).toLowerCase() }) );
		});
		$( "#aspect_submission_StepTransformer_field_dc_contributor_advisor_last,\
				#aspect_submission_StepTransformer_field_dc_contributor_referee_last,\
				#aspect_submission_StepTransformer_field_dc_contributor_coReferee_last,\
				#aspect_submission_StepTransformer_field_dc_contributor_thirdReferee_last" ).autocomplete({
			source: function(request, response) {
				var results = $.ui.autocomplete.filter(items, request.term);
				response(results.slice(0, 8));
			},
			close: function(event, ui) {
				var tokens = $(this).val().split(', ', 2);
				$(this).val( tokens[0] ); // Put only last name in first field
				$(this).parent().parent().find('input:eq(1)').val( tokens[1] ); // Put first name and title in last field
			}
		});
	});
	
});
