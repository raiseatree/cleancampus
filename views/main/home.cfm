<cfparam name="data">
<cfoutput>
	
<!---<script src="http://maps.google.com/maps?file=api&v=2&key=AIzaSyD51ESXcA_5O_tvWhezknGz9OcF-aAf7VQ"></script>
<script type="text/javascript" src="http://api.maps.yahoo.com/ajaxymap?v=3.0&appid=MapstractionDemo"></script>
<script src="http://dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=6"></script>
<script src="http://openlayers.org/api/OpenLayers.js"></script>
<script type="text/javascript" charset="utf-8" src="http://mapstraction.googlecode.com/svn/trunk/source/mxn.js?(google)"></script>--->
	
<script type="text/javascript">
$(function() {
	$('a.lightbox').lightBox(); // Select all links with lightbox class
});
</script>
	
<section id="main">
				
	#loadLoggedInHeader()#
	
	<h1>Welcome to Clean Campus!</h1>
	
	<header class="postRibbon">
		<ul class="nav-mapDash">
			<li><a href="##" id="jq-map" class="jq-mapdashlink"</a>Map View</a></li>
			<li class="selected"><a href="##" id="jq-dashboard" class="jq-mapdashlink">Dashboard</a></li>
		</ul>
		
		<div class="pins">
			#imageTag('red-pin.png')# <span class="red">#data.redProblems.RecordCount#</span>
			#imageTag('amber-pin.png')# <span class="amber">#data.amberProblems.RecordCount#</span>
			#imageTag('green-pin.png')# <span class="green">#data.greenProblems.RecordCount#</span>
		</div>
	</header>
		
	<section id="ccHolder" class="cb">
	   
		<!---><script type="text/javascript">
			var mapstraction;
			function initialize() {
			    mapstraction = new mxn.Mapstraction('map','google');
			    mapstraction.setCenterAndZoom(new mxn.LatLonPoint( #data.user.centreLat#, #data.user.centreLon# ), 14);
			    mapstraction.addLargeControls();
			    
			    // Loop thru the markers we want to add 
				<cfif data.problems.RecordCount GT 0>
					<cfloop query="data.problems">
					    advancedMarker( #data.problems.id#, #data.problems.latitude#, #data.problems.longitude#, '#data.problems.statusColour#', '#data.problems.typelabel#' );
					</cfloop>
				</cfif>
			}
			
			function advancedMarker( v_id, v_lat, v_lon, v_icon, v_typelabel ) {
			    mapstraction.addMarkerWithData(new mxn.Marker( new mxn.LatLonPoint( v_lat, v_lon )),{
			        icon : '/cleancampus/images/' + v_icon + '-pin.png',
			        iconSize : [29,30],
			        infoBubble : '<a href=## class=jq-loadproblem><strong>' + v_typelabel + '</strong></a><br/><p><a href="##" class="jq-loadproblem" id="problem-' + v_id + ' ">View Details</a></p>'
			    });
			}
			
			function alertMe() {
				alert('You triggered the function');
			}
		</script>
	   
	    <div id="map" class="cb jq-feature hidden"></div>--->
		
		<!--- Open Street Map library
	    <script src="http://www.openlayers.org/api/OpenLayers.js"></script>
		<script>
			map = new OpenLayers.Map("map");
			map.addLayer(new OpenLayers.Layer.OSM());
			var zoom=14;
			
			// Define the map centre
			var mapCentre = new OpenLayers.LonLat( #data.user.centreLon#, #data.user.centreLat# )
			      .transform(
			        new OpenLayers.Projection("EPSG:4326"), // transform from WGS 1984
			        map.getProjectionObject() // to Spherical Mercator Projection
			      );
			
			map.setCenter (mapCentre, zoom);
			
			var markers = new OpenLayers.Layer.Markers( "Markers" );
			map.addLayer(markers);
			
			// Marker Variables 
			var size = new OpenLayers.Size(29, 30);
			var offset = new OpenLayers.Pixel(-(size.w / 2), -size.h);
			var greenIcon = new OpenLayers.Icon("/cleancampus/images/green-pin.png", size, offset);
			var amberIcon = new OpenLayers.Icon("/cleancampus/images/amber-pin.png", size, offset);
			var redIcon = new OpenLayers.Icon("/cleancampus/images/red-pin.png", size, offset);
			
			// Loop thru the markers we want to add 
			<cfif data.problems.RecordCount GT 0>
				<cfloop query="data.problems">
					// Define the marker position
					var marker#data.problems.CurrentRow# = new OpenLayers.LonLat( #data.problems.longitude#, #data.problems.latitude# )
					      .transform(
					        new OpenLayers.Projection("EPSG:4326"), // transform from WGS 1984
					        map.getProjectionObject() // to Spherical Mercator Projection
					      );
					 
					// Add the marker to the map     
					markers.addMarker(new OpenLayers.Marker(marker#data.problems.CurrentRow#, #data.problems.statusColour#Icon.clone()));
				</cfloop>
			</cfif>
		</script>--->
		
		<div id="dashboard" class="cb jq-feature">
			<ul id="tabNav">
				<li<cfif data.redProblems.RecordCount GT 0> class="active"</cfif>><a href="##tab1" class="tab">Unassigned Problems (#data.redProblems.RecordCount#)</a></li>
				<li<cfif data.redProblems.RecordCount EQ 0 AND data.amberProblems.RecordCount GT 0> class="active"</cfif>><a href="##tab2" class="tab">Assigned Problems (#data.amberProblems.RecordCount#)</a></li>
				<li class="last"><a href="##tab3" class="tab">Fixed Problems (#data.greenProblems.RecordCount#)</a></li>
			</ul>
			
			<cfif data.problems.RecordCount GT 0>
				<div id="tab1" class="tabContent<cfif data.redProblems.RecordCount EQ 0> hidden</cfif>">
					<cfif data.redProblems.RecordCount GT 0>
						<cfloop query="data.redProblems">
							<div class="overflow">
								<h2 class="itemTitle"><a href="##" class="tag red">#typeLabel#</a>#title# <span class="fr">#timeAgoInWords(createdAt)# ago</span></h2>
								<p><cfif IsDefined("image") AND image GT ''><a href="/images/dropzone/#image#" class="lightbox">#imageTag(source='dropzone/#image#', class="dashImage")#</a><cfelse>#imageTag('no-image.png')#</cfif> #description#</p>
								<p>#imageTag('map-pin.png')#</p>
							</div>
						</cfloop>
					<cfelse>
						<p>Woo hoo! All problems have been assigned right now.</p>
					</cfif>
				</div>
				
				<div id="tab2" class="tabContent <cfif data.redProblems.RecordCount EQ 0 AND data.amberProblems.RecordCount GT 0> <cfelse>hidden</cfif>">
					<cfif data.amberProblems.RecordCount GT 0>
						<cfloop query="data.amberProblems">
							<div class="overflow">
								<h2 class="itemTitle"><a href="##" class="tag amber">#typeLabel#</a>#title# <span class="fr">#timeAgoInWords(createdAt)# ago</span></h2>
								<p><cfif IsDefined("image") AND image GT ''><a href="/images/dropzone/#image#" class="lightbox">#imageTag(source='dropzone/#image#', class="dashImage")#</a><cfelse>#imageTag('no-image.png')#</cfif> #description#</p>
								<p class="itemMap">
									<span>Click map to enlarge</span>
									<a href="http://maps.googleapis.com/maps/api/staticmap?maptype=satellite&center=#latitude#,#longitude#&zoom=17&&size=320x240&scale=2&markers=color:red%7C#latitude#,#longitude#&sensor=false" class="lightbox">
										<img src="http://maps.googleapis.com/maps/api/staticmap?center=#latitude#,#longitude#&zoom=15&&size=490x100&markers=color:red%7C#latitude#,#longitude#&sensor=false">
									</a>
								</p>
							</div>
						</cfloop>
					<cfelse>
						<p>No problems in this category right now.</p>
					</cfif>
				</div>
				
				<div id="tab3" class="tabContent hidden">
					<cfif data.greenProblems.RecordCount GT 0>
						<cfloop query="data.greenProblems">
							<div class="overflow">
								<h2 class="itemTitle"><a href="##" class="tag green">#typeLabel#</a>#title# <span class="fr">#timeAgoInWords(createdAt)# ago</span></h2>
								<p><cfif IsDefined("image") AND image GT ''><a href="/images/dropzone/#image#" class="lightbox">#imageTag(source='dropzone/#image#', class="dashImage")#</a><cfelse>#imageTag('no-image.png')#</cfif> #description#</p>
								<p>#imageTag('map-pin.png')#</p>
							</div>
						</cfloop>
					<cfelse>
						<p>No problems in this category right now.</p>
					</cfif>
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
	
</cfoutput>