<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	
		<!--- Declare that we provide multiple formats (HTML and JSON) --->
		<cfset provides("html,json")>
		
		<!--- Make sure we run API calls through the API Token Checker in controller.cfc --->
		<cfset filters(through="checkAPIToken", only="add,addImage,view")>
	
	</cffunction>

	<cffunction name="add">
		
		<!--- Increase page timeout --->
		<cfsetting requesttimeout="120">
		
		<!--- Create a return structure --->
		<cfset rtn = StructNew()>
		
		<!--- TODO Refactor this method so we take in all the data and add it to a queue that then gets batched so we can return the response to the client asap --->
		
		<!---<cftry>--->
			
			<cflog file="AddProblem" type="info" text="Reached method call and Decrypting the reporterID">
			
			<!--- Decrypt Reporter ID --->
			<cfset params.reporterID = decrypt(params.reporterID, GetReporterKey(), "CFMX_COMPAT", "Hex")>
		
			<cflog file="AddProblem" type="info" text="Trying to find the reporter from the db">
		
			<!--- Check reporter exists in the DB --->
			<cfset checkReporter = model("reporter").findOneByID(ID=params.reporterID, returnAs="query")>
		
			<!--- Check reporter exists --->
			<cfif checkReporter.RecordCount EQ 0>
				
				<cflog file="AddProblem" type="info" text="Reporter not found">
				
				<cfset rtn.result = false>
				<cfset rtn.message = 'Reporter not found in DB'>
				<cfset renderWith(rtn)>
			</cfif>
		
			<cflog file="AddProblem" type="info" text="About to create the problem">
		
			<!--- Create a new Problem instance --->
			<cfset problem = model("problem").create(params)>
			
			<!--- Check if we had any errors --->
			<cfif problem.hasErrors()>
				<cflog file="AddProblem" type="info" text="Errors whilst adding the problem">
				<cfset rtn.result = false>
				<cfset rtn.message = problem.allErrors()>
			<cfelse>
				
				<cflog file="AddProblem" type="info" text="successfully added error">
				
				<!--- TODO Add in Email Functionality - Tag in an email alert too 
				<cfset sendEmails = problem.sendEmails()>
				
				<cflog file="AddProblem" type="info" text="Sent emails">
			
				<!--- Check the response to see if we assigned this problem to someone --->
				<cfif sendEmails.status EQ 'assigned'>
					<!--- Now update the status of the problem --->
					<cfset updateStatus = problem.update(statusID=2)>	
				</cfif>--->
			
				<cfset rtn.result = true>
				<cfset rtn.message = "Problem added successfully">
				<cfset rtn.ID = problem.ID>

			</cfif>

			<!---<cfcatch type="any">
					
				<cfmail to="andy@touchtapapps.com" from="andy@raiseatree.co.uk" server="smtp.gmail.com" port="465" username="andy@raiseatree.co.uk" password="agam3mn0N" usessl="true" subject="Dump" type="html">
					<cfdump var="#params#" label="params">
					<cfdump var="#cfcatch#" label="cfcatch">
				</cfmail>
				
				<cfset rtn.result = false>
				
				<cfif IsDefined("cffile")>
					<cfset rtn.message = 'Error uploading image - possible file permissions issue'>
				<cfelse>
					<cfset rtn.message = 'Error uploading image - please check it''s a JPG or PNG'>
				</cfif>
				
				<cfset renderWith(rtn)>
			</cfcatch>
			
		</cftry>--->
		
		<!--- Render the message back to the user --->
		<cfset renderWith(rtn)>
	
	</cffunction>
	
	<cffunction name="addImage" hint="I'm called by the iPhone client to save an image">
	
		<!--- Increase page timeout --->
		<cfsetting requesttimeout="120">
		
		<!--- Create a return structure --->
		<cfset rtn = StructNew()>
		
		<cftry>
		
			<!--- See if we have an image to process into a blob --->
			<cfif IsDefined("params.image") AND IsDefined("params.ID") AND params.image GT '' AND IsNumeric(params.ID)>
				
				<!--- Load the problem --->
				<cfset problem = model("problem").findOneByID(params.ID)>
				
				<cflog file="AddImage" type="info" text="We have an image to upload">
				
				<!--- Set the upload file location --->
				<cfset dropLocationOriginal = ExpandPath('images/dropzone/temp')>
				<cfset fileDropLocation = ExpandPath('images/dropzone')>
			
				<!--- Try to upload the file --->
				<cffile action="upload" 
					filefield="image" 
					nameconflict="makeunique" 
					destination="#dropLocationOriginal#">
					
				<cflog file="AddImage" type="info" text="Uploaded the image">
					
				<cfimage 
					action="resize" 
					source="#dropLocationOriginal#/#cffile.ServerFile#" 
					destination="#fileDropLocation#/#cffile.ServerFile#" 
					width="640" 
					height="" 
					overwrite="yes">
					
				<cflog file="AddImage" type="info" text="Resized the image">	
				
				<!--- Set file location --->
				<cfset fileLocation = fileDropLocation & '/' & cffile.ServerFile>
				
				<!--- Save the file name --->
				<cfset params.image = cffile.ServerFile>
				
				<!--- Update the problem --->
				<cfset result = problem.update(image=params.image)>
				
				<!--- Check the response --->
				<cfif result EQ true>
					<cflog file="AddImage" type="info" text="Finished and returning to the user">	
					<!--- Set the return --->
					<cfset rtn.result = true>
					<cfset rtn.message = 'Image added successfully'>
				<cfelse>
					<cflog file="AddImage" type="error" text="Error updating the problem">	
					<!--- Set the return --->
					<cfset rtn.result = false>
					<cfset rtn.message = 'Error updating the problem'>
				</cfif>
					
			<cfelse>
				<cfset rtn.result = false>
				<cfset rtn.message = 'Incorrect input params - need an image and an id'>
			</cfif>
		
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = 'An error occurred - sorry'>
			</cfcatch>	
			
		</cftry>
		
		<!--- Render the message back to the user --->
		<cfset renderWith(rtn)>
	
	</cffunction>

	<cffunction name="new">
	
		<!--- Load a list of universities --->
		<cfset rtn.universities = model("university").findAll(order="uniName ASC")>
	
		<!--- Load the problem types --->
		<cfset rtn.problemTypes = model("problemtype").findAll(order="typeLabel ASC")>
		
		<!--- Load the Problem Effects --->
		<cfset rtn.problemEffects = model("problemeffect").findAll(order="effectLabel ASC")>
	
		<cfdump var="#rtn#"><cfabort>

	</cffunction>

	<cffunction name="view">
	
		<!--- Create return response --->
		<cfset local.rtn = StructNew()>
		
		<cfif IsDefined("params.key")>
		
			<!--- Load all problems for a university --->
			<cfset problems = model("problem").findAll(
					where="universityID=#params.key# AND (updatedAt>='#DateFormat( DateAdd( 'd', -30, now() ), 'yyyy-mm-dd')#' OR statusLabel <> 'Fixed')", 
					include="status,problemtype", 
					order="createdat desc")>
			
			<cfif problems.RecordCount GT 0>
				<cfset local.rtn.result = true>
				<cfset local.rtn.data = problems>
			<cfelse>
				<cfset local.rtn.result = false>
				<cfset local.rtn.message = 'No problems found for this university'>
			</cfif>
					
		<cfelse>
			<cfset local.rtn.result = false>
			<cfset local.rtn.message = 'Please provide a university ID'>
		</cfif>
		
		<!--- Now send the data back in the right format --->
		<cfset renderWith(local.rtn)>
	
	</cffunction>

</cfcomponent>