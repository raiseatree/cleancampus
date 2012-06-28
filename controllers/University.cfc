<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
		
		<!--- Declare that we provide multiple formats (HTML and JSON) --->
		<cfset provides("html,json")>
		
		<!--- Make sure we run API calls through the API Token Checker in controller.cfc --->
		<cfset filters(through="checkAPIToken", only="view")>
	
	</cffunction>
	
	<cffunction name="view">
	
		<!--- Load a list of universities --->
		<cftry>
			<cfset rtn.universities = model("university").findAll(order="uniname ASC")>
			<cfset rtn.result = true>
		
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = "Sorry - cannot get a list of universities at the moment">
				<cflog text="#serialize(cfcatch.message)#" type="error" file="#Application.LogFileName#">
			</cfcatch>
		</cftry>
	
		<cfset renderWith(rtn)>
	
	</cffunction>
	
</cfcomponent>