<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	
		<cfset super.init()>
		
		<!--- Filter everything through the CheckLogin function to make sure user is authenticated --->
		<cfset filters(through="checkLogin", except="login,logout,signin,register,registerInterest")>
		
	</cffunction>

	<cffunction name="home">
		
		<!--- Load this user's & university --->
		<cfset data.user = model("user").findAll(where="ID=#Decrypt(SESSION.userID, GetEncryptKey(), "CFMX_COMPAT", "Hex")#", include="university")>
		
		<!--- Check if user is a uni admin --->
		<cfif IsUserInRole('uniadmin')>

			<!--- Load all the problems for this university (updated within the last 30 days)--->
			<cfset data.problems = model("problem").findAll(
					where="universityID=#data.user.universityID# AND (updatedAt>='#DateFormat( DateAdd( 'd', -30, now() ), 'yyyy-mm-dd')#' OR statusLabel <> 'Fixed')", 
					include="status,problemtype", 
					order="createdat desc")>
		<cfelse>			
		
			<!--- Load just this user's assigned problems (updated within the last 30 days)--->
			<cfset data.problems = model("problem").findAll(
					where="userID=#data.user.ID# AND (updatedAt>='#DateFormat( DateAdd( 'd', -30, now() ), 'yyyy-mm-dd')#' OR statusLabel <> 'Fixed')", 
					include="status,problemtype(userproblemtype)", 
					order="createdat desc")>
		
		</cfif>
				
		<!--- Split down the problems into their different statuses --->
		<cfquery name="data.redProblems" dbtype="query">
			SELECT * FROM data.problems WHERE statusLabel = 'Unassigned';
		</cfquery>
	
		<cfquery name="data.amberProblems" dbtype="query">
			SELECT * FROM data.problems WHERE statusLabel = 'Assigned';
		</cfquery>
		
		<cfquery name="data.greenProblems" dbtype="query">
			SELECT * FROM data.problems WHERE statusLabel = 'Fixed';
		</cfquery>			
	
		<!---><cfquery name="countProblems" dbtype="query">
			SELECT statusColour, COUNT(*) AS noProblems FROM data.problems 
			GROUP BY statusColour;
		</cfquery>
		<cfset data.problemCount = countProblems>--->
		
	</cffunction>

	<cffunction name="register">
	
		<cfset data.interest = model("interest").new()>

	</cffunction>

	<cffunction name="registerInterest">
	
		<cfif IsPost()>
			<cfset addInterest = model("interest").create(params.interest)>
			
			<cfif addInterest.hasErrors()>
				<cfset flashInsert(error="Sorry - there was a problem with your submission - please see details below")>
				<cfset data.interest = addInterest>
				<cfset renderPage(template="signin")>
			<cfelse>
				<cfset flashInsert(success="Thanks for registering some interest - we'll keep you posted of developments")>
			</cfif>
		<cfelse>
			<cfset flashInsert(error="Sorry - can't access function like that")>
			<cfset redirectTo(back="true")>
		</cfif>
	
	</cffunction>

	<cffunction name="signin">
	
		<!--- Create an empty instance to pass to the view --->
		<cfset data.user = model("user").new()>
	
	</cffunction>
	
</cfcomponent>