<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	
		<!--- Associations --->
		<cfset hasMany("userproblemtype")>
	
	</cffunction>

</cfcomponent>