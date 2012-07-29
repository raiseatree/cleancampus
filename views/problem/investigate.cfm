<cfparam name="data">
<cfoutput>
	
<script type="text/javascript">
	$(document).ready(function() {
		// Select all links with lightbox class
		$('a.lightbox').lightBox(); 
		
		// Set up the show box links
		$('.fixButton').click(function() {
			$('.fixProblem').fadeIn();
		});
		
		$('.rejectButton').click(function() {
			$('.rejectProblem').fadeIn();
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
		
			<div class="<cfif not(IsDefined('data.showFixForm'))>hidden</cfif> fixProblem">
				
				<h2>Fix Problem</h2>
				
				#startFormTag(controller="problemcomment", action="add")#	
					
					#includePartial('/problem/addComment')#
				
					<!--- Include the redirect tag --->
					#hiddenFieldTag(name="comment[cmd]", value="fixed")#
					#submitTag(name="submit", class="activeButton", value="Fix Problem &gt;")#
				
				#endFormTag()#
				
			</div>
		
			<div class="<cfif not(IsDefined('data.showFixForm'))>hidden</cfif> rejectProblem">
				
				<h2>Reject Problem</h2>
					
				#startFormTag(controller="problemcomment", action="add")#	
					
					#includePartial('/problem/addComment')#
				
					<!--- Include the redirect tag --->
					#hiddenFieldTag(name="comment[cmd]", value="reject")#
					#submitTag(name="submit", class="redButton", value="Reject Problem &gt;")#
				
				#endFormTag()#
				
			</div>
		
		</div>
		
	</section>
	
</section>

</cfoutput>