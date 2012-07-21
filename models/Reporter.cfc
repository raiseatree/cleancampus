<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	
		<!--- Associations --->
		
		<!--- Validations --->
		<cfset validatesPresenceOf(property="udid")>
		<cfset validatesLengthOf(property="udid", maximum=40)>
        <cfset validatesUniquenessOf(property="udid")>
	
	</cffunction>

	<cffunction name="add">
		<cfargument name="params" type="struct" required="yes">
	
		<!--- Check if this user already exists in the DB --->
		<cfset check = model("reporter").findOneByUDID(UDID=params.UDID, returnAs="query")>
		
		<cfif check.RecordCount EQ 1>
			<cfset rtn.result = true>
			<cfset rtn.reporterID = encrypt(check.id, GetReporterKey(), "CFMX_COMPAT", "Hex")>
			<cfset rtn.message = "Reporter already in DB">
		<cfelse>
		
			<!--- Add the new reporter into the system --->
			<cfset result = model("reporter").create(params)>
		
			<!--- Check for errors --->
			<cfif result.hasErrors()>
				<cfset rtn.result = false>
				<cfset rtn.message = result.allErrors()>
			<cfelse>
				<cfset rtn.result = true>
				<cfset rtn.reporterID = encrypt(result.id, GetReporterKey(), "CFMX_COMPAT", "Hex")>
				<cfset rtn.message = "Reporter added successfully">
			</cfif>
		</cfif>
	
		<cfreturn rtn>
	</cffunction>

</cfcomponent>