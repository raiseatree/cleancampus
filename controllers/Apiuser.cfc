<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	
		<cfset super.init()>
	
	</cffunction>

	<!---<cffunction name="add">
	
		<cfif IsPost()>
		
			<!--- Create new API User Instance --->
			<cfset api = model("APIUser").create()>
			
			<!--- Set the username --->
			<cfset api.username = params.apiuser.username>
		
			<!--- Encrypt the UUID salt --->
			<cfset api.apiToken = encrypt(CreateUUID(),getEncryptKey(),'CFMX_COMPAT','hex')>
			
			<!--- Save the new API User --->
			<cfset result = api.save()>
		
			<!--- Dump out any errors --->
			<cfif result EQ false>
				<cfdump var="#result.allErrors()#">
			<cfelse>
				<!--- Otherwise dump out the API Token --->
				<cfdump var="#Decrypt(api.apiToken,getEncryptKey(),'CFMX_COMPAT','hex')#">	
			</cfif>
			
			<cfabort>
		
		</cfif>
	
	</cffunction>--->
	
</cfcomponent>