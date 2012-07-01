<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	
		<!--- Declare that we provide multiple formats (HTML and JSON) --->
		<cfset provides("html,json")>
		
		<!--- Make sure we run API calls through the API Token Checker in controller.cfc --->
		<cfset filters(through="checkAPIToken", only="add")>
	
	</cffunction>

	<cffunction name="add">
		
		<cftry>
			<!--- See if we have an image to process into a blob --->
			<cfif IsDefined("params.image") AND params.image GT ''>
				<!--- Set the upload file location --->
				<cfset fileDropLocation = ExpandPath('images/dropzone')>
			
				<!--- Try to upload the file --->
				
					<cffile action="upload" 
						filefield="image" 
						nameconflict="makeunique" 
						destination="#fileDropLocation#">
						
					<cfimage 
						action="resize" 
						source="#fileDropLocation#/#cffile.ServerFile#" 
						destination="#fileDropLocation#/#cffile.ServerFile#" 
						width="640" 
						height="" 
						overwrite="yes">
						
					<!--- Set file location --->
					<cfset fileLocation = fileDropLocation & '/' & cffile.ServerFile>
					
					<!--- Convert image to blob --->
					<cfset params.image = cffile.ServerFile>
				
			</cfif>
		
			<!--- Decrypt Reporter ID --->
			<cfset params.reporterID = decrypt(params.reporterID, GetReporterKey(), "CFMX_COMPAT", "Hex")>
		
			<!--- Check reporter exists in the DB --->
			<cfset checkReporter = model("reporter").findOneByID(ID=params.reporterID, returnAs="query")>
		
			<!--- Check reporter exists --->
			<cfif checkReporter.RecordCount EQ 0>
				<cfset rtn.result = false>
				<cfset rtn.message = 'Reporter not found in DB'>
				<cfreturn rtn>
			</cfif>
		
			<!--- Create a new Problem instance --->
			<cfset problem = model("problem").create(params)>
			
			<!--- Check if we had any errors --->
			<cfif problem.hasErrors()>
				<cfset rtn.result = false>
				<cfset rtn.message = problem.allErrors()>
			<cfelse>
				
				<!--- Tag in an email alert too --->
				<cfset sendEmails = problem.sendEmails()>
			
				<!--- Check the response to see if we assigned this problem to someone --->
				<cfif sendEmails.status EQ 'assigned'>
					<!--- Now update the status of the problem --->
					<cfset updateStatus = problem.update(statusID=2)>	
				</cfif>
			
				<cfset rtn.result = true>
				<cfset rtn.message = "Problem added successfully">

			</cfif>

			<cfcatch type="any">
					
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
				
				<cfreturn rtn>
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

</cfcomponent>