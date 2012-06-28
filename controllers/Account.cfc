<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
		
		<!--- Run everything thru the checkLogin function --->
		<cfset filters(through="checkLogin")>
	
	</cffunction>
	
	<cffunction name="index">
	
		<!--- Load this user --->
		<cfset data.thisUser = model("user").findOneByID( decryptUserID() )>
		
		<!--- Load all users in this university --->
		<cfset data.uniUsers = model("user").findAllByuniversityID( data.thisUser.universityID )>
		
		<!--- Loop over users to add their categories --->
		<cfset QueryAddColumn( data.uniUsers, 'categories' )>
		<cfloop query="data.uniUsers">
			<cfset temp = model("userproblemtype").findAllByUserID( UserID=ID, include="problemtype" )>
			<cfset data.uniUsers["categories"] = ValueList( temp.typeLabel )>
		</cfloop>
		
		<!--- Create a new user instance --->
		<cfset data.user = model("user").new(universityID=data.thisUser.universityID)>
		
		<!--- Now load a list of categories we can assign to this user --->
		<cfset data.categories = model("problemtype").findAll(order="typeLabel ASC")>
	
	</cffunction>

</cfcomponent>