<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	
		<!--- Associations --->
		<cfset hasMany("problem")>
	
	</cffunction>

</cfcomponent>