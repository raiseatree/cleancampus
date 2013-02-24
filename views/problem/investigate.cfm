<cfparam name="data">
<cfoutput>
	
<script type="text/javascript">
	$(document).ready(function() {
		// Select all links with lightbox class
		$('a.lightbox').lightBox(); 
		
		// Set up the show box links
		$('.addCommentButton').click(function() {
			$('.problemBox').fadeOut(function() {
				$('.addComment').fadeIn();
			});
		});
		
		$('.fixButton').click(function() {
			$('.problemBox').fadeOut(function() {
				$('.fixProblem').fadeIn();
			});
		});
		
		$('.rejectButton').click(function() {
			$('.problemBox').fadeOut(function() {
				$('.rejectProblem').fadeIn();
			});
		});
		
	});
</script>

<section id="main">
				
	#loadLoggedInHeader()#
	
	<h1>Problem #data.problem.ID#</h1>
		
	<section id="ccHolder" class="cb postRibbon">
		
		<div id="dashboard" class="cb jq-feature problemViewer">
		
			<!--- TODO Update the status colour here --->
			#showProblems(data.problem, 'red', false)#
		
			#startFormTag(controller="problemcomment", action="add")#	
				
				<div class="<cfif not(IsDefined('data.showFixForm'))>hidden</cfif> addComment problemBox">
					
					<h2>Add Comment</h2>
								
					#includePartial('/problem/addComment')#
				
					<!--- Include the redirect tag --->
					#submitTag(name="submit", class="inactiveButton", value="Add Comment")#
					
				</div>
			
				<div class="<cfif not(IsDefined('data.showFixForm'))>hidden</cfif> fixProblem problemBox">
					
					<h2>Fix Problem</h2>
								
					#includePartial('/problem/addComment')#
				
					<!--- Include the redirect tag --->
					#submitTag(name="submit", class="activeButton", value="Fix Problem")#
					
				</div>
			
				<div class="<cfif not(IsDefined('data.showFixForm'))>hidden</cfif> rejectProblem problemBox">
					
					<h2>Reject Problem</h2>
						
					#includePartial('/problem/addComment')#
				
					<!--- Include the redirect tag --->
					#submitTag(name="submit", class="redButton", value="Reject Problem")#
					
				</div>
				
				<p>
					#hiddenField(objectName="data.comment", property="problemID")#
					#hiddenField(objectName="data.comment", property="userID")#
				</p>
				
			#endFormTag()#
		
		</div>
		
	</section>
	
</section>

</cfoutput>