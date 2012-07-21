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
			
			<!--- Check if we tried uploading an image we null this (we upload images in the background on the iPhone app after receiving a success message from the server) --->
			<cfif IsDefined("params.image") AND params.image GT ''>
				<cfset params.image = ''>
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
				<cfset thumbDropLocation = ExpandPath('images/dropzone/thumbs')>
			
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
					
				<cfimage 
					action="resize" 
					source="#dropLocationOriginal#/#cffile.ServerFile#" 
					destination="#thumbDropLocation#/#cffile.ServerFile#" 
					width="150" 
					height="" 
					overwrite="yes">
					
				<cflog file="AddImage" type="info" text="Resized the image">	
				
				<!--- Set file location --->
				<cfset fileLocation = fileDropLocation & '/' & cffile.ServerFile>
				
				<!--- Save the file name --->
				<cfset params.image = cffile.ServerFile>
				
				<cfset result = problem.update( image=params.image )>
				
				<cflog file="AddImage" type="info" text="Saved problem image">
				
				<!--- Hook in the email send profile --->
				<cfset emailResult = problem.sendEmails()>
				
				<cflog file="AddImage" type="info" text="Sent emails">
				
				<!--- Check the result --->
				<cfif IsDefined("emailResult.status") AND emailResult.status EQ 'assigned'>
					<cfset status = model("status").findOne(where="statusLabel='Assigned'", returnAs="query")>
				<cfelse>
					<cfset status = model("status").findOne(where="statusLabel='Unassigned'", returnAs="query")>
				</cfif>
				
				<cflog file="AddImage" type="info" text="Got a status of #status.statusLabel#">
				
				<!--- Check the result and update the problem --->
				<cfset statusResult = problem.update( statusID=status.ID )>

				<cflog file="AddImage" type="info" text="Saved the status result">
				
				<!--- Check the response --->
				<cfif statusResult EQ true>
					<cflog file="AddImage" type="info" text="Finished and returning to the user">	
					<!--- Set the return --->
					<cfset rtn.result = true>
					<cfset rtn.message = 'Image added successfully'>
					<cfset rtn.ID = problem.ID>
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
				<cfdump var="#cfcatch#"><cfabort>
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
			<cfset problems = model("problem").findAll(select="typeLabel, effectLabel, reporterID, statusLabel, statusColour, description, image, latitude, longitude, createdAt", 
					where="universityID=#params.key# AND (updatedAt>='#DateFormat( DateAdd( 'd', -30, now() ), 'yyyy-mm-dd')#' OR statusLabel <> 'Fixed')", 
					include="status,problemtype,problemeffect", 
					order="createdat desc")>
			
			<cfif problems.RecordCount GT 0>
				<cfset local.rtn.result = true>
				
				<!--- Add in an additional query --->
				<cfset QueryAddColumn(problems, "timeAgo")>
				
				<!--- Loop through the query and calculate timeAgo --->
				<cfloop query="problems">
					<!--- Add the TimeAgo Col --->
					<cfset problems["timeAgo"] = timeAgoInWords(createdAt) & ' Ago'>
					
					<!--- Add in the full URL --->
					<cfset problems["image"] = LoadSiteURL() & '/images/dropzone/thumbs/' & image>
				</cfloop>
				
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