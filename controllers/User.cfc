<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
		
		<cfset super.init()>
		
	</cffunction>
	
	<cffunction name="add">
	
		<cfif IsPost()>
			
			<!--- First create a salt and hash the password --->
			<cfset theSalt = CreateUUID()>
			<cfset params.user.password = Hash(params.user.password & theSalt, 'SHA-512')>
			
			<!--- Next encrypt the salt --->
			<cfset params.user.passwordsalt = encrypt(theSalt,getEncryptKey(),'CFMX_COMPAT','hex')>
		
			<!--- Set the default roles --->
			<cfset params.user.roles = 'user'>
		
			<!--- Create the user --->
			<cfset result = model("user").create(params.user)>
		
			<cfif result.hasErrors()>
				<cfdump var="#result.allErrors()#"><cfabort>
			<cfelse>
			
				<!--- Check to see at least one category was chosen --->
				<cfif IsDefined("params.problemtypes") AND StructCount(params.problemtypes) GT 0>
			
					<!--- Loop thru the form and add an entry in the db for each category this user is in charge of --->
					<cfloop collection="#params.problemtypes#" item="i">
						<cfset loc.userproblem = model("userproblemtype").create( userid=result.ID, problemtypeid=i )>
						
						<cfif loc.userproblem.hasErrors()>
							<cfdump var="#loc.userproblem.allErrors()#"><cfabort>
						</cfif>
						
					</cfloop>
				
				</cfif>
			
				<!--- Flash and re-direct the user --->
				<cfset flashInsert(success="User was added successfully")>
				<cfset redirectTo(controller="account", action="index")>
			</cfif>
		
		<cfelse>
			<cfset flashInsert(error="Sorry - you can't access that function in that way")>
			<cfset redirectTo(back="true")>
		</cfif>
	
	</cffunction>
	
	<cffunction name="edit">
		
		<!---><cfdump var="#params#"><cfabort>--->
		
		<cfif IsDefined("params.id")>
			
			<!--- Load the user and make sure we are authorised to edit them --->
			<cfif IsUserInRole('admin,uniadmin')>
			
				<!--- Load this user --->
				<cfset user = model("user").findOneByID( ID=decryptUserID(), returnAs="query" )>
			
				<!--- Load the user to edit (input logged in user's university id to show they are affiliated) --->
				<cfset data.editUser = model("user").findOne(where="ID=#params.ID# AND universityID=#user.universityID#")>
				
				<!--- Check we found a user --->
				<cfif IsObject(data.editUser)>
					
					<!--- Now load a list of categories we can assign to this user --->
					<cfset data.categories = model("problemtype").findAll(order="typeLabel ASC")>
					
					<!--- Load a list of the categories already assigned to this user --->
					<cfset data.editUserCategories = data.editUser.loadCategories()>
					
				<cfelse>
					<cfset flashInsert(error="Sorry - you aren't authorised to edit that user")>
					<cfset redirectTo(back="true")>
				</cfif>
			
			<cfelse>	
				<cfset flashInsert(error="Sorry - you aren't authorised to edit that user")>
				<cfset redirectTo(back="true")>
			</cfif>
			
		<cfelse>
			<cfset flashInsert(error="Sorry - you didn't select a user to edit")>
			<cfset redirectTo(back="true")>
		</cfif>
	
	</cffunction>
	
	<cffunction name="login">
	
		<cfif IsPost()>
		
			<!--- See if this user is in the db --->
			<cfset user = model("user").findOneByEmail(email=params.user.email)>
			
			<cfif IsObject(user)>
				<!--- Email address found, check the password matches --->
				<cfset theSalt = decrypt(user.passwordSalt,getEncryptKey(),'CFMX_COMPAT','hex')>
				<cfset hashedPwd = hash(params.user.password & theSalt, 'SHA-512')>
				
				<!--- Now check the password provided against the db --->
				<cfif user.password EQ hashedPwd>
					
					<!--- Check if we want to be remembered --->
					<cfif IsDefined("params.cookie") AND params.cookie EQ 1>
						<!--- Store a cookie (primarily used for auto-login on iPhone) --->
						<cfcookie name="userID" value="#encrypt(user.id, GetEncryptKey(), "CFMX_COMPAT", "Hex")#" expires="never">
					</cfif>
					
					<!--- Encrypt the user's id and put in the session --->
					<cfset SESSION.userID = encrypt(user.id, GetEncryptKey(), "CFMX_COMPAT", "Hex")>
					
					<!--- Login the user with CF --->
					<cflogin idletimeout="3600">
						
						<cfloginuser 
							name="#user.firstname# #user.surname#" 
							password="something" 
							roles="#user.roles#" />
						
					</cflogin>
					
				<cfelse>
					<!--- Flash and re-render --->
					<cfset flashInsert(error="Sorry your password was incorrect, please try again")>
					<cfset data.user = model("user").new()>
					<cfset data.user.email = params.user.email>
					<cfset renderWith(controller="main", action="signin", data="data")>
				</cfif>
				
			<cfelse>
				<!--- Flash and re-render --->
				<cfset flashInsert(error="Sorry your email address and password were not found, please try again")>
				<cfset data.user = model("user").new()>
				<cfset renderWith(controller="main", action="signin", data="data")>
			</cfif>
			
		<cfelse>
			<!--- Flash and re-direct --->
			<cfset flashInsert(error="Sorry you can't access that function like that")>
			<cfset redirectTo(route="signin")>
		</cfif>
	
	</cffunction>

	<cffunction name="logout">
	
		<!--- Delete the session --->
		<cfset StructClear(session)>
		
		<!--- Clear the cookie --->
		<cfcookie name="userID" expires="now">
		
		<!--- Logout of CF --->
		<cflogout>
		
		<!--- Set a flash message and redirect the user --->
		<cfset flashInsert(success="You have been successfully logged out")>
		<cfset redirectTo(route="home")>
	
	</cffunction>

	<cffunction name="update">
		
		<cfif IsPost()>
		
			<!--- Load the user --->
			<cfset loc.user = model("user").findOneByID(params.editUser.ID)>
			
			<!--- Update the user --->
			<cfset update = loc.user.update( params.editUser )>
			
			<cfif update EQ true>
				<cfset flashInsert(success="User was updated successfully")>
			<cfelse>
				<cfset flashInsert(error="Sorry - an error occurred whilst updating the user")>
			</cfif>
			
			<!--- Delete all the categories this user currently manages --->
			<cfset loc.delete = loc.user.deleteAllUserProblemTypes()>
				
			<!--- Check to see if we need to add any new categories --->
			<cfif IsDefined("params.problemtypes")>
			
				<!--- Loop thru the form and add an entry in the db for each category this user is in charge of --->
				<cfloop collection="#params.problemtypes#" item="i">
					<cfset loc.userproblem = model("userproblemtype").create( userid=params.editUser.ID, problemtypeid=i )>
					
					<cfif loc.userproblem.hasErrors()>
						<cfdump var="#loc.userproblem.allErrors()#"><cfabort>
					</cfif>
					
				</cfloop>
				
			</cfif>
			
			
			
			<cfset redirectTo(controller="account", action="index")>
		
		<cfelse>
			<cfset flashInsert(error="Sorry - you can't access that function in that way")>
			<cfset redirectTo(back="true")>
		</cfif>
		
	</cffunction>

</cfcomponent>