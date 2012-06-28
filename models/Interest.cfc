<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	
		<!--- Validations --->
		<cfset validatesPresenceOf(property="email", message="Sorry - please make sure you enter your email address")>
		<cfset validatesFormatOf(property="email", type="email", message="Sorry - please make sure you enter a valid email address")>
	
	</cffunction>

</cfcomponent>