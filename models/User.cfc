<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	
		<!--- Associations --->
		<cfset belongsTo("university")>
		<cfset hasMany("userproblemtype")>
	
	</cffunction>

	<cffunction name="deleteUserProblemTypes">
	
		<!--- Delete all the user problem type categories that have been assigned to this user --->
		<cfset del = model("userproblemtype").deleteAll(where="userID=#this.ID#")>
	
	</cffunction>

	<cffunction name="loadCategories">
	
		<cfset loc.query = model("userproblemtype").findAllByUserID( UserID=this.ID, include="problemtype" )>
		<cfreturn ValueList(loc.query.typelabel)>
	
	</cffunction>

</cfcomponent>