<cfparam name="data">
<cfoutput>
	
<section id="main">
				
	#loadLoggedInHeader()#
	
	<h1>Welcome to #LoadSiteTitle()#!</h1>
	
	<header class="postRibbon">
		<ul class="nav-mapDash">
			<li class="selected"><a href="##" id="jq-map" class="jq-mapdashlink"</a>Map View</a></li>
			<li><a href="##" id="jq-dashboard" class="jq-mapdashlink">Dashboard</a></li>
		</ul>
		
		<div class="pins">
			#imageTag('red-pin.png')# <span class="red">#data.redProblems.RecordCount#</span>
			#imageTag('amber-pin.png')# <span class="amber">#data.amberProblems.RecordCount#</span>
			#imageTag('green-pin.png')# <span class="green">#data.greenProblems.RecordCount#</span>
		</div>
	</header>
		
	<section id="ccHolder" class="cb">
	   
		<div id="map" class="cb jq-feature"></div>
	   
		<div id="dashboard" class="cb jq-feature hidden">
			<ul id="tabNav">
				<li<cfif data.redProblems.RecordCount GT 0> class="active"</cfif>><a href="##tab1" class="tab">Unassigned Problems (#data.redProblems.RecordCount#)</a></li>
				<li<cfif data.redProblems.RecordCount EQ 0 AND data.amberProblems.RecordCount GT 0> class="active"</cfif>><a href="##tab2" class="tab">Assigned Problems (#data.amberProblems.RecordCount#)</a></li>
				<li class="last"><a href="##tab3" class="tab">Fixed Problems (#data.greenProblems.RecordCount#)</a></li>
			</ul>
			
			<cfif data.problems.RecordCount GT 0>
				<div id="tab1" class="tabContent<cfif data.redProblems.RecordCount EQ 0> hidden</cfif>">
					#showProblems(data.redProblems, 'red', true)#
				</div>
				
				<div id="tab2" class="tabContent <cfif data.redProblems.RecordCount EQ 0 AND data.amberProblems.RecordCount GT 0> <cfelse>hidden</cfif>">
					#showProblems(data.amberProblems, 'amber', true)#
				</div>
				
				<div id="tab3" class="tabContent hidden">
					#showProblems(data.greenProblems, 'green', true)#
				</div>
			<cfelse>
				<div class="tabContent">
					<p>Nice Work - No problems have been reported right now!</p>
				</div>
			</cfif>
		
		</div>
		
	</section>
	
</section>
			
<section id="sidePanelHolder">
	<h2 class="itemTitle">Issue Details <span><a href="##" class="jq-close-side-panel">Close #imageTag("close-sml.png")#</a></span></h2>
	<div class="side-content">
		#imageTag(source="temp-image.png", class="centre")#
		#imageTag(source="temp-assigned.png", class="centre")#
		#imageTag(source="temp-tag.png", class="centre")#
		<p>Nulla vitae elit libero, a pharetra augue. Donec ullamcorper nulla non metus auctor fringilla. Cras mattis consectetur purus sit amet fermentum.</p>
	</div>
</section>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="http://maps.google.com/maps?file=api&v=2&sensor=false&key=AIzaSyC3vJSkfPRqg6tdLWNshVzshTrL9L1abqU"></script>
<script type="text/javascript" charset="utf-8" src="http://mapstraction.googlecode.com/svn/trunk/source/mxn.js?(google)"></script>
<script type="text/javascript">
	$(document).ready(function() {
		
		// Initialise the map
		init();
		
		// Initialise the lightbox 
		$('a.lightbox').lightBox(); // Select all links with lightbox class
		
	});
   
	function init() {
		
		// initialise the map with your choice of API
		var mapstraction = new mxn.Mapstraction('map','google');
		
		// Loop thru the markers we want to add 
		<cfif data.problems.RecordCount GT 0>
			<cfloop query="data.problems">
			    <!---advancedMarker( #data.problems.id#, #data.problems.latitude#, #data.problems.longitude#, '#data.problems.statusColour#', '#data.problems.typelabel#' );--->
			    var marker = advancedMarker( #data.problems.id#, #data.problems.latitude#, #data.problems.longitude#, '#data.problems.statusColour#', '#data.problems.typelabel#', '#data.problems.image#' );
			    mapstraction.addMarker(marker);
			</cfloop>
		</cfif>
		
		mapstraction.setCenterAndZoom(new mxn.LatLonPoint( #data.user.centreLat#, #data.user.centreLon# ), 14);
	    mapstraction.addLargeControls();
	   
   }
   
   function advancedMarker( v_id, v_lat, v_lon, v_icon, v_typeLabel, v_image ) {
		
		var marker = new mxn.Marker( new mxn.LatLonPoint( v_lat, v_lon ));
	    var content = '<h2 class="' + v_icon + '">' + v_typeLabel + '</h2><br/><img src="/images/dropzone/thumbs/' + v_image + '" /><p><a href="/problem/investigate?id=' + v_id + '" class="fl activeButton">View Problem</a></p>';
        marker.setIcon('/images/' + v_icon + '-pin.png');
        marker.setIconSize([29,30]);
        marker.setInfoBubble(content);
        
	    return marker;
	    
	}
</script>
	
</cfoutput>