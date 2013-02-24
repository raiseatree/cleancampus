<cfcomponent extends="Controller" output="false">

	<cffunction name="init"></cffunction>
	
	<cffunction name="add">
	
		<cfif IsPost()>
		
			<!--- Decrypt user id --->
			<cfset params.comment.userID = decryptUser(params.comment.userID)>
		
			<!--- Add the problem comment --->
			<cfset problemComment = model("problemcomment").create(params.comment)>
			
			<!--- Check if we had any errors --->
			<cfif problemComment.hasErrors()>
					
				<!--- Re-load the problem --->
				<cfset data.problem = model("problem").findAll(where="ID=#params.comment.problemID#", include="problemtype,problemeffect,status", returnAs="query")>
				
				<!--- Save the data the user entered --->
				<cfset data.comment = problemComment>
				
				<!--- Set a flag to show the hidden form --->
				<cfset data.showFixForm = true>
				
				<!--- Put in an error message in the flash --->
				<cfset flashInsert(error="Sorry - an error occurred whilst adding the comment, please see below:")>
				
				<!--- Re-Render the page --->
				<cfset renderPage(template='/problem/investigate')>
				
			<cfelse>
			
				<!--- Check where we need to redirect to --->
				<cfif params.submit EQ 'Fix Problem'>
	
					<!--- Now forward to the Problem controller to mark the problem as fixed --->
					<cfset redirectTo(controller="problem", action="fix", params="ID=#params.comment.problemID#")>
				
				<cfelseif params.submit EQ 'Reject Problem'>
				
					<!--- Now forward to the Problem controller to mark the problem as fixed --->
					<cfset redirectTo(controller="problem", action="reject", params="ID=#params.comment.problemID#")>
				
				<cfelse>
					
					<!--- Now forward back to the investigate page --->
					<cfset redirectTo(controller="problem", action="investigate", params="ID=#params.comment.problemID#")>
					
				</cfif>
						
			</cfif>
		
		<cfelse>
			<cfset flashInsert(error="Cannot access function in that way")>
			<cfset redirectTo(back=true)>
		</cfif>
	
	</cffunction>

</cfcomponent>