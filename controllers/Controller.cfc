<cfcomponent extends="Wheels">

	<cffunction name="init">
	
		<!--- Declare that we provide multiple formats (HTML and JSON) --->
		<cfset provides("html,json")>

	</cffunction>

	<cffunction name="checkAPIToken">
	
		<!--- Set the return structure --->
		<cfset rtn = StructNew()>
			
		<!--- Run on every request to ensure access is authorised --->
		<cfif IsDefined("params.apitoken")>
			
			<!--- Encrypt the token --->
			<cfset enc = encrypt(params.apitoken,getEncryptKey(),'CFMX_COMPAT','hex')>
			
			<!--- Run the Api Token through the model to ensure they're legit --->
			<cfset verify = model("APIUser").findOneByAPIToken(APIToken=params.apitoken, returnAs="query")>
			
			<!--- Check API Token is valid --->
			<cfif verify.RecordCount EQ 0>
				<cfset rtn.result = false>
				<cfset rtn.message = "API Token not found - Please check and retry">
				<cfset renderWith(rtn)>
			</cfif>
		
		<cfelse>
			<!--- No API Token provided --->
			<cfset rtn.result = false>
			<cfset rtn.message = "Doh - Remember to include your API Token in all requests">
		</cfif>
		
		<!--- Check if we need to render the error message in the correct format --->
		<cfif IsDefined("rtn.result") AND rtn.result EQ false>
			<cfset renderWith(rtn)>
		</cfif>
	
	</cffunction>
	
	<cffunction name="checkLogin" hint="Filter - checks a user is authenticated">
	
		<!--- Check if user exists in session and redirect to login if not --->
		<cfif Not(IsUserLoggedIn()) OR Not(IsDefined("SESSION.userID"))>
				
			<!--- Check if we have a cookie --->
			<cfif IsDefined("cookie.userID")>
				
				<!--- Decrypt the userID to load from the DB --->
				<cfset user = model("user").findOneByID(decrypt(cookie.userID, GetEncryptKey(), "CFMX_COMPAT", "Hex"))>
				
				<!--- Check we found a user (ie user could have been deleted since last login) --->
				<cfif IsObject(user)>
				
					<!--- Login by cookie --->
					<cfset SESSION.userID = cookie.userID>
					
					<!--- Login the user with CF --->
					<cflogin idletimeout="3600">
						
						<cfloginuser 
							name="#user.firstname# #user.surname#" 
							password="something" 
							roles="#user.roles#" />
						
					</cflogin>
				
				<cfelse>
					<!--- TODO Chnage this to use the home route --->
					<cfset flashInsert(error="You must login before accessing that page")>
					<cfset redirectTo(controller="main", action="register")>
				</cfif>
				
			<cfelse>
				<!--- TODO Chnage this to use the home route --->
				<cfset flashInsert(error="You must login before accessing that page")>
				<cfset redirectTo(controller="main", action="register")>
			</cfif>
			
		</cfif>	
		
	</cffunction>

</cfcomponent>