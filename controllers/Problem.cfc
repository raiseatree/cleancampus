<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	
		<!--- Declare that we provide multiple formats (HTML and JSON) --->
		<cfset provides("html,json")>
		
		<!--- Make sure we run API calls through the API Token Checker in controller.cfc --->
		<cfset filters(through="checkAPIToken", only="add")>
	
	</cffunction>

	<cffunction name="add">
		
		<!--- 
			NOTE - http://stackoverflow.com/questions/936855/file-upload-to-http-server-in-iphone-programming
			See this page for an example of uploading files to an HTTP server
			---
			Would be good to resize the image down to 1024px (width) on the iPhone to save on data traffic
		--->
		<!--- See if we have an image to process into a blob --->
		<cfif IsDefined("params.image") AND params.image GT ''>
			<!--- Set the upload file location --->
			<cfset fileDropLocation = ExpandPath('files/dropzone')>
		
			<!--- Try to upload the file --->
			<cftry>
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
				<cfset params.image = ImageGetBlob(fileLocation)>
				
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
			<cfset rtn.result = true>
			<cfset rtn.message = "Problem added successfully">
			
			<!--- Try and delete the temporary file --->
			<cftry>
				<cffile action="delete" file="#fileLocation#">
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>
		
		<!--- Check if we need to delete the image we uploaded --->
		<cfif IsDefined("fileLocation")>
	
			<!--- Delete the file --->	
			<cffile action="delete" file="#fileLocation#"/>
	
		</cfif>
		
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