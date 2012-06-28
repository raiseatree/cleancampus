<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	
		<!--- Associations --->
		<cfset belongsTo("user")>
		<cfset belongsTo("problemtype")>
	
	</cffunction>

</cfcomponent>