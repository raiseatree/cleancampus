<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	
		<!--- Associations --->
		<cfset belongsTo("university")>
		<cfset belongsTo("problemtype")>
		<cfset belongsTo("problemeffect")>
		<cfset belongsTo("reporter")>
		<cfset belongsTo("status")>
	
	</cffunction>

</cfcomponent>