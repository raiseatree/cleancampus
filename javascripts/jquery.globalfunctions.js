/* This document details site-wide jquery functions */
$(document).ready(function() {
	
	// Show any notifications
	showNotifications();
	
	/*
	 * Setup a hook for the Map View/Dashboard links to switch the active state
	 */
	$('.jq-mapdashlink').click(function() {
		
		// Set this button to be active
		$('.jq-mapdashlink').parent().removeClass('selected');
		$(this).parent().addClass('selected');
		
		// Check which link we clicked and show/hide the relevant content
		
		var id = $(this).attr('id').replace('jq-','');
		
		$('.jq-feature').fadeOut('fast', function() {
			$('#' + id).fadeIn('fast');			
		});
		
	});

	/*
	 * Load the problem in the problem side pane
	 */
	/*$('.jq-loadproblem').livequery('click', function(event) {
		alert('Hello');
	});
	
	$('.jq-loadproblem').click(function() {
		alert('Hello');
	});*/
	

	$('#map').click(function() {
		//alert('Hello');
	})

	/*
	 * TEMP - Assign the load issue details to a click on the map just to demo
	 */
	/*$('#map').click(function() {
		$('#mainHolder').animate({"width": "+=217px"}, "fast", function(){
			$('#sidePanelHolder').show("slide", { direction: "left" }, "fast");	
		});
	});
	
	$('.jq-close-side-panel').click(function(){
		$('#mainHolder').animate({"width": "-=217px"}, "fast", function(){
			$('#sidePanelHolder').hide("slide", { direction: "right" }, "fast");	
		});
	});*/
	
	/*
	 * Tabbed navigation goes here
	 */
	$('.tab').click(function() {

		// Find out the link href we clicked 
		var tab = $(this).attr('href');
		
		// Hide all tabs (easier than finding which one is open first)
		$('.tabContent').hide();
		
		// Remove all selected tab styles
		$('.tab').parent().removeClass('active');
		
		// Now find and open that tab
		$(tab).fadeIn('fast');
		
		// Set this tab to be active 
		$(this).parent().addClass('active');
		
		// Stop the link from executing
		return false;
		 
	});
	
});

/*
 * Functions for showing the Flash messages to the user - message drops down from the top of the screen now
 */
function showNotifications() {

    var notification = $("#notification");

    // Make sure it's visible even when top of the page not visible
    notification.css("top", $(window).scrollTop());
    notification.css("width", $(document).width());

    //show the notification
    notification.slideDown("slow", function() {
        setTimeout(hideNotifications,
            10000 // 10 seconds
            )
    });
}

/*
 * Quick function to auto hide the flash messages after 10 secs
 */
function hideNotifications() {
    $("#notification").slideUp("slow");
}
